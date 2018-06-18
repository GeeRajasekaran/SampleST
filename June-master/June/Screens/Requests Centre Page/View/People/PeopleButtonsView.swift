//
//  PeopleButtonsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class PeopleButtonsView: RequestsButtonsView {

    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let approveButtonWidth = 0.32 * UIScreen.main.bounds.width
    private let buttonHeight = 0.104 * UIScreen.main.bounds.width
    private let spaceBetweenButtons = 0.018 * UIScreen.main.bounds.width
    
    private let blockedButtonWidth = 0.178 * UIScreen.main.bounds.width

    private let buttonFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
    private let pointsButtonFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    
    private var isBlockShown = false
    
    // MARK: - Views
    private var approveButton: UISelectableButton?
    private var ignoreButton: UISelectableButton?
    private var moreButton: UISelectableButton?
    
    //Public part
    override func setupSubviews() {
        super.setupSubviews()
        addApproveButton()
        addMoreButton()
        addIgnoreButton()
    }
    
    //Private part
    private func addApproveButton() {
        if approveButton != nil { return }
        let buttonFrame = CGRect(x: 0, y: 0, width: approveButtonWidth, height: buttonHeight)
        approveButton = UISelectableButton(frame: buttonFrame)
        approveButton?.setupUI(textColor: UIColor.requestsApproveColor, borderColor: UIColor.requestsApproveColor, title: LocalizedStringKey.RequestsViewHelper.ApproveTitile)
        approveButton?.addTarget(self, action: #selector(approvedButtonTapped(sender:)), for: .touchUpInside)
        if approveButton != nil {
            addSubview(approveButton!)
        }
    }
    
    private func addIgnoreButton() {
        if ignoreButton != nil { return }
        let buttonFrame = CGRect(x: 0, y: 0, width: 0.288 * screenWidth, height: buttonHeight)
        ignoreButton = UISelectableButton(frame: buttonFrame)
        ignoreButton?.setupUI(textColor: UIColor.requestsIgnoreTitleColor, borderColor: UIColor.requestsIgnoreColor, title: LocalizedStringKey.RequestsViewHelper.IgnoreTitile)
        
        ignoreButton?.addTarget(self, action: #selector(ignoredButtonTapped(sender:)), for: .touchUpInside)
        if ignoreButton != nil {
            addSubview(ignoreButton!)
            ignoreButton?.snp.makeConstraints { make in
                guard let left = approveButton, let right = moreButton else { return }
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalTo(left.snp.trailing).offset(spaceBetweenButtons)
                make.trailing.equalTo(right.snp.leading).offset(-spaceBetweenButtons)
            }
        }
    }
    
    private func addMoreButton() {
        if moreButton != nil { return }
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight)
        moreButton = UISelectableButton(frame: buttonFrame)
        moreButton?.setupUI(textColor: UIColor.requestsIgnoreColor, borderColor: UIColor.requestsIgnoreColor, title: LocalizedStringKey.RequestsViewHelper.MoreTitle)
       
        moreButton?.addTarget(self, action: #selector(moreButtonTapped(sender:)), for: .touchUpInside)
        if moreButton != nil {
            addSubview(moreButton!)
            moreButton?.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().offset(-0.04 * screenWidth)
                make.width.equalTo(buttonHeight)
            }
        }
    }
    
    //MARK: - change more button
    private func changeButtonsIFNeeded() {
        if isBlockShown {
            blockedButtonsConfig()
            moreButton?.removeTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
            moreButton?.addTarget(self, action: #selector(blockedButtonTapped), for: .touchUpInside)
        } else {
            normalButtonsConfig()
            moreButton?.removeTarget(self, action: #selector(blockedButtonTapped), for: .touchUpInside)
            moreButton?.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        }
    }
    
    private func hideBlocked() {
        if isBlockShown {
            isBlockShown = false
            changeButtonsIFNeeded()
        }
    }
    
    private func blockedButtonsConfig() {
        moreButton?.setupUI(textColor: UIColor.requestsBlockColor, borderColor: UIColor.requestsBlockColor, title: LocalizedStringKey.RequestsViewHelper.BlockTitile)
        moreButton?.snp.updateConstraints { make in
            make.width.equalTo(0.178 * screenWidth)
        }
    }
    
    private func normalButtonsConfig() {
        moreButton?.setupUI(textColor: UIColor.requestsIgnoreColor, borderColor: UIColor.requestsIgnoreColor, title: LocalizedStringKey.RequestsViewHelper.MoreTitle)
        moreButton?.snp.updateConstraints { make in
            make.width.equalTo(buttonHeight)
        }
        
    }
    
    //MARK: - actions
    @objc private func moreButtonTapped(sender: UISelectableButton) {
        isBlockShown = !isBlockShown
        approveButton?.deselect()
        ignoreButton?.deselect()
        changeButtonsIFNeeded()
    }
    
    @objc func approvedButtonTapped(sender: UISelectableButton) {
        sender.changeState()
        ignoreButton?.deselect()
        moreButton?.deselect()
        hideBlocked()
        onApprovedTapped?(sender)
    }
    
    @objc private func ignoredButtonTapped(sender: UISelectableButton) {
        sender.changeState()
        approveButton?.deselect()
        moreButton?.deselect()
        hideBlocked()
        onIgnoredTapped?(sender)
    }
    
    @objc private func blockedButtonTapped(sender:UISelectableButton) {
        sender.changeState()
        ignoreButton?.deselect()
        approveButton?.deselect()
        onBlockedTapped?(sender)
    }
}
