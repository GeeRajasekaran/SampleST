//
//  AccessoryActionsView.swift
//  June
//
//  Created by Ostap Holub on 9/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccessoryActionsView: UIView {
    
    // MARK: - Views
    
    private var attachmentsButton: UIButton?
    private var sendButton: UIButton?
    private var thumbUpButton: UIButton?
    
    var onAttachmentsAction: (() -> Void)?
    var onSendAction: (() -> Void)?
    var goal: ResponderOld.ResponderGoal?
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let inset = 0.04 * UIScreen.main.bounds.width
    
    // MARK: - Subviews setup
    
    func setupSubviews(isFromCompose: Bool = false, shouldShowAttachments: Bool = true) {
        if isFromCompose {
            addComposeSendButton()
            if shouldShowAttachments {
                addAttachmentsButtonForCompose()
            }
        } else {
            addSendButton()
            addAttachmentsButton()
            addThumbUpButton()
        }
    }
    
    func setupSubviews(for metadata: ResponderMetadata) {
        addSendButton()
        addAttachmentsButton()
        if metadata.state == .minimized {
            addThumbUpButton()
        }
        if metadata.isSendButtonEnabled {
            enableSendButton()
        } else {
            disableSendButton()
        }
    }
    
    // MARK: - Send button enabling/disabling
    
    func enableSendButton() {
        sendButton?.isEnabled = true
        sendButton?.setImage(UIImage(named: LocalizedImageNameKey.ResponderHelper.Send), for: .normal)
    }
    
    func disableSendButton() {
        sendButton?.isEnabled = false
        sendButton?.setImage(UIImage(named: LocalizedImageNameKey.ResponderHelper.SendDisable), for: .normal)
    }
    
    // MARK: - Thumb up button setup
    
    private func addThumbUpButton() {
        guard thumbUpButton == nil else { return }
        guard let attachButton = attachmentsButton else { return }
        
        thumbUpButton = UIButton()
        thumbUpButton?.translatesAutoresizingMaskIntoConstraints = false
        thumbUpButton?.addTarget(self, action: #selector(handleThumbUpButton), for: .touchUpInside)
        thumbUpButton?.setImage(UIImage(named: LocalizedImageNameKey.ResponderHelper.ThumbUpLarge), for: .normal)
        thumbUpButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: ResponderLayoutConstants.ActionView.imageInsetTop, right: ResponderLayoutConstants.ActionView.imageInsetRight)
        
        if thumbUpButton != nil {
            addSubview(thumbUpButton!)
            thumbUpButton?.leadingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: ResponderLayoutConstants.ActionView.thumbUpLeading).isActive = true
            thumbUpButton?.topAnchor.constraint(equalTo: topAnchor).isActive = true
            thumbUpButton?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            thumbUpButton?.widthAnchor.constraint(equalToConstant: ResponderLayoutConstants.ActionView.thumbUpWidth).isActive = true
        }
    }
    
    @objc private func handleThumbUpButton() {
        NotificationCenter.default.post(name: .onThumbsUpClicked, object: nil)
    }
    
    // MARK: - Send button
    
    private func addSendButton() {
        let image = UIImage(named: LocalizedImageNameKey.ResponderHelper.Send)
        
        sendButton = UIButton()
        sendButton?.setImage(image, for: .normal)
        sendButton?.translatesAutoresizingMaskIntoConstraints = false
        sendButton?.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)
        
        if sendButton != nil {
            addSubview(sendButton!)
            sendButton?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ResponderLayoutConstants.ActionView.sendTrailing).isActive = true
            sendButton?.heightAnchor.constraint(equalToConstant: ResponderLayoutConstants.ActionView.sendDimension).isActive = true
            sendButton?.widthAnchor.constraint(equalToConstant: ResponderLayoutConstants.ActionView.sendDimension).isActive = true
            sendButton?.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        }
    }
    
    private func addComposeSendButton() {
        let width = 0.09 * screenWidth
        let image = UIImage(named: LocalizedImageNameKey.ResponderHelper.Send)
        
        let sendButtonInset = 0.027 * screenWidth
        let sendButtonFrame = CGRect(x: frame.width - sendButtonInset - width, y: 0, width: width, height: frame.height)
        
        sendButton = UIButton(frame: sendButtonFrame)
        sendButton?.setImage(image, for: .normal)
        sendButton?.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)

        if sendButton != nil {
            addSubview(sendButton!)
        }
    }
    
    // MARK: - Attachments button
    
    private func addAttachmentsButton() {
        let image = UIImage(named: LocalizedImageNameKey.ResponderHelper.AttachmentLarge)
        attachmentsButton = UIButton()
        attachmentsButton?.translatesAutoresizingMaskIntoConstraints = false
        attachmentsButton?.setImage(image, for: .normal)
        attachmentsButton?.addTarget(self, action: #selector(handleAttachmentsTap), for: .touchUpInside)
        attachmentsButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: ResponderLayoutConstants.ActionView.imageInsetTop, right: ResponderLayoutConstants.ActionView.imageInsetRight)
        
        if attachmentsButton != nil {
            addSubview(attachmentsButton!)
            attachmentsButton?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            attachmentsButton?.topAnchor.constraint(equalTo: topAnchor).isActive = true
            attachmentsButton?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            attachmentsButton?.widthAnchor.constraint(equalToConstant: ResponderLayoutConstants.Minimized.attachmentWitdth).isActive = true
        }
    }
    
    // MARK: - Attachments button for compose
    
    private func addAttachmentsButtonForCompose() {
        let width = 0.061 * screenWidth
        let image = UIImage(named: LocalizedImageNameKey.ComposeHelper.Attachment)
        let attachmentX = 0.045 * screenWidth
        let attachmentFrame = CGRect(x: attachmentX, y: 0, width: width, height: frame.height)
        
        attachmentsButton = UIButton(frame: attachmentFrame)
        attachmentsButton?.setImage(image, for: .normal)
        attachmentsButton?.addTarget(self, action: #selector(handleAttachmentsTap), for: .touchUpInside)
        
        if attachmentsButton != nil {
            addSubview(attachmentsButton!)
        }
    }
    
    // MARK: - Buttons actions
    
    @objc private func handleAttachmentsTap() {
        onAttachmentsAction?()
        NotificationCenter.default.post(name: .onAttachClicked, object: nil)
    }
    
    @objc private func handleSendTap() {
        onSendAction?()
        NotificationCenter.default.post(name: .onSendClicked, object: nil)
    }
}
