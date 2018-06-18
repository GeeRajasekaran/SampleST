//
//  RolodexaCiewHelper.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

struct RolodexsViewHelper {

    // Screen
    var screenType: RolodexsScreenType = RolodexsScreenType.recent
    
    // Segment
    var segmentType: RolodexsSegmentType = RolodexsSegmentType.recent
    
    // Rolodexs
    var rolodexsMails: [RolodexsTableInfo] = []
    var maxRolodexsItemsReached: Bool = false
    var noRolodexsItems: Bool = false
    // Loader
    let loader = Localized.string(forKey: LocalizedString.ConvosLoaderTitle)
    
    // Favorites
    var favsMails: [FavsTableInfo] = []
    var maxFavsItemsReached: Bool = false
    var noFavsItems: Bool = false
    
    // Unread
    var unreadMails: [RolodexsTableInfo] = []
    var maxUnreadItemsReached: Bool = false
    var noUnreadItems: Bool = false
    
    // Pinned
    var pinnedMails: [RolodexsTableInfo] = []
    var maxPinnedItemsReached: Bool = false
    var noPinnedItems: Bool = false

    mutating func update(rolodexsData data: [Rolodexs]?) {
        if let model = data {
            guard model.count != 0 else { return }
            var _rolodexsMails: [RolodexsTableInfo] = []
            for rolodexs in model {
                let mail = RolodexsTableInfo(rolodexs: rolodexs)
                _rolodexsMails.append(mail)
            }
            rolodexsMails = _rolodexsMails
        }
    }
    
    mutating func update(unreadMailsData data: [Rolodexs]?) {
        if let model = data {
            guard model.count != 0 else { return }
            var _unreadMails: [RolodexsTableInfo] = []
            for rolodexs in model {
                let mail = RolodexsTableInfo(rolodexs: rolodexs)
                _unreadMails.append(mail)
            }
            unreadMails = _unreadMails
        }
    }

    mutating func update(favsData data: [Favorites]?) {
        if let model = data {
            guard model.count != 0 else { return }
            var _favsMails: [FavsTableInfo] = []
            for favorites in model {
                let mail = FavsTableInfo(favorites: favorites)
                _favsMails.append(mail)
            }
            favsMails = _favsMails
        }
    }

}
