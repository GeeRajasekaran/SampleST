//
//  ConvosViewController.swift
//  June
//
//  Created by Joshua Cleetus on 12/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData

class ConvosViewController: UIViewController {
    
    var fetchedResultController: NSFetchedResultsController<Threads>?
    var sortAscending = false
    
    var sections: [ConvosSectionType] = []
    var tapStyle: String?

    // TableView
    var tableView: UITableView?
    var dataSource: ConvosDataSource?
    var delegate: ConvosDelegate?
    
    var maxNewItemsCount: Int = 0
    var maxSeenItemsCount: Int = 0
    var maxClearedItemsCount: Int = 0
    var maxSpamItemsCount: Int = 0
    var totalNewItemsCount: Int = 0
    var totalSeenItemsCount: Int = 0
    var totalClearedItemsCount: Int = 0
    var totalSpamItemsCount: Int = 0
    
    var menuBgImageView: UIImageView = UIImageView()
    var menuTransparentButton: UIButton = UIButton()
    let menuButton: UIButton = UIButton()
    var loadingImageView: UIImageView = UIImageView()
    var isFromThreadsDetailVC = false
    var isStarredValueChanged = false
    var isFromNew = false
    var isFromSeen = false
    var isFromSpam = false
    var isFromCleared = false
    var unread: Bool?
    var seen: Bool?
    var inbox: Bool?
    var starred: Bool?
    var threadFromDetailVC: Threads?
    var undoSpamThread: Threads?
    var undoClearThreadObjects: [String: Threads] = [:]
    var undoClearIndexPaths: [String: IndexPath] = [:]
    var undoToDoThreadObjects: [String: Threads] = [:]
    var undoToDoIndexPaths: [String: IndexPath] = [:]
    var undoViewThreadObjects: [String: Threads] = [:]
    var undoViewIndexPaths: [String: IndexPath] = [:]
    var pendingRequestWorkItems: [String: DispatchWorkItem] = [:]
    let convosRealTime = ConvosRealTime()
    var categoryName: String?
    var realtimeRequestWorkItem: DispatchWorkItem?
    var isLoadingRealtime = false
    var isLoading = false
    var selectedIndexPath: IndexPath?

    // Screen Builder
    var screenBuilder: ConvosScreenBuilder = ConvosScreenBuilder(model: nil)
    
    // Screen Type
    var screenType: ConvosScreenType {
        get {
            return screenBuilder.loadSegment() as! ConvosScreenType
        }
        set {
            screenBuilder.switchSegment(newValue)
            sections = screenBuilder.loadSections() as! [ConvosSectionType]
        }
    }
    
    var newCollapsed: Bool = false {
        didSet {
            screenBuilder.viewHelper.newCollapsed = newCollapsed
            sections = screenBuilder.loadSections() as! [ConvosSectionType]
            tableView?.reloadData()
            self.scrollToFirstRow()
        }
    }
    
    var maxNewItemsReached: Bool {
        get {
            return screenBuilder.viewHelper.maxNewItemsReached
        }
        set {
            screenBuilder.viewHelper.maxNewItemsReached = newValue
        }
    }
    
    var maxSeenItemsReached: Bool {
        get {
            return screenBuilder.viewHelper.maxSeenItemsReached
        }
        set {
            screenBuilder.viewHelper.maxSeenItemsReached = newValue
        }
    }

    var maxClearedItemsReached: Bool {
        get {
            return screenBuilder.viewHelper.maxClearedItemsReached
        }
        set {
            screenBuilder.viewHelper.maxClearedItemsReached = newValue
        }
    }

    var maxSpamItemsReached: Bool {
        get {
            return screenBuilder.viewHelper.maxSpamItemsReached
        }
        set {
            screenBuilder.viewHelper.maxSpamItemsReached = newValue
        }
    }
    
    var noNewItems: Bool {
        get {
            return screenBuilder.viewHelper.noNewItems
        }
        set {
            screenBuilder.viewHelper.noNewItems = newValue
        }
    }
    
    var noSeenItems: Bool {
        get {
            return screenBuilder.viewHelper.noSeenItems
        }
        set {
            screenBuilder.viewHelper.noSeenItems = newValue
        }
    }

