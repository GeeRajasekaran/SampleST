//
//  ReadStateHandler.swift
//  June
//
//  Created by Ostap Holub on 12/11/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReadStateHandler {
    
    // MARK: - Variables & Constanst
    
    private struct PatchKeys {
        static let unread: String = "unread"
        static let seen: String = "seen"
        static let accountId: String = "account_id"
        static let primaryAccountId: String = "primary_account_id"
        static let id: String = "id"
    }
    
    private let threadsProxy: ThreadsProxy = ThreadsProxy()
    private let threadsParser: ThreadsParser = ThreadsParser()
    
    // MARK: - Public methods
    
    func markAsReadThread(with id: String?) {
        changeReadState(to: true, forId: id)
    }
    
    func markAsUnreadThread(with id: String?) {
        changeReadState(to: false, forId: id)
    }
    
    // MARK: - Private part
    
    private func changeReadState(to value: Bool, forId id: String?) {
        guard let unwrappedThreadId = ThreadIdValidator.validate(threadId: id) else {
            return
        }
        
        if let params = buildParams(for: value) {
            FeathersManager.Services.threads.request(.patch(id: unwrappedThreadId, data: params, query: nil)).on(value: { [weak self] response in
                let json = JSON(response.data.value)
                if !json.isEmpty {
                    self?.updateThreadInDatebase(json)
                }
            }).startWithFailed({ error in
                print("\(#file).\(#line) Failed to change the state of thread with id: \(unwrappedThreadId) to \(value) with error: \(error.localizedDescription)")
            })
        }
    }
 
    private func buildParams(for value: Bool) -> [String: Any]? {
        guard let accountId = fetchAccountId() else { return nil }
        return [PatchKeys.unread: !value, PatchKeys.seen: true, PatchKeys.accountId: accountId] as [String: Any]
    }
    
    private func fetchAccountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        return serializedUserObject[PatchKeys.primaryAccountId] as? String
    }
    
    // MARK: - Private processing logic
    
    private func updateThreadInDatebase(_ json: JSON) {
        let threadId = json[PatchKeys.id].stringValue
        
        if let entity = threadsProxy.fetchThread(by: threadId) {
            threadsParser.loadData(from: json, to: entity)
            threadsProxy.saveContext()
        }
    }
}
