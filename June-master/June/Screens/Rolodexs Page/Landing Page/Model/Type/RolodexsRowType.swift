//
//  RolodexsRowType.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum RolodexsRowType: Int {
    case rolodexsItem
    case favsItem
    case unreadItem
    case pinnedItem
    case loader

    static func rows(section: RolodexsSectionType, rolodexsItems: [Any], favsItems: [Any]) -> [RolodexsRowType] {
        var rows: [RolodexsRowType] = []
        switch section {
        case .rolodexs:
            rolodexsItems.forEach({ (_) in
                rows.append(rolodexsItem)
            })
        case .rolodexsLoader:
            rows = [loader]
        case .favs:
            favsItems.forEach({ (_) in
                rows.append(favsItem)
            })
        case .favsLoader:
            if favsItems.count > 19 {
                rows = [loader]
            }
        case .unreads:
            rolodexsItems.forEach({ (_) in
                rows.append(rolodexsItem)
            })
        case .unreadsLoader:
            rows = [loader]
        case .pins:
            rolodexsItems.forEach({ (_) in
                rows.append(rolodexsItem)
            })
        case .pinsLoader:
            rows = [loader]
        }
        return rows
    }

}
