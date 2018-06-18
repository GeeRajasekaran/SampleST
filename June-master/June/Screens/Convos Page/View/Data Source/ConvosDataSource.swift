//
//  ConvosDataSource.swift
//  June
//
//  Created by Joshua Cleetus on 12/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import QuartzCore

class ConvosDataSource: NSObject {
    
    var onCloseNotificationView: (() -> Void)?
    
    let cellHandler = SwipyCellHandler()
    unowned var parentVC: ConvosViewController
    init(parentVC: ConvosViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITableViewDataSource

extension ConvosDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return parentVC.sections.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let validIndex = parentVC.sections.indices.contains(section)
        if validIndex {
            let sectionType = parentVC.sections[section]
            switch sectionType {
            case .cleared:
                if let clearedItemsCount = parentVC.clearedItemsThreadInfo?.count {
                    guard clearedItemsCount > 0 else {
                        return 0
                    }
                    return clearedItemsCount
                }
            case .seen:
                if let seenItemsCount = parentVC.seenItemsThreadInfo?.count {
                    guard seenItemsCount > 0 else {
                        return 1
                    }
                    return seenItemsCount + 1
                }
                
            case .newPreview:
                if let newItemsCount = parentVC.newItemsThreadInfo?.count {
                    return newItemsCount + 2
                }
                
            case .new:
                if let newItemsCount = parentVC.newItemsThreadInfo?.count {
                    return newItemsCount + 2
                }
                
            default:
                return parentVC.screenBuilder.loadRows(withSection: sectionType).count
            }
            return parentVC.screenBuilder.loadRows(withSection: sectionType).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isIndexValid = parentVC.sections.indices.contains(indexPath.section)
        if isIndexValid {
            let sectionType = parentVC.sections[indexPath.section]
            let isRowIndexValid = parentVC.screenBuilder.loadRows(withSection: sectionType).indices.contains(indexPath.row)
            if isRowIndexValid {
                guard let rowType = parentVC.screenBuilder.loadRows(withSection: sectionType)[indexPath.row] as? ConvosRowType else {
                    return UITableViewCell()
                }
                let dataModel = parentVC.screenBuilder.loadModel(for: sectionType, rowType: rowType, forPath: indexPath)
                return cellForRowType(rowType, tableView: tableView, withModel: dataModel, item: indexPath)
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            tableView.deleteRows(at:[indexPath], with: .top)
            tableView.endUpdates()
        case .insert:
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        case .none:
            tableView.beginUpdates()
            tableView.deleteRows(at:[indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func cellForRowType(_ row: ConvosRowType, tableView: UITableView, withModel dataModel: BaseTableModel, item: IndexPath) -> UITableViewCell {
        switch row {
        case .newHeader, .seenHeader:
            let cell: LabelItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: LabelItemTableViewCell.reuseIdentifier()) as! LabelItemTableViewCell
            if let model = dataModel as? TableLabelInfo {
                cell.itemLabel.text = model.value
            }
            cell.backgroundColor = .white
            switch row {
            case .viewAll, .collapse, .loader:
                cell.itemLabel.textAlignment = .center
                cell.itemLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .regular)
                cell.itemLabel.textColor = UIColor.init(hexString:"7F7F7F")
                
            default:
                cell.itemLabel.textAlignment = .left
                cell.itemLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
                cell.itemLabel.textColor = .black
            }
            return cell
            
        case .viewAll:
            let cell: ConvosViewAllTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosViewAllTableViewCell.reuseIdentifier()) as! ConvosViewAllTableViewCell
            if let model = dataModel as? TableLabelInfo {
                self.getTotalNewMessagesCount(onCell: cell, dataModel: model)
            }
            cell.backgroundColor = .white
            cell.itemLabel.textAlignment = .center
            return cell
            
        case .collapse:
            let cell: ConvosViewAllTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosViewAllTableViewCell.reuseIdentifier()) as! ConvosViewAllTableViewCell
            if let model = dataModel as? TableLabelInfo {
                // create an NSMutableAttributedString that we'll append everything to
                let fullString = NSMutableAttributedString(string: model.value + "  ")
                
                // create our NSTextAttachment
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = #imageLiteral(resourceName: "up-carat")
                imageAttachment.bounds = CGRect.init(x: 0, y: 2, width: 11, height: 6)
                
                // wrap the attachment in its own attributed string so we can append it
                let image1String = NSAttributedString(attachment: imageAttachment)
                
                // add the NSTextAttachment wrapper to our full string, then add some more text.
                fullString.append(image1String)
                
                // draw the result in a label
                cell.itemLabel.attributedText = fullString
            }
            cell.backgroundColor = .clear
            cell.itemLabel.textAlignment = .center
            return cell
        
        case .loader:
            let cell: ConvosViewAllTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosViewAllTableViewCell.reuseIdentifier()) as! ConvosViewAllTableViewCell
            if let model = dataModel as? TableLabelInfo {
                cell.itemLabel.text = model.value
            }
            cell.backgroundColor = .clear
            cell.itemLabel.textAlignment = .center
            return cell
            
        case .newPreviewItem:
            let cell: ConvosNewPreviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosNewPreviewTableViewCell.reuseIdentifier()) as! ConvosNewPreviewTableViewCell
            if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                cell.configure(thread: thread)
            }
            cell.selectionStyle = .none
            cell.mDelegate = self
            cell.indexPath = item
            cell.selectionStyle = .default
            cell.clipsToBounds = true
            return cell
            
        case .newItem:
            let cell: ConvosNewTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosNewTableViewCell.reuseIdentifier()) as! ConvosNewTableViewCell
            if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                cell.configure(thread: thread)
            }
            cell.backgroundColor = .white
            cell.mDelegate = self
            cell.indexPath = item
            cell.selectionStyle = .default
            cell.clipsToBounds = true
            return cell
            
        case .seenItem:
            let cell: ConvosTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosTableViewCell.reuseIdentifier()) as! ConvosTableViewCell
            if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                cell.configure(thread: thread)
            }
            cell.mDelegate = self
            cell.indexPath = item
            cell.selectionStyle = .default
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.init(hexString: "F5F9FD")
            cell.selectedBackgroundView = bgColorView
            return cell
            
        case .clearedItem:
            let cell: ConvosClearedTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosClearedTableViewCell.reuseIdentifier()) as! ConvosClearedTableViewCell
            if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                cell.configure(thread: thread)
            }
            cell.mDelegate = self
            cell.indexPath = item
            cell.selectionStyle = .default
            return cell
            
        case .spamItem:
            let cell: ConvosSpamTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosSpamTableViewCell.reuseIdentifier()) as! ConvosSpamTableViewCell
            if let model = dataModel as? ConvosTableInfo, let thread = model.thread {
                cell.configure(thread: thread)
            }
            cell.mDelegate = self
            return cell
                        
        case .noNewItem:
            let cell: ConvosNoNewItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosNoNewItemTableViewCell.reuseIdentifier()) as! ConvosNoNewItemTableViewCell
            if let model = dataModel as? TableImageInfo {
                cell.itemLabel.text = model.value
                cell.picView.image = model.image
            }
            cell.backgroundColor = .clear
            cell.itemLabel.textAlignment = .left
            return cell
            
        case .noNewOrSeenItem:
            let cell: ConvosNoNewOrSeenTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosNoNewOrSeenTableViewCell.reuseIdentifier()) as! ConvosNoNewOrSeenTableViewCell
            if let model = dataModel as? TableImageInfo {
                cell.itemLabel.text = model.value
                cell.picView.image = model.image
            }
            cell.backgroundColor = .clear
            cell.itemLabel.textAlignment = .center
            return cell
            
        case .pendingContacts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PendingRequestTableViewCell.reuseIdentifier()) as! PendingRequestTableViewCell
            cell.onClose = onCloseNotificationView
            cell.setupSubviews()
            if let model = dataModel as? PendingRequestItemInfo {
                cell.loadModel(model)
            }
            return cell
        }
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
    
    func getTotalNewMessagesCount(onCell: ConvosViewAllTableViewCell, dataModel: BaseTableModel) {
        let service = ConvosAPIBridge()
        var totalCount = 0
        service.getNewConvosDataWith(_withLimit: 20, skipValue: 0) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(_):
                    strongSelf.parentVC.maxNewItemsCount = service.totalNewMessagesCount
                    totalCount = service.totalNewMessagesCount
                    if let model = dataModel as? TableLabelInfo {
                        // create an NSMutableAttributedString that we'll append everything to
                        let fullString = NSMutableAttributedString(string: model.value + " (" + String(totalCount) + ")  ")
                        
                        // create our NSTextAttachment
                        let imageAttachment = NSTextAttachment()
                        imageAttachment.image = #imageLiteral(resourceName: "down-carat")
                        imageAttachment.bounds = CGRect.init(x: 0, y: 2, width: 11, height: 6)

                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: imageAttachment)
                        
                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        
                        // draw the result in a label
                        onCell.itemLabel.attributedText = fullString
                    }
                case .Error(let message):
                    print(message)
                    totalCount = 0
                    if let model = dataModel as? TableLabelInfo {
                        // create an NSMutableAttributedString that we'll append everything to
                        let fullString = NSMutableAttributedString(string: model.value + "  ")
                        
                        // create our NSTextAttachment
                        let imageAttachment = NSTextAttachment()
                        imageAttachment.image = #imageLiteral(resourceName: "down-carat")
                        imageAttachment.bounds = CGRect.init(x: 0, y: 2, width: 11, height: 6)

                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: imageAttachment)
                        
                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        
                        // draw the result in a label
                        onCell.itemLabel.attributedText = fullString
                    }
                }
            }
        }
    }
    
}

