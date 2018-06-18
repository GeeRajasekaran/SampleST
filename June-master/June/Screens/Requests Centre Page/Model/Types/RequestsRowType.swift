//
//  RequestsRowType.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum RequestsRowType: Int {
    case collapsed = 0
    case expanded
    
    static func rows(for items: [RequestItem]) -> [RequestsRowType] {
        return items.map { item in
            return item.isCollapsed ? .collapsed : .expanded
        }
    }
}

