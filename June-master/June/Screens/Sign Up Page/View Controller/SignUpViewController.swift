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
import KeychainSwift

class SignUpViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var signUpLabel: UILabel = UILabel()
    var iAmJuneLabel: UILabel = UILabel()
    var usernameInfo: UITextField = UITextField()
    var passwordInfo: UITextField = UITextField()
    
    var loadingURL: Bool = false
    var delegate: SignUpDelegate?
    
    var signUpButton: UIButton!
    var loginButton: UIButton!
    var backButton = UIButton()

    var userObject: Dictionary = [String: Any]()
    
    var logoImage = UIImageView()
    var alreadyHaveAccountLabel = UILabel()
    
    static let signUpLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extra)
    static let signUpLabelFontForPlus: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extraMaxLarge)
    static let iAmJuneLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .large)
    static let alreadyHaveAccountLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
    static let signUpButtonFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .large)
    static let loginButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    
    lazy var loader: Loader = {
        let loader = Loader(with: self, isTimeOutNeeded: false)
        return loader
    }()
    
    @objc func signUpButtonTapped(sender : AnyObject) {
        LoginViewController().clearKeychain()
        if (!(self.usernameInfo.text?.isEmpty)! && (self.usernameInfo.text?.count)! < 3) {
            self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage1)
        } else if (self.usernameInfo.text?.isEmpty)!{
            self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage2)
        } else if (self.passwordInfo.text?.isEmpty)! {
            self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage3)
        } else if !((self.passwordInfo.text?.isEmpty)!) && (self.passwordInfo.text?.count)! < 8 {
            self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage4)
        } else if !(self.passwordInfo.text?.containsLettersAndNumbers)! {
            self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage5)
            return
        } else {
            if !loadingURL {
                
                loader.config.type = NVActivityIndicatorType(rawValue: sender.tag)!
                loader.show()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage(LocalizedStringKey.SignUpScreenViewHelper.authenticating)
                }
                self.createUserWithFeathers()
            }
        }
        
    }
    
    @objc func loginButtonTapped(sender : AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginPage()
    }
    
    func createUserWithFeathers() {
        loadingURL = true
        FeathersManager.Services.users.request(.create(data: [
            "strategy": JuneConstants.Feathers.strategy,
            "username": self.usernameInfo.text!,
            "password": self.passwordInfo.text!
            ], query: nil))
            .on(value: { response in
                let json:Dictionary = JSON(response.data.value).dictionaryObject!
                self.userObject = json

                self.loadingURL = false
                self.loader.hide()
                self.loginUserWithFeathersUserName()
                
            })
            .startWithFailed { (error) in
                self.loader.hide()
                self.loadingURL = false
                let errorString = String(describing: error.error)
                let feathersNetworkErrorStringNotAuthenticated = String(describing: FeathersNetworkError.notAuthenticated)
                let featherNetworkErrorStringConflict = String(describing: FeathersNetworkError.conflict)
                if !errorString.isEmpty && errorString == feathersNetworkErrorStringNotAuthenticated {
                    self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage6)
                } else if !errorString.isEmpty && errorString == featherNetworkErrorStringConflict {
                    self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage7)
                } else {
                    self.showErrorAlert(message: LocalizedStringKey.SignUpScreenViewHelper.errorMessage8)
                }
                
        }

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
                guard let loginResponse: Dictionary = JSON(response).dictionaryObject else {
                    self.showErrorAlert(message: "Error")
                    return
                }
                let total = loginResponse.keys.count
                if total > 0 {
                    if loginResponse["accessToken"] != nil {
                        if let accessToken = loginResponse["accessToken"] as? String {
                            KeychainSwift().set(accessToken, forKey: JuneConstants.Feathers.jwtToken)
                        }
                    }
                    if loginResponse["user"] != nil {
                        if let userObject = loginResponse["user"] as? [String: Any] {
                            let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: userObject)
                            _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                            
                            let usernameData = KeyChainManager.stringToNSDATA(string: self.usernameInfo.text!)
                            _ = KeyChainManager.save(key: JuneConstants.KeychainKey.username, data: usernameData)
                            self.goToEmailDiscoveryPage()
                        }
                    }
                }
            })
            .startWithFailed { (error) in
                print(error)
        }
        
    }

    func pullThreadFromFeathers() {
        let query = Query()
            .eq(property: "account_id", value: "dyxn5j1whfh7qhj4xznguj9of").limit(10)
        FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
            print(response)
        }).startWithFailed { (error) in
            print(error)
        }
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
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
        delegate = SignUpDelegate(parentVC: self)
        
        self.logoImage.image = #imageLiteral(resourceName: "logo_june")

        self.signUpLabel.text = Localized.string(forKey: LocalizedString.SignUpViewSignUpLabelTitle)
        self.signUpLabel.textAlignment = .center
        self.signUpLabel.backgroundColor = UIColor.clear
        self.signUpLabel.textColor = UIColor.init(hexString:"#585F6F")
        
        self.iAmJuneLabel.text = Localized.string(forKey: .SignUpViewIamJuneLabelTitle) // "Hey there, I'm June."
        self.iAmJuneLabel.textAlignment = .center
        self.iAmJuneLabel.textColor = UIColor(hexString: "#000000")
        self.iAmJuneLabel.font = SignUpViewController.iAmJuneLabelFont
        
        let borderColor = UIColor.init(hexString: "D8D8D8")
        
        var indentView = UIView()
        usernameInfo.font = UIFont.systemFont(ofSize: 13)
        indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: usernameInfo.frame.size.height))
        usernameInfo.leftView = indentView
        usernameInfo.leftViewMode = .always
        usernameInfo.placeholder = Localized.string(forKey: LocalizedString.SignUpViewUsernameFieldPlaceholder)
        usernameInfo.setPlaceHolderColor()
        usernameInfo.textColor = UIColor(hexString: LocalizedColorHexStringKey.SignUpScreenViewHelper.usernameInfoTextColor)
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
        passwordInfo.placeholder = Localized.string(forKey: LocalizedString.SignUpViewPasswordFieldPlaceholder)
        passwordInfo.setPlaceHolderColor()
        passwordInfo.textColor = UIColor(hexString: LocalizedColorHexStringKey.SignUpScreenViewHelper.usernameInfoTextColor)
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
      
        self.alreadyHaveAccountLabel.text = "Already have an account?"
        self.alreadyHaveAccountLabel.font = SignUpViewController.alreadyHaveAccountLabelFont
        self.alreadyHaveAccountLabel.text = Localized.string(forKey: LocalizedString.SignUpViewHaveAnAccountLabelTitle)
        self.alreadyHaveAccountLabel.font = UIFont(name: "Lato-Regular", size: 14)
        self.alreadyHaveAccountLabel.tintColor = UIColor(red:0.27, green:0.3, blue:0.36, alpha:1)
        self.alreadyHaveAccountLabel.backgroundColor = UIColor.clear
  
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            setupSubViewsForiPhoneX()
        } else {
            setupSubviewsExceptX()
        }
    }
    
    func setupSubViewsForiPhoneX() {
        let screen: CGFloat = self.view.frame.size.width
        
        self.backButton.frame = CGRect(x: 18, y: 79, width: 10, height: 18)
        self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        self.logoImage.frame = CGRect(x: 132, y: 64, width: 111, height: 45)
        self.logoImage.image = #imageLiteral(resourceName: "june_loginsignup_logo")
        self.view.addSubview(logoImage)
        
        self.signUpLabel.frame = CGRect(x: 148, y: 113, width: 83, height: 29)
        self.signUpLabel.font = SignUpViewController.signUpLabelFont
        self.view.addSubview(signUpLabel)
        
        self.iAmJuneLabel.frame = CGRect(x: 108, y: 165, width: 159, height: 22)
        self.view.addSubview(self.iAmJuneLabel)
        
        usernameInfo.frame = CGRect(x: 24, y: 201, width: 326, height: 54)
        self.view.addSubview(usernameInfo)
        
        passwordInfo.frame = CGRect(x: 24, y: 272, width: 326, height: 54)
        self.view.addSubview(passwordInfo)
        
        let signUpBorderColor = UIColor.init(hexString: "#D6D6D6")
        signUpButton = UIButton(frame: CGRect(x: 24, y: 357, width: 326, height: 55))
        signUpButton.layer.cornerRadius = 28
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = signUpBorderColor.cgColor
        signUpButton.setTitleColor(.black , for: .normal)
        signUpButton.backgroundColor = UIColor.clear
        signUpButton.titleLabel?.font = SignUpViewController.signUpLabelFont
        signUpButton.setTitle(Localized.string(forKey: LocalizedString.SignUpViewSignUpButtonTitle), for: .normal)
        signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        
        self.alreadyHaveAccountLabel.frame = CGRect(x: 0.236 * screen, y: 434, width: 0.41333333333 * screen, height: 17)
        self.view.addSubview(alreadyHaveAccountLabel)
        
        self.loginButton = UIButton(frame: CGRect(x: 0.6493333333333 * screen, y: 434, width: 0.12 * screen, height: 17))
        self.loginButton.backgroundColor = .clear
        self.loginButton.setTitle(Localized.string(forKey: LocalizedString.SignUpViewLogInButtonTitle), for: .normal)
        self.loginButton.setTitleColor(UIColor(red:0.27, green:0.3, blue:0.36, alpha:1), for: .normal)
        self.loginButton.titleLabel?.font = SignUpViewController.loginButtonFont
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(self.loginButton)
    }
    
    func setupSubviewsExceptX() {
        let plusSize = 414
        let screen: CGFloat = self.view.frame.size.width
        
        self.backButton.frame = CGRect(x: 21, y: 60, width: 10, height: 18)
        if Int(screen) == plusSize {
            self.backButton.frame = CGRect(x: 21, y: 62, width: 10, height: 18)
        }
        self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        self.logoImage.frame = CGRect(x: 133, y: 46, width: 111, height: 45)
        if Int(screen) == plusSize {
            self.logoImage.frame = CGRect(x: 152, y: 47, width: 111, height: 45)
        }
        self.logoImage.image = #imageLiteral(resourceName: "june_loginsignup_logo")
        self.view.addSubview(logoImage)
        
        self.signUpLabel.frame = CGRect(x: 155.5, y: 90, width: 70, height: 24)
        self.signUpLabel.font = SignUpViewController.signUpLabelFont
        if Int(screen) == plusSize {
            self.signUpLabel.frame = CGRect(x: 168, y: 96, width: 83, height: 29)
            self.signUpLabel.font = SignUpViewController.signUpLabelFontForPlus
        }
        self.view.addSubview(signUpLabel)
        
        self.iAmJuneLabel.frame = CGRect(x: 109, y: 140, width: 159, height: 22)
        if Int(screen) == plusSize {
            self.iAmJuneLabel.frame = CGRect(x: 128, y: 148, width: 159, height: 22)
        }
        self.view.addSubview(self.iAmJuneLabel)
        
        usernameInfo.frame = CGRect(x: 25, y: 174, width: 326, height: 54)
        if Int(screen) == plusSize {
            usernameInfo.frame = CGRect(x: 44, y: 184, width: 326, height: 54)
        }
        self.view.addSubview(usernameInfo)
        
        passwordInfo.frame = CGRect(x: 25, y: 239, width: 326, height: 54)
        if Int(screen) == plusSize {
            passwordInfo.frame = CGRect(x: 44, y: 255, width: 326, height: 54)
        }
        self.view.addSubview(passwordInfo)
        
        let signUpBorderColor = UIColor.init(hexString: "#D6D6D6")
        signUpButton = UIButton(frame: CGRect(x: 25, y: 307, width: 326, height: 55))
        if Int(screen) == plusSize {
            signUpButton = UIButton(frame: CGRect(x: 44, y: 340, width: 326, height: 55))
        }
        signUpButton.layer.cornerRadius = 28
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = signUpBorderColor.cgColor
        signUpButton.setTitleColor(.black , for: .normal)
        signUpButton.backgroundColor = UIColor.clear
        signUpButton.titleLabel?.font = SignUpViewController.signUpLabelFont
        signUpButton.setTitle(Localized.string(forKey: LocalizedString.SignUpViewSignUpButtonTitle), for: .normal)
        signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        
        self.alreadyHaveAccountLabel.frame = CGRect(x: 0.236 * screen, y: 376, width: 0.41333333333 * screen, height: 17)
        if Int(screen) == plusSize {
            self.alreadyHaveAccountLabel.frame = CGRect(x: 112, y: 417, width: 0.41333333333 * screen, height: 17)
        }
        self.view.addSubview(alreadyHaveAccountLabel)
        
        self.loginButton = UIButton(frame: CGRect(x: 0.6493333333333 * screen, y: 376, width: 0.12 * screen, height: 17))
        if Int(screen) == plusSize {
            self.loginButton = UIButton(frame: CGRect(x: 0.6493333333333 * screen - 3, y: 417, width: 0.12 * screen, height: 17))
        }
        self.loginButton.backgroundColor = .clear
        self.loginButton.setTitle(Localized.string(forKey: LocalizedString.SignUpViewLogInButtonTitle), for: .normal)
        self.loginButton.setTitleColor(UIColor(red:0.27, green:0.3, blue:0.36, alpha:1), for: .normal)
        self.loginButton.titleLabel?.font = SignUpViewController.loginButtonFont
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(self.loginButton)
    }
    
    @objc func backButtonPressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginSignupPage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func buttonTapped(_ sender: UIButton) {
        loader.config.type = NVActivityIndicatorType(rawValue: sender.tag)!
        loader.show()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage(LocalizedStringKey.SignUpScreenViewHelper.authenticating)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.loader.hide()
        }
        
    }
    
}
