//
//  SpoolIndexHeaderInfo.swift
//  June
//
//  Created by Ostap Holub on 4/6/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolIndexHeaderInfo {
    
    // MARK: - Variables & Constants
    
    private var rolodex: Rolodexs
    private var firstParticipant: Rolodexs_Named_Participants?
    
    var profileURL: URL? {
        return prepareProfileImageUrl()
    }
    
    var name: String? {
        if firstParticipant?.name == "" {
            return firstParticipant?.email
        }
        return firstParticipant?.name
    }
    
    var viewInfo: String {
        return LocalizedStringKey.SpoolIndexHelper.viewMoreTitle
    }
    
    init(rolodex: Rolodexs) {
        self.rolodex = rolodex
        self.firstParticipant = loadFirstParticipant()
    }
    
    private func loadFirstParticipant() -> Rolodexs_Named_Participants? {
        guard let participants = rolodex.rolodexs_named_participants?.allObjects as? [Rolodexs_Named_Participants] else {
            return nil
        }
        return participants.first
    }
    
    private func prepareProfileImageUrl() -> URL? {
        if let urlString = firstParticipant?.profile_pic {
            return URL(string: urlString)
        }
        return nil
    }
}
