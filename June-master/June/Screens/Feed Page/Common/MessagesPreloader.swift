//
//  MessagesPreloader.swift
//  June
//
//  Created by Ostap Holub on 12/5/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import AlertBar

class MessagesPreloader {
    
    // MARK: - Variables
    
    private var pendingThreadIds = [String]()
    private var messagesProxy = MessagesProxy()
    private lazy var messagesProvider: MessagesDataProvider = { [weak self] in
        let provider = MessagesDataProvider(with: self)
        return provider
    }()
    
    // MARK: - Predownload logic
    
    func preloadMessages(for optionalThreads: [Threads?]) {
        optionalThreads.forEach { [weak self] singleThread in
            if let unwrappedThread = singleThread, let threadId = unwrappedThread.id {
                self?.preloadMessages(for: threadId)
            }
        }
    }
    
    func preloadMessages(for threads: [Threads]) {
        threads.forEach { [weak self] singleThread in
            if let threadId = singleThread.id {
                self?.preloadMessages(for: threadId)
            }
        }
    }
    
    func preloadMessages(for threadId: String) {
        appendIfNeeded(threadId)
        if messagesProxy.fetchMessages(for: threadId).count == 0 {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.messagesProvider.requestMessages(for: threadId)
            }
        }
    }
    
    // MARK: - Private processing logic
    
    private func appendIfNeeded(_ threadId: String) {
        if !pendingThreadIds.contains(threadId) {
            pendingThreadIds.append(threadId)
        }
    }
}

    // MARK: - MessagesProviderDelegate

extension MessagesPreloader: MessagesProviderDelegate {
    
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessagesFor threadId: String) {
        if let index = pendingThreadIds.index(of: threadId) {
            pendingThreadIds.remove(at: index)
        }
    }
}
