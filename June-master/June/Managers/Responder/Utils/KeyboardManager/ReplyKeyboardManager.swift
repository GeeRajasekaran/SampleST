//
//  KeyboardManager.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyKeyboardManager: IResponderKeyboardManager {
    
    // MARK: - Variables
    
    unowned var parentViewController: ResponderViewControllerOld
    
    // MARK: - Initialization
    
    required init(rootVC: ResponderViewControllerOld) {
        parentViewController = rootVC
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
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let finalHeight = keyboardSize?.height, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            if parentViewController.view.frame.origin.y > UIScreen.main.bounds.height - finalHeight {
                if parentViewController.responder?.state == .minimized {
                    parentViewController.responder?.changeSize()
                }
                UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                    self?.parentViewController.view.frame.origin.y -= finalHeight
                    self?.parentViewController.view.layoutIfNeeded()
                })
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let finalHeight = keyboardSize?.height, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            if parentViewController.view.frame.origin.y < UIScreen.main.bounds.height - finalHeight {
                if parentViewController.responder?.state == .collapsed {
                    parentViewController.responder?.minimize()
                }
                UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                    self?.parentViewController.view.frame.origin.y += finalHeight
                    self?.parentViewController.view.layoutIfNeeded()
                })
            }
        }
    }
    //TODO: check correction of height when keyboard height change for different devices
    @objc private func keyboardWillChangeSize(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSizeFinal = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let keyboardSizeStart = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size

        if let finalHeight = keyboardSizeFinal?.height, let startHeight = keyboardSizeStart?.height, let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {

            if parentViewController.view.frame.origin.y > UIScreen.main.bounds.height - finalHeight { return }

            let delta = finalHeight - startHeight
            if delta > 0 {
                UIView.animate(withDuration: duration, animations: {
                    if self.parentViewController.responder?.state == .expanded {
                        self.parentViewController.view.frame.size.height -= delta
                        self.parentViewController.accessoryView?.frame.size.height -= delta
                        self.parentViewController.accessoryView?.updateLayout(for: self.parentViewController.view.frame.size.height)
                    } else {
                        self.parentViewController.view.frame.origin.y -= abs(delta)
                    }
                    self.parentViewController.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: duration, animations: {
                    if self.parentViewController.responder?.state == .expanded {
                        self.parentViewController.view.frame.size.height += abs(delta)
                        self.parentViewController.accessoryView?.frame.size.height += abs(delta)
                        self.parentViewController.accessoryView?.updateLayout(for: self.parentViewController.view.frame.size.height)
                    } else {
                        self.parentViewController.view.frame.origin.y += abs(delta)
                    }
                    self.parentViewController.view.layoutIfNeeded()
                })
            }
        }
    }
}
