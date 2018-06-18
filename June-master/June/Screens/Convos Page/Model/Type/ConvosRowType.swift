//
//  ConvosRowType.swift
//  June
//
//  Created by Joshua Cleetus on 12/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

enum ConvosRowType: Int {
    case noNewItem
    case noNewOrSeenItem
    case newHeader
    case newPreviewItem
    case newItem
    case seenHeader
    case seenItem
    case viewAll
    case collapse
    case clearedItem
    case loader
    case spamItem
    case pendingContacts
    
    static func rows(section: ConvosSectionType, newPreviewItems: [Any], newItems: [Any], seenItems: [Any], clearedItems: [Any], collapsed: Bool, spamItems: [Any], contactsHelper: ConvosContactsHelper) -> [ConvosRowType] {
        var rows: [ConvosRowType] = []
        switch section {
        case .newPreview:
            rows = [newHeader]
            if contactsHelper.pendingContactsCount != 0 && !contactsHelper.isPendingContactsNotificationClosed {
                rows.append(.pendingContacts)
            }
            newItems.forEach({ (_) in
                rows.append(newPreviewItem)
            })
            if newItems.count > 3 {
                rows.append(viewAll)
            } else {
                if rows.contains(viewAll) {
                    rows.remove(object: viewAll)
                }
            }
            
        case .new:
            rows = [newHeader]
            if contactsHelper.pendingContactsCount != 0 && !contactsHelper.isPendingContactsNotificationClosed {
                rows.append(.pendingContacts)
            }
            newItems.forEach({ (_) in
                rows.append(newItem)
            })
            if newItems.count > 3 {
                rows.append(collapse)
            }
            
        case .seen:
            rows = [seenHeader]
            seenItems.forEach({ (_) in
                rows.append(seenItem)
            })
            
        case .seenLoader:
            rows = [loader]

        case .cleared:
            clearedItems.forEach({ (_) in
                rows.append(clearedItem)
            })
            
        case .clearedLoader:
            rows = [loader]
            
        case .spam:
            spamItems.forEach({ (_) in
                rows.append(spamItem)
            })
            
        case .spamLoader:
            rows = [loader]

        case .noNew:
            rows = [newHeader]
            rows.append(noNewItem)
            
        case .noNewOrSeen:
            rows = [noNewOrSeenItem, loader]

        }
        
        return rows
    }
}
