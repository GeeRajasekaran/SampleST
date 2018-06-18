//
//  MessageHeaderInfo.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class MessageHeaderInfo: BaseTableModel {
    
    var isExpanded: Bool
    var vendorName: String?
    var vendorEmail: String?
    var profileImageURL: URL?
    
    var toNames: [String]
    var toEmails: [String]
    var date: Int32
    
    init(isExpanded: Bool, message: Messages, thread: Threads) {
        self.isExpanded = isExpanded
        
        vendorName = (message.messages_from?.anyObject() as? Messages_From)?.name
        vendorEmail = (message.messages_from?.anyObject() as? Messages_From)?.email
        
//        vendorName = thread.last_message_from?.name
//        vendorEmail = thread.last_message_from?.email
        toNames = message.toNames()
        toEmails = message.toEmails()
        date = message.date
        
        if let urlString = thread.last_message_from?.profile_pic {
            profileImageURL = URL(string: urlString)
        }
    }
    
}
