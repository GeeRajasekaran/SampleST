//
//  FeedTabRealTimeListener.swift
//  June
//
//  Created by Ostap Holub on 10/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedTabRealTimeListener: IRealTimeListener {
    
    // MARK: - Validating conditions
    
    private struct ValidationField {
        static let approved = "approved"
        static let category = "category"
        static let unread = "unread"
        static let lastMessageReceivedTime = "last_message_received_timestamp"
    }
    
    private struct ValidationThreshold {
        static let category = "conversations"
    }
    
    // MARK: - Interface variables
    
    var onEvent: (TabsRealTimeManager.RealTimeTabName) -> Void
    var tab: TabsRealTimeManager.RealTimeTabName
    
    required init(event: @escaping (TabsRealTimeManager.RealTimeTabName) -> Void, for tab: TabsRealTimeManager.RealTimeTabName) {
        onEvent = event
        self.tab = tab
    }
    
    func subscribe() {
        FeathersManager.Services.threads.on(event: .patched).observeValues({ [weak self] thread in
            if let action = self?.onEvent, let tabName = self?.tab {
                if self?.validate(thread) == true {
                    action(tabName)
                }
            }
        })
    }
    
    func unsubscribe() {
        FeathersManager.Services.threads.off(event: .patched)
    }
}

// MARK: - IRealTimeValidatable

extension FeedTabRealTimeListener: IRealTimeValidateable {
    
    func validate(_ object: [String : Any]) -> Bool {
        guard let approved = object[ValidationField.approved] as? Bool,
            let category = object[ValidationField.category] as? String,
            let unread = object[ValidationField.unread] as? Bool,
            let lastMessageReceivedTime = object[ValidationField.lastMessageReceivedTime] as? Int,
            let feedTimestamp = TimestampUserDefaults().feedTimestamp else { return false }
        
        return (approved && category != ValidationThreshold.category && unread && lastMessageReceivedTime > feedTimestamp) == true
    }
}
