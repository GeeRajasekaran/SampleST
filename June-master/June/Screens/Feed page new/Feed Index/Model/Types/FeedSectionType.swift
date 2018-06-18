//
//  FeedSectionType.swift
//  June
//
//  Created by Ostap Holub on 1/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum FeedSectionType: Int {
    case brief = 0
    case mostRecent
    case earlier
    case bookmarks
    
    static func sections(isBookmarksActive: Bool) -> [FeedSectionType] {
        if isBookmarksActive {
            return [.bookmarks]
        } else {
            return [.brief, .mostRecent, .earlier]
        }
    }
}
