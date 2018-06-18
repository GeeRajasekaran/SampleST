//
//  MessageInfo.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/15/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class MessageInfo: BaseTableModel {

    private(set) var message: Message?
    
    // MARK: - Calculated properties
    var isExpanded: Bool = false
    
    var subject: String? {
        get { return message?.subject }
    }
    
    var fromName: String? {
        get { return loadFromName() }
    }
    
    var toName: String? {
        get { return loadToName() }
    }
    
    var toEmail: String? {
        get { return message?.senderEmail }
    }
    
    var date: String? {
        get { return loadDate() }
    }
    
    var body: String? {
        get { return loadMessageBody() }
    }
    
    var hasAttachments: Bool? {
        get { return message?.hasAttachments }
    }
    
    var isCurrentUserMessage: Bool? {
        get { return checkIfCurrentUserAnswer() }
    }
    
    var id: String? {
        get { return message?.id }
    }
    
    var isDraftExist: Bool? {
        get {
            return draftInfo == nil ? false : true
        }
    }
    
    var draftInfo: DraftInfo? {
        get { return loadDraft() }
    }
    
    init(message: Message? = nil) {
        self.message = message
    }
    
    //MARK: - private processing logic
    private func loadToName() -> String? {
        if let array = message?.toList?.allObjects as? [Messages_To] {
            let firstName = array.first?.name ?? ""
            return firstName
        }
        return nil
    }
    
    private func loadFromName() -> String? {
        if let array = message?.fromList?.allObjects as? [Messages_From] {
            let firstName = array.first?.name ?? ""
            return firstName
        }
        return nil
    }
    
    
    private func loadDate() -> String? {
        if let timestamp = message?.timestamp {
            return Date.dateAndTimeFormat(from: timestamp)
        }
        return nil
    }
    
    private func loadMessageBody() -> String? {
        return message?.htmlMarkDown ?? message?.htmlBody
    }
    
    private func checkIfCurrentUserAnswer() -> Bool? {
        if let fromName = fromName, let userName = UserInfoLoader.userName {
            if fromName == userName {
                return true
            } else {
                return false
            }
        }
        return nil
    }
    
    private func loadDraft() -> DraftInfo? {
        var draftInfo: DraftInfo? = nil
        if let messageId = id {
            let draftProxy = DraftsProxy()
            if let draftEntity = draftProxy.fetchDraft(by: messageId) {
                draftInfo = DraftInfo(entity: draftEntity)
            }
        }
        return draftInfo
    }
}
