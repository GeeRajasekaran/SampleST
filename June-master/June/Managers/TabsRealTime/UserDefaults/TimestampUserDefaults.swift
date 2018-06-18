//
//  RealTimeUserDefaults.swift
//  June
//
//  Created by Ostap Holub on 10/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class TimestampUserDefaults: JuneUserDefaults {
    
    // MARK: - UserDefaults keys
    
    private struct Keys {
        static let threads = "kLastViewedThreadsSection"
        static let feed = "kLastViewedFeedSection"
        static let requests = "kLastViewedRequestsSection"
    }
    
    private struct ActiveKeys {
        static let threads = "kIsThreadsActive"
        static let feed = "kIsFeedActive"
        static let requests = "kIsReqeustsActive"
    }
    
    // MARK: - Active tab tracking logic
    
    var isTreadsActive: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: ActiveKeys.threads)
            synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: ActiveKeys.threads)
        }
    }
    
    var isFeedActive: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: ActiveKeys.feed)
            synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: ActiveKeys.feed)
        }
    }
    
    var isRequestsActive: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: ActiveKeys.requests)
            synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: ActiveKeys.requests)
        }
    }
    
    // MARK: - Threads timestamp
    
    var threadsTimestamp: Int? {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.threads)
            synchronize()
        }
        get {
            if let value = UserDefaults.standard.value(forKey: Keys.threads) as? Int {
                return value
            }
            return nil
        }
    }
    
    // MARK: - Feed timestamp
    
    var feedTimestamp: Int? {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.feed)
            synchronize()
        }
        get {
            if let value = UserDefaults.standard.value(forKey: Keys.feed) as? Int {
                return value
            }
            return nil
        }
    }
    
    // MARK: - Request timestamp
    
    var requestsTimestamp: Int? {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.requests)
            synchronize()
        }
        get {
            if let value = UserDefaults.standard.value(forKey: Keys.requests) as? Int {
                return value
            }
            return nil
        }
    }
}
