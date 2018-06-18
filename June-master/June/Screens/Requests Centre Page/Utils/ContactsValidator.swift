//
//  ContactsValidator.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ContactsValidator: NSObject {
    
    /// Method that validates contact id
    ///
    /// - Parameter contactId: Contact id that you want to check
    /// - Returns: contact id if id is valid and empty, otherwise -> nil
    class func validate(contactId: String?) -> String? {
        guard let unwrappedContactId = contactId else {
            print("\(#file).\(#line) Failed to unwrap the contact id")
            return nil
        }
        
        if unwrappedContactId.isEmpty {
            print("\(#file).\(#line) Contact id is empty")
            return nil
        }
        return unwrappedContactId
    }
}
