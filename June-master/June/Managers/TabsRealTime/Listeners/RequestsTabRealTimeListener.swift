//
//  RequestsTabRealTimeListener.swift
//  June
//
//  Created by Ostap Holub on 10/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class RequestsTabRealTimeListener: IRealTimeListener {
    
    // MARK: - Validating conditions
    
    private struct ValidationField {
        static let status = "status"
        static let lastThreadMessageSent = "last_thread_message_sent_timestamp"
        static let lastMessageUnread = "last_message_unread"
    }
    
    private struct ValidationThreshold {
        static let statusApproved = "approved"
        static let statusBlocked = "blocked"
        static let statusIgnored = "ignored"
    }
    
    // MARK: - Interface variables
    
    var onEvent: (TabsRealTimeManager.RealTimeTabName) -> Void
    var tab: TabsRealTimeManager.RealTimeTabName
    
    required init(event: @escaping (TabsRealTimeManager.RealTimeTabName) -> Void, for tab: TabsRealTimeManager.RealTimeTabName) {
        onEvent = event
        self.tab = tab
    }
    
    func subscribe() {
        FeathersManager.Services.contacts.on(event: .patched).observeValues({ [weak self] contact in
            if let action = self?.onEvent, let tabName = self?.tab {
                if self?.validate(contact) == true {
                    action(tabName)
                }
            }
        })
    }
    
    func unsubscribe() {
        FeathersManager.Services.contacts.off(event: .patched)
    }
}

// MARK: - IRealTimeValidatable

extension RequestsTabRealTimeListener: IRealTimeValidateable {
    
    func validate(_ object: [String : Any]) -> Bool {
        guard let lastMessageDate = object[ValidationField.lastThreadMessageSent] as? Int,
            let lastMessageUnread = object[ValidationField.lastMessageUnread] as? Bool,
            let requestsTimestamp = TimestampUserDefaults().requestsTimestamp else { return false }
        
        var statusCheckingResult = true
        if let status = object[ValidationField.status] as? String {
            if status != "" { statusCheckingResult = false }
        }
        return (statusCheckingResult && lastMessageDate > requestsTimestamp && lastMessageUnread) == true
    }
}
