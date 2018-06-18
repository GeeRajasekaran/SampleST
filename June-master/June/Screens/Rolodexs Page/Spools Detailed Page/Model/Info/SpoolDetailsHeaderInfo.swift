//
//  SpoolDetailsHeaderInfo.swift
//  June
//
//  Created by Ostap Holub on 4/6/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolDetailsHeaderInfo {
    
    // MARK: - Variables & Constants
    
    private var spool: Spools?
    private var firstParticipant: Spools_Named_Participants?
    
    // MARK: - Initialization
    
    init(spool: Spools?) {
        self.spool = spool
        self.firstParticipant = loadFirstParticipant()
    }
    
    // MARK: - Getters
    
    var subject: String? {
        return spool?.last_message_subject
    }
    
    var name: String? {
        if firstParticipant?.name == "" {
            return firstParticipant?.email
        }
        return firstParticipant?.name
    }
    
    // MARK: - Loading first named participant
    
    private func loadFirstParticipant() -> Spools_Named_Participants? {
        guard let participants = spool?.spools_named_participants?.allObjects as? [Spools_Named_Participants] else {
            return nil
        }
        return participants.first
    }
}
