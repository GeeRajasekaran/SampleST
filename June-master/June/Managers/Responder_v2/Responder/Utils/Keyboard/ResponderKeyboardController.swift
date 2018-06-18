//
//  ResponderKeyboardController.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderKeyboardController: IKeyboardController {
    
    // MARK: - Variables & Constants
    
    weak var delegate: KeyboardControllerDelegate?
    private var isKeyboardShown: Bool = false
    
    private var previousHeights: (start: CGFloat, end: CGFloat) = (start: -1, end: -1)
    
    // MARK: - Subscribe/unsubscribe logic
    
    func subscribe(_ delegate: KeyboardControllerDelegate?) {
        self.delegate = delegate
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
//        self.delegate = nil
    }
    
    // MARK: - Private handling logic
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let startHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height,
            let endHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        
        if previousHeights.start == startHeight, previousHeights.end == endHeight { return }
        previousHeights.start = startHeight
        previousHeights.end = endHeight
        
        if !isKeyboardShown {
            isKeyboardShown = true
            delegate?.controller(self, willShowKeyboardWith: endHeight)
            return
        }
        
        if endHeight > startHeight {
            isKeyboardShown = true
            delegate?.controller(self, willIncreaseHeight: endHeight - startHeight)
        } else if startHeight > endHeight {
            isKeyboardShown = true
            delegate?.controller(self, willDecreaseHeight: startHeight - endHeight)
        } else if startHeight == endHeight {
            isKeyboardShown = true
            delegate?.controller(self, willShowKeyboardWith: endHeight)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let startHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height,
            let endHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        
        if endHeight == startHeight {
            isKeyboardShown = false
            previousHeights = (start: -1, end: -1)
            delegate?.controller(self, willHideKeyboardWith: endHeight)
        }
    }
}
