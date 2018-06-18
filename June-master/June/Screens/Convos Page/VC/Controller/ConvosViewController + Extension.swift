//
//  ConvosController + Extension.swift
//  June
//
//  Created by Joshua Cleetus on 1/7/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

extension ConvosViewController {
    
    func setUpNavigationMenuButton() {
        self.menuButton.sizeToFit()
        self.menuButton.frame = CGRect.init(x: self.view.frame.size.width/4, y: 0, width: self.view.frame.size.width/2, height: 40)
                
        var attr = NSMutableAttributedString()
        if screenType.rawValue == 0 {
            attr = NSMutableAttributedString(string: Localized.string(forKey: LocalizedString.ConvosToDoTitle) + " ")
        } else if screenType.rawValue == 1 {
            attr = NSMutableAttributedString(string: Localized.string(forKey: LocalizedString.ConvosClearedTitle) + " ")
        }
        
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.ConvosViewHelper.titleFont, size: UIView.midInterMargin)! ]
        let myRange = NSRange(location: 0, length: attr.length)
        attr.addAttributes( myAttribute, range: myRange)

        let downCarat = #imageLiteral(resourceName: "down-carat-blue")
        let attachment = NSTextAttachment()
        let imageView = UIImageView(image: downCarat)
        imageView.sizeToFit()
        
        attachment.image = downCarat
        attachment.bounds = CGRect(x: 0, y: 2, width: imageView.frame.width, height: imageView.frame.height)
        let imageStr = NSAttributedString(attachment: attachment)
        attr.append(imageStr)
        
        self.menuButton.setAttributedTitle(attr, for: .normal)
        self.menuButton.addTarget(self, action: #selector(ConvosViewController.didTap(title:)), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(self.menuButton)
        
        self.menuTransparentButton.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height + 66)
        self.menuTransparentButton.backgroundColor = UIColor.clear
        self.navigationController?.view.addSubview(self.menuTransparentButton)
        self.menuTransparentButton.addTarget(self, action: #selector(didTapBackgroundButton), for: .touchUpInside)
        self.menuTransparentButton.isHidden = true
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            //iPhone X
            self.menuBgImageView.frame = CGRect.init(x: 101, y: 102-25, width: 186, height: 114)
        } else {
            self.menuBgImageView.frame = CGRect.init(x: 101, y: 102-25-25, width: 186, height: 114)
        }
        self.menuBgImageView.isUserInteractionEnabled = true
        self.navigationController?.view.addSubview(self.menuBgImageView)
        self.menuBgImageView.isHidden = true
        
        let toDoButton: UIButton = UIButton()
        toDoButton.sizeToFit()
        toDoButton.frame = CGRect.init(x: 0, y: 0, width: (self.menuBgImageView.frame.size.width), height: (self.menuBgImageView.frame.size.height)/2)
        toDoButton.addTarget(self, action: #selector(ConvosViewController.didTapToDo), for: .touchUpInside)
        self.menuBgImageView.addSubview(toDoButton)
        
        let clearedButton: UIButton = UIButton()
        clearedButton.sizeToFit()
        clearedButton.frame = CGRect.init(x: 0, y: (self.menuBgImageView.frame.size.height)/2, width: (self.menuBgImageView.frame.size.width), height: (self.menuBgImageView.frame.size.height)/2)
        clearedButton.addTarget(self, action: #selector(ConvosViewController.didTapCleared), for: .touchUpInside)
        self.menuBgImageView.addSubview(clearedButton)
        
    }
    
    @objc func didTapBackgroundButton() {
        switch screenType {
        case .combined:
            self.didTapToDo()
        
        case .cleared:
            self.didTapCleared()
            
        case .spam:
            print("spam")
        }
    }
    
    @objc func didTap(title sender: UIButton) {
        switch screenType {
        case .combined:
            self.toDoTitleUpArrow()
            showToDoMenuBg()
            
        case .cleared:
            self.clearedTitleUpArrow()
            showClearedMenuBg()
            
        case .spam:
            print("spam")

        }
    }
    
    func showToDoMenuBg() {
        self.menuBgImageView.image = #imageLiteral(resourceName: "menu-to-do")
        self.menuBgImageView.isHidden = false
        self.menuTransparentButton.isHidden = false
        self.tableView?.isUserInteractionEnabled = false
        self.tableView?.allowsSelection = false
    }
    
    func showClearedMenuBg() {
        self.menuBgImageView.image = #imageLiteral(resourceName: "menu-cleared")
        self.menuBgImageView.isHidden = false
        self.menuTransparentButton.isHidden = false
        self.tableView?.isUserInteractionEnabled = false
        self.tableView?.allowsSelection = false
    }
    
    @objc func didTapToDo(){
        let convosUndoActions = ConvosUndoActions(parentVC: self)
        convosUndoActions.removeAllUndoButton()
        self.toDoTitleDownArrow()
        screenType = .combined
        self.menuBgImageView.isHidden = true
        self.menuTransparentButton.isHidden = true
        self.tableView?.reloadData()
        self.tableView?.isUserInteractionEnabled = true
        self.tableView?.allowsSelection = true
    }
    
    @objc func didTapCleared(){
        let convosUndoActions = ConvosUndoActions(parentVC: self)
        convosUndoActions.removeAllUndoButton()
        self.clearedTitleDownArrow()
        screenType = .cleared
        self.menuBgImageView.isHidden = true
        self.menuTransparentButton.isHidden = true
        if self.clearedItemsThreadInfo?.count == 0 || !(self.clearedItemsThreadInfo != nil) {
            let convosLoading = ConvosLoading(parentVC: self)
            convosLoading.checkDataStoreForClearedConvos()
        }
        self.tableView?.reloadData()
        self.tableView?.isUserInteractionEnabled = true
        self.tableView?.allowsSelection = true
    }
    
    @objc func didTapSpam() {
        if let tabBarVC = self.tabBarController {
            tabBarVC.selectedIndex = 0
        }
        self.isFromSpam = true
        
        self.menuButton.removeFromSuperview()
        self.menuBgImageView.removeFromSuperview()
        self.menuTransparentButton.removeFromSuperview()
        self.tabBarController?.title = "Spam"

        screenType = .spam
        var attr = NSMutableAttributedString()
            attr = NSMutableAttributedString(string:  " Spam")
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.ConvosViewHelper.titleFont, size: UIView.midInterMargin)! ]
        let myRange = NSRange(location: 0, length: attr.length)
        attr.addAttributes( myAttribute, range: myRange)
        
        if self.spamItemsThreadInfo?.count == 0 || self.spamItemsThreadInfo == nil {
            checkDataStoreForSpamConvos()
            if self.spamItemsThreadInfo?.count == 0 {
                showEmptyState()
            }
        }
        self.tableView?.reloadData()
    }
    
    func showEmptyState() {
        let noMessageView = UIImageView()
        noMessageView.image = #imageLiteral(resourceName: "no_message")
        noMessageView.frame = CGRect(x: 129, y: 359, width: 134, height: 129)
        self.view.addSubview(noMessageView)
    }
    
    func toDoTitleDownArrow() {
        let attr = NSMutableAttributedString(string: Localized.string(forKey: LocalizedString.ConvosToDoTitle) + " ")
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.ConvosViewHelper.titleFont, size: UIView.midInterMargin)! ]
        let myRange = NSRange(location: 0, length: attr.length)
        attr.addAttributes( myAttribute, range: myRange)
        let downCarat = #imageLiteral(resourceName: "down-carat-blue")
        let attachment = NSTextAttachment()
        let imageView = UIImageView(image: downCarat)
        imageView.sizeToFit()
        
        attachment.image = downCarat
        attachment.bounds = CGRect(x: 0, y: 2, width: imageView.frame.width, height: imageView.frame.height)
        let imageStr = NSAttributedString(attachment: attachment)
        attr.append(imageStr)
        
        self.menuButton.setAttributedTitle(attr, for: .normal)
    }
    
    func toDoTitleUpArrow() {
        let attr = NSMutableAttributedString(string: Localized.string(forKey: LocalizedString.ConvosToDoTitle) + " ")
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.ConvosViewHelper.titleFont, size: UIView.midInterMargin)! ]
        let myRange = NSRange(location: 0, length: attr.length)
        attr.addAttributes( myAttribute, range: myRange)
        let upCarat = #imageLiteral(resourceName: "up-carat-blue")
        let attachment = NSTextAttachment()
        let imageView = UIImageView(image: upCarat)
        imageView.sizeToFit()
        
        attachment.image = upCarat
        attachment.bounds = CGRect(x: 0, y: 2, width: imageView.frame.width, height: imageView.frame.height)
        let imageStr = NSAttributedString(attachment: attachment)
        attr.append(imageStr)
        
        self.menuButton.setAttributedTitle(attr, for: .normal)
    }
    
    func clearedTitleDownArrow() {
        let attr = NSMutableAttributedString(string: Localized.string(forKey: LocalizedString.ConvosClearedTitle) + " ")
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.ConvosViewHelper.titleFont, size: UIView.midInterMargin)! ]
        let myRange = NSRange(location: 0, length: attr.length)
        attr.addAttributes( myAttribute, range: myRange)
        let downCarat = #imageLiteral(resourceName: "down-carat-blue")
        let attachment = NSTextAttachment()
        let imageView = UIImageView(image: downCarat)
        imageView.sizeToFit()
        
        attachment.image = downCarat
        attachment.bounds = CGRect(x: 0, y: 2, width: imageView.frame.width, height: imageView.frame.height)
        let imageStr = NSAttributedString(attachment: attachment)
        attr.append(imageStr)
        
        self.menuButton.setAttributedTitle(attr, for: .normal)
    }
    
    func clearedTitleUpArrow() {
        let attr = NSMutableAttributedString(string: Localized.string(forKey: LocalizedString.ConvosClearedTitle) + " ")
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.ConvosViewHelper.titleFont, size: UIView.midInterMargin)! ]
        let myRange = NSRange(location: 0, length: attr.length)
        attr.addAttributes( myAttribute, range: myRange)
        let upCarat = #imageLiteral(resourceName: "up-carat-blue")
        let attachment = NSTextAttachment()
        let imageView = UIImageView(image: upCarat)
        imageView.sizeToFit()
        
        attachment.image = upCarat
        attachment.bounds = CGRect(x: 0, y: 2, width: imageView.frame.width, height: imageView.frame.height)
        let imageStr = NSAttributedString(attachment: attachment)
        attr.append(imageStr)
        
        self.menuButton.setAttributedTitle(attr, for: .normal)
    }
    
    //Spam
    func checkDataStoreForSpamConvos() {
        self.showLoadingGif()
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "spam = \(NSNumber(value:true))")
        request.predicate = predicate1
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getSpamConvosFromBackend()
            } else {
                self.loadSpamConvosData()
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getSpamConvosFromBackend() {
        let service = ConvosAPIBridge()
        service.getSpamDataWith(completion: ) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    let threadsService = ConvosService(parentVC: strongSelf)
                    threadsService.saveSpamInCoreDataWith(array: data)
                    strongSelf.maxSpamItemsCount = service.totalspamMessagesCount
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    func loadLatestSpamConvosData() {
        let service = ConvosAPIBridge()
        service.getSpamDataWith(completion: ) { [weak self] result in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    let threadsService = ConvosService(parentVC: strongSelf)
                    threadsService.saveInCoreDataWithRealtimeEvents(array: data)
                    if data.count > 0, let spamItemsArray = strongSelf.spamItemsThreadInfo, spamItemsArray.count > 0 {
                        if let threadId = data.first!["id"] as? String, let oldThreadId = spamItemsArray.first?.id {
                            if !threadId.isEqualToString(find: oldThreadId) {
                                strongSelf.loadSpamConvosData()
                            }
                        }
                    }
                case .Error(let message):
                     print(message)
                }
            }
        }
    }
    
    func loadSpamConvosData() {
        let threadsService = ConvosService(parentVC: self)
        let fetchedResultController = threadsService.getSpamConversations(withAscendingOrder: sortAscending)
        self.spamItemsThreadInfo = fetchedResultController.fetchedObjects
        let spamItemsCount = self.spamItemsThreadInfo?.count
        if spamItemsCount == self.maxSpamItemsCount {
            self.maxSpamItemsReached = true
        } else {
            self.maxSpamItemsReached = false
        }
        if self.view.subviews.contains(self.loadingImageView) {
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){ [weak self] in
                self?.loadingImageView.removeFromSuperview()
            }
        }
    }
 
    func fetchMoreSpamConvos(_withSkip skip:Int) {
        let service = ConvosAPIBridge()
        service.getSpamDataWith(_withSkip: skip) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    if data.count > 0 {
                        let threadsService = ConvosService(parentVC: strongSelf)
                        threadsService.saveSpamInCoreDataWith(array: data)
                    }
                    strongSelf.maxSpamItemsCount = service.totalspamMessagesCount
                    if strongSelf.spamItemsThreadInfo?.count == service.totalspamMessagesCount {
                        strongSelf.maxSpamItemsReached = true
                        strongSelf.sections = strongSelf.screenBuilder.loadSections() as! [ConvosSectionType]
                        self?.tableView?.reloadData()
                    }
                    
                case .Error(let message):
                    print(message)
                }
            }
        }
        
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        if indexPathIsValid(indexPath: indexPath) == true {
            self.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        if let tableView = self.tableView {
            return indexPath.section < tableView.numberOfSections && indexPath.row < tableView.numberOfRows(inSection: indexPath.section)
        } else {
            return false
        }
    }
    
    // Show loading gif image
    func showLoadingGif() {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.showLoadingGif()
    }
    
    // Remove loading gif image
    func removeLoadingGif() {
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){ [weak self] in
            if let viewsArray = self?.view.subviews, let imgView = self?.loadingImageView {
                if viewsArray.contains(imgView) {
                    self?.loadingImageView.removeFromSuperview()
                }
            }
        }
    }
    
    // App entered foreground
    @objc func appEnteredForeground() -> Void {
        let convosLoading = ConvosLoading(parentVC: self)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            convosLoading.fetchNewMessagesData()
            convosLoading.fetchClearedMessagesData()
            convosLoading.fetchSeenMessagesData()
        }
    }

    func loadNewConvosData() {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadNewConvosData()
        DispatchQueue.global().async {
            self.screenBuilder.updateModel(model: self.newItemsThreadInfo, type: ConvosType.new)
            DispatchQueue.main.async {
                let convosLoading = ConvosLoading(parentVC: self)
                convosLoading.checkDataStoreForSeenConvos()
                self.isLoading = false
            }
        }
    }
    
    func checkCoreDataForNewConvos() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let convosLoading = ConvosLoading(parentVC: self)
            convosLoading.checkDataStoreForNewConvos()
        }
    }
    
    func fetchMoreNewConvos(_withSkip skip:Int) {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.fetchMoreNewConvos(_withSkip: skip)
    }
    
    func loadSeenConvosData() {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadSeenConvosData()
        self.screenBuilder.updateModel(model: self.seenItemsThreadInfo, type: ConvosType.seen)
        self.sections = self.screenBuilder.loadSections() as! [ConvosSectionType]
        DispatchQueue.main.async {
            self.tableView?.reloadData()
            self.isLoading = false
        }
    }
    
    func loadSeenConvosDataWithoutTableReload() {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadSeenConvosDataWithoutTableReload()
        DispatchQueue.global().async { [weak self] in
            self?.screenBuilder.updateModel(model: self?.seenItemsThreadInfo, type: ConvosType.seen)
            self?.sections = self?.screenBuilder.loadSections() as! [ConvosSectionType]
        }
    }
    
    func fetchMoreSeenConvos(_withSkip skip:Int) {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.fetchMoreSeenConvos(_withSkip: skip)
    }
    
    func loadClearedConvosData() {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadClearedConvosData()
        DispatchQueue.global().async {
            self.screenBuilder.updateModel(model: self.clearedItemsThreadInfo, type: ConvosType.cleared)
            self.sections = self.screenBuilder.loadSections() as! [ConvosSectionType]
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.isLoading = false
            }
        }
        self.removeLoadingGif()
    }
    
    func loadClearedConvosDataWithoutTableReload() {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadClearedConvosDataWithoutTableReload()
        DispatchQueue.global().async {
            self.screenBuilder.updateModel(model: self.clearedItemsThreadInfo, type: ConvosType.cleared)
            self.sections = self.screenBuilder.loadSections() as! [ConvosSectionType]
        }
    }
    
    func fetchMoreClearedConvos(_withSkip skip: Int) {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.fetchMoreClearedConvos(_withSkip: skip)
    }
    
    @objc func undoClearButtonPressed(sender: UIButton) {
        let convosUndoActions = ConvosUndoActions(parentVC: self)
        convosUndoActions.undoClearButtonPressed(sender: sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    @objc func undoToDoButtonPressed(sender: UIButton) {
        let convosUndoActions = ConvosUndoActions(parentVC: self)
        convosUndoActions.undoToDoButtonPressed(sender: sender)
    }
    
    @objc func viewSeenMessageButtonPressed(sender: UIButton) {
        let convosUndoActions = ConvosUndoActions(parentVC: self)
        convosUndoActions.viewSeenMessageButtonPressed(sender: sender)
    }
    
    func removeThreadFromNewPreviewToSeen(sender: ConvosNewPreviewTableViewCell, thread: Threads, indexPath: IndexPath) {
        let convosUndoAction = ConvosUndoActions(parentVC: self)
        convosUndoAction.removeThreadFromNewPreviewToSeen(sender: sender, thread: thread, indexPath: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadSeenConvosDataWithoutTableReload()
            self.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func removeThreadFromNewToSeen(sender: ConvosNewTableViewCell, thread: Threads, indexPath: IndexPath) {
        let convosUndoAction = ConvosUndoActions(parentVC: self)
        convosUndoAction.removeThreadFromNewToSeen(sender: sender, thread: thread, indexPath: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadSeenConvosDataWithoutTableReload()
            self.loadClearedConvosDataWithoutTableReload()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func getRecipients(from threads: Threads) -> String {
        guard let toArray = threads.threads_named_participants?.allObjects as? [Threads_Named_Participants] else { return "" }
        var nameArray: [String] = []
        var nameConcatenatedString = ""
        if toArray.count == 1 {
            if let toObject: Threads_Named_Participants = toArray.first {
                guard let name = toObject.name else { return "" }
                nameConcatenatedString = name
            }
        } else if toArray.count > 1 {
            for toData in toArray {
                let toObject: Threads_Named_Participants = toData
                if toObject.first_name?.count == 0 {
                    guard let name = toObject.name else { return "" }
                    nameArray.append(name)
                } else {
                    guard let first_name = toObject.first_name else { return "" }
                    nameArray.append(first_name)
                }
            }
            nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: Localized.string(forKey: LocalizedString.ConvosSeparatorTitle))
        }
        return nameConcatenatedString
    }
    
    
    func showUndoRecategorizeSpamButton() {
        
     let title = UILabel()
     let undoSpamBtnView = UIView()
        if (self.categoryName?.isEqualToString(find: "conversations"))! || (self.categoryName?.isEqualToString(find: "notifications"))! {
            title.frame = CGRect(x: 18, y: 11, width: 135 + 16, height: 22)
            undoSpamBtnView.frame = CGRect(x: 65, y: 560, width: 245 + 16, height: 46)
        } else if (self.categoryName?.isEqualToString(find: "purchases"))! || (self.categoryName?.isEqualToString(find: "promotions"))! || (self.categoryName?.isEqualToString(find: "finance"))! {
            title.frame = CGRect(x: 18, y: 11, width: 133, height: 22)
            undoSpamBtnView.frame = CGRect(x: 74, y: 560, width: 243, height: 46)
        }  else if (self.categoryName?.isEqualToString(find: "trips"))! || (self.categoryName?.isEqualToString(find: "news"))! ||
            (self.categoryName?.isEqualToString(find: "social"))! {
            title.frame = CGRect(x: 18, y: 11, width: 133 - 40, height: 22)
            undoSpamBtnView.frame = CGRect(x: 74 + 20, y: 560, width: 243 - 40, height: 46)
        }
      
        self.view?.addSubview(undoSpamBtnView)
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: undoSpamBtnView.frame.size.width, height: 46))
        backgroundImage.image = #imageLiteral(resourceName: "undo_recategorise_background")
        undoSpamBtnView.addSubview(backgroundImage)
        
        title.text = "Moved to \(String(describing: self.categoryName!) )"
        title.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        title.textAlignment = .left
        title.textColor = UIColor.init(hexString: ":FFFFFF")
        
        let undoSpamButton = UIButton(frame: CGRect(x: undoSpamBtnView.frame.size.width - 81, y: 11, width: 67, height: 26))
        undoSpamButton.setImage(#imageLiteral(resourceName: "undo_button"), for: .normal)
        undoSpamButton.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        undoSpamBtnView.addSubview(title)
        undoSpamBtnView.addSubview(undoSpamButton)
        
        let when = DispatchTime.now() + 3.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            undoSpamButton.removeFromSuperview()
            title.removeFromSuperview()
            backgroundImage.removeFromSuperview()
            undoSpamBtnView.removeFromSuperview()
        }
        
    }
    
    @objc func undoButtonPressed() {
       
    }

    // Real time updates
    func listenToRealTimeEvents() {
        let when = DispatchTime.now() + 3.5
        DispatchQueue.main.asyncAfter(deadline: when){
            let convosLoading = ConvosLoading(parentVC: self)
            convosLoading.listenToRealTimeEvents()
        }
    }
    
    func loadNewConvosWithRealtimeUpdates(thread: Threads) {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadNewConvosWithRealtimeUpdates(thread: thread)
    }
    
    func loadSeenConvosWithRealtimeUpdates(thread: Threads) {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadSeenConvosWithRealtimeUpdates(thread: thread)
    }
    
    func loadClearedConvosWithRealtimeUpdates(thread: Threads) {
        let convosLoading = ConvosLoading(parentVC: self)
        convosLoading.loadClearedConvosWithRealtimeUpdates(thread: thread)
    }
    
    func loadNewNewConvosData() {
        DispatchQueue.global().async { [weak self] in
            self?.screenBuilder.updateModel(model: self?.newItemsThreadInfo, type: ConvosType.new)
            self?.sections = self?.screenBuilder.loadSections() as! [ConvosSectionType]
            self?.loadNewConvosData()
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                self?.isLoadingRealtime = false
            }
        }
    }

    func loadNewSeenData() {
        DispatchQueue.global().async { [weak self] in
            self?.screenBuilder.updateModel(model: self?.seenItemsThreadInfo, type: ConvosType.seen)
            self?.sections = self?.screenBuilder.loadSections() as! [ConvosSectionType]
            self?.loadClearedConvosData()
            self?.loadNewConvosData()
            self?.loadSeenConvosData()
            self?.isLoadingRealtime = false
        }
    }
    
    func loadNewClearedData() {
        DispatchQueue.global().async {
            self.screenBuilder.updateModel(model: self.clearedItemsThreadInfo, type: ConvosType.cleared)
            self.sections = self.screenBuilder.loadSections() as! [ConvosSectionType]
            self.loadClearedConvosData()
            self.loadNewConvosData()
            self.loadSeenConvosData()
            self.isLoadingRealtime = false
        }
    }

}
