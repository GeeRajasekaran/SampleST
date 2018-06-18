//
//  SpoolsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolsDataRepository {
    
    // MARK: - Variables & Constants
    
    var spoolItems: [SpoolItemInfo] = []
    
    var count: Int {
        return spoolItems.count
    }
    
    // MARK: - Model updating logic
    
    func update(with data: [SpoolItemInfo]) {
        spoolItems = data
    }
}
