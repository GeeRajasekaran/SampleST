//
//  EmailOAuthViewController.swift
//  June
//
//  Created by Joshua Cleetus on 7/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import AlertBar

class GenericEmailViewController: UIViewController, NVActivityIndicatorViewable {
    
    var emailAddress: String = String()
    var enterPasswordLabel : UILabel = UILabel()
    var emailInfo: UITextField = UITextField()
    var passwordInfo: UITextField = UITextField()
    var nextButton: UIButton!
    var emailProvider:String!
    var emailProviderType:String!
    var userObjectData:NSData!
    var userID:String!
    var emailLinkingObject: Dictionary = [String: Any]()
    var emailLinkingResponse: Dictionary = [String: Any]()
    var delegate: GenericEmailDelegate?

    lazy var loader: Loader = {
        let loader = Loader(with: self, isTimeOutNeeded: false)
        loader.config.message = "Linking Email..."
        loader.config.type = NVActivityIndicatorType(rawValue: 0)!
        return loader
    }()
    
    @objc func backButtonPressed(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped(sender : AnyObject) {
        self.LinkEmail()
    }
    
    func LinkEmail() {
        if let userData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            self.userObjectData = userData
            let userObject = KeyChainManager.NSDATAtoDictionary(data: self.userObjectData)
            self.userID = (userObject["_id"] as? String)!
            loader.show()
            FeathersManager.Services.accounts.request(.create(data: [
                "email":self.emailAddress,
                "provider":self.emailProvider,
                "provider_type":self.emailProviderType,
                "reauth":false,
                "password":self.passwordInfo.text!,
                "user_id":self.userID
                ], query: nil))
                .on(value: { response in
                    print("Response: ",response)
                    self.loader.hide()
                    let jsonDict:Dictionary = JSON(response.data.value).dictionaryObject as! NSMutableDictionary as Dictionary
                    self.emailLinkingResponse = jsonDict as! Dictionary
                    
                    print(self.emailLinkingResponse)
                    if self.emailLinkingResponse["success"] != nil {
                        if self.emailLinkingResponse["success"] as! Bool == true {
                            let accountID = self.emailLinkingResponse["account_id"] as! String
                            let accountIDData = KeyChainManager.stringToNSDATA(string: accountID)
                            _ = KeyChainManager.save(key: JuneConstants.KeychainKey.accountID, data: accountIDData)
                            self.goToHomePage()
                        } else {
                            self.showErrorAlert(message: "Failed to connect email. Please try again.")
                        }
                    }
                })
                .startWithFailed( { (error) in
                    print("error ", error)
                    self.loader.hide()
                    self.showErrorAlert(message: "Failed to connect email. Please try again.")
                })
        }
        
    }

    func goToHomePage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showHomePage()
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }
    
    static let backBtnFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .medium)
    static let enterPasswordLabelFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let imageName = LocalizedImageNameKey.GenericEmailViewHelper.BackgroundImageName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 3, y: 3, width: self.view.frame.size.width-6, height: self.view.frame.size.height-6)
        self.view.addSubview(imageView)
        
        let backBtn = UIButton(type: .system) as UIButton
        backBtn.backgroundColor = .white
        backBtn.setTitle(Localized.string(forKey: LocalizedString.GenericEmailViewBackButtonTitle), for: .normal)
        backBtn.setTitleColor(.black, for: .normal)
        backBtn.titleLabel?.font = GenericEmailViewController.backBtnFont 
        backBtn.frame = CGRect(x: 7, y: 25, width: 60, height: 40)
        backBtn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        self.enterPasswordLabel.frame = CGRect(x: 20, y: self.view.frame.size.height * 0.315, width: (self.view.frame.size.width-40), height: 20)
        self.enterPasswordLabel.textColor = .black
        self.enterPasswordLabel.font = GenericEmailViewController.enterPasswordLabelFont
        self.enterPasswordLabel.backgroundColor = .white
        self.enterPasswordLabel.textAlignment = .center
        self.enterPasswordLabel.text = Localized.string(forKey: LocalizedString.GenericEmailViewEnterPasswordLabelTitle)
        self.view.addSubview(self.enterPasswordLabel)
        
        var indentView = UIView()
        emailInfo.frame = CGRect(x: 25, y: self.view.frame.size.height * 0.415, width: self.view.frame.size.width - 50, height: self.view.frame.size.height * 0.088)
        emailInfo.font = UIFont.systemFont(ofSize: 14)
        indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
        emailInfo.leftView = indentView
        emailInfo.leftViewMode = .always
        emailInfo.placeholder = self.emailAddress
        emailInfo.setPlaceHolderColor()
        emailInfo.textColor = UIColor(hexString: "84878F")
        emailInfo.borderStyle = UITextBorderStyle.none
        emailInfo.layer.cornerRadius = 5
        emailInfo.autocorrectionType = UITextAutocorrectionType.no
        emailInfo.keyboardType = UIKeyboardType.emailAddress
        emailInfo.clearButtonMode = UITextFieldViewMode.whileEditing;
        emailInfo.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        emailInfo.backgroundColor = UIColor(hexString: LocalizedColorHexStringKey.GenericEmailViewHelper.EmailInfoBackgroundInactiveColor)
        emailInfo.delegate = delegate
        emailInfo.autocapitalizationType = .none
        emailInfo.isUserInteractionEnabled = false
        self.view.addSubview(emailInfo)
        
        passwordInfo.frame = CGRect(x: emailInfo.frame.origin.x, y: emailInfo.frame.origin.y+emailInfo.frame.size.height+13, width: emailInfo.frame.size.width, height: emailInfo.frame.size.height)
        passwordInfo.font = emailInfo.font
        let indentView2 = UIView(frame: CGRect(x: indentView.frame.origin.x, y: indentView.frame.origin.y, width: indentView.frame.size.width, height: indentView.frame.size.height))
        passwordInfo.leftView = indentView2
        passwordInfo.leftViewMode = .always
        passwordInfo.placeholder = Localized.string(forKey: LocalizedString.GenericEmailViewPasswordInfoPlaceholderTitle)
        passwordInfo.setPlaceHolderColor()
        passwordInfo.textColor = UIColor(hexString: "84878F")
        passwordInfo.borderStyle = UITextBorderStyle.none
        passwordInfo.layer.cornerRadius = 5
        passwordInfo.autocorrectionType = UITextAutocorrectionType.no
        passwordInfo.keyboardType = UIKeyboardType.default
        passwordInfo.returnKeyType = UIReturnKeyType.done
        passwordInfo.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordInfo.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        passwordInfo.backgroundColor = UIColor(hexString: LocalizedColorHexStringKey.SignUpScreenViewHelper.UserNameInfoBackgroundInactiveColor)
        passwordInfo.delegate = delegate
        passwordInfo.autocapitalizationType = .none
        passwordInfo.isSecureTextEntry = true
        self.view.addSubview(passwordInfo)
        
        nextButton = UIButton(frame: CGRect(x: emailInfo.frame.origin.x, y: emailInfo.frame.origin.y+(emailInfo.frame.size.height * 3)+15, width: emailInfo.frame.size.width, height: emailInfo.frame.size.height))
        nextButton.layer.cornerRadius = 5
        nextButton.backgroundColor = UIColor(hexString: LocalizedColorHexStringKey.SignUpScreenViewHelper.SignUpButtonBackgroundColor)
        nextButton.setTitle(Localized.string(forKey: LocalizedString.GenericEmailViewNextButtonTitle), for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "SanFranciscoText-Regular", size: 16.0)
        nextButton.addTarget(self, action: #selector(self.nextButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
