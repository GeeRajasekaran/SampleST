//
//  AccountsRealTimeManager.swift
//  June
//
//  Created by Ostap Holub on 1/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class AccountsRealTimeManager {
    
    // MARK: - Variables & Constants
    
    private struct Key {
        static let id: String = "id"
        static let syncState: String = "sync_state"
        static let accounts: String = "accounts"
    }
    
    private let runningThreshold: String = "running"
    private var onEvent: (() -> Void)?
    
    // MARK: - Initialization
    
    init(action: (() -> Void)?) {
        onEvent = action
    }
    
    // MARK: - Public subscribe / unsubscribe logic
    
    func subscribe() {
        FeathersManager.Services.accounts.on(event: .patched).observeValues({ [weak self] account in
            if self?.isAccountInvalid(account) == true {
                self?.onEvent?()
            }
        })
    }
    
    func unsubscribe() {
        FeathersManager.Services.accounts.off(event: .patched)
    }
    
    // MARK: - Private validation logic
    
    private func isAccountInvalid(_ account: [String: Any]) -> Bool {
        guard let accountId = account[Key.id] as? String else { return false }
        if userContainsAccount(with: accountId) {
            if let syncState = account[Key.syncState] as? String {
                return syncState != runningThreshold
            }
        }
        return false
    }
    
    private func userContainsAccount(with id: String) -> Bool {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return false }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accounts = serializedUserObject[Key.accounts] as? [[String: Any]] {
            return accounts.contains(where: { containsPredicate($0, id) })
        }
        return false
    }
    
    private lazy var containsPredicate: ([String: Any], String) -> Bool = { account, id in
        guard let accountId = account[Key.id] as? String else { return false }
        return accountId == id
    }
}
