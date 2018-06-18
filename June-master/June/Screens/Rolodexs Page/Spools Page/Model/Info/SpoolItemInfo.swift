//
//  SpoolItemInfo.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolItemInfo: BaseTableModel {
    
    // MARK: - Variables & Constants
    
    var spool: Spools
    
    var title: String? {
        return spool.last_message_subject
    }
    
    var summary: String? {
        if spool.summary == "" || spool.summary == nil {
            return spool.last_message_snippet
        }
        return spool.summary
    }
    
    var timestamp: Int32 {
        return spool.last_message_date
    }
    
    var participants: String? {
        return namedParticipantsNames()
    }
    
    var unread: Bool {
        return spool.unread
    }
    
    var unreadCount: Int16? {
        return spool.unread_message_count
    }
    
    // MARK: - Initialization
    
    init(spool: Spools) {
        self.spool = spool
    }
    
    // MARK: - Private processing logic
    
    private func namedParticipantsNames() -> String? {
        
        guard let participants = spool.spools_named_participants?.sortedArray(using: []) as? [Spools_Named_Participants] else { return nil }
        if participants.count == 0 {
            return participantsNames()
        }
        let names = participants.map { p -> String in
            if p.first_name != "" {
                return p.first_name ?? ""
            } else {
                return p.email ?? ""
            }
        }.sorted(by: {$0 < $1})
        return names.joined(separator: ", ")
    }
    
    private func participantsNames() -> String? {
        guard let participants = spool.spools_participants?.sortedArray(using: []) as? [Spools_Participants] else { return nil }
        let names = participants.map { p -> String in
            if p.name != "" {
                return p.name ?? ""
            } else {
                return p.email ?? ""
            }
            }.sorted(by: {$0 < $1})
        return names.joined(separator: ", ")
    }
}
