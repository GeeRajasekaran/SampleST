//
//  FeedPreferencesRealtimeListener.swift
//  June
//
//  Created by Ostap Holub on 2/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import KeychainSwift

class FeedPreferencesRealtimeListener {
    
    private var onEvent: (() -> Void)?
    
    // MARK: - Initialization
    
    init(action: (() -> Void)?) {
        onEvent = action
    }
    
    // MARK: - Public subscribe / unsubscribe logic
    
    func subscribe() {
        FeathersManager.Services.users.on(event: .patched).observeValues({ [weak self] user in
            let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: user)
            _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
            self?.onEvent?()
        })
    }
    
    func unsubscribe() {
        FeathersManager.Services.accounts.off(event: .patched)
    }
    
}
