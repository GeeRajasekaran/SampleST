//
//  ConvosSectionType.swift
//  June
//
//  Created by Joshua Cleetus on 12/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

enum ConvosSectionType: Int {
    case noNew
    case noNewOrSeen
    case newPreview
    case new
    case seen
    case seenLoader
    case cleared
    case clearedLoader
    case spam
    case spamLoader
    
    static func sections(screenType: ConvosScreenType, newCollapsed: Bool, maxSeenItemsReached: Bool, maxClearedItemsReached: Bool, maxSpamItemsReached: Bool, noNewItems: Bool, noSeenItems: Bool) -> [ConvosSectionType] {
        var sections: [ConvosSectionType] = []
        switch screenType {
        case .combined:
            if noNewItems && noSeenItems {
                sections = [noNewOrSeen, seen]
            } else
            if noNewItems {
                sections = [noNew, seen]
            } else {
                sections = newCollapsed ? [newPreview, seen] :  [new, seen]
            }
            if !maxSeenItemsReached {
                // load more here
            }
            
        case .cleared:
            sections = [cleared]
            if !maxClearedItemsReached {
                sections.append(clearedLoader)
            }
        
        case .spam:
            sections = [spam]
            if !maxSpamItemsReached {
                sections.append(spamLoader)
            }
        }
        
        return sections
    }
}
