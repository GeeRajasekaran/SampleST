//
//  ResponderAccessoryView.swift
//  June
//
//  Created by Ostap Holub on 2/13/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SnapKit

class ResponderAccessoryView: UIView {
    
    // MARK: - Variables & Constants
    
    private var headerView: AccessoryViewHeader?
    private var textField: UITextView?
    private var actionsView: AccessoryActionsView?
    private var attachmentsView: AttachmentsView?
    
    private var metadata: ResponderMetadata?
    
    // MARK: - Text view expand variables
    
    private var oldTextViewHeight: CGFloat?
    private var newTextViewHeight: CGFloat?
    
    func removeLastRecipientIfNeeded() {
        headerView?.removeLastRecipientIfNeeded()
    }
    
    func addRecipient(_ recipient: EmailReceiver) {
        headerView?.addRecipient(recipient)
    }
    
    override func resignFirstResponder() -> Bool {
        textField?.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    func becomeFirstResponderIfNeeded() {
        if textField?.isFirstResponder == false {
            textField?.becomeFirstResponder()
        }
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews(for metadata: ResponderMetadata) {
        self.metadata = metadata
        backgroundColor = .white
        addHeaderView()
        addActionsView(for: metadata)
        addAttachmentsView(with: metadata)
        addTextView()
        checkSendButtonVisibility()
        changeTextViewColorsAndStates(metadata)
    }
    
    func updateLayout(for metadata: ResponderMetadata) {
        headerView?.removeFromSuperview()
        headerView = nil
        addHeaderView()
        actionsView?.removeFromSuperview()
        actionsView = nil
        addActionsView(for: metadata)
        
        attachmentsView?.removeFromSuperview()
        attachmentsView = nil
        addAttachmentsView(with: metadata)
        
        textField?.snp.makeConstraints { [weak self] make in
            guard let sSelf = self, let top = headerView, let bottom = attachmentsView else { return }
            make.leading.equalTo(sSelf).offset(ResponderLayoutConstants.TextInput.horizontalInset)
            make.trailing.equalTo(sSelf).offset(-ResponderLayoutConstants.TextInput.horizontalInset)
            make.top.equalTo(top.snp.bottom).offset(ResponderLayoutConstants.TextInput.topInset)
            make.bottom.equalTo(bottom.snp.top).offset(-ResponderLayoutConstants.TextInput.bottomInset)
        }
        checkSendButtonVisibility()
        changeTextViewColorsAndStates(metadata)
    }
    
    private func changeTextViewColorsAndStates(_ metadata: ResponderMetadata) {
        if metadata.state == .minimized {
            guard metadata.message.isEmpty == false else {
                textField?.text = metadata.placeholder
                textField?.textContainer.maximumNumberOfLines = 1
                textField?.textContainer.lineBreakMode = .byTruncatingTail
                textField?.isScrollEnabled = false
                textField?.textColor = UIColor.responderPlaceholderTextColor
                textField?.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
                return
            }
            textField?.attributedText = attributedDraft(with: metadata)
            textField?.isScrollEnabled = false
            textField?.textContainer.maximumNumberOfLines = 1
            textField?.textContainer.lineBreakMode = .byTruncatingTail
        } else if metadata.state == .regular {
            textField?.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
            textField?.textContainer.maximumNumberOfLines = 0
            textField?.textContainer.lineBreakMode = .byWordWrapping
            textField?.textColor = UIColor.responderRegularTextColor
            textField?.text = metadata.message
            textField?.isScrollEnabled = true
            checkTextFieldSize()
        }
    }
    
    private func attributedDraft(with meta: ResponderMetadata) -> NSAttributedString {
        
        let initialString = NSString(string: "[ Draft ] \(meta.message)")
        let attributedString = NSMutableAttributedString(string: initialString as String)
        
        let range = initialString.range(of: "[ Draft ]")
        attributedString.addAttribute(.foregroundColor, value: UIColor.draftBlueColor, range: range)
        attributedString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .bold, size: .medium), range: range)
        let messageRange = initialString.range(of: meta.message)
        attributedString.addAttribute(.foregroundColor, value: UIColor.responderPlaceholderTextColor, range: messageRange)
        attributedString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .regular, size: .medium), range: messageRange)
        
        return attributedString
    }
    
    func disableSendButton() {
        actionsView?.disableSendButton()
    }
    
    func enableSendButton() {
        actionsView?.enableSendButton()
    }
    
    func checkSendButtonVisibility() {
        if metadata?.isSendButtonEnabled == true {
            actionsView?.enableSendButton()
        } else if metadata?.isSendButtonEnabled == false  {
            actionsView?.disableSendButton()
        }
    }
    
    // MARK: - Private attachments view setup
    
    private func addAttachmentsView(with metadata: ResponderMetadata) {
        guard attachmentsView == nil else { return }
        
        attachmentsView = AttachmentsView()
        attachmentsView?.translatesAutoresizingMaskIntoConstraints = false
        attachmentsView?.onOpenAttachment = onOpenAttachment
        attachmentsView?.onRemove = onRemoveAttachment
        var height: CGFloat = 0.0
        if !metadata.attachments.isEmpty && metadata.state != .minimized {
            height = ResponderLayoutConstants.Height.attachments
            attachmentsView?.setupSubviews(for: metadata)
        }
        
        if attachmentsView != nil {
            addSubview(attachmentsView!)
            attachmentsView?.snp.makeConstraints { [weak self] make in
                guard let bottom = self?.actionsView else { return }
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(bottom.snp.top)
                make.height.equalTo(height)
            }
        }
    }
    
    private var onOpenAttachment: (Attachment) -> Void = { attachment in
        let userInfo: [AnyHashable: Any] = ["attachment": attachment]
        NotificationCenter.default.post(name: .onAttachmentOpened, object: nil, userInfo: userInfo)
    }
    
    private var onRemoveAttachment: (Attachment) -> Void = { attachment in
        let userInfo: [AnyHashable: Any] = ["attachment": attachment]
        NotificationCenter.default.post(name: .onAttachmentRemoved, object: nil, userInfo: userInfo)
    }
    
    // MARK: - Private header view setup
    
    private func addHeaderView() {
        guard headerView == nil else { return }
        guard let unwrappedMetadata = metadata else { return }
        
        headerView = AccessoryViewHeader()
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        headerView?.setupSubviews(for: unwrappedMetadata)
        headerView?.onExpand = onExpand
        
        if headerView != nil {
            addSubview(headerView!)
            headerView?.snp.makeConstraints { [weak self] make in
                guard let sSelf = self else { return }
                make.leading.equalTo(sSelf)
                make.trailing.equalTo(sSelf)
                make.top.equalTo(sSelf)
                make.height.equalTo(ResponderLayoutConstants.Header.height(for: unwrappedMetadata.state))
            }
        }
    }
    
    // MARK: - Private actions view setup
    
    private func addActionsView(for metadata: ResponderMetadata) {
        guard actionsView == nil else { return }
        
        actionsView = AccessoryActionsView()
        actionsView?.setupSubviews(for: metadata)
        actionsView?.translatesAutoresizingMaskIntoConstraints = false
        
        if actionsView != nil {
            addSubview(actionsView!)
            actionsView?.snp.makeConstraints { [weak self] make in
                guard let sSelf = self else { return }
                make.leading.equalTo(sSelf)
                make.trailing.equalTo(sSelf)
                make.bottom.equalTo(sSelf)
                make.height.equalTo(ResponderLayoutConstants.ActionView.height)
            }
        }
    }
    
    // MARK: - Private text field setup
    
    lazy var onExpand: (ResponderState) -> Void = { [weak self] state in
        if state == .regular {
            self?.textField?.becomeFirstResponder()
        }
    }
    
    private func addTextView() {
        guard textField == nil else { return }
        
        textField = UITextView()
        textField?.delegate = self
        textField?.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        textField?.textColor = UIColor.responderRegularTextColor
        textField?.translatesAutoresizingMaskIntoConstraints = false
        
        if textField != nil {
            addSubview(textField!)
            textField?.snp.makeConstraints { [weak self] make in
                guard let sSelf = self, let top = headerView, let bottom = attachmentsView else { return }
                make.leading.equalTo(sSelf).offset(ResponderLayoutConstants.TextInput.horizontalInset)
                make.trailing.equalTo(sSelf).offset(-ResponderLayoutConstants.TextInput.horizontalInset)
                make.top.equalTo(top.snp.bottom).offset(ResponderLayoutConstants.TextInput.topInset)
                make.bottom.equalTo(bottom.snp.top).offset(-ResponderLayoutConstants.TextInput.bottomInset)
            }
        }
    }
}

