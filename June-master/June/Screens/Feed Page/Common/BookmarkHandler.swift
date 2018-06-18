//
//  BookmarkHandler.swift
//  June
//
//  Created by Ostap Holub on 9/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

class BookmarkHandler {
    
    // MARK: - Variables
    
    private var parser = ThreadsParser()
    private var proxy = ThreadsProxy()
    
    // MARK: - Star / unstar server call
    
    func changeState(of thread: Threads, to value: Bool, completion: @escaping (String) -> Void) {
        guard let validatedThreadId = ThreadIdValidator.validate(threadId: thread.id) else {
            return
        }
        if let parameters = params(for: thread, and: value) {
            FeathersManager.Services.threads.request(.patch(id: validatedThreadId, data: parameters, query: nil))
                .on(value: { response in
                    completion("")
                }).startWithFailed({ error in
                    completion(error.localizedDescription)
                })
        }
    }
    
    func changeState(of thread: Threads, completion: @escaping (String) -> Void) {
        guard let validatedThreadId = ThreadIdValidator.validate(threadId: thread.id) else {
            return
        }
        
        if let params = parameters(for: thread) {
            FeathersManager.Services.threads.request(.patch(id: validatedThreadId, data: params, query: nil))
                .on(value: { response in
                    completion("")
                }).startWithFailed({ error in
                    completion(error.localizedDescription)
                })
        }
    }
    
    func changeStateAndSave(_ card: FeedItem, completion: @escaping (String) -> Void) {
        guard let validatedThreadId = ThreadIdValidator.validate(threadId: card.id) else {
            return
        }
        
        if let params = parameters(for: card) {
            FeathersManager.Services.threads.request(.patch(id: validatedThreadId, data: params, query: nil))
                .on(value: { [weak self] response in
                    if let strongSelf = self {
                        let threadJson = JSON(response.data.value)
                        strongSelf.updateThreadJsonInCoreData(threadJson, completion: completion)
                    }
                }).startWithFailed({ error in
                    completion(error.localizedDescription)
                })
        }
    }
    
    private func updateThreadJsonInCoreData(_ jsonObject: JSON, completion: @escaping (String) -> Void) {
        if !jsonObject.isEmpty {
           
            if let threadId = jsonObject["id"].string {
                if let threadEntity = proxy.fetchThread(by: threadId) {
                    parser.loadData(from: jsonObject, to: threadEntity)
                    proxy.saveContext()
                    completion("")
                }
            }
        }
    }
    
    // MARK: - Parameters building
    
    private func params(for thread: Threads, and value: Bool) -> [String: Any]? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accountId = serializedUserObject["primary_account_id"] as? String {
            return ["starred": value, "unread": false, "account_id": accountId] as [String : Any]
        }
        return nil
    }
    
    private func parameters(for thread: Threads) -> [String: Any]? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accountId = serializedUserObject["primary_account_id"] as? String {
            return ["starred": !thread.starred, "unread": false, "account_id": accountId] as [String : Any]
        }
        return nil
    }
    
    private func parameters(for card: FeedItem) -> [String: Any]? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accountId = serializedUserObject["primary_account_id"] as? String {
            return ["starred": !card.starred, "unread": false, "account_id": accountId] as [String : Any]
        }
        return nil
    }
}
