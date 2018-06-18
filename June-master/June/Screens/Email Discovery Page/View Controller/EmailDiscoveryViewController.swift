//
//  EmailDiscoveryViewController.swift
//  June
//
//  Created by Joshua Cleetus on 7/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar
import NVActivityIndicatorView
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import SafariServices
import KeychainSwift

let kCloseSafariViewControllerNotification = "kCloseSafariViewControllerNotification"

class EmailDiscoveryViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, SFSafariViewControllerDelegate {
    
    var userObjectData:NSData!
    var usernameLabel : UILabel = UILabel()
    var linkLabel : UILabel = UILabel()
    var emailInfo: UITextField = UITextField()

    var loadingURL: Bool = false
    var delegate: EmailDiscoveryDelegate?
    var safariDelegate: SFSafariViewControllerDelegate?
    var nextButton: UIButton!
    
    var userID:String!
    var query:Query = Query()
    var emailProvider:String!
    var emailProviderType:String!
    var emailLinkingObject: Dictionary = [String: Any]()
    var emailLinkingResponse: Dictionary = [String: Any]()
    var authorizationURL: String!
    
    var safariVC: SFSafariViewController!
    var oAuthCode: String!
    
    static let signUpLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extra)
    static let signUpLabelFontForPlus: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extraMaxLarge)
    static let linkEmailFont = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
    static let nextButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extra)
    
    lazy var loader: Loader = {
        let loader = Loader(with: self, isTimeOutNeeded: false)
        loader.config.type = NVActivityIndicatorType(rawValue: 0)!
        return loader
    }()

    @objc func backButtonPressed(sender:UIButton!) {
        // get a reference to the app delegate
        if !self.loadingURL {
            loader.config.message = "Deleting User..."
            loader.show()
            self.deleteUser()
        }
    }
    
    func deleteUser() {
        self.loadingURL = true
        if let userData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            self.userObjectData = userData
            let userObject = KeyChainManager.NSDATAtoDictionary(data: self.userObjectData)
            guard let userId = (userObject["_id"] as? String) else {
                removeUserAndShowSighUp()
                return
            }
            self.userID = userId
            self.query = Query().eq(property: "_id" , value: self.userID)
            print("query = ",self.query.serialize())
            FeathersManager.Services.users.request(.remove(id: nil, query: self.query)).on( value: { [weak self] response in
                print(response)
                self?.removeUserAndShowSighUp()
            })
            .startWithFailed({ [weak self] error in
                print(error.error.localizedDescription)
                self?.removeUserAndShowSighUp()
            })
        }
    }
    
    func removeUserAndShowSighUp() {
        self.loader.hide()
        self.loadingURL = false
        _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userObject, data: self.userObjectData)
        FeathersManager.Providers.feathersApp.logout().start()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showSignUpPage()
        }
    }
    
    @objc func nextButtonTapped(sender : AnyObject) {
        if (emailInfo.text?.isEmpty)! {
            self.showErrorAlert(message: "Email is a required field")
        } else if !(emailInfo.text?.isValidEmail())! {
            self.showErrorAlert(message: "Enter a vaild email")
        } else {
            self.discoverEmail()
        }

    }
    
    func discoverEmail() {
        loader.config.message = "Checking Email..."
        loader.show()
        
        FeathersManager.Services.accounts.request(.create(data: [
            "email" : emailInfo.text!
            ], query: nil))
            .on(value: { response in
                print(response)
                self.loader.hide()
                let jsonDict:Dictionary = JSON(response.data.value).dictionaryObject!
                self.emailLinkingObject = jsonDict
                if self.emailLinkingObject["provider"] != nil {
                    self.emailProvider = self.emailLinkingObject["provider"] as! String
                }
                if self.emailLinkingObject["provider_type"] != nil {
                    self.emailProviderType = self.emailLinkingObject["provider_type"] as! String
                }
                if self.emailProvider == LocalizedStringKey.EmailDiscoveryViewHelper.gmail {
                    self.authorizationURL = self.emailLinkingObject["authorization_url"] as! String
                    self.showGoogleOAuth()
                } else {
                    self.goToGenericEmailPage()
                }
                
            })
            .startWithFailed { (error) in
                self.loader.hide()
                self.showErrorAlert(message: "Could not link to the account.")
                print(error.error)
                print(error.error.localizedDescription)
        }

    }
    
    func showGoogleOAuth() {
        if let url = URL(string: authorizationURL) {
            self.safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.safariVC.delegate = self.safariDelegate
            present(self.safariVC, animated: true)
        }
    }
    
    func goToGenericEmailPage() {
        let genericEmailVC = GenericEmailViewController()
        genericEmailVC.emailAddress = self.emailInfo.text!
        genericEmailVC.emailProvider = self.emailProvider
        genericEmailVC.emailProviderType = self.emailProviderType
        self.navigationController?.pushViewController(genericEmailVC, animated: true)
    }
    
    @objc func safariLogin(notification: NSNotification) {
        // get the url form the auth callback
        let url = notification.object as! NSURL
        let urlString = url.absoluteString
        if !((urlString?.isEmpty)!) && (urlString?.count)! > 13 {
            let index = urlString?.index((urlString?.startIndex)!, offsetBy: 13)
            let subString = String(urlString![index!..<(urlString?.endIndex)!])
            if !(subString.isEmpty) {
                self.oAuthCode = subString
                print("oAuth Code = ", oAuthCode)
                print("Email = ", self.emailInfo.text!)
                print("Provider = ", self.emailProvider)
                print("Provider Type = ", self.emailProviderType)
                self.LinkEmail()
            } else {
                self.showErrorAlert(message: "Failed to authenticate email. Please try again.")
            }
        } else {
            self.showErrorAlert(message: "Failed to authenticate email. Please try again.")
        }
        
        // then do whatever you like, for example :
        // get the code (token) from the URL
        // and do a request to get the information you need (id, name, ...)
        // Finally dismiss the Safari View Controller with:
        self.safariVC!.dismiss(animated: true, completion: nil)
        
    }
    
    func LinkEmail() {
        if let userData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            self.userObjectData = userData
            let userObject = KeyChainManager.NSDATAtoDictionary(data: self.userObjectData)
            print(userObject as Any)
            guard let userId = userObject["id"] as? String else {
                self.showErrorMessage()
                return
            }
            self.userID = userId
            loader.config.message = "Linking Email..."
            loader.show()
            FeathersManager.Services.accounts.request(.create(data: [
                "email":self.emailInfo.text!,
                "provider":self.emailProvider,
                "provider_type":self.emailProviderType,
                "reauth":false,
                "code":self.oAuthCode,
                "user_id":self.userID
                ], query: nil))
                .on(value: { response in
                    print(response)
                    self.loader.hide()
                    let jsonDict:Dictionary = JSON(response.data.value).dictionaryObject!
                    self.emailLinkingResponse = jsonDict
                    print(self.emailLinkingResponse)
                    if self.emailLinkingResponse["success"] != nil {
                        if self.emailLinkingResponse["success"] as! Bool == true {
                            let accountID = self.emailLinkingResponse["account_id"] as! String
                            let accountIDData = KeyChainManager.stringToNSDATA(string: accountID)
                            _ = KeyChainManager.save(key: JuneConstants.KeychainKey.accountID, data: accountIDData)
                            self.queryUserObject()
                            //TO-DO add onboarding here
                        } else {
                            self.showErrorAlert(message: "Failed to connect email. Please try again.")
                        }
                    }
                })
                .startWithFailed( { (error) in
                    print(error)
                    self.loader.hide()
                    self.showErrorAlert(message: "Failed to connect email. Please try again.")
            })
        }
        
    }
    
    func queryUserObject() -> Void {
        guard let token = KeychainSwift().get(JuneConstants.Feathers.jwtToken) else {
            print("no jwt token found")
            let settingsVC = SettingsViewController()
            settingsVC.logOutUser()
            return
        }
        print(token)
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": "jwt",
            "accessToken": token
            ])
            .on(value: { response in
                self.saveUserObject(response: response)
            })
            .startWithFailed { (error) in
                if error.error.localizedDescription.isEqualToString(find: "The operation couldn’t be completed. (Feathers.FeathersNetworkError error 2.)") {
                    AlertBar.show(.error, message: "The operation couldn’t be completed. Network is down")
                    let settingsVC = SettingsViewController()
                    settingsVC.logOutUser()
                }
        }
        
    }
    
    func saveUserObject(response: [String: Any]) {
        guard let json:[String:Any] = JSON(response).dictionaryObject else {
            self.showErrorMessage()
            return
        }
        let total = json.keys.count
        if total > 0 {
            let loginResponse = json
            if loginResponse["accessToken"] != nil {
                let accessToken = loginResponse["accessToken"] as! String
                if !(accessToken.isEmpty) {
                    KeychainSwift().set(accessToken, forKey: JuneConstants.Feathers.jwtToken)
                }
            }
            if loginResponse["user"] != nil {
                let userObject = loginResponse["user"] as! [String : Any]
                print(userObject as Any)
                let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: userObject)
                _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                if let accounts_object = userObject["accounts"] as? NSArray {
                    let accountsObject = accounts_object
                    if accountsObject.count > 0 {
                        let accountsDict = accountsObject[0] as! [String : Any]
                        if (accountsDict["account_id"] as? String) != nil {
                            //TO-DO add onboarding here
                            self.goToHomePage()
                        } else {
                            self.showErrorMessage()
                        }
                    } else {
                        self.showErrorMessage()
                    }
                } else {
                    self.showErrorMessage()
                }
            } else {
                self.showErrorMessage()
            }
        } else {
            self.showErrorMessage()
        }
    }
    
    func showErrorMessage() {
        self.showErrorAlert(message: "Error. Please Login again.")
        let settingsVC = SettingsViewController()
        settingsVC.logOutUser()
    }
    
    func pullThreadFromFeathers() {
        let query = Query()
            .eq(property: "account_id", value: "cfkm7roj7g8utf0f2ws1wuid3").limit(10)
        FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
            print(response)
        }).startWithFailed { (error) in
            print(error)
        }
    }
    
    func goToHomePage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.buildNavigationDrawer()
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        let plusSize = 414
        let screen = self.view.frame.size.width
        
        delegate = EmailDiscoveryDelegate(parentVC: self)
        self.safariDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.safariLogin(notification:)), name: NSNotification.Name(rawValue: kCloseSafariViewControllerNotification), object: nil)

        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "june_loginsignup_logo")
        imageView.frame = CGRect(x: 133, y: 46, width: 111, height: 45)
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
           imageView.frame = CGRect(x: 132, y: 64, width: 111, height: 45)
        }
        if Int(screen) == plusSize {
            imageView.frame = CGRect(x: 152, y: 47, width: 111, height: 45)
        }
        self.view.addSubview(imageView)

        let backBtn = UIButton()
        backBtn.backgroundColor = .white
        backBtn.setImage(#imageLiteral(resourceName: "back_login_signup"), for: .normal)
        backBtn.frame = CGRect(x: 21, y: 60, width: 10, height: 18)
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            backBtn.frame = CGRect(x: 18, y: 79, width: 10, height: 18)
        }
        if Int(screen) == plusSize {
            backBtn.frame = CGRect(x: 21, y: 62, width: 10, height: 18)
        }
        backBtn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        let signUpLabel = UILabel()
        signUpLabel.text = Localized.string(forKey: LocalizedString.SignUpViewSignUpLabelTitle)
        signUpLabel.textAlignment = .center
        signUpLabel.backgroundColor = UIColor.clear
        signUpLabel.textColor = UIColor.init(hexString:"#585F6F")
        signUpLabel.frame = CGRect(x: 155.5, y: 90, width: 70, height: 24)
        signUpLabel.font = EmailDiscoveryViewController.signUpLabelFont
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            signUpLabel.frame = CGRect(x: 148, y: 113, width: 83, height: 29)
            signUpLabel.font = EmailDiscoveryViewController.signUpLabelFont
        }
        if Int(screen) == plusSize {
            signUpLabel.frame = CGRect(x: 168, y: 96, width: 83, height: 29)
            signUpLabel.font = EmailDiscoveryViewController.signUpLabelFontForPlus
        }
        self.view.addSubview(signUpLabel)
       
        self.usernameLabel.frame = CGRect(x: 20, y: self.view.frame.size.height * 0.2925, width: (self.view.frame.size.width-40), height: 20)
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
        }
        if Int(screen) == plusSize {
        }
        self.usernameLabel.textColor = .black
        self.usernameLabel.font = UIFont.avenirStyleAndSize(style: .book, size: .medium) 
        self.usernameLabel.backgroundColor = .white
        self.usernameLabel.textAlignment = .center
