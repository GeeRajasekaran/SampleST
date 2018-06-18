//
//  SettingsDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 8/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsDelegate: NSObject {
    unowned var parentVC: SettingsViewController
    
    init(parentVC: SettingsViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
}

// MARK:- UITextFieldDelegate

extension SettingsDelegate:UITextFieldDelegate {
    
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


extension SettingsDelegate: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
}

