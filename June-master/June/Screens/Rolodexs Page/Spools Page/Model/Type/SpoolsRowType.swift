//
//  SpoolsRowType.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum SpoolsRowType: Int {
    
    case item

    static func rowTypes(from array: [Any]) -> [SpoolsRowType] {
        return array.map({ _ in return .item })
    }
}
