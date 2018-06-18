//
//  SignUpViewController.swift
//  June
//
//  Created by Joshua Cleetus on 7/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import QuartzCore
import NVActivityIndicatorView
import AlertBar
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import Alamofire
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var loginLabel: UILabel = UILabel()
    var usernameInfo: UITextField = UITextField()
    var passwordInfo: UITextField = UITextField()
    var forgotPasswordButton: UIButton!
    var loadingURL: Bool = false
    var delegate: LoginDelegate?
    var loginButton: UIButton!
    var signUpButton: UIButton!
    var loginResponse: Dictionary = [String: Any]()
    var userObject: Dictionary = [String: Any]()
    var accountsObject: NSArray = []
    var accountsDict: Dictionary = [String: Any]()
    var accountID: String!
    var backButton = UIButton()
    var logoImage = UIImageView()
    var dontHaveAccountLabel = UILabel()

    static let loginButtonFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .large)
    static let signUpButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    static let dontHaveAccountLabFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
    static let forgotButtonFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
    static let loginLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .large)
    
    lazy var loader: Loader = {
        let loader = Loader(with: self, isTimeOutNeeded: false)
        return loader
    }()
    
    @objc func loginButtonTapped(sender : AnyObject) {
        self.clearKeychain()
        if (!(self.usernameInfo.text?.isEmpty)! && (self.usernameInfo.text?.count)! < 3) {
            self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage1)
        } else if (self.usernameInfo.text?.isEmpty)!{
            self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage2)
        } else if (self.passwordInfo.text?.isEmpty)! {
            self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage3)
        } else if !((self.passwordInfo.text?.isEmpty)!) && (self.passwordInfo.text?.count)! < 8 {
            self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage4)
        }
