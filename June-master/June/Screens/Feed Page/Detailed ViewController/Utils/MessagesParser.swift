//
//  MessagesParser.swift
//  June
//
//  Created by Ostap Holub on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class MessagesParser {
    
    struct JsonKeys {
        // object keys
        static let accountId = "account_id"
        static let body = "body"
        static let categoryIds = "category_ids"
        static let charactersCount = "character_count"
        static let dataSha256 = "data_sha256"
        static let date = "date"
        static let emotionScore = "emotion_score"
        static let lastMessageFromContactId = "last_message_from_contact_id"
        static let obmId = "obm_id"
        static let rolodexId = "rolodex_id"
        static let section = "section"
        static let snippet = "snippet"
        static let spoolId = "spool_id"
        static let starred = "starred"
        static let subject = "subject"
        static let summary = "sumamry"
        static let threadId = "thread_id"
        static let unread = "unread"
        static let wordsCount = "word_count"
        static let messageId = "_id"
        
        // relationships keys
        static let bcc = "bcc"
        static let cc = "cc"
        static let events = "events"
        static let files = "files"
        static let from = "from"
        static let replyTo = "reply_to"
        static let segmentedHTML = "segmented_html"
        static let segmentedPro = "segmented_pro"
        static let to = "to"
        
        // common part
        static let object = "object"
        static let id = "id"
        static let email = "email"
        static let name = "name"
        static let profilePicture = "profile_pic"
        
        // files
        static let size = "size"
        static let fileName = "filename"
        static let contentType = "content_type"
        
        // segmented
        static let order = "order"
        static let type = "type"
        static let html = "html"
        static let htmlMarkdown = "html_markdown"
        
        static let isInPath: String = "is_in_path"
        static let rolodexSubjectId: String = "rolodex_subject_id"
        static let participantsId: String = "participants_id"
    }
    
    private var proxy: MessagesProxy
    
    init() {
        proxy = MessagesProxy()
    }
    
    func loadData(from json: JSON, into entity: Messages) {
        entity.account_id = json[JsonKeys.accountId].string
        entity.body = json[JsonKeys.body].string
        
//        if let array = json[JsonKeys.categoryIds].array as NSArray? {
//            entity.category_ids = array
//        }
        
        entity.messages_id = json[JsonKeys.messageId].string
        entity.character_count = json[JsonKeys.charactersCount].int32Value
        entity.data_sha256 = json[JsonKeys.dataSha256].string
        entity.date = json[JsonKeys.date].int32Value
        entity.emotion_score = json[JsonKeys.emotionScore].doubleValue
        entity.last_message_from_contact_id = json[JsonKeys.lastMessageFromContactId].string
        entity.id = json[JsonKeys.id].string
        entity.object = json[JsonKeys.object].string
        entity.obm_id = json[JsonKeys.obmId].string
        entity.rolodex_id = json[JsonKeys.rolodexId].string
        entity.section = json[JsonKeys.section].string
        entity.snippet = json[JsonKeys.snippet].string
        entity.spool_id = json[JsonKeys.spoolId].string
        entity.starred = json[JsonKeys.starred].boolValue
        entity.subject = json[JsonKeys.subject].string
        entity.summary = json[JsonKeys.summary].string
        entity.thread_id = json[JsonKeys.threadId].string
        entity.unread = json[JsonKeys.unread].boolValue
        entity.word_count = json[JsonKeys.wordsCount].int32Value
        
        entity.participants_id = json[JsonKeys.participantsId].string
        entity.is_in_path = json[JsonKeys.isInPath].boolValue
        entity.rolodex_subject_id = json[JsonKeys.rolodexSubjectId].string
        
        // relationships part
        if let bccArray = json[JsonKeys.bcc].array {
            add(bccsFrom: bccArray, to: entity)
        }

        if let ccArray = json[JsonKeys.cc].array {
            add(ccsFrom: ccArray, to: entity)
        }

        if let fromArray = json[JsonKeys.from].array {
            add(emailSourceFrom: fromArray, to: entity)
        }

        if let filesArray = json[JsonKeys.files].array {
            add(filesFrom: filesArray, to: entity)
        }

        if let replyToArray = json[JsonKeys.replyTo].array {
            add(replyToFrom: replyToArray, to: entity)
        }

        if let segmentedHtmlArray = json[JsonKeys.segmentedHTML].array {
            add(segmentedHtmlFrom: segmentedHtmlArray, to: entity)
        }

        if let segmentedProArray = json[JsonKeys.segmentedPro].array {
            add(segmentedProFrom: segmentedProArray, to: entity)
        }

        if let toArray = json[JsonKeys.to].array {
            add(toFrom: toArray, to: entity)
        }
    }
    
    // MARK: - Ccarbon copies
    
    private func add(bccsFrom json: [JSON], to entity: Messages) {
        var bccsFrom = [Messages_Bcc]()
        for bccElement in json {
            let bccEntity = Messages_Bcc(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            bccEntity.email = bccElement[JsonKeys.email].string
            bccEntity.name = bccElement[JsonKeys.name].string
            bccEntity.profile_pic = bccElement[JsonKeys.profilePicture].string
            bccsFrom.append(bccEntity)
        }
        entity.messages_bcc = NSSet(array: bccsFrom)
    }
    
    private func add(ccsFrom json: [JSON], to entity: Messages) {
        var ccsFrom = [Messages_Cc]()
        for ccElement in json {
            let ccEntity = Messages_Cc(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            ccEntity.email = ccElement[JsonKeys.email].string
            ccEntity.name = ccElement[JsonKeys.name].string
            ccEntity.profile_pic = ccElement[JsonKeys.profilePicture].string
            ccsFrom.append(ccEntity)
        }
        entity.messages_cc = NSSet(array: ccsFrom)
    }
    
    // MARK: - From / to part
    
    private func add(emailSourceFrom json: [JSON], to entity: Messages) {
        var emailsFrom = [Messages_From]()
        for source in json {
            let fromEntity = Messages_From(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            fromEntity.email = source[JsonKeys.email].string
            fromEntity.name = source[JsonKeys.name].string
            fromEntity.profile_pic = source[JsonKeys.profilePicture].string
            emailsFrom.append(fromEntity)
        }
        entity.messages_from = NSSet(array: emailsFrom)
    }
    
    // MARK: - Files
    
    private func add(filesFrom json: [JSON], to entity: Messages) {
        var files = [Messages_Files]()
        for file in json {
            let filesEntity = Messages_Files(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            filesEntity.size = file[JsonKeys.size].int32Value
            filesEntity.id = file[JsonKeys.id].string
            filesEntity.file_name = file[JsonKeys.fileName].string
            filesEntity.content_type = file[JsonKeys.contentType].string
            files.append(filesEntity)
        }
        entity.messages_files = NSSet(array: files)
    }
    
    // MARK: - Reply to
    
    private func add(replyToFrom json: [JSON], to entity: Messages) {
        var messagesReplyTo = [Messages_Reply_To]()
        for source in json {
            let replyToEntity = Messages_Reply_To(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            replyToEntity.email = source[JsonKeys.email].string
            replyToEntity.name = source[JsonKeys.name].string
            replyToEntity.profile_pic = source[JsonKeys.profilePicture].string
            messagesReplyTo.append(replyToEntity)
        }
        entity.messages_reply_to = NSSet(array: messagesReplyTo)
    }
    
    private func add(toFrom json: [JSON], to entity: Messages) {
        var messagesTo = [Messages_To]()
        for source in json {
            let toEntity = Messages_To(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            toEntity.email = source[JsonKeys.email].string
            toEntity.name = source[JsonKeys.name].string
            toEntity.profile_pic = source[JsonKeys.profilePicture].string
            messagesTo.append(toEntity)
        }
        entity.messages_to = NSSet(array: messagesTo)
    }
    
    // MARK: - Segmented objects
    
    private func add(segmentedHtmlFrom json: [JSON], to entity: Messages) {
        var messagesSegmentedHtml = [Messages_Segmented_Html]()
        for object in json {
            let htmlEntity = Messages_Segmented_Html(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            htmlEntity.object = object[JsonKeys.object].string
            htmlEntity.order = object[JsonKeys.order].int16Value
            htmlEntity.type = object[JsonKeys.type].string
            htmlEntity.html = object[JsonKeys.html].string
            htmlEntity.html_markdown = object[JsonKeys.htmlMarkdown].string
            messagesSegmentedHtml.append(htmlEntity)
        }
        entity.messages_segmented_html = NSSet(array: messagesSegmentedHtml)
    }
    
    private func add(segmentedProFrom json: [JSON], to entity: Messages) {
        var messagesSegmentedPro = [Messages_Segmented_Pro]()
        for object in json {
            let htmlEntity = Messages_Segmented_Pro(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
            htmlEntity.object = object[JsonKeys.object].string
            htmlEntity.order = object[JsonKeys.order].int16Value
            htmlEntity.type = object[JsonKeys.type].string
            htmlEntity.html = object[JsonKeys.html].string
            messagesSegmentedPro.append(htmlEntity)
        }
        entity.messages_segmented_pro = NSSet(array: messagesSegmentedPro)
    }
}

