//
//  ThreadsParser.swift
//  June
//
//  Created by Ostap Holub on 9/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class ThreadsParser {
    
    struct ThreadsJsonKeys {
        static let accountId = "account_id"
        static let trash = "trash"
        static let hasAttachments = "has_attachments"
        static let approved = "approved"
        static let draftIds = "draft_ids"
        static let subject = "subject"
        static let messageIds = "message_ids"
        static let inbox = "inbox"
        static let starred = "starred"
        static let id = "id"
        static let all = "all"
        static let archived = "archived"
        static let category = "category"
        static let sent = "sent"
        static let lastMessageReceivedTimestamp = "last_message_received_timestamp"
        static let lastMessageSentTimestamp = "last_message_sent_timestamp"
        static let lastMessageFrom = "last_message_from"
        static let labels = "labels"
        static let object = "object"
        static let section = "section"
        static let broadcastedAt = "broadcasted_at"
        static let snippet = "snippet"
        static let lastMessageTimestamp = "last_message_timestamp"
        static let summary = "summary"
        static let drafts = "drafts"
        static let firstMessageTimestamp = "first_message_timestamp"
        static let _id = "_id"
        static let categoryIds = "category_ids"
        static let spam = "spam"
        static let unread = "unread"
        static let important = "important"
        static let version = "version"
        static let participants = "participants"
        static let messageDataSha256 = "message_data_sha256s"
        static let seen = "seen"
        static let trackingNumbers = "tracking_number"
        static let threadId = "thread_id"
        static let vendor = "vendor"
        static let messageId = "message_id"
        static let orderNumber = "order_number"
        static let orderTotal = "order_total"
        static let template = "template"
        static let items = "items"
        static let emailImage = "email_image"
        static let qwantImage = "qwant_image"
        static let cards = "cards"
    }
    
    func loadData(from json: JSON, to entity: Threads) {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        entity.id = json[ThreadsJsonKeys.id].string
        entity.last_message_timestamp = json[ThreadsJsonKeys.lastMessageTimestamp].int32Value
        
        entity.account_id = json[ThreadsJsonKeys.accountId].string
        entity.trash = json[ThreadsJsonKeys.trash].boolValue
        entity.has_attachments = json[ThreadsJsonKeys.hasAttachments].boolValue
        entity.subject = json[ThreadsJsonKeys.subject].string
        entity.category = json[ThreadsJsonKeys.category].string
        
        if let array = json[ThreadsJsonKeys.messageIds].arrayObject as NSArray? {
            entity.message_ids = array
        }
        
        entity.starred = json[ThreadsJsonKeys.starred].boolValue
        entity.all = json[ThreadsJsonKeys.all].boolValue
        entity.archived = json[ThreadsJsonKeys.archived].boolValue
        entity.sent = json[ThreadsJsonKeys.sent].boolValue
        entity.last_message_received_timestamp = json[ThreadsJsonKeys.lastMessageReceivedTimestamp].int32Value
        entity.last_message_sent_timestamp = json[ThreadsJsonKeys.lastMessageSentTimestamp].int32Value
        
        if let lastMessageFromJSON = json[ThreadsJsonKeys.lastMessageFrom].array {
            if lastMessageFromJSON.count > 0 {
                let lastMessageFrom = LastMessageFrom(context: context)
                if let name = lastMessageFromJSON.first?["name"].string {
                    lastMessageFrom.name = name
                }
                if let email = lastMessageFromJSON.first?["email"].string {
                    lastMessageFrom.email = email
                }
                if let profilePicture = lastMessageFromJSON.first?["profile_pic"].string {
                    lastMessageFrom.profile_pic = profilePicture
                }
                entity.last_message_from = lastMessageFrom
            }
        }
        
        entity.object = json[ThreadsJsonKeys.object].string
        entity.section = json[ThreadsJsonKeys.section].string
        entity.broadcasted_at = json[ThreadsJsonKeys.broadcastedAt].int32Value
        entity.snippet = json[ThreadsJsonKeys.snippet].string
        entity.last_message_sent_timestamp = json[ThreadsJsonKeys.lastMessageSentTimestamp].int32Value
        entity.summary = json[ThreadsJsonKeys.summary].string
        entity.first_message_timestamp = json[ThreadsJsonKeys.firstMessageTimestamp].int32Value
        
        entity.approved = json[ThreadsJsonKeys.approved].boolValue
        
        if let array = json[ThreadsJsonKeys.categoryIds].arrayObject as NSArray? {
            entity.category_ids = array
        }
        
        entity.spam = json[ThreadsJsonKeys.spam].boolValue
        entity.unread = json[ThreadsJsonKeys.unread].boolValue
        entity.seen = json[ThreadsJsonKeys.seen].boolValue
        entity.inbox = json[ThreadsJsonKeys.inbox].boolValue
        entity.important = json[ThreadsJsonKeys.important].boolValue
        
        if let participantsJSON = json[ThreadsJsonKeys.participants].array {

            let participantsData = entity.participants?.mutableCopy() as! NSMutableSet
            for singlePartisipantJSON in participantsJSON {
                let participant = Participants(context: context)
                if let name = singlePartisipantJSON["name"].string {
                    participant.name = name
                }
                if let email = singlePartisipantJSON["email"].string {
                    participant.email = email
                }

                participantsData.add(participant)
                entity.addToParticipants(participantsData)
            }
        }
        
        let cards = Cards(context: context)
        let cardsJSON = json[ThreadsJsonKeys.cards]
        if !cardsJSON.isEmpty {
            cards.email_image = cardsJSON[ThreadsJsonKeys.emailImage].string
            cards.qwant_image = cardsJSON[ThreadsJsonKeys.qwantImage].string
            
            cards.object = cardsJSON[ThreadsJsonKeys.object].string
            cards.thread_id = cardsJSON[ThreadsJsonKeys.threadId].string
            cards.message_id = cardsJSON[ThreadsJsonKeys.messageId].string
            cards.order_number = cardsJSON[ThreadsJsonKeys.orderNumber].string
            cards.order_total = cardsJSON[ThreadsJsonKeys.orderTotal].string
            cards.template = cardsJSON[ThreadsJsonKeys.template].string
            
            //vendor object parcing
            let vendor = Vendor(context: context)
            vendor.name = cardsJSON[ThreadsJsonKeys.vendor]["name"].string
            vendor.icon = cardsJSON[ThreadsJsonKeys.vendor]["icon"].string
            cards.vendor = vendor
            
            //items object parcing
            cards.items = [cardsJSON[ThreadsJsonKeys.items].rawString() as Any]
        }
        entity.cards = cards
        
        if let eventsArray = json["events"].array {
            save(events: eventsArray, to: entity)
        }
    }
    
    private func save(events: [JSON], to entity: Threads) {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        events.forEach { [weak self] event in
            if let eventEntity = self?.createSingleEvent(from: event, in: context) {
                entity.addToThreadsEvents(eventEntity)
            }
        }
    }

    private func createSingleEvent(from json: JSON, in context: NSManagedObjectContext) -> ThreadsEvents {
        let event = ThreadsEvents(context: context)
        
        event.updatedAt = json["updated_at"].int32Value
        event.object = json["object"].string
        event.eventDescription = json["description"].string
        event.calendarId = json["calendar_id"].string
        event.isBusy = json["busy"].boolValue
        event.isReadOnly = json["read_only"].boolValue
        event.status = json["status"].string
        event.location = json["location"].string
        event.id = json["id"].string
        event.threadId = json["thread_id"].string
        event.owner = json["owner"].string
        event.title = json["title"].string
        event.messageId = json["message_id"].string
        event.accountId = json["account_id"].string
        event.when = json["when"].rawString()
        
        if let participantsArray = json["participants"].array {
            save(participants: participantsArray, to: event)
        }
        
        return event
    }

    private func save(participants: [JSON], to event: ThreadsEvents) {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext

        participants.forEach { [weak self] participantJSON in
            if let participant = self?.createSingleParticipant(from: participantJSON, in: context) {
                event.addToThreadsEventsParticipants(participant)
            }
        }
    }
    
    private func createSingleParticipant(from json: JSON, in context: NSManagedObjectContext) -> ThreadsEventsParticipants {
        let participant = ThreadsEventsParticipants(context: context)
        
        participant.comment = json["comment"].string
        participant.status = json["status"].string
        participant.email = json["email"].string
        participant.name = json["name"].string
        participant.profilePicture = json["profile_pic"].string
        
        return participant
    }
}
