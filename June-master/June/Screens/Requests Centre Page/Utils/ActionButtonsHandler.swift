//
//  ActionButtonsHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/18/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ActionButtonsHandler {

    private unowned var parentVC: UIViewController
    private var messageProxy = MessagesProxy()
    private var draftsHandler = DraftsHandler()
    private var rightButton: RightImageButton?
    private var responder: ResponderOld?
    private var lastRepliedRequestItem: RequestItem?
    private var lastEditedDraft: DraftInfo?

    lazy var cannedResponsePopupPresenter: ActionsPopupPresenter = { [unowned self] in
        let presenter = ActionsPopupPresenter(with: parentVC)
        return presenter
    }()
    
    init(with controller: UIViewController) {
        parentVC = controller
    }
    
    var onReplied: ((RequestItem, MessageInfo) -> Void)?
    var onUpdateItemAction: ((RequestItem) -> Void)?
    
    //MARK: - reply and canned response
    lazy var onReplyCell: (RequestItem, RightImageButton) -> Void = { [weak self] i, b in
        self?.showReplyPopup(item: i, button: b)
        self?.lastRepliedRequestItem = i
        self?.rightButton = b
    }
    
    private func showCannedResponsePopup(item: RequestItem, button: RightImageButton) {
        cannedResponsePopupPresenter.delegate = self
        cannedResponsePopupPresenter.contact = item
        cannedResponsePopupPresenter.showPopup(view: button, and: .cannedResponse)
    }
    
    private func showReplyPopup(item: RequestItem, button: RightImageButton) {
        cannedResponsePopupPresenter.delegate = self
        cannedResponsePopupPresenter.contact = item
        cannedResponsePopupPresenter.showPopup(view: button, and: .reply)
    }
    
    //MARK: responder
    func hideResponder() {
        responder?.hide()
        saveDraft()
    }
    
    private func saveDraft() {
        guard let requestItem = lastRepliedRequestItem, let lastMessageId = lastRepliedRequestItem?.lastMessageId, let lastMessageEntity = messageProxy.fetchMessage(by: lastMessageId), let responderText = responder?.getMessageBody(), let attachments = responder?.getAttachments() else { return }
        if responderText != "" || attachments.count > 0 {
            draftsHandler.saveDraftIntoCoreData(withRepliedToMessageId: lastMessageId, and: lastMessageEntity, and: responderText, attachments: attachments)
            onUpdateItemAction?(requestItem)
            responder = nil
        }
    }
    
    private func addResponder(for requestItem: RequestItem, with messageBody: String, attachments: [Attachment] = []) {
        guard let threadId = requestItem.lastMessageThreadId, let senderName = requestItem.peopleInfo?.name, let lastMessageEntity = requestItem.lastMessage?.message?.entity else { return }
        let proxy = ThreadsProxy()
        guard let unwrappedThread = proxy.fetchThread(by: threadId) else { return }
        let body = String.init(format: messageBody, senderName)
        if responder != nil { responder?.hide() }
        let config = ResponderConfig(with: .reply, thread: unwrappedThread, message: lastMessageEntity, minimized: false)
        responder = ResponderOld(with: parentVC, and: config)
        responder?.onSuccessResponse = onSuccessReplyResponse
        responder?.onSendButtonPressed = onSendAction
        responder?.start()
        if attachments.count > 0 {
            responder?.add(attachments: attachments)
        }
        responder?.setBody(with: body)
    }
    
    private lazy var onSuccessReplyResponse: ([String: AnyObject], String) -> Void = { [weak self] attributes, string in
        guard let sSelf = self else { return }
        if let obmId = attributes["obm_id"] as? String, let requestItem = sSelf.lastRepliedRequestItem {
            if let messageEntity = sSelf.messageProxy.fetchMessage(byObm: obmId) {
                let message = Message(with: messageEntity)
                let messageInfo = MessageInfo(message: message)
                sSelf.onReplied?(requestItem, messageInfo)
            }
        }
        sSelf.responder?.hide()
    }
    
    private lazy var onSendAction: (Messages, String, [EmailReceiver], [Attachment]) -> Void = { [weak self] message, text, receivers, attachments in
        guard let sSelf = self else { return }
        if let draftInfo = sSelf.lastEditedDraft {
            sSelf.draftsHandler.removeDraftFromCoreData(with: draftInfo)
        }
    }
    
    //MARK: - draft actions
    lazy var onDiscardDraftAction: (RequestItem, DraftInfo) -> Void = { [weak self] requestItem, info in
        guard let sSelf = self else { return }
        sSelf.draftsHandler.removeDraftFromCoreData(with: info)
        sSelf.onUpdateItemAction?(requestItem)
    }
    
    lazy var onEditDraftAction: ((RequestItem, DraftInfo) -> Void) = { [weak self] requestItem, info in
        guard let sSelf = self else { return }
        sSelf.lastRepliedRequestItem = requestItem
        sSelf.lastEditedDraft = info
        if let text = info.text, let attachments = info.attachments {
            sSelf.addResponder(for: requestItem, with: text, attachments: attachments)
        }
    }
}

extension ActionButtonsHandler: ActionsPopupPresenterDelegate {
    func presenter(_ presenter: ActionsPopupPresenter, dismissPopupWith replyAction: ReplyAction, requestItem: RequestItem) {
        if replyAction.title == LocalizedStringKey.RequestsViewHelper.CannedResponseTitle {
            guard let btn = rightButton else { return }
            showCannedResponsePopup(item: requestItem, button: btn)
        } else {
            if let message = replyAction.message {
                addResponder(for: requestItem, with: message)
            } else {
                addResponder(for: requestItem, with: "")
            }
        }
    }
}
