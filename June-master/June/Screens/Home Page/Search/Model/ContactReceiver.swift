//
//  ContactReceiver.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactReceiver: Equatable {
    // MARK: - Variables
    var name: String
    var email: String
    var imageURL: String
    var lastMessageThreadId: String
    var id: String
    
    // MARK: - Initialization
    init() {
        id = ""
        lastMessageThreadId = ""
        name = ""
        email = ""
        imageURL = ""
    }
    
    init(with jsonObject: JSON) {
        id = jsonObject["id"].stringValue
        lastMessageThreadId = jsonObject["last_message_thread_id"].stringValue
        name = jsonObject["name"].stringValue
        email = jsonObject["email"].stringValue
        imageURL = jsonObject["profile_pic"].stringValue
    }
    
    static func == (lhs: ContactReceiver, rhs: ContactReceiver) -> Bool {
        return lhs.email == rhs.email
    }

}
