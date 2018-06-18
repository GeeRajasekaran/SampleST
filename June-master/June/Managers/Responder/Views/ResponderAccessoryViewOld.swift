//
//  ResponderAccessoryViewOld.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ResponderAccessoryViewOld: UIView {
    
    // MARK: - Variables & Constants
    
    private let maxLinesInCollapsedState: Int = 5
    private let screenWidth = UIScreen.main.bounds.width
    private let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    var onExpandAction: (() -> Void)?
    var onAttachementsAction : (() -> Void)?
    var onSendAction: (() -> Void)?
    var onTextViewExpanded: ((CGFloat) -> Void)?
    
    var onOpenAttachment: ((Attachment) -> Void)?
    var onRemovedAttachment: (() -> Void)?
    
    weak var dataSource: EmailReceiverDataSource?
    weak var delegate: EmailReceiverDelegate?
    
    weak var responder: ResponderOld?
    weak var config: ResponderConfig?
    
    // MARK: - Text view expand variables
    
    private var oldTextViewHeight: CGFloat?
    private var newTextViewHeight: CGFloat?
    
    // MARK: - Views
    
    var textView: UITextView?
    var headerView: AccessoryViewHeader?
    var actionView: AccessoryActionsView?
    var shareHeaderView: UIView?
    var minimizedPlaceholderLabel: UILabel?
    var attachmentsView: AttachmentsView?
    
    // MARK: - Send button enabling/disabling
    
    func enableSendButton() {
        actionView?.enableSendButton()
    }
    
    func disableSendButton() {
        actionView?.disableSendButton()
    }
    
    // MARK: - Layout setup
    
    var bodyText: String? {
        get { return textView?.text }
    }
    
    var textViewOrigin: CGPoint? {
        get { return textView?.frame.origin }
    }
    
    func updateTextFieldForMinimizedState(with message: Messages) {
        updatePlaceholderLabel(with: message)
    }
    
    func updateTextFieldForRegularState(with message: Messages) {
        
    }
    
    func center() {
        textView?.centerVertically()
    }
    
    func setupSubviews(for configuration: ResponderConfig, using responder: ResponderOld) {
        self.responder = responder
        self.config = configuration
        // Note, that order of calling this methods is imporatant
        // addTextField() method should be called the last
        addShareHeaderView()
        addHeaderView(with: configuration, and: onExpandAction)
        addAttachmentsView()
        addActionsView()
        addTextView()
        
        if self.responder?.state == .minimized {
            shareHeaderView?.isHidden = true
            headerView?.isHidden = true
            updatePlaceholderLabel(with: configuration.message)
            drawTopShadow()
        }
    }
    
    func setFirstResponder() {
        textView?.becomeFirstResponder()
    }
    
    func removeFirstResponder() {
        textView?.resignFirstResponder()
        headerView?.removeFirstResponder()
    }
    
    func removeReceiver(at index: IndexPath) {
        
    }
    
    func reloadReceiver(at index: IndexPath) {
        
    }
    
    func insertReceiver(at index: IndexPath) {
        
    }
    
    func reloadReveivers() {
        
    }
    
    //MARK: - manage attachments
    
    func getAttachments() -> [Attachment] {
        if let attachments = attachmentsView?.getAttachments() {
            return attachments
        }
        return []
    }
    
    func isAttchmentsExist() -> Bool {
        guard let count = attachmentsView?.getAttachmentsCount() else { return false }
        if count > 0 {
            return true
        }
        return false
    }
    
    func append(_ attachment: Attachment) {
        attachmentsView?.frame.size.height = attachmentsViewHeight
        attachmentsView?.append(attachment)
    }
    
    func add(_ attachments: [Attachment]) {
        attachmentsView?.frame.size.height = attachmentsViewHeight
        attachmentsView?.add(attachments)
    }
    
    func removeAttachmentView() {
        if !isAttchmentsExist() {
            attachmentsView?.frame.size.height = 0
            guard let state = responder?.state else { return }
            if state == .collapsed {
                responder?.collapseWithoutAttachments()
            }
        }
    }
    
    // MARK: - Expand / collapse logic
    
    func updateLayout(for height: CGFloat) {
        if isAttchmentsExist() {
            attachmentsView?.frame.size.height = attachmentsViewHeight
        } else {
            attachmentsView?.frame.size.height = 0
        }
        actionView?.frame = actionViewFrame()
        if let newTextViewFrame = textViewFrame() {
            textView?.frame = newTextViewFrame
        }
    }
    
    // MARK: - Text field setup
    
    private func addTextView() {
        if textView == nil {
            guard let viewFrame = inputTextViewFrame() else { return }
            textView = UITextView(frame: viewFrame)
            textView?.backgroundColor = .clear
            textView?.font = UIFont(name: LocalizedFontNameKey.ResponderHelper.InputViewFont, size: 15)
            textView?.textColor = UIColor.responderTextColor
            textView?.autocorrectionType = .default
            textView?.keyboardType = .default
            textView?.returnKeyType = .default
            textView?.delegate = self

            if textView != nil {
                addSubview(textView!)
            }
        }
    }
    
    //MARK: - attachments view
    private func addAttachmentsView() {
        if attachmentsView != nil { return }
        let attachmentsViewFrame = CGRect(x: 0, y: (headerView?.frame.size.height)! + (headerView?.frame.origin.y)!, width: screenWidth, height: 0)
        
        attachmentsView = AttachmentsView(frame: attachmentsViewFrame)
        attachmentsView?.shouldShowRemoveButton = true
        
        attachmentsView?.onOpenAttachment = onOpenAttachment
        attachmentsView?.onRemovedAttachment = onRemovedAttachment
        attachmentsView?.setupSubviews()
        
        if attachmentsView != nil {
            addSubview(attachmentsView!)
        }
    }
    
    // MARK: - Header view
    
    private func addShareHeaderView() {
        guard let shareHeaderFrame = shareHeaderViewFrame() else { return }
        shareHeaderView = UIView(frame: shareHeaderFrame)
        shareHeaderView?.backgroundColor = .white
        if shareHeaderView != nil {
            addTopShadowView(to: shareHeaderView!)
            addTitleLabel(to: shareHeaderView!)
            sendSubview(toBack: shareHeaderView!)
            addSubview(shareHeaderView!)
        }
    }
    
    private func addTitleLabel(to view: UIView) {
        let height = 0.032 * screenWidth
        let titleFrame = CGRect(x: UIView.midMargin, y: view.frame.height / 2 - height / 2, width: screenWidth - 2 * UIView.midMargin, height: height)
        
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = LocalizedStringKey.ResponderHelper.HeaderTitle
        titleLabel.font = UIFont(name: LocalizedFontNameKey.ResponderHelper.HeaderTitleFont, size: 10)
        titleLabel.textColor = UIColor.participantsLabelGray
        
        view.addSubview(titleLabel)
    }
    
    private func addTopShadowView(to view: UIView) {
        let shadowFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        
        view.addSubview(shadowView)
    }
    
    private func addHeaderView(with configuration: ResponderConfig, and expandAction: (() -> Void)?) {
        guard let headerFrame = receiversHeaderViewFrame() else { return }
        headerView = AccessoryViewHeader(frame: headerFrame)
        headerView?.setupSubviews(for: configuration)
        
        sendSubview(toBack: headerView!)
        addSubview(headerView!)
    }
    
    // MARK: - Actions view 
    
    private func addActionsView() {
        guard let actionFrame = bottomActionViewFrame() else { return }
        
        actionView = AccessoryActionsView(frame: actionFrame)
        actionView?.backgroundColor = .white
        actionView?.goal = config?.goal
        actionView?.setupSubviews()
        actionView?.onAttachmentsAction = onAttachementsAction
        actionView?.onSendAction = onSendAction
        actionView?.disableSendButton()
        
        if actionView != nil {
            addSubview(actionView!)
        }
    }
    
    private func actionViewFrame() -> CGRect {
        let height = 0.102 * screenWidth
        return CGRect(x: 15, y: frame.height - height, width: screenWidth, height: height)
    }
    
    //TODO: check text view frame
    private func textViewFrame() -> CGRect? {
        guard let headerFrame = headerView?.frame, let actionFrame = actionView?.frame, let attachmentsViewFrame = attachmentsView?.frame else { return nil }
        var originOffset: CGFloat = 0
        if let shareFrame = shareHeaderView?.frame {
            originOffset = shareFrame.height
        }
        return CGRect(x: UIView.midMargin, y: headerFrame.height + originOffset + attachmentsViewFrame.height, width: screenWidth - 2 * UIView.midMargin, height: actionFrame.origin.y - headerFrame.height - originOffset - attachmentsViewFrame.height)
    }
    
    // MARK: - Placeholder label creation
    
    func updatePlaceholderLabel(with message: Messages?) {
        textView?.centerVertically()
        if let text = textView?.text {
            if text != "" {
                minimizedPlaceholderLabel?.removeFromSuperview()
                minimizedPlaceholderLabel = nil
                return
            }
        }
        
        createPlaceholderLabel()
        if self.config?.goal == .forward {
            setPlaceholderText("Say something...")
        } else if self.config?.goal == .replyAll {
            if let unwrappedConfig = config {
                createReplyAllPlaceholder(from: unwrappedConfig.message)
            }
        } else {
            if let unwrappedConfig = config {
                createPlaceholderString(from: unwrappedConfig.message)
            }
        }
    }
    
    func createReplyAllPlaceholder(from message: Messages) {
        
        var placeholderString = "Message"
        let fromNames = message.fromNames()
        let toNames = message.toNames()
        let ccNames = message.ccNames()
        let fromEmails = message.fromEmails()
        let toEmails = message.toEmails()
        let ccEmails = message.ccEmails()
        
        var emailsDict: [String : String] = [:]
        
        if let currentUserEmail = userPrimaryEmail() {
            print(currentUserEmail as Any)
            for (key, value) in zip(ccEmails, ccNames) {
                if key != currentUserEmail {
                    emailsDict[key] = value
                }
            }
            for (key, value) in zip(toEmails, toNames) {
                if key != currentUserEmail {
                    emailsDict[key] = value
                }
            }
            for (key, value) in zip(fromEmails, fromNames) {
                if key != currentUserEmail {
                    emailsDict[key] = value
                }
            }
        }

        emailsDict.values.forEach { name in
            placeholderString += " " + name
            placeholderString += ","
        }
        
        placeholderString = placeholderString + "..."
        setPlaceholderText(placeholderString)
    }
    
    func createPlaceholderString(from message: Messages) {
        var placeholderString = "Message"
        let fromEmails = message.fromEmails()
        var names = message.fromNames()
        
        if let currentUserEmail = userPrimaryEmail() {
            print(currentUserEmail as Any)
            if fromEmails.contains(currentUserEmail) {
                names = message.toNames()
            }
        }
        
        names.forEach { name in
            placeholderString += " " + name
            placeholderString += ","
        }
        placeholderString = placeholderString.dropLast() + "..."
        setPlaceholderText(placeholderString)
        
    }
    
    func removePlaceholderLabel() {
        minimizedPlaceholderLabel?.isHidden = true
    }
    
    func setPlaceholderText(_ string: String) {
        let attributedPlaceholderString = NSMutableAttributedString(string: string)
        if let font = UIFont(name: LocalizedFontNameKey.ResponderHelper.MinimizedPlaceholderFont, size: 12) {
            attributedPlaceholderString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedPlaceholderString.length))
            attributedPlaceholderString.addAttribute(.foregroundColor, value: UIColor.minimizedPlaceholderGray, range: NSRange(location: 0, length: attributedPlaceholderString.length))
        }
        minimizedPlaceholderLabel?.attributedText = attributedPlaceholderString
    }
    
    func createPlaceholderLabel() {
        guard minimizedPlaceholderLabel == nil else { return }
        guard let textViewFrame = textView?.frame else { return }
        
        let height = 0.037 * screenWidth
        let minimazeHeight = 0.144 * screenWidth
        let labelFrame = CGRect(x: UIView.midLargeMargin + UIView.slimMargin / 2, y: minimazeHeight / 2 - height / 2, width: textViewFrame.width - UIView.slimMargin, height: height)
        minimizedPlaceholderLabel = UILabel(frame: labelFrame)
        addSubview(minimizedPlaceholderLabel!)
        bringSubview(toFront: textView!)
    }
    
    // MARK: - Minimization logic
    
    func minimize() {
        minimizedPlaceholderLabel?.isHidden = false
        frame.size.height = 0.144 * screenWidth
        drawTopShadow()
        shareHeaderView?.frame = shareHeaderViewFrame()!
        shareHeaderView?.isHidden = true
        headerView?.frame = receiversHeaderViewFrame()!
        headerView?.isHidden = true
        actionView?.frame = bottomActionViewFrame()!
        textView?.frame = inputTextViewFrame()!
        attachmentsView?.isHidden = true
        textView?.textContainer.maximumNumberOfLines = 1
        textView?.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func makeRegular() {
        removePlaceholderLabel()
        var topViewHeightConst: CGFloat = 0
        if config?.goal == .forward {
            topViewHeightConst = 0.096
        }
        if isAttchmentsExist() {
            frame.size.height = (0.336 + 0.15 + topViewHeightConst) * screenWidth
        } else {
             frame.size.height = 0.336 * screenWidth
        }
        attachmentsView?.isHidden = false
        layer.shadowColor = UIColor.clear.cgColor
        headerView?.isHidden = false
        shareHeaderView?.isHidden = false
        shareHeaderView?.frame = shareHeaderViewFrame()!
        headerView?.frame = receiversHeaderViewFrame()!
        actionView?.frame = bottomActionViewFrame()!
        textView?.frame = inputTextViewFrame()!
        
        textView?.textContainer.maximumNumberOfLines = Int.max
        textView?.textContainer.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Frames calcuations
    private func shareHeaderViewFrame() -> CGRect? {
        guard let unwrappedResponder = responder, let unwrappedConfig = self.config else { return nil }
        let headerHeight = 0.096 * screenWidth
        
        if unwrappedConfig.goal == .forward {
            if unwrappedResponder.state == .collapsed {
                return CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
            }
        }
        return nil
    }
    
    private func receiversHeaderViewFrame() -> CGRect? {
        guard let unwrappedResponder = responder else { return nil }
        let headerHeight = 0.128 * screenWidth
        var originY: CGFloat = 0
        
        if let shareHeaderFrame = shareHeaderView?.frame {
            originY = shareHeaderFrame.height
        }
        if unwrappedResponder.state == .minimized {
            return CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
        }
        return CGRect(x: 0, y: originY, width: screenWidth, height: headerHeight)
    }
    
    private func inputTextViewFrame() -> CGRect? {
        guard let unwrappedResponder = responder else { return nil }
        
        if unwrappedResponder.state == .minimized {
            return CGRect(x: UIView.midInterMargin, y: 0, width: screenWidth * 0.75, height: frame.height)
        } else {
            return textViewFrame()
        }
    }
    
    private func bottomActionViewFrame() -> CGRect? {
        guard let unwrappedResponder = responder else { return nil }
        let height = 0.102 * screenWidth
        
        if unwrappedResponder.state == .minimized {
            return CGRect(x: screenWidth - 60, y: frame.height / 2 - height / 2, width: screenWidth, height: height)
        } else {
            return actionViewFrame()
        }
    }
    
    private func expandTextView(_ textView: UITextView) {
        guard let oldHeight = oldTextViewHeight, let newHeight = newTextViewHeight else { return }
        onTextViewExpanded?(oldHeight - newHeight)
    }
    
    private func username() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]], let firstAccount = accounts.first {
            if let name = firstAccount["name"] as? String {
                return name
            }
        }
        return nil
    }
    
    private func userPrimaryEmail() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let primary_email = serializedUserObject["primary_email"] {
            return primary_email as? String
        }
        return nil
    }
}

extension ResponderAccessoryViewOld: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        oldTextViewHeight = textView.contentSize.height
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            disableSendButton()
        } else {
            enableSendButton()
        }
        newTextViewHeight = textView.contentSize.height
        if textView.linesCount() <= maxLinesInCollapsedState + 1 && responder?.state == .collapsed {
            expandTextView(textView)
        }
    }
}
