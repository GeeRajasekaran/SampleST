//
//  RolodexsDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RolodexsDelegate: NSObject {
    unowned var parentVC: RolodexsViewController
    
    init(parentVC: RolodexsViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITableViewDelegate

extension RolodexsDelegate: UITableViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let tableView = parentVC.rolodexTableView {
            if self.parentVC.segment == .recent {
                if !parentVC.loadingRolodexsItems {
                    if tableView.willScrollToBottom(offset: LabelItemTableViewCell.heightForCell()) {
                        if !parentVC.maxRolodexsItemsReached {
                            parentVC.loadingRolodexsItems = true
                        }
                    }
                }
            } else if self.parentVC.segment == .favorites {
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isSectionIndexValid = parentVC.sections.indices.contains(indexPath.section)
        if isSectionIndexValid {
            let sectionType = parentVC.sections[indexPath.section]
            let isIndexValid = parentVC.screenBuilder.loadRows(withSection: sectionType).indices.contains(indexPath.row)
            if isIndexValid {
                let rowType = parentVC.screenBuilder.loadRows(withSection: sectionType)[indexPath.row] as! RolodexsRowType
                let dataModel = parentVC.screenBuilder.loadModel(for: sectionType, rowType: rowType, forPath: indexPath)
                switch sectionType {
                case .rolodexs:
                    switch rowType {
                    case .rolodexsItem:
                        if let model = dataModel as? RolodexsTableInfo, let rolodexs = model.rolodexs {
                            if rolodexs.last_message_unread == true {
                                return RolodexsTableViewCell.heightForCell()
                            } else {
                                return RolodexsTableViewCell.heightForReadCell()
                            }
                        }
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)

                    default:
                        return 0
                    }

                case .rolodexsLoader:
                    switch rowType {
                    case .loader:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .favs:
                    switch rowType {
                    case .favsItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .favsLoader:
                    switch rowType {
                    case .loader:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .unreads:
                    switch rowType {
                    case .unreadItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        break
                    }
                    
                case .unreadsLoader:
                    switch rowType {
                    case .loader:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }

                case .pins:
                    switch rowType {
                    case .pinnedItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        break
                    }
                    
                case .pinsLoader:
                    switch rowType {
                    case .loader:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                         break
                    }
                    
                }
            }
        }
        
        return 0
    }
    
    func heightForRowType(_ rowType: RolodexsRowType, tableView: UITableView, withModel dataModel: BaseTableModel) -> CGFloat {
        switch rowType {
        case .rolodexsItem:
            return RolodexsTableViewCell.heightForCell()
            
        case .loader:
            return RolodexsTableViewCell.footerHeight()
            
        case .favsItem:
            return FavsTableViewCell.heightForCell()
            
        case .unreadItem:
            return RolodexsTableViewCell.heightForCell()

        case .pinnedItem:
            return RolodexsTableViewCell.heightForCell()

        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0 {
            return UITableViewCellEditingStyle.none
        }
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.parentVC.segment == .recent {
            guard let rolodexId = parentVC.rolodexsItemsInfo?[indexPath.row].rolodexs_id else { return }
            let spoolVC: SpoolIndexViewController = SpoolIndexViewController()
            spoolVC.rolodex = parentVC.rolodexsItemsInfo?[indexPath.row]
            spoolVC.rolodexIds = [rolodexId]
            self.parentVC.navigationController?.pushViewController(spoolVC, animated: true)
        } else if self.parentVC.segment == .unread {
            guard let rolodexId = parentVC.unreadsItemsInfo?[indexPath.row].rolodexs_id else { return }
            let spoolVC: SpoolIndexViewController = SpoolIndexViewController()
            spoolVC.rolodex = parentVC.unreadsItemsInfo?[indexPath.row]
            spoolVC.rolodexIds = [rolodexId]
            self.parentVC.navigationController?.pushViewController(spoolVC, animated: true)
        } else if self.parentVC.segment == .pinned {
            guard let rolodexId = parentVC.pinnedItemsInfo?[indexPath.row].rolodexs_id else { return }
            let spoolVC: SpoolIndexViewController = SpoolIndexViewController()
            spoolVC.rolodex = parentVC.pinnedItemsInfo?[indexPath.row]
            spoolVC.rolodexIds = [rolodexId]
            self.parentVC.navigationController?.pushViewController(spoolVC, animated: true)
        } else if self.parentVC.segment == .favorites {
            
        }
    }
    
    func didTap(threadItem thread:Threads, unread:Bool, seen:Bool, inbox: Bool, isFromSpam: Bool) {
        
    }
    
}

