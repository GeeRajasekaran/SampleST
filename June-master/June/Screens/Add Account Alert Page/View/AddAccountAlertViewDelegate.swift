//
//  AddAccountAlertViewDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 8/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AddAccountAlertViewDelegate: NSObject {
    unowned var parentVC: AddAccountAlertViewController
    
    init(parentVC: AddAccountAlertViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
}

// MARK:- UITextFieldDelegate

extension AddAccountAlertViewDelegate:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
                        print("TextField did begin editing method called")
        parentVC.alertView.frame.origin.y -= 60
        parentVC.closeButton.frame.origin.y -= 60
        parentVC.titleLabel.frame.origin.y -= 60
        parentVC.emailAddress.frame.origin.y -= 60
        parentVC.addAccountButton.frame.origin.y -= 60
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
        
        textField.resignFirstResponder();
        return true;
    }
}