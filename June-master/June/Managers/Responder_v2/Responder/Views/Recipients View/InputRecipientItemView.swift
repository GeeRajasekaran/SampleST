//
//  InputRecipientItemView.swift
//  June
//
//  Created by Ostap Holub on 2/23/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class InputRecipientItemView: RecipientItemView, UITextFieldDelegate {
    
    // MARK: - Subviews
    
    var onReturnAction: ((String) -> Void)?
    var fromShareInJune: Bool = false
    var textField: RecipientInputTextField?
    var isSearchStarted: Bool = false
    
    // MARK: - Public UI setup
    
    override func setupViews(for recipient: EmailReceiver) {
        super.setupViews(for: recipient)
        addTextField()
        subscribeForNotifications()
    }
    
    func setFirstResponder() {
        textField?.becomeFirstResponder()
    }
    
    func addPlaceholder() {
        textField?.placeholder = LocalizedStringKey.ResponderHelper.InputCellPlaceholder
    }
    
    func removePlaceholder() {
        textField?.placeholder = ""
    }
    
    private func clearText() {
        textField?.text = ""
    }
    
    // MARK: - Text field
    
    private func addTextField() {
        guard textField == nil else { return }
        textField = RecipientInputTextField(frame: bounds)
        textField?.font = UIFont(name: LocalizedFontNameKey.ResponderHelper.ReceiverTitleFont, size: 11)
        textField?.textColor = UIColor.receiverTitleGrey
        textField?.autocorrectionType = .default
        textField?.keyboardType = .emailAddress
        textField?.autocapitalizationType = .none
        textField?.delegate = self
        textField?.deleteDelegate = self
        if textField != nil {
            addSubview(textField!)
        }
        
        textField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Text field text did change
    
    @objc private func textDidChange() {
        if textField?.text != "" && !isSearchStarted {
            isSearchStarted = true
            NotificationCenter.default.post(name: .onSearchStarted, object: nil)
        } else if textField?.text == "" {
            isSearchStarted = false
            NotificationCenter.default.post(name: .onSearchFinished, object: nil)
            return
        }
        
        if let query = textField?.text {
            let userInfo: [AnyHashable: Any] = ["query": query]
            NotificationCenter.default.post(name: .onQueryChanged, object: nil, userInfo: userInfo)
        }
    }
    
    // MARK: - Notifications handling
    
    private func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleClearText(_:)), name: .onClearTextInput, object: nil)
    }
    
    private func unsubscribeForNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleClearText(_ notification: Notification) {
        clearText()
        removePlaceholder()
        isSearchStarted = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let action = onReturnAction, let text = textField.text {
            action(text)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if reason == .committed {
            NotificationCenter.default.post(name: Notification.Name(rawValue: ResponderOld.SearchNotificationName.resign), object: nil)
        }
    }
    
    var countOfClicks: Int = 0
}

extension InputRecipientItemView: RecipientInputTextFieldDelegate {
    
    func didDeleteBackward(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            if countOfClicks == 1 {
                NotificationCenter.default.post(name: .onRemoveRecipientByBackspace, object: nil)
                countOfClicks = 0
            } else {
                countOfClicks += 1
            }
        }
    }
}
