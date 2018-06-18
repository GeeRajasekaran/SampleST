//
//  ConvosScreenBuilder.swift
//  June
//
//  Created by Joshua Cleetus on 12/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ConvosScreenBuilder: ScreenTableModelBuilder {
    
    var viewHelper: ConvosViewHelper = ConvosViewHelper()
    var contactsHelper: ConvosContactsHelper = ConvosContactsHelper()
    
    override init(model: Any?) {
        
    }
    
    override func updateModel(model: Any?, type: Any) {
        if let modelType = type as? ConvosType, let data = model as? [Threads] {
            switch modelType {
            case .seen:
                viewHelper.update(seenData: data)
                
            case .new:
                viewHelper.update(newData: data)
                
            case .cleared:
                viewHelper.update(clearedData: data)
                
            case .spam:
                viewHelper.update(spamData: data)
            }
        }
    }
    
    override func loadSegment() -> Any {
        return viewHelper.screenType
    }
    
    override func switchSegment(_ segment: Any) {
        let s = segment as! ConvosScreenType
        viewHelper.screenType = s
    }
    
    override func loadSections() -> [Any] {
        return ConvosSectionType.sections(screenType: viewHelper.screenType, newCollapsed: viewHelper.newCollapsed, maxSeenItemsReached: viewHelper.maxSeenItemsReached, maxClearedItemsReached: viewHelper.maxClearedItemsReached, maxSpamItemsReached: viewHelper.maxSpamItemsReached, noNewItems: viewHelper.noNewItems, noSeenItems: viewHelper.noSeenItems)
    }
    
    override func loadRows(withSection section: Any) -> [Any] {
        let s = section as! ConvosSectionType
        return ConvosRowType.rows(section: s, newPreviewItems: viewHelper.newPreviewMails, newItems: viewHelper.newMails, seenItems: viewHelper.seenMails, clearedItems: viewHelper.clearedMails, collapsed: viewHelper.newCollapsed, spamItems: viewHelper.seenMails, contactsHelper: contactsHelper)
    }
    
    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        if let section = sectionType as? ConvosSectionType, let row = rowType as? ConvosRowType {
            switch section {
            case .newPreview:
                switch row {
                case .newHeader:
                    return TableLabelInfo(value: viewHelper.newHeader)
                    
                case .pendingContacts:
                    let title = LocalizedStringKey.RequestNotificationViewHelper.newPeopleTitle
                    return PendingRequestItemInfo(title: title, count: contactsHelper.pendingContactsCount)
                case .newPreviewItem:
                    let _index = indexPath.row - 1
                    if _index >= 0 {
                        let isIndexValid = viewHelper.newMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.newMails[_index]
                        }
                    }
                    
                case .viewAll:
                    return TableLabelInfo(value: viewHelper.viewAll)
                    
                default:
                    break
                }
                
            case .new:
                switch row {
                case .newHeader:
                    return TableLabelInfo(value: viewHelper.newHeader)
                    
                case .pendingContacts:
                    let title = LocalizedStringKey.RequestNotificationViewHelper.newPeopleTitle
                    return PendingRequestItemInfo(title: title, count: contactsHelper.pendingContactsCount)
                    
                case .newItem:
                    let _index = indexPath.row - 1
                    if _index >= 0 {
                        let isIndexValid = viewHelper.newMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.newMails[_index]
                        }
                    }
                    
                case .collapse:
                    return TableLabelInfo(value: viewHelper.collapse)
                    
                default:
                    break
                }
                
            case .seen:
                switch row {
                case .seenHeader:
                    return TableLabelInfo(value: viewHelper.seenHeader)
                    
                case .seenItem:
                    let _index = indexPath.row - 1
                    if _index >= 0 {
                        let isIndexValid = viewHelper.seenMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.seenMails[_index]
                        }
                    }
                    
                default:
                    break
                }
                
            case .seenLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
                
            case .cleared:
                switch row {
                case .clearedItem:
                    let _index = indexPath.row 
                    if _index >= 0 {
                        let isIndexValid = viewHelper.clearedMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.clearedMails[_index]
                        }
                    }
                    
                default:
                    break
                }

            case .clearedLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
            
            case .spam:
                switch row {
                case .spamItem:
                    let _index = indexPath.row
                    if _index >= 0 {
                        let isIndexValid = viewHelper.spamMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.spamMails[_index]
                        }
                    }
                    
                default:
                    break
                }
                
            case .spamLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
                

            case .noNew:
                switch row {
                case .noNewItem:
                    return TableImageInfo(value: viewHelper.noNewItemsTitle, image: viewHelper.noNewItemsImage)
                    
                default:
                    break
                }
                
            case .noNewOrSeen:
                switch row {
                case .noNewOrSeenItem:
                    return TableImageInfo(value: viewHelper.noNewOrSeenItemsTitle, image: viewHelper.noNewOrSeenItemsImage)
                    
                default:
                    break
                }
                
            }
            
        }
        return BaseTableModel()
    }
}