extension ResponderAccessoryView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if metadata?.state == .minimized {
            NotificationCenter.default.post(name: .onMinimizedViewClicked, object: nil)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        oldTextViewHeight = textView.frame.height
        return true
    }
    
    private func checkTextFieldSize() {
        guard let textView = textField else { return }
        if textView.contentSize.height > textView.frame.height {
            guard metadata?.config.shouldAutoExpand == false else { return }
            let delta = textView.contentSize.height - textView.frame.height
            let userInfo: [AnyHashable: Any] = ["delta": delta,
                                                "message": textView.text,
                                                "last_content_height": textView.contentSize.height]
            NotificationCenter.default.post(name: .onMessageChanged, object: nil, userInfo: userInfo)
            setNeedsLayout()
            layoutIfNeeded()
            textView.setContentOffset(.zero, animated: false)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        newTextViewHeight = textView.contentSize.height
        var delta: CGFloat = 0.0
        if textView.linesCount() > 6 {
            let userInfo: [AnyHashable: Any] = ["delta": delta,
                                                "message": textView.text,
                                                "last_content_height": textView.contentSize.height]
            NotificationCenter.default.post(name: .onMessageChanged, object: nil, userInfo: userInfo)
        } else {
            delta = (newTextViewHeight ?? 0.0) - (oldTextViewHeight ?? 0.0)
            let userInfo: [AnyHashable: Any] = ["delta": delta,
                                                "message": textView.text,
                                                "last_content_height": textView.contentSize.height]
            NotificationCenter.default.post(name: .onMessageChanged, object: nil, userInfo: userInfo)
            setNeedsLayout()
            layoutIfNeeded()
            textView.setContentOffset(.zero, animated: false)
        }
        checkSendButtonVisibility()
    }
}
