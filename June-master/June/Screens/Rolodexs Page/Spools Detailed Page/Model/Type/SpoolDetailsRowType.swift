//
//  SpoolDetailsRowType.swift
//  June
//
//  Created by Ostap Holub on 4/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum SpoolDetailsRowType: Int {
    case message
    case showOlderMessages
    
    static func rowTypes(for items: [Any], isLoadingMoreAvailable: Bool) -> [SpoolDetailsRowType] {
        var types: [SpoolDetailsRowType] = items.map { _ in return .message }
        if isLoadingMoreAvailable {
            types.insert(.showOlderMessages, at: 0)
        }
        return types
    }
}
