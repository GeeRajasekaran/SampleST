//
//  SignUpDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 7/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class LoginDelegate: NSObject {
    unowned var parentVC: LoginViewController
    
    init(parentVC: LoginViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITextFieldDelegate

extension LoginDelegate:UITextFieldDelegate {
    
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
        if textField == parentVC.usernameInfo {
            if (!(textField.text?.isEmpty)! && (textField.text?.count)! < 3) {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.LoginViewErrorMessageUsernameTooShort))
            } else if (textField.text?.isEmpty)!{
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.LoginViewErrorMessageUsernameRequirement))
            }
            parentVC.passwordInfo.becomeFirstResponder()
        }
        if  textField == parentVC.passwordInfo {
            if (textField.text?.isEmpty)! {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.LoginViewErrorMessagePasswordRequirement))
            } else
            if !((textField.text?.isEmpty)!) && (textField.text?.count)! < 8 {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.LoginViewErrorMessagePasswordLength))
            }
//            else if !(textField.text?.containsLettersAndNumbers)! {
//                parentVC.showErrorAlert(message: LocalizedStringKey.LoginScreenViewHelper.errorMessage5)
//            }
            else {
                if !parentVC.loadingURL {
                    parentVC.loginButtonTapped(sender: textField)
                }
            }
        }
        return true;
    }
}
