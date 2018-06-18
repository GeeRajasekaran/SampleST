//
//  RecipientsLoader.swift
//  June
//
//  Created by Ostap Holub on 2/23/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RecipientsLoader {
    
    func loadRecipients(from config: ResponderConfig) -> [EmailReceiver] {
        var recipients: [EmailReceiver] = []
        
        if let fromSet = config.message.messages_from {
            fromSet.forEach({ object in
                if object is Messages_From {
                    let from = object as! Messages_From
                    let receiver = EmailReceiver(name: from.name, email: from.email, destination: .display)
                    if !recipients.contains(receiver) {
                        recipients.append(receiver)
                    }
                }
            })
        }
        
        if let email = userPrimaryEmail() {
            if containsEmail(email, in: recipients) {
                recipients = []
                if let messagesToSet = config.message.messages_to {
                    messagesToSet.forEach({ object in
                        if object is Messages_To {
                            let toObject = object as! Messages_To
                            let receiver = EmailReceiver(name: toObject.name, email: toObject.email, destination: .display)
                            if !recipients.contains(receiver) {
                                recipients.append(receiver)
                            }
                        }
                    })
                }
            }
        }
        
        if config.goal == .reply {
            if recipients.count > 0 {
                recipients = [recipients[0]]
            }
        }
        
        if config.goal == .replyAll {
            if let carbonCopySet = config.message.messages_cc {
                carbonCopySet.forEach({ object in
                    if object is Messages_Cc {
                        let carbonCopy = object as! Messages_Cc
                        let receiver = EmailReceiver(name: carbonCopy.name, email: carbonCopy.email, destination: .display)
                        if !recipients.contains(receiver) {
                            recipients.append(receiver)
                        }
                    }
                })
            }
            
            if let blindCarbonCopySet = config.message.messages_bcc {
                blindCarbonCopySet.forEach({ object in
                    if object is Messages_Bcc {
                        let blindCopy = object as! Messages_Bcc
                        let receiver = EmailReceiver(name: blindCopy.name, email: blindCopy.email, destination: .display)
                        if !recipients.contains(receiver) {
                            recipients.append(receiver)
                        }
                    }
                })
            }
            
            if let messagesToSet = config.message.messages_to {
                messagesToSet.forEach({ object in
                    if object is Messages_To {
                        let toObject = object as! Messages_To
                        let receiver = EmailReceiver(name: toObject.name, email: toObject.email, destination: .display)
                        if !recipients.contains(receiver) {
                            recipients.append(receiver)
                        }
                    }
                })
            }
        }
        
        if let sender = sender() {
            if config.goal == .replyAll {
                if let index = recipients.index(of: sender) {
                    recipients.remove(at: index)
                }
            }
        }
        let inputReceiver = EmailReceiver(name: "", email: "", destination: .input)
        recipients.append(inputReceiver)
        return recipients
    }
    
    func names(from message: Messages) -> String? {
        guard let messageRecipients = message.messages_recipients?.sortedArray(using: []) as? [Messages_Recipients] else { return nil }
        
        let names: [String] = messageRecipients.compactMap { r -> String? in
            if r.email == self.userEmail() { return nil }
            return r.first_name
        }
        return "Message to \(names.joined(separator: ", "))…"
    }
    
    private func sender() -> EmailReceiver? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]], let firstAccount = accounts.first {
            if let name = firstAccount["name"] as? String, let email = firstAccount["email_address"] as? String {
                return EmailReceiver(name: name, email: email, destination: .display)
            }
        }
        return nil
    }
    
    private func userEmail() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]], let firstAccount = accounts.first {
            if let email = firstAccount["email_address"] as? String {
                return email
            }
        }
        return nil
    }
    
    private func userPrimaryEmail() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let primary_email = serializedUserObject["primary_email"] {
            return primary_email as? String
        }
        return nil
    }
    
    private func containsEmail(_ email: String, in array: [EmailReceiver]) -> Bool {
        for recipient in array {
            if recipient.email == email { return true }
        }
        return false
    }
}
