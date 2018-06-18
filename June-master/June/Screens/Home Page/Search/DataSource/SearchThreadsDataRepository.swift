//
//  SearchThreadDataRepository.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchThreadsDataRepository: NSObject {
    
    // MARK: - Variables
    var receivers = [ThreadsReceiver]()
    var threadsDataProvider: ThreadsDataProvider = ThreadsDataProvider()
    var readStateHandler: ReadStateHandler = ReadStateHandler()
    var convosAPI: ConvosAPIBridge = ConvosAPIBridge()
    
    func clean() {
        receivers.removeAll()
    }
    
    func append(_ receivers: [ThreadsReceiver]) {
        self.receivers.append(contentsOf: receivers)
    }
    
    func markAsRead(_ receiver: ThreadsReceiver) {
        if let seen = receiver.seen {
            if !seen {
                let thread = receiver.threadEntity
                threadsDataProvider.update(thread, unread: true, seen: true, inbox: true)
                readStateHandler.markAsReadThread(with: receiver.threadEntity?.id)
            }
        }        
    }
    //unread = true, seen = false, inbox = true
    func markAsUnread(_ receiver: ThreadsReceiver) {
        guard let thread = receiver.threadEntity, let id = receiver.id, let accountId = receiver.accountId else { return }
        threadsDataProvider.update(thread, unread: true, seen: false, inbox: true)
        convosAPI.markThreadAsSeen(threadId: id, accountId: accountId, thread: thread) { [weak self] result in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                self?.threadsDataProvider.update(thread, unread: true, seen: false, inbox: true)
                print(message)
            }
        }
    }
    
    
    func markAsSeen(_ receiver: ThreadsReceiver) {
        guard let thread = receiver.threadEntity, let id = receiver.id, let accountId = receiver.accountId else { return }
        threadsDataProvider.update(thread, unread: true, seen: true, inbox: true)
        convosAPI.markThreadAsSeen(threadId: id, accountId: accountId, thread: thread) { result in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func markAsCleared(_ receiver: ThreadsReceiver) {
        guard let thread = receiver.threadEntity, let id = receiver.id, let accountId = receiver.accountId else { return }
        threadsDataProvider.update(thread, unread: false, seen: false, inbox: true)
        convosAPI.markThreadAsCleared(threadId: id, accountId: accountId, thread: thread) { result in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    //MARK: - getting
    func receiver(by index: Int) -> ThreadsReceiver? {
        if index < receivers.count {
            return receivers[index]
        }
        return nil
    }
    
    func index(of receiver: ThreadsReceiver) -> Int? {
        return receivers.index(of: receiver)
    }
    
    func getCount() -> Int {
        return receivers.count
    }
}
