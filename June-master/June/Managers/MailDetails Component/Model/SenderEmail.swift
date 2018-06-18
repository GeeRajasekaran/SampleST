//
//  SenderEmail.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class SenderEmail {
    
    var email: String
    var profilePictureURL: String
    
    init(email: String, url: String) {
        self.email = email
        self.profilePictureURL = url
    }
    
}
