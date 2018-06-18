//
//  DraftsParser.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/1/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class DraftsParser {

    func loadData(from messageEntity: Messages, and messageText: String, to entity: Drafts) {
        entity.body = messageText
        entity.message_id = messageEntity.id
        entity.subject = messageEntity.subject
  
        addMessageTo(from: messageEntity, to: entity)
        addMessageFrom(from: messageEntity, to: entity)
        addMessageCarbonCopy(from: messageEntity, to: entity)
        addMessageBlindCarbonCopy(from: messageEntity, to: entity)
    }
    
    //MARK: - private part
    
    func addMessageFrom(from messageEntity: Messages, to entity: Drafts) {
        var messagesFrom = [Messages_From]()
        if let messagesFromSet = messageEntity.messages_from {
            messagesFromSet.forEach({ object in
                if object is Messages_From {
                    if let copy = object as? Messages_From {
                        messagesFrom.append(copy)
                    }
                }
            })
            entity.messages_from = NSSet(array: messagesFrom)
        }
    }
    
    func addMessageTo(from messageEntity: Messages, to entity: Drafts) {
        var messagesTo = [Messages_To]()
        if let messagesToSet = messageEntity.messages_to {
            messagesToSet.forEach({ object in
                if object is Messages_To {
                    if let copy = object as? Messages_To {
                        messagesTo.append(copy)
                    }
                }
            })
            entity.messages_to = NSSet(array: messagesTo)
        }
    }
    
    func addMessageBlindCarbonCopy(from messageEntity: Messages, to entity: Drafts) {
        var messagesBcc = [Messages_Bcc]()
        if let blindCarbonCopySet = messageEntity.messages_bcc {
            blindCarbonCopySet.forEach({ object in
                if object is Messages_Bcc {
                    if let copy = object as? Messages_Bcc {
                        messagesBcc.append(copy)
                    }
                }
            })
            entity.messages_bcc = NSSet(array: messagesBcc)
        }
    }
    
    func addMessageCarbonCopy(from messageEntity: Messages, to entity: Drafts) {
        var messagesCc = [Messages_Cc]()
        if let carbonCopySet = messageEntity.messages_cc {
            carbonCopySet.forEach({ object in
                if object is Messages_Cc {
                    if let copy = object as? Messages_Cc {
                        messagesCc.append(copy)
                    }
                }
            })
            entity.messages_cc = NSSet(array: messagesCc)
        }
    }
    
    // MARK: - Files
    func add(filesFrom files: [Messages_Files], to entity: Drafts) {
        entity.messages_files = NSSet(array: files)
    }
}