extension ConvosDataSource: ConvosNewPreviewCellDelegate, ConvosNewViewCellDelegate, ConvosViewCellDelegate, ConvosClearedViewCellDelegate, ConvosSpamViewCellDelegate {
    func convosNewPreview(didTapItem sender: ConvosNewPreviewTableViewCell, thread: Threads?, indexPath: IndexPath) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard self.parentVC.isLoading == false else {
            return
        }
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.newItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.newItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newIndexPath.row == 0 {
                if self.parentVC.newItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .none, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                }
            } else if newIndexPath.row == newItemsCount {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            } else {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            }
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoClearButton(thread: threadObject, indexPath: newIndexPath, emailType: "new")
        if let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreNewConvos(_withSkip: newItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func convosNewPreview(didSwipeItem sender: ConvosNewPreviewTableViewCell, thread: Threads?, indexPath: IndexPath, xValue: CGFloat) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard self.parentVC.isLoading == false else {
            return
        }
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.newItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.newItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            self.parentVC.tableView?.backgroundColor = UIColor.juneGreen
            tableview.superview?.sendSubview(toBack: sender)
            if newIndexPath.row == 0 {
                if self.parentVC.newItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .none, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                }
            } else if newIndexPath.row == newItemsCount {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            } else {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            }
            self.parentVC.tableView?.backgroundColor = UIColor.white
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoClearButton(thread: threadObject, indexPath: newIndexPath, emailType: "new")
        if let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreNewConvos(_withSkip: newItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func convosNewView(didTapItem sender: ConvosNewTableViewCell, thread: Threads?, indexPath: IndexPath) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard self.parentVC.isLoading == false else {
            return
        }
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.newItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.newItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newIndexPath.row == 0 {
                if self.parentVC.newItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .none, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                }
            } else if newIndexPath.row == newItemsCount {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            } else {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            }
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoClearButton(thread: threadObject, indexPath: newIndexPath, emailType: "new")
        if let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreNewConvos(_withSkip: newItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func convosNewView(didSwipeItem sender: ConvosNewTableViewCell, thread: Threads?, indexPath: IndexPath, xValue: CGFloat) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.newItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.newItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            self.parentVC.tableView?.backgroundColor = UIColor.juneGreen
            tableview.superview?.sendSubview(toBack: sender)
            if newIndexPath.row == 0 {
                if self.parentVC.newItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .none, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                }
            } else if newIndexPath.row == newItemsCount {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            } else {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            }
            self.parentVC.tableView?.backgroundColor = UIColor.white
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoClearButton(thread: threadObject, indexPath: newIndexPath, emailType: "new")
        if let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreNewConvos(_withSkip: newItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadClearedConvosDataWithoutTableReload()
        }
    }

    func convosView(didTapItem sender: ConvosTableViewCell, thread: Threads?, indexPath: IndexPath) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard self.parentVC.isLoading == false else {
            return
        }
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: threadObject.inbox)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.seenItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.seenItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.seenItemsThreadInfo, type: ConvosType.seen)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count {
            if newIndexPath.row == 0 {
                if self.parentVC.seenItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .delete, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                }
            } else if newIndexPath.row == seenItemsCount {
                tableview.deleteRows(at: [nextIndexPath], with: .top)
                sender.mailView.clearButton.setImage( #imageLiteral(resourceName: "clear-circle"), for: .normal)
                tableview.scrollToRow(at: newIndexPath, at: .bottom, animated: false)
            } else {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            }
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoClearButton(thread: threadObject, indexPath: newIndexPath, emailType: "seen")
        if let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count {
            if seenItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreSeenConvos(_withSkip: seenItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func convosView(didSwipeItem sender: ConvosTableViewCell, thread: Threads?, indexPath: IndexPath, xValue: CGFloat) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard self.parentVC.isLoading == false else {
            return
        }
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.seenItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.seenItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.seenItemsThreadInfo, type: ConvosType.seen)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count {
            self.parentVC.tableView?.backgroundColor = UIColor.juneGreen
            if newIndexPath.row == 0 {
                if self.parentVC.seenItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .none, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                }
            } else if newIndexPath.row == seenItemsCount {
                if seenItemsCount == 1 {
                    tableview.deleteRows(at: [nextIndexPath], with: .none)
                } else {
                    tableview.deleteRows(at: [newIndexPath], with: .none)
                    sender.isHidden = true
                    tableview.scrollToRow(at: newIndexPath, at: .bottom, animated: false)
                }
            } else {
                tableview.deleteRows(at: [nextIndexPath], with: .none)
            }
            self.parentVC.tableView?.backgroundColor = UIColor.white
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoClearButton(thread: threadObject, indexPath: newIndexPath, emailType: "seen")
        if let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count {
            if seenItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreSeenConvos(_withSkip: seenItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func convosClearedView(didTapItem sender: ConvosClearedTableViewCell, thread: Threads?, indexPath: IndexPath) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        guard self.parentVC.isLoading == false else {
            return
        }
        guard let threadObject = thread else {
            return
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: true, seen: true, inbox: true)
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.clearedItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        self.parentVC.clearedItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.clearedItemsThreadInfo, type: ConvosType.cleared)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let seenItemsCount = self.parentVC.clearedItemsThreadInfo?.count {
            if newIndexPath.row == 0 {
                if self.parentVC.clearedItemsThreadInfo?.count == 0 {
                    self.tableView(tableview, commit: .none, forRowAt: newIndexPath)
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                    tableview.reloadData()
                } else {
                    tableview.deleteRows(at: [newIndexPath], with: .none)
                }
            } else if newIndexPath.row == seenItemsCount {
                tableview.deleteRows(at: [newIndexPath], with: .none)
            } else {
                tableview.deleteRows(at: [newIndexPath], with: .top)
            }
        }
        let convosUndoActions = ConvosUndoActions(parentVC: self.parentVC)
        convosUndoActions.showUndoToDoButton(thread: threadObject, indexPath: indexPath, emailType: "cleared")
        if let clearedItemsCount = self.parentVC.clearedItemsThreadInfo?.count {
            if clearedItemsCount == 19 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
                    self.parentVC.isLoading = true
                    self.parentVC.fetchMoreClearedConvos(_withSkip: clearedItemsCount)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadSeenConvosDataWithoutTableReload()
        }
    }
    
    func convosSpamView(didTapItem sender: ConvosSpamTableViewCell, thread: Threads?) {
        guard let threadObject = thread else {
            return
        }
        guard let threadId = thread?.id else {
            return
        }
        guard let accountId = thread?.account_id else {
            return
        }
        
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, withNewStarredValue: false, withNewUnreadValue: false)
        let convosLoading = ConvosLoading(parentVC: self.parentVC)
        self.parentVC.loadSpamConvosData()
        convosLoading.loadSeenConvosData()
        self.parentVC.tableView?.reloadData()
        
        let backendService = ConvosAPIBridge()
        backendService.markThreadAsSeen(threadId: threadId, accountId: accountId, thread: threadObject) { (result) in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
        
    }

}
