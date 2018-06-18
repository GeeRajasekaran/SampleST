//
//  ContactsParser.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/24/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactsParser {

    struct ContactsJsonKeys {
        static let accountId = "account_id"
        static let createdAt = "created_at"
        static let email = "email"
        static let id = "id"
        static let lastMessageDate = "last_message_date"
        static let lastMessageId = "last_message_id"
        static let lastMessageSubject = "last_message_subject"
        static let lastMessageThreadId = "last_message_thread_id"
        static let lastMessageUnread = "last_message_unread"
        static let lastMessageCategoryIds = "last_message_category_ids"
        static let lastMessageSnippet = "last_message_snippet"
        static let listName = "list_name"
        static let name = "name"
        static let object = "object"
        static let profilePic = "profile_pic"
        static let status = "status"
        static let updatedAt = "updated_at"
        static let inbox = "inbox"
    }

    func loadData(from json: JSON, to entity: Contacts) {
        entity.account_id = json[ContactsJsonKeys.accountId].string
        entity.created_at = json[ContactsJsonKeys.createdAt].int32Value
        entity.email = json[ContactsJsonKeys.email].string
        entity.id = json[ContactsJsonKeys.id].string
        entity.last_message_date = json[ContactsJsonKeys.lastMessageDate].int32Value
        entity.last_message_id = json[ContactsJsonKeys.lastMessageId].string
        entity.last_message_subject = json[ContactsJsonKeys.lastMessageSubject].string
        entity.last_message_thread_id = json[ContactsJsonKeys.lastMessageThreadId].string
        entity.last_message_unread = json[ContactsJsonKeys.lastMessageUnread].boolValue
        entity.list_name = json[ContactsJsonKeys.listName].string
        entity.name = json[ContactsJsonKeys.name].string
        entity.object = json[ContactsJsonKeys.object].string
        entity.profile_pic = json[ContactsJsonKeys.profilePic].string
        entity.status = json[ContactsJsonKeys.status].string
        entity.updated_at = json[ContactsJsonKeys.updatedAt].int32Value
        entity.inbox = json[ContactsJsonKeys.inbox].boolValue
        entity.last_message_snippet = json[ContactsJsonKeys.lastMessageSnippet].string
        if let array = json[ContactsJsonKeys.lastMessageCategoryIds].arrayObject as NSArray? {
            entity.last_message_category_ids = array
        }
    }
}