//        self.view.addSubview(self.usernameLabel)
        
        if let usernameData = KeyChainManager.load(key: JuneConstants.KeychainKey.username) {
            let username = KeyChainManager.NSDATAtoString(data: usernameData)
            self.usernameLabel.text = "@" + username
        }
        
        self.linkLabel.frame = CGRect(x: 96, y: 170, width: 186, height: 22)
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.linkLabel.frame = CGRect(x: 95, y: 208, width: 186, height: 22)
        }
        if Int(screen) == plusSize {
            self.linkLabel.frame = CGRect(x: 115, y: 170, width: 186, height: 22)
        }
        self.linkLabel.textColor = .black
        self.linkLabel.font = EmailDiscoveryViewController.linkEmailFont
        self.linkLabel.backgroundColor = .white
        self.linkLabel.textAlignment = .center
        self.view.addSubview(self.linkLabel)
        self.linkLabel.text = Localized.string(forKey: LocalizedString.EmailDiscoveryViewLinkLabelTitle)
        
        var indentView = UIView()
        if UIDevice.current.modelName == "iPhone 7" {
            emailInfo.frame = CGRect(x: 23, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 46, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 13)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            emailInfo.frame = CGRect(x: 25, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 50, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 14)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 6s" {
            emailInfo.frame = CGRect(x: 23, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 46, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 13)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            emailInfo.frame = CGRect(x: 25, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 50, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 14)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 6" {
            emailInfo.frame = CGRect(x: 23, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 46, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 13)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 6 Plus" {
            emailInfo.frame = CGRect(x: 25, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 50, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 14)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 5s" {
            emailInfo.frame = CGRect(x: 21, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 42, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 11)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 5c" {
            emailInfo.frame = CGRect(x: 21, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 42, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 11)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone 5" {
            emailInfo.frame = CGRect(x: 21, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 42, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 11)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "iPhone SE" {
            emailInfo.frame = CGRect(x: 21, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 42, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 11)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else if UIDevice.current.modelName == "Simulator" {
            emailInfo.frame = CGRect(x: 25, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 50, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 14)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        } else {
            emailInfo.frame = CGRect(x: 23, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 46, height: self.view.frame.size.height * 0.088)
            emailInfo.font = UIFont.systemFont(ofSize: 13)
            indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            emailInfo.leftView = indentView
            emailInfo.leftViewMode = .always
        }
        emailInfo.frame = CGRect(x: 25, y: 213, width: 326, height: 54)
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            emailInfo.frame = CGRect(x: 24, y: 251, width: 326, height: 54)
        }
        if Int(screen) == plusSize {
            emailInfo.frame = CGRect(x: 44, y: 213, width: 326, height: 54)
        }

        let borderColor = UIColor.init(hexString: "D8D8D8")
        emailInfo.placeholder = Localized.string(forKey: LocalizedString.EmailDiscoveryViewEmailInfoTitle)
        emailInfo.setPlaceHolderColor()
        emailInfo.textColor = UIColor(hexString: "84878F")
        emailInfo.borderStyle = UITextBorderStyle.none
        emailInfo.layer.cornerRadius = 5
        emailInfo.layer.borderWidth = 1
        emailInfo.layer.borderColor = borderColor.cgColor
        emailInfo.autocorrectionType = UITextAutocorrectionType.no
        emailInfo.keyboardType = UIKeyboardType.emailAddress
        emailInfo.clearButtonMode = UITextFieldViewMode.whileEditing;
        emailInfo.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        emailInfo.backgroundColor = .clear
        emailInfo.delegate = delegate
        emailInfo.autocapitalizationType = .none
        emailInfo.returnKeyType = .done
        self.view.addSubview(emailInfo)

        nextButton = UIButton(frame: CGRect(x: 25, y: 314, width: 326, height: 55))
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            nextButton.frame = CGRect(x: 24, y: 397, width: 326, height: 55)
        }
        if Int(screen) == plusSize {
            nextButton.frame = CGRect(x: 44, y: 359, width: 326, height: 55)
        }
        let signUpBorderColor = UIColor.init(hexString: "#D6D6D6")
        nextButton.layer.cornerRadius = 28
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = signUpBorderColor.cgColor
        nextButton.setTitleColor(.black , for: .normal)
        nextButton.backgroundColor = UIColor.clear
        nextButton.titleLabel?.font = EmailDiscoveryViewController.nextButtonFont
        nextButton.setTitle(Localized.string(forKey: LocalizedString.EmailDiscoveryViewNextButtonTitle), for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
