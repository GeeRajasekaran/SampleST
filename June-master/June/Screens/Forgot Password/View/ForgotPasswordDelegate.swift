//
//  ForgorPasswordDelegate.swift
//  June
//
//  Created by Tatia Chachua on 16/08/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ForgotPasswordDelegate: NSObject {
    unowned var parentVC: ForgotPasswordViewController
    
     init(parentVC: ForgotPasswordViewController) {
        self.parentVC = parentVC
        super.init()
    }

}

extension ForgotPasswordDelegate: UITextFieldDelegate {
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        print("While entering the characters this method gets called")
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if textField == parentVC.usernameTextField {
            if (textField.text?.isEmpty)! {
                parentVC.showErrorAlert(message: "Username or email is requaired")
                
            } else {
                if (textField.text?.contains("@"))! {
                
                    if !(textField.text?.isValidEmail())! {
                        parentVC.showErrorAlert(message: "Email doesn't exist. Try again, or create an account.")
                        
                    } else {
                        self.parentVC.emailRequest()
                        parentVC.showErrorAlert(message: "Email sent successfully")
                        
                        let sentEmailPage = SentEmailViewController()
                        sentEmailPage.emailStr = self.parentVC.email
                        sentEmailPage.usernameStr = self.parentVC.username
                        self.parentVC.navigationController?.pushViewController(sentEmailPage, animated: true)
                }
                } else {
                     self.parentVC.usernameRequest()
                     parentVC.showErrorAlert(message: "Email sent successfully")
                    
                    let sentEmailPage = SentEmailViewController()
                    sentEmailPage.emailStr = self.parentVC.email
                    sentEmailPage.usernameStr = self.parentVC.username
                    self.parentVC.navigationController?.pushViewController(sentEmailPage, animated: true)
                }
            }
        }
        return true
    }
    
}
