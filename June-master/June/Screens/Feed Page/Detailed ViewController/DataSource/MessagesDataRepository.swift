//
//  MessagesDataSource.swift
//  June
//
//  Created by Ostap Holub on 9/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import AlertBar

class MessagesDataRepository {
    
    // MARK: - Variables
    
    private var threadId: String
    fileprivate var messages: [Message]
    var onUpdateCallback: (() -> Void)?
    
    // MARK: - Additional components
    
    fileprivate var messagesProxy = MessagesProxy()
    
    fileprivate lazy var messagesProvider: MessagesDataProvider = {
        let provider = MessagesDataProvider(with: self)
        return provider
    }()
    
    init(with id: String?) {
        messages = [Message]()
        threadId = id ?? ""
    }
    
    // MARK: - Setting logic
    
    func append(_ message: Message) {
        messages.append(message)
        onUpdateCallback?()
    }
    
    func append(contentsOf array: [Message]) {
        messages.append(contentsOf: array)
        onUpdateCallback?()
    }
    
    fileprivate func replace(with array: [Message]) {
        messages = array
        onUpdateCallback?()
    }
    
    // MARK: - Getting logic
    
    var count: Int {
        get { return messages.count }
    }
    
    func message(at index: Int) -> Message? {
        if index >= 0 && index < messages.count {
            return messages[index]
        }
        return nil
    }
    
    func firstMessage() -> Message? {
        return messages.first
    }
    
    func index(of message: Message) -> Int? {
        return messages.index(of: message)
    }
    
    // MARK: - Access logic
    
    func requestMessages() {
        append(contentsOf: messagesProxy.fetchMessages(for: threadId))
        messagesProvider.requestMessages(for: threadId)
    }
}

// MARK: - MessagesProviderDelegate

extension MessagesDataRepository: MessagesProviderDelegate {
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessagesFor threadId: String) {
        replace(with: messagesProxy.fetchMessages(for: threadId))
    }
}
