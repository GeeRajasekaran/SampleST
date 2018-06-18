//
//  ResponderMetadata.swift
//  June
//
//  Created by Ostap Holub on 2/13/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderMetadata: NSObject {
    
    // MARK: - Variables & Constants
    
    private let recipientsLoader: RecipientsLoader = RecipientsLoader()
    
    var config: ResponderConfig
    var state: ResponderState {
        didSet { rawState = state.rawValue }
    }
    @objc dynamic var rawState: String
    @objc dynamic var message: String
    var recipients: [EmailReceiver]
    var attachments: [Attachment] {
        willSet { previousAttachmentsCount = attachments.count }
        didSet { attachmentsCount = attachments.count }
    }
    var frame: CGRect = .zero {
        didSet {
            let userInfo: [AnyHashable: Any] = ["frame": frame]
            NotificationCenter.default.post(name: .onFrameChanged, object: nil, userInfo: userInfo)
        }
    }
    var heightDelta: CGFloat?
    var lastContentHeight: CGFloat?
    
    var placeholder: String?
    
    var previousAttachmentsCount: Int
    @objc dynamic var attachmentsCount: Int
    
    var isSendButtonEnabled: Bool {
        get {
            return !message.isEmpty && recipients.count > 1
        }
    }
    
    // MARK: - Initialization
    
    init(config: ResponderConfig) {
        self.config = config
        state = .minimized
        rawState = state.rawValue
        message = ""
        recipients = []
        attachments = []
        previousAttachmentsCount = attachments.count
        attachmentsCount = attachments.count
        frame = .zero
        recipients = recipientsLoader.loadRecipients(from: config)
        super.init()
        placeholder = makePlaceholder()
        checkForDrafts()
    }
    
    func append(_ recipient: EmailReceiver) {
        let index = recipients.count - 1
        if index < recipients.count {
            recipients.insert(recipient, at: index)
        }
    }
    
    func makePlaceholder() -> String? {
        return recipientsLoader.names(from: config.message)
    }
    
    func checkForDrafts() {
        if let draft = DraftsProxy().fetchDraft(byThreadId: config.thread.id) {
            guard let messageEntity = MessagesProxy().fetchMessage(by: config.message.id ?? "") else { return }
            config.message = messageEntity
            message = draft.body ?? ""
            recipients = []
            draft.messages_to?.forEach { objet in
                guard let toObject = objet as? Messages_To else { return }
                let recipient = EmailReceiver(name: toObject.name, email: toObject.email, destination: .display)
                recipient.profileImage = toObject.profile_pic
                recipients.append(recipient)
            }
            recipients.append(EmailReceiver(name: nil, email: nil, destination: .input))
        }
    }
    
    func update(_ config: ResponderConfig) {
        DraftsProxy().removeDraft(threadId: config.thread.id)
        clear()
        self.config = config
        recipients = recipientsLoader.loadRecipients(from: self.config)
        checkForDrafts()
    }
    
    func clear() {
        message = ""
        attachments = []
        placeholder = makePlaceholder()
    }
}
