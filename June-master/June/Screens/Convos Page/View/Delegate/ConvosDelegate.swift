//
//  ConvosDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 12/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ConvosDelegate: NSObject {
    
    unowned var parentVC: ConvosViewController

    init(parentVC: ConvosViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
}

// MARK:- UITableViewDelegate

extension ConvosDelegate: UITableViewDelegate, UIGestureRecognizerDelegate, ThreadsDetailViewControllerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let tableView = parentVC.tableView {
            switch parentVC.screenType {
            case .cleared:
                if !parentVC.loadingClearedItems {
                    if tableView.willScrollToBottom(offset: LabelItemTableViewCell.heightForCell()) {
                        if !parentVC.maxClearedItemsReached {
                            parentVC.loadingClearedItems = true
                        }
                    }
                }
                
            case .spam:
                if !parentVC.loadingSpamItems {
                    if tableView.willScrollToBottom(offset: LabelItemTableViewCell.heightForCell()) {
                        if !parentVC.maxSpamItemsReached {
                            parentVC.loadingSpamItems = true
                        }
                    }
                }
                
            case .combined:
                if parentVC.sections.contains(ConvosSectionType.new) {
                    let toDoRows = parentVC.screenBuilder.loadRows(withSection: ConvosSectionType.new) as! [ConvosRowType]
                    
                    if let toDoSectionIndex = parentVC.sections.index(of: ConvosSectionType.new) {
                        if let toDoRowIndex = toDoRows.index(of: ConvosRowType.collapse) {
                            if tableView.isCellVisible(section: toDoSectionIndex, row: toDoRowIndex) {
                                if !parentVC.loadingNewItems {
                                    if !parentVC.maxNewItemsReached {
                                        parentVC.loadingNewItems = true
                                    }
                                }
                            }
                        }
                    }
                }
                
                if !parentVC.loadingSeenItems {
                    if tableView.willScrollToBottom(offset: LabelItemTableViewCell.heightForCell()) {
                        if !parentVC.maxSeenItemsReached {
                            parentVC.loadingSeenItems = true
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isSectionIndexValid = parentVC.sections.indices.contains(indexPath.section)
        if isSectionIndexValid {
            let sectionType = parentVC.sections[indexPath.section]
            let isIndexValid = parentVC.screenBuilder.loadRows(withSection: sectionType).indices.contains(indexPath.row)
            if isIndexValid {
                let rowType = parentVC.screenBuilder.loadRows(withSection: sectionType)[indexPath.row] as! ConvosRowType
                let dataModel = parentVC.screenBuilder.loadModel(for: sectionType, rowType: rowType, forPath: indexPath)
                switch sectionType {
                case .newPreview:
                    switch rowType {
                    case .newHeader, .viewAll, .pendingContacts:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    case .newPreviewItem:
                        return heightForNewPreviewItem(indexPath: indexPath)
                        
                    case .newItem:
                        return heightForNewPreviewItem(indexPath: indexPath)
                        
                    default:
                        return 0
                    }
                    
                case .new:
                    switch rowType {
                    case .newHeader, .newItem, .collapse, .pendingContacts:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .seen:
                    switch rowType {
                    case .seenHeader, .seenItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .seenLoader:
                    switch rowType {
                    case .loader:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)

                    default:
                        return 0
                    }
                    
                case .cleared:
                    switch rowType {
                    case .clearedItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .clearedLoader:
                    switch rowType {
                    case .loader:
                        if let clearedItemsCount = self.parentVC.clearedItemsThreadInfo?.count {
                            guard clearedItemsCount > 19 else {
                                return 0
                            }
                        }
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .spam:
                    switch rowType {
                    case .spamItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .spamLoader:
                    switch rowType {
                    case .loader:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .noNew:
                    switch rowType {
                    case .noNewItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                case .noNewOrSeen:
                    switch rowType {
                    case .noNewOrSeenItem:
                        return heightForRowType(rowType, tableView: tableView, withModel: dataModel)
                        
                    default:
                        return 0
                    }
                    
                }
            } else {
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func heightForRowType(_ rowType: ConvosRowType, tableView: UITableView, withModel dataModel: BaseTableModel) -> CGFloat {
        switch rowType {
        case .newHeader:
            if self.parentVC.newItemsThreadInfo?.count == 0 {
                return 0
            }
            return LabelItemTableViewCell.headerHeight()
            
        case .seenHeader:
            if let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count, seenItemsCount == 0 {
                return 0
            }
            return LabelItemTableViewCell.headerHeight()
            
        case .viewAll, .collapse, .loader:
            return ConvosViewAllTableViewCell.footerHeight()
            
        case .noNewItem:
            return ConvosNoNewItemTableViewCell.fixedHeight()
        
        case .noNewOrSeenItem:
            return ConvosNoNewOrSeenTableViewCell.fixedHeight()
            
        case .pendingContacts:
            return PendingRequestTableViewCell.fixedHeight()
            
        default:
            return ConvosTableViewCell.heightForCell()
        }
    }
    
    func heightForNewPreviewItem(indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 3 {
            return ConvosTableViewCell.heightForCell()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0 {
            return UITableViewCellEditingStyle.none
        }
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = parentVC.sections[indexPath.section]
        let isIndexValid = parentVC.screenBuilder.loadRows(withSection: sectionType).indices.contains(indexPath.row)
        if isIndexValid {
            let rowType = parentVC.screenBuilder.loadRows(withSection: sectionType)[indexPath.row] as! ConvosRowType
            let dataModel = parentVC.screenBuilder.loadModel(for: sectionType, rowType: rowType, forPath: indexPath)
            switch sectionType {
            case .newPreview:
                switch rowType {
                case .viewAll:
                    parentVC.newCollapsed = false
                    break
                    
                case .newPreviewItem:
                    if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                        self.parentVC.isFromNew = true
                        self.didTap(threadItem: thread, unread: thread.unread, seen: thread.seen, inbox: thread.inbox, isFromSpam: false)
                    }
                    
                case .newItem:
                    if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                        self.parentVC.isFromNew = true
                        self.didTap(threadItem: thread, unread: thread.unread, seen: thread.seen, inbox: thread.inbox, isFromSpam: false)
                    }
                case .pendingContacts:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "OnOpenRequestsWithPeople"), object: nil)
                    
                default:
                    break
                }
                
            case .new:
                switch rowType {
                case .collapse:
                    parentVC.newCollapsed = true
                    break
                    
                case .newItem:
                    if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                        self.parentVC.isFromNew = true
                        self.didTap(threadItem: thread, unread: thread.unread, seen: thread.seen, inbox: thread.inbox, isFromSpam: false)
                    }
                case .pendingContacts:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "OnOpenRequestsWithPeople"), object: nil)
                    
                default:
                    break
                }
                
            case .seen:
                switch rowType {
                case .seenItem:
                    if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                        self.parentVC.isFromSeen = true
                        self.didTap(threadItem: thread, unread: thread.unread, seen: thread.seen, inbox: thread.inbox, isFromSpam: false)
                    }
                    
                default:
                    break
                }
                
            case .cleared:
                switch rowType {
                case .clearedItem:
                    if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                        self.parentVC.isFromCleared = true
                        self.didTap(threadItem: thread, unread: thread.unread, seen: thread.seen, inbox: thread.inbox, isFromSpam: false)
                    }
                    
                default:
                    break
                }
            
            case .spam:
                switch rowType {
                case .spamItem:
                    if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                        self.parentVC.isFromSpam = true
                        self.didTap(threadItem: thread, unread: thread.unread, seen: thread.seen, inbox: thread.inbox, isFromSpam: true)
                    }
                    
                default:
                    break
                }
                
            default:
                break
            }
        }
    }
    
    func didTap(threadItem thread:Threads, unread:Bool, seen:Bool, inbox: Bool, isFromSpam: Bool) {
        let detailVC:ThreadsDetailViewController = ThreadsDetailViewController()
        detailVC.threadId = thread.id
        detailVC.threadAccountId = thread.account_id
        detailVC.threadToRead = thread
        detailVC.unread = unread
        detailVC.seen = seen
        detailVC.inbox = inbox
        detailVC.isFromSpam = parentVC.isFromSpam
        detailVC.categoryName = parentVC.categoryName
        self.parentVC.selectedIndexPath = self.parentVC.tableView?.indexPathForSelectedRow
        let subject = thread.subject
        if  let title:String = subject, !title.isEmpty {
            detailVC.subjectTitle = title
        }
        detailVC.controllerDelegate = self.parentVC.delegate
        self.parentVC.isFromThreadsDetailVC = true
        self.parentVC.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func actionInDetailViewController(_ controller: ThreadsDetailViewController, unread: Bool, seen: Bool, inbox: Bool, starredValueChanged: Bool, thread: Threads) {
        self.parentVC.unread = unread
        self.parentVC.seen = seen
        self.parentVC.inbox = inbox
        self.parentVC.isStarredValueChanged = starredValueChanged
        self.parentVC.threadFromDetailVC = thread
    }
    
    func actionInDetailViewController(_ controller: ThreadsDetailViewController, starred: Bool, unread: Bool, starredValueChanged: Bool, thread: Threads) {
        self.parentVC.starred = starred
        self.parentVC.unread = unread
        self.parentVC.isStarredValueChanged = starredValueChanged
        self.parentVC.threadFromDetailVC = thread
    }
    
    func controller(_ controller: ThreadsDetailViewController, starred isStarred: Bool) {
        self.parentVC.starred = isStarred
    }
    
    func recategorizeValue(_controller: ThreadsDetailViewController, category: String) {
        self.parentVC.categoryName = category
    }
    
}

