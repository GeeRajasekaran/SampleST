//
//  RequestItem.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RequestItem: BaseTableModel {
    
    private(set) var contactEntity: Contacts?
    
    // MARK: - Calculated properties
    var isCollapsed: Bool = false
    
    var peopleInfo: PeopleInfo? {
        get { return PeopleInfo(entity: contactEntity, messagesCount: lastMessages?.count) }
    }
    
    var contactId: String? {
        get { return contactEntity?.id }
    }
    
    var lastMessageThreadId: String? {
        get { return contactEntity?.last_message_thread_id }
    }
    
    var lastMessageId: String? {
        get { return contactEntity?.last_message_id }
    }

    var lastMessages: [MessageInfo]? {
        get { return loadLastThreeMessages() }
    }
    
    var lastMessage: MessageInfo? {
        get { return messages?.last }
    }
    
    var type: RequestsScreenType? {
        get { return loadType() }
    }
    
    var messages: [MessageInfo]?
    
    init(contact: Contacts? = nil) {
        self.contactEntity = contact
    }
    
    //MARK: - private processing logic
    private func loadLastThreeMessages() -> [MessageInfo]? {
        guard let lastThreeItems = messages?.prefix(3) else { return nil }
        return Array(lastThreeItems.reversed())
    }
    
    private func loadType() -> RequestsScreenType? {
        guard let entiy = contactEntity else { return nil }
        return RequestsScreenType.create(from: entiy.list_name, and: entiy.status)
    }
}
