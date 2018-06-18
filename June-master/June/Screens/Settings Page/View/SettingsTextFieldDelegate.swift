//
//  SettingsTextFieldDelegate.swift
//  June
//
//  Created by Tatia Chachua on 17/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsTextFieldDelegate: NSObject {

    unowned var parentVC: SettingsViewController
    
    init(parentVC: SettingsViewController) {
        self.parentVC = parentVC
        super.init()
    }

}


// MARK:- text field delegate
extension SettingsTextFieldDelegate: UITextFieldDelegate {
    
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
        if textField == self.parentVC.originalPasswordTextField {
            self.parentVC.changePasswordTextField.becomeFirstResponder()
        } else if textField == self.parentVC.changePasswordTextField {
            self.parentVC.saveChangesButtonPressed()
        } else if textField == self.parentVC.editFullNameTextField {
            self.parentVC.editDoneButtonPressed()
        }
        textField.resignFirstResponder();
        return true;
    }
}