//        else if !(self.passwordInfo.text?.containsLettersAndNumbers)! {
//            self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage5)
//            return
//        }
        else {
            if !loadingURL {
                loader.show()
                if (self.usernameInfo.text?.isValidEmail())! {
                    self.loginUserWithFeathersEmail()
                } else {
                    self.loginUserWithFeathersUserName()
                }
            }
        }
        
    }
    
    @objc func signUpButtonTapped(sender : AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showSignUpPage()
    }
    
    func loginUserWithFeathersUserName() {
        loadingURL = true
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": JuneConstants.Feathers.strategy,
            "username": self.usernameInfo.text!,
            "password": self.passwordInfo.text!
        ])
        .on(value: { response in
            self.loadingURL = false
            self.loader.hide()
            let json:Dictionary = JSON(response).dictionaryObject!
            let total = json.keys.count
            if total > 0 {
                self.loginResponse = json
                if self.loginResponse["accessToken"] != nil {
                    let accessToken = self.loginResponse["accessToken"] as! String
                    if !(accessToken.isEmpty) {
                        KeychainSwift().set(accessToken, forKey: JuneConstants.Feathers.jwtToken)
                    }
                }
                if self.loginResponse["user"] != nil {
                    self.userObject = self.loginResponse["user"] as! [String : Any]
                    let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: self.userObject)
                    _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                    if let accounts_object = self.userObject["accounts"] as? NSArray {
                        self.accountsObject = accounts_object
                        if self.accountsObject.count > 0 {
                            self.accountsDict = self.accountsObject[0] as! [String : Any]
                            if let account_id = self.accountsDict["account_id"] as? String {
                                self.accountID = account_id
                                self.goToHomePage()
                            } else {
                                self.showEmailDiscoveryPage()
                            }
                        } else {
                            self.showEmailDiscoveryPage()
                        }
                    } else {
                        self.goToHomePage()
                    }
                } else {
                    self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
                }
            } else {
                self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
            }
        })
        .startWithFailed { (error) in
            print(error)
            self.loadingURL = false
            self.loader.hide()
            self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage6)
            self.signUpButton.isEnabled = true
        }

    }
    
    func loginUserWithFeathersEmail() {
        print(self.usernameInfo.text!)
        loadingURL = true
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": JuneConstants.Feathers.strategy,
            "username": self.usernameInfo.text!,
            "email": self.usernameInfo.text!,
            "password": self.passwordInfo.text!
            ])
            .on(value: { response in
                print(response)
                self.loadingURL = false
                self.loader.hide()
                let json:Dictionary = (JSON(response).dictionaryObject)!
                let total = json.keys.count
                if total > 0 {
                    self.loginResponse = json
//                    if self.loginResponse["accessToken"] != nil {
//                        let accessToken = self.loginResponse["accessToken"] as! String
//                        if !(accessToken.isEmpty) {
//                            KeychainSwift().set(accessToken, forKey: JuneConstants.Feathers.jwtToken)
//                        }
//                    }
                    if self.loginResponse["user"] != nil {
                        self.userObject = self.loginResponse["user"] as! [String : Any]
                        let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: self.userObject)
                        _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                        if let accounts_object = self.userObject["accounts"] as? NSArray {
                            self.accountsObject = accounts_object
                            if self.accountsObject.count > 0 {
                                self.accountsDict = self.accountsObject[0] as! [String : Any]
                                if let account_id = self.accountsDict["account_id"] as? String {
                                    self.accountID = account_id
                                    self.goToHomePage()
                                } else {
                                    self.showEmailDiscoveryPage()
                                }
                            } else {
                                self.showEmailDiscoveryPage()
                            }
                        } else {
                            self.goToHomePage()
                        }
                    } else {
                        self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
                    }
                } else {
                    self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
                }
                
            })
            .startWithFailed { (error) in
                print(error)
                self.loadingURL = false
               self.loader.hide()
                self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage6)
                self.signUpButton.isEnabled = true
        }
        
    }
    
    func loginUserWithUsername() {
        let parameters: [String: String] = [
            "strategy": JuneConstants.Feathers.strategy,
            "username" : self.usernameInfo.text!,
            "password" : self.passwordInfo.text!
        ]
        let urlString = JuneConstants.Feathers.baseURL
        let url = URL(string: urlString)
        let relativeUrl = URL(string: "/authentication", relativeTo: url)
        Alamofire.request(relativeUrl!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            self.loader.hide()
            let json:Dictionary = JSON(response.data!).dictionaryObject as! NSMutableDictionary as Dictionary
            let total = json.keys.count
            if total > 0 {
                self.loginResponse = json as! [String : Any]
                if self.loginResponse["accessToken"] != nil {
                    let accessToken = self.loginResponse["accessToken"] as! String
                    if !(accessToken.isEmpty) {
                        KeychainSwift().set(accessToken, forKey: JuneConstants.Feathers.jwtToken)
                    }
                }
                if self.loginResponse["user"] != nil {
                    self.userObject = self.loginResponse["user"] as! [String : Any]
                    let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: self.userObject)
                    _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                    if let accounts_object = self.userObject["accounts"] as? NSArray {
                        self.accountsObject = accounts_object
                        if self.accountsObject.count > 0 {
                            self.accountsDict = self.accountsObject[0] as! [String : Any]
                            if let account_id = self.accountsDict["account_id"] as? String {
                                self.accountID = account_id
                                self.goToHomePage()
                            } else {
                                self.showEmailDiscoveryPage()
                            }
                        } else {
                            self.showEmailDiscoveryPage()
                        }
                    } else {
                        self.goToHomePage()
                    }
                } else {
                    self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
                }
            } else {
                self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
            }
        }
    }
    
    func goToHomePage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.buildNavigationDrawer()
    }
    
    func showEmailDiscoveryPage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.emailDiscoveryPage()
    }
    
    func loginUserWithEmail() {
        let parameters: [String: String] = [
            "strategy": JuneConstants.Feathers.strategy,
            "username" : self.usernameInfo.text!,
            "email": self.usernameInfo.text!,
            "password" : self.passwordInfo.text!
        ]
        let urlString = JuneConstants.Feathers.baseURL
        let url = URL(string: urlString)
        let relativeUrl = URL(string: "/authentication", relativeTo: url)
        Alamofire.request(relativeUrl!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            self.loader.hide()
            let json:Dictionary = JSON(response.data!).dictionaryObject as! NSMutableDictionary as Dictionary
            let total = json.keys.count
            if total > 0 {
                self.loginResponse = json as! [String : Any]
                if self.loginResponse["user"] != nil {
                    self.userObject = self.loginResponse["user"] as! [String : Any]
                    let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: self.userObject)
                    _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                    if self.userObject["accounts"] != nil {
                        self.accountsObject = self.userObject["accounts"] as! NSArray
                        if self.accountsObject.count > 0 {
                            self.accountsDict = self.accountsObject[0] as! [String : Any]
                            if self.accountsDict["account_id"] != nil {
                                self.accountID = self.accountsDict["account_id"] as! String
                                self.goToHomePage()
                            } else {
                                self.showEmailDiscoveryPage()
                            }
                        } else {
                            self.showEmailDiscoveryPage()
                        }
                    } else {
                        self.goToHomePage()
                    }
                } else {
                    self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
                }
            } else {
                self.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage7)
            }
        }
    }
    
    func queryUserinMongoDB() {
        
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }
    
    func checkForEmailAccount() {
        
    }
    
    func goToEmailDiscoveryPage() {
        let emailDiscoveryVC = EmailDiscoveryViewController()
        self.navigationController?.pushViewController(emailDiscoveryVC, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        KeyChainManager.clear()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        delegate = LoginDelegate(parentVC: self)

        self.logoImage.image = #imageLiteral(resourceName: "june_loginsignup_logo")
       
        self.loginLabel.font = UIFont(name: "Lato Regular", size: 18)
        self.loginLabel.text = Localized.string(forKey: .LoginViewLoginLabelTitle)
        self.loginLabel.textAlignment = .center
        self.loginLabel.backgroundColor = UIColor.clear
        self.loginLabel.textColor = UIColor.init(hexString:"#000000")
        
        self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        
        let borderColor = UIColor.init(hexString: "D8D8D8")
        
        var indentView = UIView()
        usernameInfo.font = UIFont.systemFont(ofSize: 14)
        indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.view.frame.size.height * 0.16))
        usernameInfo.leftView = indentView
        usernameInfo.leftViewMode = .always
        usernameInfo.placeholder = Localized.string(forKey: LocalizedString.LoginViewUsernameInfoPlaceholderTitle)
        usernameInfo.setPlaceHolderColor()
        usernameInfo.textColor = UIColor(hexString: LocalizedColorHexStringKey.LoginScreenViewHelper.usernameInfoTextColor)
        usernameInfo.borderStyle = UITextBorderStyle.none
        usernameInfo.layer.borderWidth = 1
        usernameInfo.layer.borderColor = borderColor.cgColor
        usernameInfo.autocorrectionType = UITextAutocorrectionType.no
        usernameInfo.keyboardType = UIKeyboardType.default
        usernameInfo.clearButtonMode = UITextFieldViewMode.whileEditing;
        usernameInfo.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        usernameInfo.backgroundColor = UIColor.clear
        usernameInfo.delegate = delegate
        usernameInfo.autocapitalizationType = .none
        usernameInfo.returnKeyType = .next

        passwordInfo.font = usernameInfo.font
        let indentView2 = UIView(frame: CGRect(x: indentView.frame.origin.x, y: indentView.frame.origin.y, width: indentView.frame.size.width, height: indentView.frame.size.height))
        passwordInfo.leftView = indentView2
        passwordInfo.leftViewMode = .always
        passwordInfo.placeholder = Localized.string(forKey: LocalizedString.LoginViewPasswordInfoPlaceholderTitle)
        passwordInfo.setPlaceHolderColor()
        passwordInfo.textColor = UIColor(hexString: LocalizedColorHexStringKey.LoginScreenViewHelper.passwordInfoTextColor)
        passwordInfo.borderStyle = UITextBorderStyle.none
        passwordInfo.layer.borderWidth = 1
        passwordInfo.layer.borderColor = borderColor.cgColor
        passwordInfo.autocorrectionType = UITextAutocorrectionType.no
        passwordInfo.keyboardType = UIKeyboardType.default
        passwordInfo.returnKeyType = UIReturnKeyType.done
        passwordInfo.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordInfo.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        passwordInfo.backgroundColor = UIColor.clear
        passwordInfo.delegate = delegate
        passwordInfo.autocapitalizationType = .none 
        passwordInfo.isSecureTextEntry = true

        self.dontHaveAccountLabel.font = LoginViewController.dontHaveAccountLabFont
        self.dontHaveAccountLabel.text = Localized.string(forKey: LocalizedString.LoginViewDontHaveAccountLabelTitle)
        self.dontHaveAccountLabel.textColor = UIColor(hexString: "#000000")
        self.dontHaveAccountLabel.backgroundColor = UIColor.clear

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            setupSubViewsForiPhoneX()
        } else {
            setupSubviewsExceptX()
        }
        
    }
    
    func setupSubViewsForiPhoneX() {
        let screen: CGFloat = self.view.frame.size.width
        
        self.logoImage.frame = CGRect(x: 132, y: 64, width: 111, height: 45)
        self.view.addSubview(logoImage)
        
        self.loginLabel.frame = CGRect(x: 164.5, y: 148, width: 47, height: 22)
        self.view.addSubview(loginLabel)
        
        self.backButton.frame = CGRect(x: 18, y: 79, width: 10, height: 18)
        self.view.addSubview(backButton)
        
        usernameInfo.frame = CGRect(x: 24, y: 181, width: 326, height: 54)
        self.view.addSubview(self.usernameInfo)
        
        passwordInfo.frame = CGRect(x: 24, y: 252, width: 326, height: 54)
        self.view.addSubview(self.passwordInfo)
        
        let forgotPasswordButtonColor = UIColor.init(hexString: "#000000")
        self.forgotPasswordButton = UIButton(frame: CGRect(x: 27, y: 321, width: 189, height: 17))
        self.forgotPasswordButton.setTitle(Localized.string(forKey: LocalizedString.LoginViewForgotPasswordButtonTitle), for: .normal)
        self.forgotPasswordButton.setTitleColor(forgotPasswordButtonColor, for: .normal)
        self.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordBtnPressed), for: .touchUpInside)
        self.forgotPasswordButton.backgroundColor = .clear
        self.forgotPasswordButton.contentHorizontalAlignment = .left
        self.forgotPasswordButton.titleLabel?.font = LoginViewController.forgotButtonFont
        self.view.addSubview(forgotPasswordButton)
        
        self.loginButton = UIButton(frame: CGRect(x: 24, y: 357, width: 326, height: 55))
        self.loginButton.setImage(#imageLiteral(resourceName: "june_login_button"), for: .normal)
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.loginButton)
        
        self.dontHaveAccountLabel.frame = CGRect(x: 92, y: 434, width: 0.384 * screen, height: 17)
        self.view.addSubview(self.dontHaveAccountLabel)
        
        self.signUpButton = UIButton(frame: CGRect(x: 0.62666666666 * screen, y: 434, width: 0.133333333333 * screen, height: 17))
        self.signUpButton.backgroundColor = .clear
        signUpButton.titleLabel?.font = LoginViewController.signUpButtonFont
        self.signUpButton.setTitle(Localized.string(forKey: LocalizedString.LoginViewSignUpButtonTitle), for: .normal)
        signUpButton.setTitleColor(UIColor(red:0.27, green:0.3, blue:0.36, alpha:1), for: .normal)
        self.signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(self.signUpButton)
    }
    
    func setupSubviewsExceptX() {
        let plusSize = 414
        let screen: CGFloat = self.view.frame.size.width
        
        self.logoImage.frame = CGRect(x: 133, y: 46, width: 111, height: 45)
        if Int(screen) == plusSize {
            self.logoImage.frame = CGRect(x: 152, y: 47, width: 111, height: 45)
        }
        self.view.addSubview(logoImage)
        
        self.loginLabel.frame = CGRect(x: 166, y: 98, width: 47, height: 22)
        if Int(screen) == plusSize {
            self.loginLabel.frame = CGRect(x: 184.5, y: 128, width: 47, height: 22)
        }
        self.view.addSubview(loginLabel)
        
        self.backButton.frame = CGRect(x: 21, y: 60, width: 10, height: 18)
        if Int(screen) == plusSize {
            self.backButton.frame = CGRect(x: 21, y: 62, width: 10, height: 18)
        }
        self.view.addSubview(backButton)
        
        usernameInfo.frame = CGRect(x: 25, y: 131, width: 326, height: 54)
        if Int(screen) == plusSize {
            usernameInfo.frame = CGRect(x: 44, y: 161, width: 326, height: 54)
        }
        self.view.addSubview(self.usernameInfo)
        
        passwordInfo.frame = CGRect(x: 25, y: 202, width: 326, height: 54)
        if Int(screen) == plusSize {
            passwordInfo.frame = CGRect(x: 44, y: 232, width: 326, height: 54)
        }
        self.view.addSubview(self.passwordInfo)
        
        let forgotPasswordButtonColor = UIColor.init(hexString: "#000000")
        self.forgotPasswordButton = UIButton(frame: CGRect(x: 28, y: 271, width: 189, height: 17))
        if Int(screen) == plusSize {
            self.forgotPasswordButton = UIButton(frame: CGRect(x: 47, y: 301, width: 189, height: 17))
        }
        self.forgotPasswordButton.setTitle(Localized.string(forKey: LocalizedString.LoginViewForgotPasswordButtonTitle), for: .normal)
        self.forgotPasswordButton.setTitleColor(forgotPasswordButtonColor, for: .normal)
        self.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordBtnPressed), for: .touchUpInside)
        self.forgotPasswordButton.backgroundColor = .clear
        self.forgotPasswordButton.contentHorizontalAlignment = .left
        self.forgotPasswordButton.titleLabel?.font = LoginViewController.forgotButtonFont
        self.view.addSubview(forgotPasswordButton)
        
        self.loginButton = UIButton(frame: CGRect(x: 25, y: 307, width: 326, height: 55))
        if Int(screen) == plusSize {
            self.loginButton = UIButton(frame: CGRect(x: 44, y: 337, width: 326, height: 55))
        }
        self.loginButton.setImage(#imageLiteral(resourceName: "june_login_button"), for: .normal)
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.loginButton)
        
        self.dontHaveAccountLabel.frame = CGRect(x: 93, y: 376, width: 0.384 * screen, height: 17)
        if Int(screen) == plusSize {
            self.dontHaveAccountLabel.frame = CGRect(x: 112, y: 414, width: 0.384 * screen, height: 17)
        }
        self.view.addSubview(self.dontHaveAccountLabel)
        
        self.signUpButton = UIButton(frame: CGRect(x: 0.62666666666 * screen, y: 376, width: 0.133333333333 * screen, height: 0.0453333333 * screen))
        if Int(screen) == plusSize {
            self.signUpButton = UIButton(frame: CGRect(x: 0.62666666666 * screen - 3, y: 414, width: 0.133333333333 * screen, height: 0.0453333333 * screen))
        }
        self.signUpButton.backgroundColor = .clear
        signUpButton.titleLabel?.font = LoginViewController.signUpButtonFont
        self.signUpButton.setTitle(Localized.string(forKey: LocalizedString.LoginViewSignUpButtonTitle), for: .normal)
        signUpButton.setTitleColor(UIColor(red:0.27, green:0.3, blue:0.36, alpha:1), for: .normal)
        self.signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(self.signUpButton)
    }
    
    @objc func backButtonPressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginSignupPage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } 
   
    @objc func forgotPasswordBtnPressed(_ sender: UIButton) {
        let forgotPasswordVC = ForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func clearKeychain() {
        FeathersManager.Providers.feathersApp.logout().start()
        KeychainSwift().delete(JuneConstants.Feathers.jwtToken)
        
        if let usernameData = KeyChainManager.load(key: JuneConstants.KeychainKey.username) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.username, data: usernameData)
        }
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
        }
        if let userAccountData = KeyChainManager.load(key: JuneConstants.KeychainKey.accountID) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.accountID, data: userAccountData)
        }
        if let userIDData = KeyChainManager.load(key: JuneConstants.KeychainKey.userID) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userID, data: userIDData)
        }
    }
    
}
