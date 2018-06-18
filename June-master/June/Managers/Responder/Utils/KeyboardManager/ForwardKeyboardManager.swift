//
//  ForwardKeyboardManager.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ForwardKeyboardManager: IResponderKeyboardManager {
    
    // MARK: - Variables
    
    unowned var parentViewController: ResponderViewControllerOld
    private var bottomInputViewPosition: CGFloat
    
    // MARK: - Initialization
    
    required init(rootVC: ResponderViewControllerOld) {
        parentViewController = rootVC
        if let inputView = parentViewController.accessoryView {
            bottomInputViewPosition = parentViewController.view.frame.height - inputView.frame.height
        } else {
            bottomInputViewPosition = 0
        }

    }
    
    // MARK: - Subscrbe / unsubscribe keyboard notifications
    
    func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeSize(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func unsubscribeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary? else { return }
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let finalHeight = keyboardSize?.height, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            guard let inputView = parentViewController.accessoryView else { return }
            if inputView.frame.origin.y == bottomInputViewPosition {
                UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                    inputView.frame.origin.y -= finalHeight
                    self?.parentViewController.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let finalHeight = keyboardSize?.height, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            guard let inputView = parentViewController.accessoryView else { return }
            if inputView.frame.origin.y == bottomInputViewPosition - finalHeight {
                UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                    inputView.frame.origin.y += finalHeight
                    self?.parentViewController.view.layoutIfNeeded()
                })
            }

        }
    }
    
    @objc private func keyboardWillChangeSize(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSizeFinal = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let finalHeight = keyboardSizeFinal?.height, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            guard let inputView = parentViewController.accessoryView else { return }
            UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                if let unwrappedPosition = self?.bottomInputViewPosition {
                    inputView.frame.origin.y = unwrappedPosition - finalHeight
                    self?.parentViewController.view.layoutIfNeeded()
                }
            })
        }
    }
}
