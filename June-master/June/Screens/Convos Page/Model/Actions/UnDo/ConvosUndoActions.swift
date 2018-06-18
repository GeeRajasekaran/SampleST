//
//  UndoActions.swift
//  June
//
//  Created by Joshua Cleetus on 2/13/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ConvosUndoActions:NSObject {
    
    unowned var parentVC: ConvosViewController
    init(parentVC: ConvosViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
    func showUndoClearButton(thread: Threads, indexPath: IndexPath, emailType: String) {
        guard let threadId = thread.id else {
            return
        }
        guard let threadAccountId = thread.account_id else {
            return
        }
        self.removeAllUndoButton()
        
        let undoClearButton = UIButton()
        if UIScreen.isPhoneX {
            undoClearButton.frame = CGRect.init(x: 68, y: 560, width: 245, height: 50)
        } else if UIScreen.is6Or6S() {
            undoClearButton.frame = CGRect.init(x: 68, y: 475, width: 245, height: 50)
        } else if UIScreen.is6PlusOr6SPlus() {
            undoClearButton.frame = CGRect.init(x: 68, y: 540, width: 245, height: 50)
        }
        undoClearButton.setImage(#imageLiteral(resourceName: "undo-clear-bg"), for: .normal)
        undoClearButton.contentMode = UIViewContentMode.scaleAspectFill
        undoClearButton.addTarget(self.parentVC, action: #selector(ConvosViewController.undoClearButtonPressed(sender:)), for: .touchUpInside)
        undoClearButton.accessibilityHint = emailType
        undoClearButton.accessibilityIdentifier = threadId
        self.parentVC.view.addSubview(undoClearButton)
        
        self.parentVC.undoClearThreadObjects[threadId] = thread
        self.parentVC.undoClearIndexPaths[threadId] = indexPath
        DispatchQueue.global().async {
            self.markThreadAsCleared(threadId: threadId, threadAccountId: threadAccountId, thread:  thread)
        }
        let requestWorkItem = DispatchWorkItem {
            undoClearButton.removeFromSuperview()
        }
        self.parentVC.pendingRequestWorkItems[threadId] = requestWorkItem
        // Save the new work item and execute it after 3.5 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5,
                                      execute: requestWorkItem)
    }
    
    func markThreadAsCleared(threadId: String, threadAccountId: String, thread: Threads) {
        let backendService = ConvosAPIBridge()
        backendService.markThreadAsCleared(threadId: threadId, accountId: threadAccountId, thread: thread) { (result) in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func markThreadAsNew(threadId: String, threadAccountId: String, thread: Threads) {
        let backendService = ConvosAPIBridge()
        backendService.markThreadAsNew(threadId: threadId, accountId: threadAccountId, thread: thread) { (result) in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func markThreadAsSeen(threadId: String, threadAccountId: String, thread: Threads) {
        let backendService = ConvosAPIBridge()
        backendService.markThreadAsSeen(threadId: threadId, accountId: threadAccountId, thread: thread) { (result) in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
    }

    
    @objc func undoClearButtonPressed(sender: UIButton) {
        guard let threadId = sender.accessibilityIdentifier else {
            return
        }
        guard let threadObject = self.parentVC.undoClearThreadObjects[threadId] else {
            return
        }
        guard let indexPath = self.parentVC.undoClearIndexPaths[threadId] else {
            return
        }
        guard let emailType = sender.accessibilityHint else {
            return
        }
        guard let threadAccountId = threadObject.account_id else {
            return
        }
        for subview in self.parentVC.view.subviews {
            if subview.isKind(of: UIButton.self) {
                let btn = subview as! UIButton
                if let btn_id = btn.accessibilityIdentifier {
                    if btn_id.isEqualToString(find:threadId) {
                        btn.removeFromSuperview()
                    }
                }
            }
        }
        
        if self.parentVC.pendingRequestWorkItems[threadId] != nil {
            self.parentVC.pendingRequestWorkItems[threadId]?.cancel()
            self.parentVC.pendingRequestWorkItems.removeValue(forKey: threadId)
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        if emailType.isEqualToString(find: "new") {
            DispatchQueue.global().async {
                self.markThreadAsNew(threadId: threadId, threadAccountId: threadAccountId, thread: threadObject)
            }
            convosService.update(currentThread: threadObject, unread: true, seen: false, inbox: true)
            self.parentVC.newItemsThreadInfo?.insert(threadObject, at: indexPath.row)
            self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
            self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
            let nextIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
            if let tableview = self.parentVC.tableView {
                if self.parentVC.newItemsThreadInfo?.count == (indexPath.row + 1) {
                    tableview.insertRows(at: [nextIndexPath], with: .automatic)
                    tableview.reloadData()
                } else if self.parentVC.newItemsThreadInfo?.count == 1 {
                    tableview.insertRows(at: [nextIndexPath], with: .bottom)
                    tableview.reloadData()
                } else {
                    tableview.insertRows(at: [nextIndexPath], with: .bottom)
                }
            }
        } else if emailType.isEqualToString(find: "newPreview") {
            DispatchQueue.global().async {
                self.markThreadAsNew(threadId: threadId, threadAccountId: threadAccountId, thread: threadObject)
            }
            convosService.update(currentThread: threadObject, unread: true, seen: false, inbox: true)
            self.parentVC.newItemsThreadInfo?.insert(threadObject, at: indexPath.row)
            self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
            if self.parentVC.newItemsThreadInfo?.count == 1 {
                self.parentVC.tableView?.reloadData()
            }
        } else if emailType.isEqualToString(find: "seen") {
            DispatchQueue.global().async {
                self.markThreadAsSeen(threadId: threadId, threadAccountId: threadAccountId, thread: threadObject)
            }
            convosService.update(currentThread: threadObject, unread: true, seen: true, inbox: true)
            self.parentVC.seenItemsThreadInfo?.insert(threadObject, at: indexPath.row)
            print(threadObject as Any)
            self.parentVC.screenBuilder.updateModel(model: self.parentVC.seenItemsThreadInfo, type: ConvosType.seen)
            self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
            let nextIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
            if let tableview = self.parentVC.tableView, let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count {
                if seenItemsCount == (indexPath.row + 1) {
                    tableview.insertRows(at: [nextIndexPath], with: .bottom)
                    self.parentVC.tableView?.scrollToRow(at: nextIndexPath, at: .bottom, animated: true)
                    if seenItemsCount == 1 {
                        self.parentVC.tableView?.reloadData()
                    }
                } else if seenItemsCount > 1 && indexPath.row == seenItemsCount - 2 {
                    tableview.insertRows(at: [nextIndexPath], with: .bottom)
                    self.parentVC.tableView?.scrollToRow(at: nextIndexPath, at: .top, animated: true)
                } else {
                    tableview.insertRows(at: [nextIndexPath], with: .bottom)
                }
            }
        }

    }
    

    func showUndoToDoButton(thread: Threads, indexPath: IndexPath, emailType: String) {
        guard let threadId = thread.id else {
            return
        }
        guard let threadAccountId = thread.account_id else {
            return
        }
        self.removeAllUndoButton()
        
        let undoToDoButton = UIButton()
        if UIScreen.isPhoneX {
            undoToDoButton.frame = CGRect.init(x: 78, y: 560, width: 217, height: 50)
        } else if UIScreen.is6Or6S() {
            undoToDoButton.frame = CGRect.init(x: 78, y: 475, width: 217, height: 50)
        } else if UIScreen.is6PlusOr6SPlus() {
            undoToDoButton.frame = CGRect.init(x: 100, y: 540, width: 217, height: 50)
        }
        undoToDoButton.setImage(#imageLiteral(resourceName: "undo-to-do"), for: .normal)
        undoToDoButton.contentMode = UIViewContentMode.scaleAspectFill
        undoToDoButton.addTarget(self, action: #selector(ConvosViewController.undoToDoButtonPressed), for: .touchUpInside)
        undoToDoButton.accessibilityHint = emailType
        undoToDoButton.accessibilityIdentifier = threadId
        self.parentVC.view.addSubview(undoToDoButton)
        self.parentVC.undoToDoThreadObjects[threadId] = thread
        self.parentVC.undoToDoIndexPaths[threadId] = indexPath
        self.markThreadAsSeen(threadId: threadId, threadAccountId: threadAccountId, thread: thread)
        let requestWorkItem = DispatchWorkItem {
            undoToDoButton.removeFromSuperview()
        }
        self.parentVC.pendingRequestWorkItems[threadId] = requestWorkItem
        // Save the new work item and execute it after 3.5 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5,
                                      execute: requestWorkItem)
    }
    
    @objc func undoToDoButtonPressed(sender: UIButton) {
        guard let threadId = sender.accessibilityIdentifier else {
            return
        }
        guard let threadObject = self.parentVC.undoToDoThreadObjects[threadId] else {
            return
        }
        guard let indexPath = self.parentVC.undoToDoIndexPaths[threadId] else {
            return
        }
        guard let threadAccountId = threadObject.account_id else {
            return
        }
        for subview in self.parentVC.view.subviews {
            if subview.isKind(of: UIButton.self) {
                let btn = subview as! UIButton
                if let btn_id = btn.accessibilityIdentifier {
                    if btn_id.isEqualToString(find:threadId) {
                        btn.removeFromSuperview()
                    }
                }
            }
        }
        if self.parentVC.pendingRequestWorkItems[threadId] != nil {
            self.parentVC.pendingRequestWorkItems[threadId]?.cancel()
            self.parentVC.pendingRequestWorkItems.removeValue(forKey: threadId)
        }
        self.markThreadAsCleared(threadId: threadId, threadAccountId: threadAccountId, thread: threadObject)
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)
        self.parentVC.clearedItemsThreadInfo?.insert(threadObject, at: indexPath.row)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.clearedItemsThreadInfo, type: ConvosType.cleared)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        if let tableview = self.parentVC.tableView, let clearedItemsCount = self.parentVC.clearedItemsThreadInfo?.count {
            if clearedItemsCount == (indexPath.row + 1) {
                tableview.insertRows(at: [indexPath], with: .bottom)
                self.parentVC.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } else if clearedItemsCount >= 1 && indexPath.row == clearedItemsCount - 2 {
                tableview.insertRows(at: [indexPath], with: .bottom)
                self.parentVC.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
            } else {
                tableview.insertRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
    func removeThreadFromNewPreviewToSeen(sender: ConvosNewPreviewTableViewCell, thread: Threads, indexPath: IndexPath) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        let threadObject = thread
        var rowIndex:Int = indexPath.row
        if let index = self.parentVC.newItemsThreadInfo?.index(where: {(item) -> Bool in
            item === threadObject
        }) {
            rowIndex = Int(index)
        }
        let convosService = ConvosService(parentVC: self.parentVC)
        convosService.update(currentThread: threadObject, unread: true, seen: true, inbox: true)
        self.parentVC.newItemsThreadInfo?.remove(object: threadObject)
        self.parentVC.screenBuilder.updateModel(model: self.parentVC.newItemsThreadInfo, type: ConvosType.new)
        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
        let newIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
        let nextIndexPath = IndexPath(row: rowIndex+1, section: indexPath.section)
        if let tableview = self.parentVC.tableView, let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
            if newIndexPath.row == 0 {
                if newItemsCount == 0 {
                    tableview.deleteRows(at: [newIndexPath], with: .fade)
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
        self.showViewSeenMessageButton(thread: thread, indexPath: indexPath, emailType: "new")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadSeenConvosData()
            if let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
                self.parentVC.fetchMoreNewConvos(_withSkip: newItemsCount)
            }
        }
    }
    
    func removeThreadFromNewToSeen(sender: ConvosNewTableViewCell, thread: Threads, indexPath: IndexPath) {
        self.parentVC.convosRealTime.switchOffThreadsRealtimeListener()
        let threadObject = thread
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
                if newItemsCount == 0 {
                    tableview.deleteRows(at: [newIndexPath], with: .fade)
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
        self.showViewSeenMessageButton(thread: thread, indexPath: indexPath, emailType: "new")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentVC.loadSeenConvosData()
            if let newItemsCount = self.parentVC.newItemsThreadInfo?.count {
                self.parentVC.fetchMoreNewConvos(_withSkip: newItemsCount)
            }
        }
    }
    
    func showViewSeenMessageButton(thread: Threads, indexPath: IndexPath, emailType: String) {
        guard let accountId = thread.account_id else {
            return
        }
        guard let threadId = thread.id else {
            return
        }
        self.removeAllUndoButton()
        
        let viewSeenButton = UIButton()
        if UIScreen.isPhoneX {
            viewSeenButton.frame = CGRect.init(x: 64, y: 560, width: 250, height: 50)
        } else if UIScreen.is6Or6S() {
            viewSeenButton.frame = CGRect.init(x: 64, y: 475, width: 250, height: 50)
        } else if UIScreen.is6PlusOr6SPlus() {
            viewSeenButton.frame = CGRect.init(x: 64, y: 540, width: 250, height: 50)
        }
        viewSeenButton.setImage(#imageLiteral(resourceName: "view-seen-bg"), for: .normal)
        viewSeenButton.contentMode = UIViewContentMode.scaleAspectFill
        viewSeenButton.addTarget(self, action: #selector(ConvosViewController.viewSeenMessageButtonPressed), for: .touchUpInside)
        viewSeenButton.accessibilityIdentifier = threadId
        viewSeenButton.accessibilityHint = "seen"
        self.parentVC.view.addSubview(viewSeenButton)
        
        self.parentVC.undoViewThreadObjects[threadId] = thread
        self.parentVC.undoViewIndexPaths[threadId] = indexPath
        
        let requestWorkItem = DispatchWorkItem {
            viewSeenButton.removeFromSuperview()
            let backendService = ConvosAPIBridge()
            backendService.markThreadAsSeen(threadId: threadId, accountId: accountId, thread: thread) { (result) in
                switch result {
                case .Success(let data):
                    print(data)
                case .Error(let message):
                    print(message)
                }
            }
        }
        self.parentVC.pendingRequestWorkItems[threadId] = requestWorkItem
        // Save the new work item and execute it after 3.5 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5,
                                      execute: requestWorkItem)
    }
    
    @objc func viewSeenMessageButtonPressed(sender: UIButton) {
        self.removeAllUndoButton()
        guard let threadId = sender.accessibilityIdentifier else {
            return
        }
        guard let threadObject = self.parentVC.undoViewThreadObjects[threadId] else {
            return
        }
        let detailVC:ThreadsDetailViewController = ThreadsDetailViewController()
        detailVC.threadId = threadId
        detailVC.threadAccountId = threadObject.account_id
        detailVC.threadToRead = threadObject
        detailVC.unread = threadObject.unread
        detailVC.starred = threadObject.starred
        let subject = threadObject.subject
        if  let title:String = subject, !title.isEmpty {
            detailVC.subjectTitle = title
        }
        detailVC.controllerDelegate = self.parentVC.delegate
        self.parentVC.isFromThreadsDetailVC = true
        self.parentVC.isFromSeen = true
        self.parentVC.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func removeAllUndoButton() {
        for subview in self.parentVC.view.subviews {
            if subview.isKind(of: UIButton.self) {
                let btn = subview as! UIButton
                if let btn_type = btn.accessibilityHint {
                    if btn_type.isEqualToString(find:"new") || btn_type.isEqualToString(find: "newPreview") || btn_type.isEqualToString(find: "seen") || btn_type.isEqualToString(find: "cleared") {
                        btn.removeFromSuperview()
                    }
                }
            }
        }
    }
    
}
