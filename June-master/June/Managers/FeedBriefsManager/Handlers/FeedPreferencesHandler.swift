//
//  FeedPreferencesHandler.swift
//  June
//
//  Created by Ostap Holub on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedPreferencesHandler {
    
    // MARK: - Variables & Constants
    
    private struct Key {
        static let preferences: String = "preferences"
        static let feed: String = "feed"
        static let show: String = "show"
    }
    
    var briefCategories: [String] = []
    
    // MARK: - Initialization
    
    init() {
        loadBriefCategories()
    }
    
    // MARK: - Private processing logic
    
    func loadBriefCategories() {
        briefCategories = []
        guard let preferences = feedPreferences() else { return }
        preferences.forEach { [weak self] key, value in
            guard let valueDict = value as? [String: Bool] else { return }
            if valueDict[Key.show] == true {
                self?.briefCategories.append(key)
            }
        }
    }
    
    private func serializedUserObject() -> [String: Any]? {
        guard let userData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        return KeyChainManager.NSDATAtoDictionary(data: userData)
    }
    
    private func feedPreferences() -> [String: Any]? {
        guard let user = serializedUserObject() else { return nil }
        if let preferences = user[Key.preferences] as? [String: Any] {
            return preferences[Key.feed] as? [String: Any]
        }
        return nil
    }
}
