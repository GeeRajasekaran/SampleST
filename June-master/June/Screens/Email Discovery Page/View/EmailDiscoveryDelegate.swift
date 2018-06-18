//
//  EmailDiscoveryDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 7/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class EmailDiscoveryDelegate: NSObject {
    unowned var parentVC: EmailDiscoveryViewController
    
    init(parentVC: EmailDiscoveryViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITextFieldDelegate

extension EmailDiscoveryDelegate:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//                print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//                print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//                print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//                print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//                print("TextField should snd editing method called")
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//                print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("Return button clicked")
        if textField == parentVC.emailInfo {
            if (textField.text?.isEmpty)! {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.EmailDiscoveryViewErrorAlertEmailRequirement))
            } else if !(textField.text?.isValidEmail())! {
                parentVC.showErrorAlert(message: Localized.string(forKey: LocalizedString.EmailDiscoveryViewErrorAlertEnterValidEmail))
            } else {
                parentVC.nextButtonTapped(sender: textField)
            }
        }
        textField.resignFirstResponder();
        return true;
    }
}
