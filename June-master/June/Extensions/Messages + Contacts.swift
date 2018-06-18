//
//  Messages + Contacts.swift
//  June
//
//  Created by Ostap Holub on 10/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

extension Messages {
    
    func toNames() -> [String] {
        var names = [String]()
        messages_to?.forEach { element in
            if let toElement = element as? Messages_To, let name = toElement.name {
                names.append(name)
            }
        }
        return names
    }
    
    func toEmails() -> [String] {
        var emails = [String]()
        messages_to?.forEach { element in
            if let toElement = element as? Messages_To, let email = toElement.email {
                emails.append(email)
            }
        }
        return emails
    }
    
    func fromNames() -> [String] {
        var names = [String]()
        messages_from?.forEach { element in
            if let fromElement = element as? Messages_From, let name = fromElement.name {
                names.append(name)
            }
        }
        return names
    }
    
    func fromEmails() -> [String] {
        var emails = [String]()
        messages_from?.forEach { element in
            if let fromElement = element as? Messages_From, let email = fromElement.email {
                emails.append(email)
            }
        }
        return emails
    }
    
    func ccNames() -> [String] {
        var names = [String]()
        messages_cc?.forEach { element in
            if let ccElement = element as? Messages_Cc, let name = ccElement.name {
                names.append(name)
            }
        }
        return names
    }
    
    func ccEmails() -> [String] {
        var emails = [String]()
        messages_cc?.forEach { element in
            if let ccElement = element as? Messages_Cc, let email = ccElement.email {
                emails.append(email)
            }
        }
        return emails
    }
    
    func bccNames() -> [String] {
        var names = [String]()
        messages_bcc?.forEach { element in
            if let bccElement = element as? Messages_Bcc, let name = bccElement.name {
                names.append(name)
            }
        }
        return names
    }
    
    func bccEmails() -> [String] {
        var emails = [String]()
        messages_bcc?.forEach { element in
            if let bccElement = element as? Messages_Bcc, let email = bccElement.email {
                emails.append(email)
            }
        }
        return emails
    }
}
