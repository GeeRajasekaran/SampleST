//
//  ResponderCommunicationNode.swift
//  June
//
//  Created by Ostap Holub on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderCommunicationNode: IResponderCommunicationNode {
    
    // MARK: - Variables & Constants
    
    weak var responder: IResponder?
    
    // MARK: - Subscribe/unsubscribe logic
    
    func subscribe(for responder: IResponder) {
        self.responder = responder
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnExpandNotification(_:)), name: .onExpandClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnMinimizedViewClickNotification), name: .onMinimizedViewClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMessageChanged(_:)), name: .onMessageChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFrameChanges(_:)), name: .onFrameChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactsSearchStarted(_:)), name: .onSearchStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactsSearchEnded(_:)), name: .onSearchFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactsSearchQueryChanged(_:)), name: .onQueryChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnAddRecipient(_:)), name: .onAddRecipient, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnSuccessResponse(_:)), name: .onSuccessResponse, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnFailedResponse(_:)), name: .onFailedResponse, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnSendAction(_:)), name: .onSendClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnAttachAction(_:)), name: .onAttachClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnRemoveAttachment(_:)), name: .onAttachmentRemoved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnOpenAttachment(_:)), name: .onAttachmentOpened, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnThumbsUpClicked(_:)), name: .onThumbsUpClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnStartUploading(_:)), name: .onStartUploading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnFinishedUploading(_:)), name: .onStopUploading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRemoveLastRecipient) , name: .onRemoveRecipientByBackspace, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSendButtonCheck(_:)), name: .sendButtonCheck, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: .onSendClicked, object: nil)
//        responder = nil
    }
}

    // MARK: - Responder view buttons actions

extension ResponderCommunicationNode {
    
    @objc private func handleOnExpandNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        guard let value = userInfo["state"], let state = ResponderState(rawValue: value) else { return }
        responder?.suggestionsViewController.clear()
        responder?.navigationCoordinator.hideSuggestions()
        responder?.metadata.state = state
    }
    
    @objc private func handleOnMinimizedViewClickNotification() {
        responder?.metadata.state = .regular
    }
    
    @objc private func handleMessageChanged(_ notification: Notification) {
        guard let message = notification.userInfo?["message"] as? String,
            let height = notification.userInfo?["delta"] as? CGFloat,
            let lastHeight = notification.userInfo?["last_content_height"] as? CGFloat else { return }
        responder?.metadata.heightDelta = height
        responder?.metadata.lastContentHeight = lastHeight
        responder?.metadata.message = message
    }
    
    @objc private func handleFrameChanges(_ notification: Notification) {
        if let frame = notification.userInfo?["frame"] as? CGRect {
            if responder?.metadata.state != .expanded {
                responder?.actionsListener?.onChangeFrame(frame)
            }
        }
    }
    
    @objc private func handleContactsSearchStarted(_ notification: Notification) {
        guard let unwrappedMeta = responder?.metadata, let controller = responder?.suggestionsViewController, let root = responder?.rootViewController else { return }
        controller.metadata = unwrappedMeta
        responder?.navigationCoordinator.show(suggestions: controller, for: unwrappedMeta, at: root)
    }
    
    @objc private func handleContactsSearchEnded(_ notification: Notification) {
        responder?.suggestionsViewController.clear()
        responder?.navigationCoordinator.hideSuggestions()
    }
    
    @objc private func handleContactsSearchQueryChanged(_ notification: Notification) {
        guard let query = notification.userInfo?["query"] as? String else { return }
        responder?.suggestionsViewController.search(by: query)
    }
    
    @objc private func handleOnAddRecipient(_ notification: Notification) {
        guard let recipient = notification.userInfo?["recipient"] as? EmailReceiver else { return }
        responder?.suggestionsViewController.clear()
        responder?.navigationCoordinator.hideSuggestions()
        responder?.addRecipient(recipient)
        responder?.responderViewController.responderAccessoryView?.checkSendButtonVisibility()
    }
    
    @objc private func handleOnSendAction(_ notification: Notification) {
        guard let unwrappedMetadata = responder?.metadata else { return }
        responder?.apiEngine?.sendMessage(with: unwrappedMetadata)
        responder?.actionsListener?.onSendAction(unwrappedMetadata)
        if responder?.metadata.config.shouldClearOnSend == true {
            responder?.metadata.clear()
        }
    }
    
    @objc private func handleOnSuccessResponse(_ notification: Notification) {
        guard let data = notification.userInfo?["data"] as? [String: AnyObject] else { return }
        responder?.actionsListener?.onSuccessAction(data)
        if responder?.metadata.config.shouldClearOnSend == false {
            responder?.metadata.clear()
            responder?.hide()
        }
    }
    
    @objc private func handleOnFailedResponse(_ notification: Notification) {
        guard let error = notification.userInfo?["error"] as? String else { return }
        responder?.actionsListener?.onFailAction(error)
    }
    
    @objc private func handleOnAttachAction(_ notification: Notification) {
        responder?.responderViewController.view.isHidden = true
        _ = responder?.responderViewController.responderAccessoryView?.resignFirstResponder()
        responder?.attachmentsActionSheetHandler.show()
    }
    
    @objc private func handleOnRemoveAttachment(_ notification: Notification) {
        guard let attachment = notification.userInfo?["attachment"] as? Attachment else { return }
        responder?.removeAttachment(attachment)
    }
    
    @objc private func handleOnOpenAttachment(_ notification: Notification) {
        guard let attachment = notification.userInfo?["attachment"] as? Attachment else { return }
        responder?.attachmentsHandler.present(attachment)
        _ = responder?.responderViewController.responderAccessoryView?.resignFirstResponder()
    }
    
    @objc private func handleOnThumbsUpClicked(_ notification: Notification) {
        responder?.metadata.message = "👍"
        if let unwrappedMetadata = responder?.metadata {
            responder?.apiEngine?.sendMessage(with: unwrappedMetadata)
            responder?.metadata.clear()
            responder?.actionsListener?.onSendAction(unwrappedMetadata)
            responder?.responderViewController.responderAccessoryView?.disableSendButton()
        }
    }
    
    @objc private func handleOnStartUploading(_ notification: Notification) {
        responder?.responderViewController.responderAccessoryView?.disableSendButton()
    }
    
    @objc private func handleOnFinishedUploading(_ notification: Notification) {
        if responder?.metadata.isSendButtonEnabled == true {
            responder?.responderViewController.responderAccessoryView?.enableSendButton()
        }
    }
    
    @objc private func handleRemoveLastRecipient(_ notification: Notification) {
        responder?.responderViewController.responderAccessoryView?.removeLastRecipientIfNeeded()
    }
    
    @objc private func handleSendButtonCheck(_ notification: Notification) {
        responder?.responderViewController.responderAccessoryView?.checkSendButtonVisibility()
    }
}
