//
//  ForgotPasswordViewController.swift
//  June
//
//  Created by Tatia Chachua on 16/08/17.
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

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var backButton: UIButton!
    var lucyLogoImage: UIImageView!
    var enterInfoLabel: UILabel = UILabel()
    var usernameTextField: UITextField = UITextField()
    var sendLinkButton: UIButton!
    var delegate: ForgotPasswordDelegate?
    
    var email: String!
    var username: String!
    
    static let backBUttonFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)
    static let enterInfoLabelFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = ForgotPasswordDelegate(parentVC: self)
        self.view.backgroundColor = UIColor.white
        
        self.backButton = UIButton(frame: CGRect(x: 7, y: 25, width: 60, height: 40))
        self.backButton.backgroundColor = UIColor.clear
        self.backButton.setTitle(Localized.string(forKey: LocalizedString.ForgotPasswordViewBackButtonTitle), for: .normal)
        self.backButton.titleLabel?.alpha = 0.7
        self.backButton.setTitleColor(.black, for: .normal)
        self.backButton.titleLabel?.font = ForgotPasswordViewController.backBUttonFont
        self.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(self.backButton)
        
        self.lucyLogoImage = UIImageView()
        self.lucyLogoImage.frame = CGRect(x: Int(self.view.center.x - 80), y: 134, width: 160, height: 60)
        self.lucyLogoImage.image = UIImage(named: LocalizedImageNameKey.ForgotPasswordViewHelper.JuneLogoImageName)
        self.view.addSubview(self.lucyLogoImage)       
        
        self.enterInfoLabel.frame = CGRect(x: Int(self.view.center.x - 142), y: 206, width: 284, height: 63)
        self.enterInfoLabel.font = ForgotPasswordViewController.enterInfoLabelFont
        self.enterInfoLabel.text = Localized.string(forKey: LocalizedString.ForgotPasswordViewEnterInfoLabel)
        self.enterInfoLabel.textAlignment = .center
        self.enterInfoLabel.numberOfLines = 0
        self.enterInfoLabel.alpha = 0.7
        self.view.addSubview(self.enterInfoLabel)
        
        var indentView = UIView()
        indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.view.frame.size.height * 0.16))
        self.usernameTextField.leftView = indentView
        self.usernameTextField.leftViewMode = .always
        self.usernameTextField.frame = CGRect(x: 20, y: 316, width: self.view.frame.size.width - 40, height: 60)
        self.usernameTextField.font = UIFont.systemFont(ofSize: 14)
        self.usernameTextField.placeholder = Localized.string(forKey: LocalizedString.ForgotPasswordViewUsernameTextFieldPlaceholder)
        self.usernameTextField.setPlaceHolderColor()
        self.usernameTextField.textColor = UIColor(hexString: LocalizedColorHexStringKey.LoginScreenViewHelper.usernameInfoTextColor)
        self.usernameTextField.borderStyle = UITextBorderStyle.none
        self.usernameTextField.layer.cornerRadius = 5
        self.usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        self.usernameTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.usernameTextField.backgroundColor = UIColor(hexString: LocalizedColorHexStringKey.SignUpScreenViewHelper.UserNameInfoBackgroundInactiveColor)
        self.usernameTextField.autocapitalizationType = .none
        self.usernameTextField.returnKeyType = .done
        self.usernameTextField.delegate = delegate
        self.usernameTextField.keyboardType = UIKeyboardType.emailAddress
        self.view.addSubview(self.usernameTextField)
        
        sendLinkButton = UIButton(frame: CGRect(x: 20, y: 467, width: self.view.frame.size.width - 40, height: 60))
        sendLinkButton.layer.cornerRadius = 5
        sendLinkButton.backgroundColor = UIColor(hexString: LocalizedColorHexStringKey.SignUpScreenViewHelper.SignUpButtonBackgroundColor)
        sendLinkButton.setTitle(Localized.string(forKey: LocalizedString.ForgotPasswordViewSendLinkButtonTitle), for: .normal)
        sendLinkButton.addTarget(self, action: #selector(sendLinkButtonPressed), for: .touchUpInside)
        self.view.addSubview(self.sendLinkButton)
        
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }

    @objc func backButtonPressed()   {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func forgotEmailButtonPressed() {
        print("Forgot email button pressed")
    }

    @objc func sendLinkButtonPressed() {

            if (usernameTextField.text?.isEmpty)! {
                self.showErrorAlert(message: "Username or email is requaired")
                
            } else {
                if (usernameTextField.text?.contains("@"))! {
                    
                    if !(usernameTextField.text?.isValidEmail())! {
                        self.showErrorAlert(message: "Email doesn't exist. Try again, or create an account.")
                        
                    } else {
                        self.emailRequest()
                        self.showErrorAlert(message: "Email sent successfully")
                        
                        let sentEmailPage = SentEmailViewController()
                        sentEmailPage.emailStr = self.email
                        sentEmailPage.usernameStr = self.username
                        self.navigationController?.pushViewController(sentEmailPage, animated: true)
                    }
                } else {
                    self.usernameRequest()
                    self.showErrorAlert(message: "Email sent successfully")
                    let sentEmailPage = SentEmailViewController()
                    sentEmailPage.emailStr = self.email
                    sentEmailPage.usernameStr = self.username
                    self.navigationController?.pushViewController(sentEmailPage, animated: true)
                }
            }
    }
    
    func usernameRequest() {
        FeathersManager.Services.tokens.request(.create(data: [
            "username": self.usernameTextField.text!,
            ], query: nil))
    
            .on(value: { response in
                print(response)
//                print("this is response: \(response)")
        })
            .startWithFailed { (error) in
                print(error)
        }
        
        self.username = self.usernameTextField.text!
    }
    
    func emailRequest() {
        FeathersManager.Services.tokens.request(.create(data: [
            "email": self.usernameTextField.text!,
            ], query: nil))

            .on(value: { response in
                print(response)
            })
            .startWithFailed { (error) in
                print(error)
        }
        
        self.email = self.usernameTextField.text!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
