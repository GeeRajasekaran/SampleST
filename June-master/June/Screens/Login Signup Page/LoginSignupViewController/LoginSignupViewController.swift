//
//  LoginSignupViewController.swift
//  June
//
//  Created by Tatia Chachua on 15/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {
    
    var logo = UIImageView()
    var loginButton = UIButton()
    var signUpButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            //iPhone X
            setupSubViewsForiPhoneX()
        } else {
            setupSubviews()
        }
      
    }
    
    func setupSubViewsForiPhoneX() {
        
        self.logo.frame = CGRect(x: 70, y: 338, width: 236, height: 96)
        self.logo.image = #imageLiteral(resourceName: "june_logo_new")
        self.view.addSubview(logo)
        
        self.loginButton.frame = CGRect(x: 24, y: 668, width: 326, height: 55)
        self.loginButton.setImage(#imageLiteral(resourceName: "login_button"), for: .normal)
        self.loginButton.setImage(#imageLiteral(resourceName: "login_highlight"), for: .highlighted)
        self.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        self.signUpButton.frame = CGRect(x: 24, y: 597, width: 326, height: 55)
        self.signUpButton.setImage(#imageLiteral(resourceName: "signup_button"), for: .normal)
        self.signUpButton.setImage(#imageLiteral(resourceName: "signup_highlight"), for: .highlighted)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        self.view.addSubview(signUpButton)
    }
    
    func setupSubviews() {
        let plusSize = 414
        
        self.logo.frame = CGRect(x: 71, y: 240, width: 236, height: 96)
        if Int(self.view.frame.size.width) == plusSize {
            self.logo.frame = CGRect(x: 90, y: 287, width: 236, height: 96)
        }
        
        self.logo.image = #imageLiteral(resourceName: "june_logo_new")
        self.view.addSubview(logo)
        
        self.loginButton.frame = CGRect(x: 25, y: 570, width: 326, height: 55)
        if Int(self.view.frame.size.width) == plusSize {
           self.loginButton.frame = CGRect(x: 44, y: 617, width: 326, height: 55)
        }
        self.loginButton.setImage(#imageLiteral(resourceName: "login_button"), for: .normal)
        self.loginButton.setImage(#imageLiteral(resourceName: "login_highlight"), for: .highlighted)
        self.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        self.signUpButton.frame = CGRect(x: 25, y: 499, width: 326, height: 55)
        if Int(self.view.frame.size.width) == plusSize {
            self.signUpButton.frame = CGRect(x: 44, y: 546, width: 326, height: 55)
        }
        self.signUpButton.setImage(#imageLiteral(resourceName: "signup_button"), for: .normal)
        self.signUpButton.setImage(#imageLiteral(resourceName: "signup_highlight"), for: .highlighted)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        self.view.addSubview(signUpButton)
    }
    
    @objc func signUpButtonPressed() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showSignUpPage()
        }
    }
    
    @objc func loginButtonPressed() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showLoginPage()
        }
    }
    
}
