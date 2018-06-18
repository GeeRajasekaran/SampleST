//
//  SignUpDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 7/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SignUpDelegate: NSObject {
    unowned var parentVC: SignUpViewController
    
    init(parentVC: SignUpViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITextFieldDelegate

extension SignUpDelegate:UITextFieldDelegate {
    
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
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.SignUpViewErrorAertUsernameTooShort))
            } else if (textField.text?.isEmpty)!{
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.SignUpViewErrorAlertUsernameRequirement))
            }
            parentVC.passwordInfo.becomeFirstResponder()
        }
        if  textField == parentVC.passwordInfo {
            if (textField.text?.isEmpty)! {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.SignUpViewErrorAlertPasswordRequirement))
            } else
            if !((textField.text?.isEmpty)!) && (textField.text?.count)! < 8 {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.SignUpViewErrorAlertPasswordLength))
            } else if !(textField.text?.containsLettersAndNumbers)! {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.SignUpViewErrorAlertPasswordLettersNumbersRequirement))
            } else {
                if !parentVC.loadingURL {
                    parentVC.signUpButtonTapped(sender: textField)
                }
            }
        }
        return true;
    }
}
