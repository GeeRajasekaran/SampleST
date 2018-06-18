//
//  SpoolDetailsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 4/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolDetailsDataRepository {
    
    // MARK: - Variables & Constants
    
    var messages: [SpoolMessageInfo] = []
    
    var count: Int {
        return messages.count
    }
    
    // MARK: - Public update logic
    
    func update(with messages: [SpoolMessageInfo]) {
        self.messages = messages
    }
}
