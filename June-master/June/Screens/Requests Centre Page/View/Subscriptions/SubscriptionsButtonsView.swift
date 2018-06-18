//
//  SubscriptionsButtonsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SubscriptionsButtonsView: RequestsButtonsView {
    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let buttonHeight = 0.104 * UIScreen.main.bounds.width
    private let spaceBetweenButtons = 0.018 * UIScreen.main.bounds.width
    
    private let buttonWidth = 0.288 * UIScreen.main.bounds.width
    
    private let buttonFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
    
    // MARK: - Views
    private var approveButton: UISelectableButton?
    private var denyButton: UISelectableButton?

    //Public part
    override func setupSubviews() {
        super.setupSubviews()
        addApproveButton()
        addDenyButton()
    }
    
    //Private part
    private func addApproveButton() {
        if approveButton != nil { return }
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        approveButton = UISelectableButton(frame: buttonFrame)
        approveButton?.setupUI(textColor: UIColor.requestsApproveColor, borderColor: UIColor.requestsApproveColor, title: LocalizedStringKey.RequestsViewHelper.ApproveTitile)
        approveButton?.addTarget(self, action: #selector(approvedButtonTapped(sender:)), for: .touchUpInside)
        if approveButton != nil {
            addSubview(approveButton!)
        }
    }
    
    private func addDenyButton() {
        if denyButton != nil { return }
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        denyButton = UISelectableButton(frame: buttonFrame)
        denyButton?.setupUI(textColor: UIColor.requestsIgnoreTitleColor, borderColor: UIColor.requestsIgnoreColor, title: LocalizedStringKey.RequestsViewHelper.DenyTitile)
        
        denyButton?.addTarget(self, action: #selector(denyButtonTapped(sender:)), for: .touchUpInside)
        if denyButton != nil {
            addSubview(denyButton!)
            denyButton?.snp.makeConstraints { make in
                guard let left = approveButton else { return }
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(buttonWidth)
                make.leading.equalTo(left.snp.trailing).offset(spaceBetweenButtons)
            }
        }
    }

    //MARK: - actions
    
    @objc internal func approvedButtonTapped(sender: UISelectableButton) {
        sender.changeState()
        denyButton?.deselect()
        onApprovedTapped?(sender)
    }
    
    @objc private func denyButtonTapped(sender: UISelectableButton) {
        sender.changeState()
        approveButton?.deselect()
        onDeniedTapped?(sender)
    }
}
