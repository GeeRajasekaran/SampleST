//
//  RolodexsSectionType.swift
//  June
//
//  Created by Joshua Cleetus on 3/19/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum RolodexsSectionType: Int {
    case rolodexs
    case rolodexsLoader
    case favs
    case favsLoader
    case unreads
    case unreadsLoader
    case pins
    case pinsLoader

    static func sections(screenType: RolodexsScreenType, maxRolodexsItemsReached: Bool, noRolodexsItems: Bool, maxFavsItemsReached: Bool, noFavsItems: Bool, maxUnreadItemsReached: Bool, noUnreadItems: Bool, maxPinnedItemsReached: Bool, noPinnedItems: Bool) -> [RolodexsSectionType] {
        var sections: [RolodexsSectionType] = []
        switch screenType {
        case .recent:
            sections = [rolodexs]
            if !maxRolodexsItemsReached {
                sections.append(rolodexsLoader)
            }
            return sections
        case .favorites:
            sections = [favs]
            if !maxRolodexsItemsReached {
                sections.append(favsLoader)
            }
            return sections
        case .unread:
            sections = [rolodexs]
            if !maxRolodexsItemsReached {
                sections.append(rolodexsLoader)
            }
            return sections
        case .pinned:
            sections = [rolodexs]
            if !maxRolodexsItemsReached {
                sections.append(rolodexsLoader)
            }
            return sections
        }
    }
}
