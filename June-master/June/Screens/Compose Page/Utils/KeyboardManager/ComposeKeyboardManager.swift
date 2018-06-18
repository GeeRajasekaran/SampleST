//
//  ComposeKeyboardManager.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol ComposeKeyboardManagerDelegate: class {
    func manager(_ keyboardManager: ComposeKeyboardManager, willShowKeyboardWith height: CGFloat)
    func manager(_ keyboardManager: ComposeKeyboardManager, willHideKeyboardWith height: CGFloat)
    func manager(_ keyboardManager: ComposeKeyboardManager, willChangeSizeWith delta: CGFloat)
}

class ComposeKeyboardManager {
    
    // MARK: - Variables
    
    private unowned var parentViewController: ComposeViewController
    private weak var delegate: ComposeKeyboardManagerDelegate?
    
    // MARK: - Initialization
    
    init(callbackResponder: ComposeKeyboardManagerDelegate?, rootVC: ComposeViewController) {
        parentViewController = rootVC
        delegate = callbackResponder
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

            if (parentViewController.textInputView?.frame.height)! + (parentViewController.textInputView?.frame.origin.y)! > UIScreen.main.bounds.height - finalHeight {
                UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.delegate?.manager(sSelf, willShowKeyboardWith: finalHeight)
                })
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let oldKeyboardHeight = keyboardSize?.height, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                guard let sSelf = self else { return }
                sSelf.delegate?.manager(sSelf, willHideKeyboardWith: oldKeyboardHeight)
            })
        }
    }
    
    @objc private func keyboardWillChangeSize(_ notification: Notification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSizeFinal = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let keyboardSizeStart = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        if let finalHeight = keyboardSizeFinal?.height, let startHeight = keyboardSizeStart?.height, let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            let delta = finalHeight - startHeight
            if delta == 0 { return }

            //Checked if size already changed
            guard let actionsViewFrame = parentViewController.actionsView?.frame else { return }
            if parentViewController.view.frame.height - finalHeight == actionsViewFrame.origin.y + actionsViewFrame.height {
                return
            }
            
            UIView.animate(withDuration: duration, animations: { [weak self] in
                guard let sSelf = self else { return }
                sSelf.delegate?.manager(sSelf, willChangeSizeWith: delta)
            })
        }
    }
}
