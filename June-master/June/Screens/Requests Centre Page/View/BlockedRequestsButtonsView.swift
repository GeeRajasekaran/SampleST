//
//  BlockedRequestsButtonsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class BlockedRequestsButtonsView: RequestsButtonsView {

    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let buttonWidth = 0.288 * UIScreen.main.bounds.width
    private let buttonHeight = 0.104 * UIScreen.main.bounds.width

    private let buttonFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
    
    // MARK: - Views
    private var unblockButton: UISelectableButton?

    //Public part
    override func setupSubviews() {
        super.setupSubviews()
        addUnblockButton()
    }
    
    //Private part
    private func addUnblockButton() {
        if unblockButton != nil { return }
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        unblockButton = UISelectableButton(frame: buttonFrame)
        unblockButton?.setupUI(textColor: UIColor.requestsIgnoreTitleColor, borderColor: UIColor.requestsIgnoreColor, title: LocalizedStringKey.RequestsViewHelper.UnblockTitile)
        unblockButton?.addTarget(self, action: #selector(unblockButtonTapped(sender:)), for: .touchUpInside)
        if unblockButton != nil {
            addSubview(unblockButton!)
        }
        addUnblockButtonConstraints()
    }
    
    //MARK: - constranits
    private func addUnblockButtonConstraints() {
        unblockButton?.translatesAutoresizingMaskIntoConstraints = false
        
        unblockButton?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        unblockButton?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        unblockButton?.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        unblockButton?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0.04 * screenWidth).isActive = true
    }
    
    //MARK: - actions
    @objc private func unblockButtonTapped(sender: UISelectableButton) {
        sender.changeState()
        onUnblockedTapped?(sender)
    }
}
