//
//  Account.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account {
    
    var email: String = ""
    var name: String = ""
    var syncState: String = ""
    var isPrimary: Bool = false
    
    init(withDictionary dictionary: [String:Any]) {
        
        if let emaiAddress = dictionary["email_address"] as? String {
            email = emaiAddress
        }
        
        if let state = dictionary["sync_state"] as? String {
            syncState = state
        }
        
        if let accountName = dictionary["name"] as? String {
            name = accountName
        }
    }
    
    init(withJson jsonObject: JSON) {
        email = jsonObject["email_address"].stringValue
        name = jsonObject["name"].stringValue
        syncState = jsonObject["sync_state"].stringValue
    }
    
    func shouldReauthenticate() -> Bool {
        if syncState == "running" {
            return false
        }
        return true
    }
}
