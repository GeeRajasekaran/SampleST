//
//  RolodexsScreenBuilder.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RolodexsScreenBuilder: ScreenTableModelBuilder {
    
    var viewHelper: RolodexsViewHelper = RolodexsViewHelper()
    
    override init(model: Any?) {
        
    }
    
    override func updateModel(model: Any?, type: Any) {
        if let modelType = type as? RolodexsScreenType {
            switch modelType {
            case .recent:
                if let data = model as? [Rolodexs] {
                    viewHelper.update(rolodexsData: data)
                }
            case .favorites:
                if let data = model as? [Favorites] {
                    viewHelper.update(favsData: data)
                }
            case .unread:
                if let data = model as? [Rolodexs] {
                    viewHelper.update(unreadMailsData: data)
                }
            case .pinned:
                break
            }
        }
        
        if let data = model as? [Rolodexs] {
            viewHelper.update(rolodexsData: data)
        }
    }
    
    override func loadSegment() -> Any {
        return viewHelper.screenType
    }

    override func switchSegment(_ segment: Any) {
        let s = segment as! RolodexsScreenType
        viewHelper.screenType = s
    }
    
    override func loadSections() -> [Any] {
        return RolodexsSectionType.sections(screenType: viewHelper.screenType, maxRolodexsItemsReached: viewHelper.maxRolodexsItemsReached, noRolodexsItems: viewHelper.noRolodexsItems, maxFavsItemsReached: viewHelper.maxFavsItemsReached, noFavsItems: viewHelper.noFavsItems, maxUnreadItemsReached: viewHelper.maxUnreadItemsReached, noUnreadItems: viewHelper.noUnreadItems, maxPinnedItemsReached: viewHelper.maxFavsItemsReached, noPinnedItems: viewHelper.noPinnedItems)
    }
    
    override func loadRows(withSection section: Any) -> [Any] {
        let s = section as! RolodexsSectionType
        return RolodexsRowType.rows(section: s, rolodexsItems: viewHelper.rolodexsMails, favsItems: viewHelper.favsMails)
    }
    
    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        if let section = sectionType as? RolodexsSectionType, let row = rowType as? RolodexsRowType {
            switch section {
            case .rolodexs:
                switch row {
                case .rolodexsItem:
                    let _index = indexPath.row
                    if _index >= 0 {
                        let isIndexValid = viewHelper.rolodexsMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.rolodexsMails[_index]
                        }
                    }
                    
                default:
                    break
                }
            case .rolodexsLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
                
            case .favs:
                switch row {
                case .favsItem:
                    let _index = indexPath.row
                    if _index >= 0 {
                        let isIndexValid = viewHelper.favsMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.favsMails[_index]
                        }
                    }
                    
                default:
                    break
                }
                
            case .favsLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
                
            case .unreads:
                switch row {
                case .unreadItem:
                    let _index = indexPath.row
                    if _index >= 0 {
                        let isIndexValid = viewHelper.unreadMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.unreadMails[_index]
                        }
                    }
                    
                default:
                    break
                }
                
            case .unreadsLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
                
            case .pins:
                switch row {
                case .pinnedItem:
                    let _index = indexPath.row
                    if _index >= 0 {
                        let isIndexValid = viewHelper.pinnedMails.indices.contains(_index)
                        if isIndexValid {
                            return viewHelper.pinnedMails[_index]
                        }
                    }
                    
                default:
                    break
                }
                
            case .pinsLoader:
                switch row {
                case .loader:
                    return TableLabelInfo(value: viewHelper.loader)
                    
                default:
                    break
                }
            }
        }
        return BaseTableModel()
    }
    
}