    var loadingSeenItems: Bool = false {
        didSet {
            if loadingSeenItems {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: {
                    if let seenItemsCount = self.seenItemsThreadInfo?.count {
                        self.fetchMoreSeenConvos(_withSkip: seenItemsCount)
                        self.loadingSeenItems = false
                    }
                })
            }
        }
    }
    
    var loadingNewItems: Bool = false {
        didSet {
            if loadingNewItems {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: {
                    if let newItemsCount = self.newItemsThreadInfo?.count {
                        self.fetchMoreNewConvos(_withSkip: newItemsCount)
                        self.loadingNewItems = false
                    }
                })
            }
        }
    }
    
    var loadingClearedItems: Bool = false {
        didSet {
            if loadingClearedItems {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: {
                    if let clearedItemsCount = self.clearedItemsThreadInfo?.count {
                        self.fetchMoreClearedConvos(_withSkip: clearedItemsCount)
                        self.loadingClearedItems = false
                    }
                })
            }
        }
    }
    
    var loadingSpamItems: Bool = false {
        didSet {
            if loadingSpamItems {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: {
                    if let spamItemsCount = self.spamItemsThreadInfo?.count {
                        self.fetchMoreSpamConvos(_withSkip: spamItemsCount)
                        self.loadingSpamItems = false
                    }
                })
            }
        }
    }
    
    var newItemsThreadInfo: [Threads]? = nil {
        didSet {
            if newItemsThreadInfo?.count == 0 {
                self.noNewItems = true
            } else {
                self.noNewItems = false
            }
        }
    }
    
    var seenItemsThreadInfo: [Threads]? = nil {
        didSet {
            if seenItemsThreadInfo?.count == 0 {
                self.noSeenItems = true
            } else {
                self.noSeenItems = false
            }
        }
    }
    
    var clearedItemsThreadInfo: [Threads]? = nil {
        didSet {

        }
    }
    
    var spamItemsThreadInfo: [Threads]? = nil {
        didSet {
            DispatchQueue.global().async {
                self.screenBuilder.updateModel(model: self.spamItemsThreadInfo, type: ConvosType.spam)
                self.sections = self.screenBuilder.loadSections() as! [ConvosSectionType]
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - Pending people update logic
    
    private lazy var onPendingCountUpdated: () -> Void = { [weak self] in
        self?.tableView?.reloadData()
    }
    
    private lazy var onClosePendingContactView: () -> Void = { [weak self] in
        self?.screenBuilder.contactsHelper.isPendingContactsNotificationClosed = true
        self?.tableView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupView()
        screenBuilder.contactsHelper.onCountUpdated = onPendingCountUpdated
        dataSource?.onCloseNotificationView = onClosePendingContactView
        let convosLoading = ConvosLoading(parentVC: self)
        if isFromSpam {
            checkDataStoreForSpamConvos()
        } else {
            convosLoading.checkDataStoreForNewConvos()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenBuilder.contactsHelper.requestPendingContactsCount()
        NotificationCenter.default.addObserver(self, selector:#selector(ConvosViewController.appEnteredForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConvosViewController.didTapSpam), name: NSNotification.Name(rawValue: "spam"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConvosViewController.updateConvosAfterSearch(_:)), name: NSNotification.Name(rawValue: "UpdateConvosAfterSearch"), object: nil)
        self.tabBarController?.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.menuButton.removeFromSuperview()
        self.menuBgImageView.removeFromSuperview()
        self.convosRealTime.switchOffThreadsRealtimeListener()
        let convosUndoActions = ConvosUndoActions(parentVC: self)
        convosUndoActions.removeAllUndoButton()
        self.convosRealTime.switchOffThreadsRealtimeListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isFromThreadsDetailVC {
            if self.isStarredValueChanged {
                if let unread = self.unread, let seen = self.seen, let inbox = self.inbox, unread == true, seen == true, inbox == true, self.isFromNew {
                    self.isFromNew = false
                    if let threadObject = self.threadFromDetailVC, let index = self.selectedIndexPath {
                        if let cell = self.tableView?.cellForRow(at: index) as? ConvosNewPreviewTableViewCell {
                            let convosUndoAction = ConvosUndoActions(parentVC: self)
                            convosUndoAction.removeThreadFromNewPreviewToSeen(sender: cell, thread: threadObject, indexPath: index)
                        } else if let cell = self.tableView?.cellForRow(at: index) as? ConvosNewTableViewCell {
                            let convosUndoAction = ConvosUndoActions(parentVC: self)
                            convosUndoAction.removeThreadFromNewToSeen(sender: cell, thread: threadObject, indexPath: index)
                        }
                    }
                } else if let unread = self.unread, let seen = self.seen, let inbox = self.inbox, unread == false, seen == false, inbox == true, self.isFromNew {
                    self.isFromNew = false
                    if let threadObject = self.threadFromDetailVC, let index = self.selectedIndexPath {
                        if let cell = self.tableView?.cellForRow(at: index) as? ConvosNewPreviewTableViewCell {
                            self.dataSource?.convosNewPreview(didTapItem: cell, thread: threadObject, indexPath: index)
                        } else if let cell = self.tableView?.cellForRow(at: index) as? ConvosNewTableViewCell {
                            self.dataSource?.convosNewView(didTapItem: cell, thread: threadObject, indexPath: index)
                        }
                    }
                } else if let unread = self.unread, let seen = self.seen, let inbox = self.inbox, unread == false, seen == false, inbox == true, self.isFromSeen {
                    self.isFromSeen = false
                    if let threadObject = self.threadFromDetailVC, let index = self.selectedIndexPath {
                        if let cell = self.tableView?.cellForRow(at: index) as? ConvosTableViewCell {
                            self.dataSource?.convosView(didTapItem: cell, thread: threadObject, indexPath: index)
                        }
                    }
                } else if let unread = self.unread, let seen = self.seen, unread == true, seen == true, self.isFromCleared {
                    self.isFromCleared = false
                    if let threadObject = self.threadFromDetailVC, let index = self.selectedIndexPath {
                        if let cell = self.tableView?.cellForRow(at: index) as? ConvosClearedTableViewCell {
                            self.dataSource?.convosClearedView(didTapItem: cell, thread: threadObject, indexPath: index)
                        }
                    }
                }
                self.isFromThreadsDetailVC = false
            } else {
                let convosLoading = ConvosLoading(parentVC: self)
                convosLoading.getClearedConvosFromBackend()
                convosLoading.getSeenConvosFromBackend()
                convosLoading.fetchNewMessagesData()
            }
            self.isFromThreadsDetailVC = false
        } else {
            let convosLoading = ConvosLoading(parentVC: self)
            convosLoading.fetchClearedMessagesData()
            convosLoading.fetchSeenMessagesData()
            convosLoading.fetchNewMessagesData()
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.listenToRealTimeEvents()
            }
        }
        if let index = self.tableView?.indexPathForSelectedRow {
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.tableView?.deselectRow(at: index, animated: true)
            }
        }
        
        if isFromSpam == false {
            setUpNavigationMenuButton()
        } else {
            self.navigationController?.navigationBar.topItem?.title = "Spam"
        }
        if categoryName != nil {
            self.showUndoRecategorizeSpamButton()
            self.categoryName = nil
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - update convos after search
    @objc func updateConvosAfterSearch(_ notification: Notification) {
        self.loadNewConvosData()
        self.loadSeenConvosData()
        self.loadClearedConvosData()
        self.listenToRealTimeEvents()
    }
    
    func setupView() {
        var tableViewFrame: CGRect
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height {
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height - 66 - tabBarHeight - 70))
            } else {
                tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height - 66 - tabBarHeight))
            }
        } else {
            tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height - 66))
        }
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        self.tableView?.separatorStyle = .none
        self.tableView?.rowHeight = 0
        self.tableView?.estimatedRowHeight = 0;
        self.tableView?.estimatedSectionHeaderHeight = 0;
        self.tableView?.estimatedSectionFooterHeight = 0;
        self.tableView?.backgroundColor = .white
        dataSource = ConvosDataSource(parentVC: self)
        delegate = ConvosDelegate(parentVC: self)
        self.tableView?.delegate = delegate
        self.tableView?.dataSource = dataSource
        if let tableView = self.tableView {
            view.addSubview(tableView)
        }
        
        tableView?.register(PendingRequestTableViewCell.self, forCellReuseIdentifier: PendingRequestTableViewCell.reuseIdentifier())
        tableView?.register(LabelItemTableViewCell.self, forCellReuseIdentifier: LabelItemTableViewCell.reuseIdentifier())
        tableView?.register(ConvosTableViewCell.self, forCellReuseIdentifier: ConvosTableViewCell.reuseIdentifier())
        tableView?.register(ConvosNewPreviewTableViewCell.self, forCellReuseIdentifier: ConvosNewPreviewTableViewCell.reuseIdentifier())
        tableView?.register(ConvosNewTableViewCell.self, forCellReuseIdentifier: ConvosNewTableViewCell.reuseIdentifier())
        tableView?.register(ConvosViewAllTableViewCell.self, forCellReuseIdentifier: ConvosViewAllTableViewCell.reuseIdentifier())
        tableView?.register(ConvosClearedTableViewCell.self, forCellReuseIdentifier: ConvosClearedTableViewCell.reuseIdentifier())
        tableView?.register(ConvosSpamTableViewCell.self, forCellReuseIdentifier: ConvosSpamTableViewCell.reuseIdentifier())
        tableView?.register(ConvosNoNewItemTableViewCell.self, forCellReuseIdentifier: ConvosNoNewItemTableViewCell.reuseIdentifier())
        tableView?.register(ConvosNoNewOrSeenTableViewCell.self, forCellReuseIdentifier: ConvosNoNewOrSeenTableViewCell.reuseIdentifier())

    }
    
    override func loadViewIfNeeded() {
        let convosLoading = ConvosLoading(parentVC: self)
        if let tapStyleString = self.tapStyle {
            if tapStyleString.isEqualToString(find: "double") {
                if isFromSpam == true {
                    isFromSpam = false
                    screenType = .combined
                    self.tabBarController?.title = ""
                    convosLoading.checkDataStoreForNewConvos()
                    setUpNavigationMenuButton()
                    if let index = self.tableView?.indexPathForSelectedRow {
                        let when = DispatchTime.now() + 0.3
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.tableView?.deselectRow(at: index, animated: true)
                    }
                }
                    self.tableView?.reloadData()
                    self.listenToRealTimeEvents()
                    convosLoading.fetchClearedMessagesData()
                    convosLoading.fetchSeenMessagesData()
                    convosLoading.fetchNewMessagesData()
                } else {
                    self.scrollToFirstRow()
                }
            }
        }
    }
    
}

