//
//  Message.swift
//  June
//
//  Created by Ostap Holub on 9/4/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class Message: Equatable {
    
    var id: String {
        get { return messageEntity.id ?? "" }
    }
    
    var subject: String? {
        get { return messageEntity.subject }
    }
    
    var profilePictureUrl: String? {
        get { return (messageEntity.messages_from?.anyObject() as? Messages_From)?.profile_pic }
    }
    
    var senderName: String? {
        get { return (messageEntity.messages_from?.anyObject() as? Messages_From)?.email }
    }
    
    var senderEmail: String? {
        get { return (messageEntity.messages_from?.anyObject() as? Messages_From)?.name }
    }
    
    var timestamp: Int32? {
        get { return messageEntity.date }
    }
    
    var htmlBody: String? {
        get { return messageEntity.body }
    }
    
    var toList: NSSet? {
        get { return messageEntity.messages_to }
    }
    
    var fromList: NSSet? {
        get { return messageEntity.messages_from }
    }
    
    var htmlMarkDown: String? {
        get {
            if let allObjects = messageEntity.messages_segmented_html?.allObjects as? [Messages_Segmented_Html] {
                for segmentedHtml in allObjects {
                    if segmentedHtml.order == 1 && segmentedHtml.type == "top_message" {
                        if let markdown = segmentedHtml.html_markdown {
                            return markdown
                        } else {
                            return segmentedHtml.html
                        }
                    }
                }
            }
            return nil
        }
    }
    
    var entity: Messages {
        get { return messageEntity }
    }
    
    var hasAttachments: Bool? {
        get {
            if let count = messageEntity.messages_files?.count {
                return count != 0
            }
            return nil
        }
    }
    
    private var messageEntity: Messages
    
    init(with entity: Messages) {
        messageEntity = entity
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}
