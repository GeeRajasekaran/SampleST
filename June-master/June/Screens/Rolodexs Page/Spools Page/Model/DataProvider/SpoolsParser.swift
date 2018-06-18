//
//  SpoolsParser.swift
//  June
//
//  Created by Ostap Holub on 4/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class SpoolsParser {
    
    struct Key {
        static let _id: String = "_id"
        static let id: String = "id"
        static let all: String = "all"
        static let lastMessagesRolodexId: String = "last_message_rolodex_id"
        static let inbox: String = "inbox"
        static let lastMessageThreadId: String = "last_message_thread_id"
        static let lastMessageFrom: String = "last_message_from"
        static let lastMessageId: String = "last_message_id"
        static let archived: String = "archived"
        static let lastMessageEvents: String = "last_message_event"
        static let lastMessageDataSha: String = "last_message_data_sha"
        static let drafts: String = "drafts"
        static let spam: String = "spam"
        static let participants: String = "participants"
        static let lastMessageUnread: String = "last_message_unread"
        static let lastMessageSnippet: String = "last_message_snippet"
        static let lastMessageObmId: String = "last_message_odm_id"
        static let lastMessageAccountId: String = "last_message_account_id"
        static let trash: String = "trash"
        static let lastMessageFiles: String = "last_message_files"
        static let lastMessageTo: String = "last_message_to"
        static let lastMessageReplyTo: String = "last_message_reply_to"
        static let object: String = "object"
        static let lastMessagesRolodexSubjectId: String = "last_messages_rolodex_subject_id"
        static let lastMessagesParticipantsId: String = "last_messages_participants_id"
        static let lastMessagesRolodexSubjectSnippetId: String = "last_messages_rolodex_subject_snippet_id"
        static let important: String = "important"
        static let lastMessageSubject: String = "last_message_subject"
        static let lastMessageCC: String = "last_message_cc"
        static let lastMessageBCC: String = "last_message_bcc"
        static let sent: String = "sent"
        static let lastMessageDate: String = "last_message_date"
        static let lastMessageStarred: String = "last_message_starred"
        static let section: String = "section"
        static let category: String = "category"
        static let categoryIds: String = "category_ids"
        static let brodcastedAt: String = "brodcasted_at"
        static let unread: String = "unread"
        static let unreadMessageCount: String = "unread_message_count"
        static let starred: String = "starred"
        static let starredMessageCount: String = "starredMessageCount"
        static let updatedAt: String = "updatedAt"
        static let namedParticipants: String = "named_participants"
        static let summary: String = "summary"
    }
    
    class func load(data: JSON, into entity: Spools) {
        entity.all = data[Key.all].boolValue
        entity.archived = data[Key.archived].boolValue
        entity.drafts = data[Key.drafts].boolValue
        entity.inbox = data[Key.inbox].boolValue
        entity.last_message_account_id = data[Key.lastMessageAccountId].string
        entity.last_message_data_sha = data[Key.lastMessageDataSha].string
        entity.last_message_id = data[Key.lastMessageId].string
        entity.last_message_obm_id = data[Key.lastMessageObmId].string
        entity.last_message_snippet = data[Key.lastMessageSnippet].string
        entity.last_message_unread = data[Key.lastMessageUnread].boolValue
        
        entity.last_messages_participants_id = data[Key.lastMessagesParticipantsId].string
        entity.last_messages_rolodex_id = data[Key.lastMessagesRolodexId].string
        entity.last_messages_rolodex_subject_id = data[Key.lastMessagesRolodexSubjectId].string
        entity.last_messages_rolodex_subject_snippet_id = data[Key.lastMessagesRolodexSubjectSnippetId].string
        entity.last_messages_thread_id = data[Key.lastMessageThreadId].string
        entity.object = data[Key.object].string
        entity.spam = data[Key.spam].boolValue
        entity.spools_id = data[Key.id].string
        entity.spools_underscore_id = data[Key._id].string
        entity.starred_message_count = data[Key.starredMessageCount].int16Value
        entity.trash = data[Key.trash].boolValue
        entity.unread = data[Key.unread].boolValue
        entity.unread_message_count = data[Key.unreadMessageCount].int16Value
        entity.last_message_subject = data[Key.lastMessageSubject].string
        entity.summary = data[Key.summary].string
        
        entity.last_message_date = data[Key.lastMessageDate].int32Value
        entity.starred = data[Key.starred].boolValue
        entity.starred_message_count = data[Key.starredMessageCount].int16Value
        
        addNamedParticipants(from: data, to: entity)
        addParticipants(from: data, to: entity)
    }
    
    class func addNamedParticipants(from data: JSON, to entity: Spools) {
        guard let participantsJSON = data[Key.namedParticipants].array else { return }
        guard let context = entity.managedObjectContext else { return }
        let participantsSet: NSMutableSet = NSMutableSet()
        
        let proxy: SpoolsProxy = SpoolsProxy()
        participantsJSON.forEach { json in
            let participant = proxy.addNewSpoolNamedPartcipant(into: context)
            participant.name = json["name"].string
            participant.email = json["email"].string
            participant.first_name = json["first_name"].string
            participant.last_name = json["last_name"].string
            participantsSet.add(participant)
        }
        entity.spools_named_participants = participantsSet
    }
    
    class func addParticipants(from data: JSON, to entity: Spools) {
        guard let participantsJSON = data[Key.participants].array else { return }
        guard let context = entity.managedObjectContext else { return }
        let participantsSet: NSMutableSet = NSMutableSet()
        
        let proxy: SpoolsProxy = SpoolsProxy()
        participantsJSON.forEach { json in
            let participant = proxy.addNewsSpoolParticipant(into: context)
            participant.name = json["name"].string
            participant.email = json["email"].string
            participantsSet.add(participant)
        }
        entity.spools_participants = participantsSet
    }
}
