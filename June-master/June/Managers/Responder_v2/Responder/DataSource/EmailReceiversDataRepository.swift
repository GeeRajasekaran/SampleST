//
//  PersonsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class EmailReceiversDataRepository {
    
    // MARK: - Variables
    
    var receivers: [EmailReceiver]
    private weak var config: ResponderConfig?
    
    // MARK: - Initialization
    
    init() {
        receivers = [EmailReceiver]()
        appendInputReceiver()
    }
    
    init(with config: ResponderConfig) {
        self.config = config
        receivers = [EmailReceiver]()
    }
    
    func contains(_ receiver: EmailReceiver) -> Bool {
        return receivers.contains(receiver)
    }
    
    func append(_ receiver: EmailReceiver) {
        let index = receivers.count - 1
        if index < receivers.count {
            receivers.insert(receiver, at: index)
        }
    }
    
    func index(of receiver: EmailReceiver) -> Int? {
        return receivers.index(of: receiver)
    }
    
    func remove(at index: Int) {
        receivers.remove(at: index)
    }
    
    func containsEmail(_ email: String) -> Bool {
        for receiver in receivers {
            if receiver.email == email { return true }
        }
        return false
    }
    
    // MARK: - Private data loading
    
    func clear() {
        receivers = []
    }
    
    func loadData() {
        
        receivers = []

        guard config?.goal != .forward else {
            appendInputReceiver()
            return
        }
        
        if let fromSet = config?.message.messages_from {
            fromSet.forEach({ object in
                if object is Messages_From {
                    let from = object as! Messages_From
                    let receiver = EmailReceiver(name: from.name, email: from.email, destination: .display)
                    if !contains(receiver) {
                        receivers.append(receiver)
                    }
                }
            })
        }
        
        if let email = userPrimaryEmail() {
            if containsEmail(email) {
                clear()
                if let messagesToSet = config?.message.messages_to {
                    messagesToSet.forEach({ object in
                        if object is Messages_To {
                            let toObject = object as! Messages_To
                            let receiver = EmailReceiver(name: toObject.name, email: toObject.email, destination: .display)
                            if !contains(receiver) {
                                receivers.append(receiver)
                            }
                        }
                    })
                }
            }
        }
        
        if config?.goal == .reply {
            if receivers.count > 0 {
                receivers = [receivers[0]]
            }
        }
        
        if config?.goal == .replyAll {
            if let carbonCopySet = config?.message.messages_cc {
                carbonCopySet.forEach({ object in
                    if object is Messages_Cc {
                        let carbonCopy = object as! Messages_Cc
                        let receiver = EmailReceiver(name: carbonCopy.name, email: carbonCopy.email, destination: .display)
                        if !contains(receiver) {
                            receivers.append(receiver)
                        }
                    }
                })
            }
            
            if let blindCarbonCopySet = config?.message.messages_bcc {
                blindCarbonCopySet.forEach({ object in
                    if object is Messages_Bcc {
                        let blindCopy = object as! Messages_Bcc
                        let receiver = EmailReceiver(name: blindCopy.name, email: blindCopy.email, destination: .display)
                        if !contains(receiver) {
                            receivers.append(receiver)
                        }
                    }
                })
            }
            
            if let messagesToSet = config?.message.messages_to {
                messagesToSet.forEach({ object in
                    if object is Messages_To {
                        let toObject = object as! Messages_To
                        let receiver = EmailReceiver(name: toObject.name, email: toObject.email, destination: .display)
                        if !contains(receiver) {
                            receivers.append(receiver)
                        }
                    }
                })
            }
        }
        
        if let sender = sender() {
            if config?.goal == .replyAll {
                if let index = receivers.index(of: sender) {
                    receivers.remove(at: index)
                }
            }
        }
        appendInputReceiver()
    }
    
    private func appendInputReceiver() {
        let inputReceiver = EmailReceiver(name: "", email: "", destination: .input)
        receivers.append(inputReceiver)
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

}