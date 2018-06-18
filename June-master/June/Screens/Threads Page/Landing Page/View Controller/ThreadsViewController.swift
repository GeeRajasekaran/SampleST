//
//  ThreadsViewController.swift
//  June
//
//  Created by Joshua Cleetus on 8/1/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import QuartzCore
import NVActivityIndicatorView
import AlertBar
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import CoreData
import Actions
import KeychainSwift

struct CustomSwipeAction: ThreadsSwipeAction {
    var title: String
    var color: UIColor
}

struct CustomStarUnstarAction: ThreadsStarUnstarSwipeAction {
    var title: String
    var color: UIColor
}

class ThreadsViewController: UIViewController, ThreadsTableViewCellDelegate, ThreadsStarUnstarTableViewCellDelegate, ThreadsHeaderViewCellDelegate, NVActivityIndicatorViewable, UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate {
    
    // TableView
    var tableView: UITableView?
    var readTableView: UITableView?
    var trashTableView: UITableView?
    var spamTableView: UITableView?
    private let refreshControl = UIRefreshControl()
    private let refreshControl2 = UIRefreshControl()
    private let refreshControl3 = UIRefreshControl()
    private let refreshControl4 = UIRefreshControl()
    var filterBgImageView: UIImageView?
    var trashSpamBgImageView: UIImageView?
    var containerView: UIView!
    var trashButton: UIButton?
    var spamButton: UIButton?
    var fromTableViewTag: Int?
    var lastSelectedIndexPath: IndexPath?
    var lastSelectedTableViewTag: Int?
    var tapStyle: String?
    private var pendingRequestWorkItems: [String: DispatchWorkItem] = [:]
    private var alertButton: UIButton!
    private var alertButtonLabel = UILabel()
    var dataSource: ThreadsDataSource?
    var delegate: ThreadsDelegate?
    var tableViewContentOffset: CGPoint = CGPoint.init(x: 0, y: 0)
    //New Messages
    var fetchedResultController: NSFetchedResultsController<Threads>?
    var threadsService: ThreadsService?
    var threadToRead: Threads?
    var threadToStar: Threads?
    var sortAscending = false
    var isLoading = false
    var threadsList = [Threads]()
    var dataArray: [NSFetchRequestResult] = []
    var totalNewMessagesCount: Int32 = 0
    var fetchedCount: Int32 = 0
    // ReadAndSent
    var fetchedResultController2: NSFetchedResultsController<Threads>?
    var threadsService2: ThreadsService?
    var sortAscending2 = false
    var threadsList2 = [Threads]()
    var dataArray2: [NSFetchRequestResult] = []
    var totalNewMessagesCount2: Int32 = 0
    var fetchedCount2: Int32 = 0
    var threadToStar2: Threads?
    var threadToUnStar2: Threads?
    //Trash
    var fetchedResultController3: NSFetchedResultsController<Threads>?
    var threadsService3: ThreadsService?
    var sortAscending3 = false
    var threadsList3 = [Threads]()
    var dataArray3: [NSFetchRequestResult] = []
    var totalNewMessagesCount3: Int32 = 0
    var fetchedCount3: Int32 = 0
    var threadToStar3: Threads?
    var threadToUnStar3: Threads?
    //Spam
    var fetchedResultController4: NSFetchedResultsController<Threads>?
    var threadsService4: ThreadsService?
    var sortAscending4 = false
    var threadsList4 = [Threads]()
    var dataArray4: [NSFetchRequestResult] = []
    var totalNewMessagesCount4: Int32 = 0
    var fetchedCount4: Int32 = 0
    var threadToStar4: Threads?
    var threadToUnStar4: Threads?
    var smileFaceImageView: UIImageView!
    var noNewMessageLabel: UILabel!
    var shouldLoadMoreReadThreads = true
    var shouldLoadMoreTrashThreads = true
    var shouldLoadMoreSpamThreads = true
    var shouldLoadMoreNewThreads = true
    var isFromThreadsDetailVC = false
    var starredFromThreadsDetailVC = false
    var categoryFromThreadsDetailVC: String?
    var indexPathOfSwipedItem: IndexPath? = nil
    var disabledCells: [IThreadCell] = []
    var newConversationBackUpArray = [Threads]()
    var conversationBackUpArray = [Threads]()    
    private var alertWorkItem: DispatchWorkItem?
    
    var categories: [FeedCategory] = [FeedCategory]()
    var categoriesDataProvider: CategoriesDataProvider = CategoriesDataProvider()

    private let threadsRealTime = ThreadsRealTime()
    
    static let alertButtonFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let AlertButtonLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let noNewMessageLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .extraMid)
    
    lazy var loader: Loader = { [unowned self] in
        let loader = Loader(with: self)
        return loader
    }()
    
    func showAlert() {
        alertWorkItem?.cancel()
        self.alertButtonLabel.text = ""
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let workItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alertButton.isHidden = true
            strongSelf.alertButtonLabel.isHidden = true
        }
        alertWorkItem = workItem
        let when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when, execute: workItem)
    }
    
    func cellSwipedRight(thread: Threads) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        guard let index = self.fetchedResultController?.fetchedObjects?.index(of: thread) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        guard let threadId = thread.id, let accountId = thread.account_id else { return }
        let starred = true
        let unread = false                                      //// was true
        self.threadsService = ThreadsService(parentVC: self)
        self.threadsService?.update(currentThreadUnreadValue: thread, withNewUnreadValue: unread)
        if pendingRequestWorkItems[threadId] != nil {
            pendingRequestWorkItems[threadId]?.cancel()
        }
        self.isLoading = true
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            let service = ThreadsAPIBridge()
            service.markThreadAsRead(threadId: threadId, accountId: accountId) { [weak self] (result) in
                if let strongSelf = self {
                    switch result {
                    case .Success( _):
                        strongSelf.isLoading = false
                    case .Error(let message):
                        print(message)
                        strongSelf.isLoading = false
                    }
                }
            }
        }
        
        pendingRequestWorkItems[threadId] = requestWorkItem
        
        // Save the new work item and execute it after 3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3,
                                      execute: requestWorkItem)
        let tableViewTag = self.tableView?.tag
        showAlert()
        self.alertButton.removeActions(for: .allEvents)
        self.alertButton.add(event: .touchUpInside) {
            self.alertButton.isHidden = true
            self.alertButtonLabel.isHidden = true
            guard let tag = tableViewTag else { return }
            self.undoDeletedStarredCell(threadId: threadId, starred: starred, unread: unread, accountId: accountId, tableViewTag: tag, indexPath: indexPath)
        }
        self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_read"), for: .normal)
    }
    
    func cellSwipedLeft(thread: Threads) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        guard let index = self.fetchedResultController?.fetchedObjects?.index(of: thread) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        let threadId = thread.id
        let accountId = thread.account_id
        let starred = true
        let unread = false                           //// was true
        let tableViewTag = self.tableView?.tag
        self.isLoading = true
        guard let unwrappedThreadId = threadId, let unwrappedAccountId = accountId, let tag = tableViewTag else { return }
        self.markThreadAsStarredOrUnstarred(threadId: unwrappedThreadId, starred: starred, unread: unread, accountId: unwrappedAccountId, tableViewTag: tag, indexPath: indexPath)
        showAlert()
        
        self.alertButton.removeActions(for: .allEvents)
        self.alertButton.add(event: .touchUpInside) {
            self.alertButton.isHidden = true
            self.alertButtonLabel.isHidden = true
            self.undoDeletedStarredCell(threadId: unwrappedThreadId, starred: starred, unread: unread, accountId: unwrappedAccountId, tableViewTag: tag, indexPath: indexPath)
        }
        self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
    }
    
    func cellSwipedToStar2(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let isIndexValid = self.fetchedResultController2?.fetchedObjects?.indices.contains(indexPath.row)
        if isIndexValid! {
            threadToStar2 = fetchedResultController2?.object(at: indexPath)
            let threadId = threadToStar2?.id
            let accountId = threadToStar2?.account_id
            let starred = true
            let unread = false
            let tableViewTag = self.readTableView?.tag
            self.isLoading = true
            self.markThreadAsStarredOrUnstarred(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            showAlert()
            self.alertButton.removeActions(for: .allEvents)
            self.alertButton.add(event: .touchUpInside) {
                self.isLoading = false
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
                self.undoStarredUnstarredAction(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            }
            self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
        }
    }
    
    func cellSwipedToUnstar2(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let isIndexValid = self.fetchedResultController2?.fetchedObjects?.indices.contains(indexPath.row)
        if isIndexValid! {
            threadToUnStar2 = fetchedResultController2?.object(at: indexPath)
            let threadId = threadToUnStar2?.id
            let accountId = threadToUnStar2?.account_id
            let starred = false
            let unread = false
            let tableViewTag = self.readTableView?.tag
            showAlert()
            self.alertButton.removeActions(for: .allEvents)
            self.alertButton.add(event: .touchUpInside) {
                self.isLoading = false
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
                self.undoStarredUnstarredAction(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            }
            self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_unstarred"), for: .normal)
            self.isLoading = true
            self.markThreadAsStarredOrUnstarred(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
        }
    }
    
    func cellSwipedToStar3(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let isIndexValid = self.fetchedResultController3?.fetchedObjects?.indices.contains(indexPath.row)
        if isIndexValid! {
            threadToStar3 = fetchedResultController3?.object(at: indexPath)
            let threadId = threadToStar3?.id
            let accountId = threadToStar3?.account_id
            let starred = true
            let unread = false
            let tableViewTag = self.trashTableView?.tag
            self.markThreadAsStarredOrUnstarred(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            showAlert()
            self.alertButton.removeActions(for: .allEvents)
            self.alertButton.add(event: .touchUpInside) {
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
                self.undoStarredUnstarredAction(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            }
            self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
        }
    }
    
    func cellSwipedToUnstar3(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let isIndexValid = self.fetchedResultController3?.fetchedObjects?.indices.contains(indexPath.row)
        if isIndexValid! {
            threadToUnStar3 = fetchedResultController3?.object(at: indexPath)
            let threadId = threadToUnStar3?.id
            let accountId = threadToUnStar3?.account_id
            let starred = false
            let unread = false
            let tableViewTag = self.trashTableView?.tag
            self.markThreadAsStarredOrUnstarred(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            showAlert()
            self.alertButton.removeActions(for: .allEvents)
            self.alertButton.add(event: .touchUpInside) {
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
                self.undoStarredUnstarredAction(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            }
            self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_unstarred"), for: .normal)
        }
    }

    func cellSwipedToStar4(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let isIndexValid = self.fetchedResultController4?.fetchedObjects?.indices.contains(indexPath.row)
        if isIndexValid! {
            threadToStar4 = fetchedResultController4?.object(at: indexPath)
            let threadId = threadToStar4?.id
            let accountId = threadToStar4?.account_id
            let starred = true
            let unread = false
            let tableViewTag = self.spamTableView?.tag
            self.isLoading = true
            self.markThreadAsStarredOrUnstarred(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            showAlert()
            self.alertButton.removeActions(for: .allEvents)
            self.alertButton.add(event: .touchUpInside) {
                self.isLoading = false
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
                self.undoStarredUnstarredAction(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            }
            self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
        }
    }
    
    func cellSwipedToUnstar4(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        let isIndexValid = self.fetchedResultController4?.fetchedObjects?.indices.contains(indexPath.row)
        if isIndexValid! {
            threadToUnStar4 = fetchedResultController4?.object(at: indexPath)
            let threadId = threadToUnStar4?.id
            let accountId = threadToUnStar4?.account_id
            let starred = false
            let unread = false
            let tableViewTag = self.spamTableView?.tag
            self.isLoading = true
            self.markThreadAsStarredOrUnstarred(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            showAlert()
            self.alertButton.removeActions(for: .allEvents)
            self.alertButton.add(event: .touchUpInside) {
                self.isLoading = false
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
                self.undoStarredUnstarredAction(threadId: threadId!, starred: starred, unread: unread, accountId: accountId!, tableViewTag: tableViewTag!, indexPath: indexPath)
            }
            self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_unstarred"), for: .normal)
        }
    }
    
    func showNewMessages() {
        tableViewIsEmpty()
        
        self.tableView?.isHidden = false
        self.readTableView?.isHidden = true
        self.spamTableView?.isHidden = true
        self.trashTableView?.isHidden = true
        self.tableView?.tag = 10
        self.lastSelectedTableViewTag = self.tableView?.tag
        if (self.fetchedResultController == nil || (self.fetchedResultController?.fetchedObjects?.count) == 0) {
            self.checkDataStoreA()
        } else {
            self.loadData()
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){ [weak self] in
                guard let is_loading = self?.isLoading else {
                    return
                }
                if !is_loading {
                    self?.fetchNewMessagesData()
                    self?.fetchNewReadAndSentData()
                }
            }
        }
        
        filterBgImageView?.isHidden = true
        trashSpamBgImageView?.isHidden = true
        self.tableView?.reloadData()
    }
    
    func showReadAndSentMessages() {
        tableViewIsEmpty()
        
        tableView?.isHidden = true
        readTableView?.isHidden = false
        spamTableView?.isHidden = true
        trashTableView?.isHidden = true
        self.readTableView?.tag = 20
        self.lastSelectedTableViewTag = self.readTableView?.tag
        if (self.fetchedResultController2 == nil || (self.fetchedResultController2?.fetchedObjects?.count) == 0) {
            self.checkDataStore2()
        } else {
            self.loadData2()
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewReadAndSentData()
            }
        }
        filterBgImageView?.isHidden = true
        trashSpamBgImageView?.isHidden = true
        self.readTableView?.reloadData()
    }
    
    func showMoreButton() {
        
        if self.filterBgImageView?.isHidden == true {
            self.filterBgImageView?.isHidden = false
            self.trashSpamBgImageView?.isHidden = false
        } else {
            self.filterBgImageView?.isHidden = true
            self.trashSpamBgImageView?.isHidden = true
        }
    }
    
    @objc func trashButtonPressed() {
        tableViewIsEmpty()
        
        self.lastSelectedTableViewTag = self.trashTableView?.tag
        self.filterBgImageView?.isHidden = true
        self.trashSpamBgImageView?.isHidden = true
        self.trashTableView?.isHidden = false
        self.tableView?.isHidden = true
        self.readTableView?.isHidden = true
        self.spamTableView?.isHidden = true
        self.checkDataStore3()
        self.trashTableView?.reloadData()
    }
    
    @objc func spamButtonPressed() {
        tableViewIsEmpty()
        
        self.lastSelectedTableViewTag = self.spamTableView?.tag
        self.filterBgImageView?.isHidden = true
        self.trashSpamBgImageView?.isHidden = true
        self.trashTableView?.isHidden = true
        self.tableView?.isHidden = true
        self.readTableView?.isHidden = true
        self.spamTableView?.isHidden = false
        self.checkDataStore4()
        self.spamTableView?.reloadData()
        self.spamTableView?.beginUpdates()
        self.spamTableView?.endUpdates()
    }
    
    func fetchMoreUnreadThreads(_withSkip skip:Int) {

        self.isLoading = true
        let service = ThreadsAPIBridge()
        service.getUnreadConversationsDataWith(_withSkip: skip) { (result) in
            switch result {
            case .Success(let data):
                self.isLoading = false
                self.tableView?.tableFooterView = nil
                if data.count > 0 {
                    self.threadsService = ThreadsService(parentVC: self)
                    self.threadsService?.saveInCoreDataWith(array: data)
                }
                self.shouldLoadMoreNewThreads = true
                self.totalNewMessagesCount = service.totalNewMessagesCount
            case .Error(let message):
                print(message)
                self.isLoading = false
                self.tableView?.tableFooterView = nil
                self.shouldLoadMoreNewThreads = true
            }
        }
    }
    
    func fetchMoreReadThreads(_withSkip skip:Int) {
        self.isLoading = true
        let service = ThreadsAPIBridge()
        service.getReadConversationsDataWith(_withSkip: skip) { (result) in
            switch result {
            case .Success(let data):
                self.isLoading = false
                self.readTableView?.tableFooterView = nil
                if data.count > 0 {
                    self.threadsService = ThreadsService(parentVC: self)
                    self.threadsService?.saveInCoreDataWith2(array: data)
                }
                self.shouldLoadMoreNewThreads = true
                self.totalNewMessagesCount2 = service.totalNewMessagesCount2
            case .Error(let message):
                print(message)
                self.isLoading = false
                self.readTableView?.tableFooterView = nil
                self.shouldLoadMoreNewThreads = true
            }
        }
    }
    
    func fetchMoreTrashThreads(_withSkip skip:Int) {
        self.isLoading = true
        let service = ThreadsAPIBridge()
        service.getTrashDataWith(_withSkip: skip) { (result) in
            switch result {
            case .Success(let data):
                self.isLoading = false
                self.trashTableView?.tableFooterView = nil
                if data.count > 0 {
                    self.threadsService = ThreadsService(parentVC: self)
                    self.threadsService?.saveInCoreDataWith3(array: data)
                }
                self.shouldLoadMoreNewThreads = true
                self.totalNewMessagesCount3 = service.totalNewMessagesCount3
            case .Error(let message):
                print(message)
                self.isLoading = false
                self.trashTableView?.tableFooterView = nil
                self.shouldLoadMoreNewThreads = true
            }
        }
    }
    
    func fetchMoreSpamThreads(_withSkip skip:Int) {
        self.isLoading = true
        let service = ThreadsAPIBridge()
        service.getSpamDataWith(_withSkip: skip) { (result) in
            switch result {
            case .Success(let data):
                self.isLoading = false
                self.spamTableView?.tableFooterView = nil
                if data.count > 0 {
                    self.threadsService = ThreadsService(parentVC: self)
                    self.threadsService?.saveInCoreDataWith4(array: data)
                }
                self.shouldLoadMoreNewThreads = true
                self.totalNewMessagesCount4 = service.totalNewMessagesCount4
            case .Error(let message):
                print(message)
                self.isLoading = false
                self.spamTableView?.tableFooterView = nil
                self.shouldLoadMoreNewThreads = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.checkDataStore()
        
        categoriesDataProvider.requestCategories(completion: { [weak self] result in
            switch result {
            case .Success(let categories):
                self?.categories = categories
            case .Error(let error):
                AlertBar.show(.error, message: error)
            }
        })
    }
    
    @objc func appWillEnterForeground() -> Void {
        if self.lastSelectedTableViewTag == 10 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewMessagesData()
            }
        } else if self.lastSelectedTableViewTag == 20 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewReadAndSentData()
            }
        } else if self.lastSelectedTableViewTag == 30 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewTrashData()
            }
        } else if self.lastSelectedTableViewTag == 40 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewSpamData()
            }
        }
    }
    
    @objc func appEnteredForeground() -> Void {
        if self.lastSelectedTableViewTag == 10 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewMessagesData()
            }
        } else if self.lastSelectedTableViewTag == 20 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewReadAndSentData()
            }
        } else if self.lastSelectedTableViewTag == 30 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewTrashData()
            }
        } else if self.lastSelectedTableViewTag == 40 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewSpamData()
            }
        }
    }
    
    override func loadViewIfNeeded() {
        if let tapStyleString = self.tapStyle {
            if tapStyleString.isEqualToString(find: "double") {
                self.doubleTappedTabBar()
            } else if (tapStyleString.isEqualToString(find: "single")) {

            }
        }
    }
    
    func doubleTappedTabBar() -> Void {
        
        tableViewIsEmpty()
        self.tableView?.isHidden = false
        self.readTableView?.isHidden = true
        self.spamTableView?.isHidden = true
        self.trashTableView?.isHidden = true
        self.tableView?.tag = 10
        self.lastSelectedTableViewTag = self.tableView?.tag
        filterBgImageView?.isHidden = true
        trashSpamBgImageView?.isHidden = true
        self.loadData()
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){ [weak self] in
            guard let is_loading = self?.isLoading else {
                return
            }
            if !is_loading {
                self?.fetchNewMessagesData()
                self?.fetchNewReadAndSentData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(appEnteredForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.fetchedResultController?.delegate = nil
        self.fetchedResultController2?.delegate = nil
        self.fetchedResultController3?.delegate = nil
        self.fetchedResultController4?.delegate = nil
    }
    
    
    //MARK: - swipe and remove methods
    func removeAfterSwipeLeft(with indexPath: IndexPath) {
        //create star animation
        if isFromThreadsDetailVC {
            guard let thread = fetchedResultController?.object(at: indexPath) else { return }
            let cell = tableView?.cellForRow(at: indexPath) as? ThreadsTableViewCell
            cell?.swipeLeftAnimation(completion: { [weak self] _ in
                if let strolngSelf = self {
                    strolngSelf.cellSwipedLeft(thread: thread)
                    strolngSelf.isFromThreadsDetailVC = false
                }
            })
        }
        starredFromThreadsDetailVC = false
    }
    
    func removeAfterSwipeRight(with indexPath: IndexPath) {
        //create read animation
        if isFromThreadsDetailVC {
            guard let thread = fetchedResultController?.object(at: indexPath) else { return }
            let cell = tableView?.cellForRow(at: indexPath) as? ThreadsTableViewCell
            cell?.swipeRightAnimation(completion: { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.cellSwipedRight(thread: thread)
                    strongSelf.isFromThreadsDetailVC = false
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listenToRealTimeEvents()
        
        self.isFromThreadsDetailVC = false
        
        //MARK: - update new messages and read/sent messages
        //that updating need when real time comes and user is on another page
        if self.fromTableViewTag == nil {
            self.fetchNewMessagesData()
            self.fetchNewReadAndSentData()
        }
        
        if self.fromTableViewTag == 10 {
            self.isFromThreadsDetailVC = true
            self.fromTableViewTag = nil
            if let selectedIndex = self.lastSelectedIndexPath {
                if starredFromThreadsDetailVC {
                    removeAfterSwipeLeft(with: selectedIndex)
                    self.lastSelectedIndexPath = nil
                } else {
                    removeAfterSwipeRight(with: selectedIndex)
                    self.lastSelectedIndexPath = nil
                }
            }
        } else if self.fromTableViewTag == 20 {
            self.readTableView?.reloadData()
        } else if self.fromTableViewTag == 30 {
            self.trashTableView?.reloadData()
        } else if self.fromTableViewTag == 40 {
            self.spamTableView?.reloadData()
        }
        self.fromTableViewTag = nil
        self.fetchedResultController?.delegate = delegate
        self.fetchedResultController?.delegate = delegate
        self.fetchedResultController2?.delegate = delegate
        self.fetchedResultController3?.delegate = delegate
        self.fetchedResultController4?.delegate = delegate
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        threadsRealTime.switchOffThreadsRealtimeListener()
    }

    internal func setupView() {
        self.view.backgroundColor = .white
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 66 - (self.tabBarController?.tabBar.frame.size.height)!), style: .plain)
        self.dataSource = ThreadsDataSource(parentVC: self)
        self.delegate = ThreadsDelegate(parentVC: self)
        self.tableView?.delegate = delegate
        self.tableView?.dataSource = dataSource
        self.tableView?.separatorInset = .zero
        self.tableView?.layoutMargins = .zero
        self.tableView?.scrollsToTop = true
        self.tableView?.tag = 10
        self.view.addSubview(self.tableView!)
        self.tableView?.register(ThreadsTableViewCell.self, forCellReuseIdentifier: ThreadsTableViewCell.reuseIdentifier())
        self.tableView?.allowsSelection = true
        self.tableView?.allowsSelectionDuringEditing = true
        self.tableView?.isScrollEnabled = true
        self.tableView?.tableFooterView = UIView()
        registerForPreviewing(with: self, sourceView: self.tableView!)
        self.lastSelectedTableViewTag = self.tableView?.tag
        self.tableView?.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)

        self.readTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 66 - (self.tabBarController?.tabBar.frame.size.height)!), style: .plain)
        self.readTableView?.delegate = delegate
        self.readTableView?.dataSource = dataSource
        self.readTableView?.separatorInset = .zero
        self.readTableView?.layoutMargins = .zero
        self.readTableView?.scrollsToTop = true
        self.readTableView?.tag = 20
        self.view.addSubview(self.readTableView!)
        self.view.bringSubview(toFront: self.readTableView!)
        self.readTableView?.register(ThreadsStarUnstarTableViewCell.self, forCellReuseIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier())
        self.readTableView?.isHidden = true
        readTableView?.allowsSelection = true
        readTableView?.allowsSelectionDuringEditing = true
        self.readTableView?.isScrollEnabled = true
        self.readTableView?.tableFooterView = UIView()
        self.readTableView?.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        trashTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 66 - (self.tabBarController?.tabBar.frame.size.height)!))
        trashTableView?.delegate = delegate
        trashTableView?.dataSource = dataSource
        trashTableView?.scrollsToTop = true
        trashTableView?.tag = 30
        self.view.addSubview(self.trashTableView!)
        trashTableView?.register(ThreadsStarUnstarTableViewCell.self, forCellReuseIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier())
        trashTableView?.separatorInset = .zero
        trashTableView?.layoutMargins = .zero
        trashTableView?.isHidden = true
        trashTableView?.allowsSelection = true
        trashTableView?.allowsSelectionDuringEditing = true
        trashTableView?.tableFooterView = UIView()

        spamTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 66 - (self.tabBarController?.tabBar.frame.size.height)!))
        spamTableView?.delegate = delegate
        spamTableView?.dataSource = dataSource
        spamTableView?.scrollsToTop = true
        spamTableView?.tag = 40
        self.view.addSubview(self.spamTableView!)
        spamTableView?.register(ThreadsStarUnstarTableViewCell.self, forCellReuseIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier())
        spamTableView?.isHidden = true
        spamTableView?.allowsSelection = true
        spamTableView?.separatorInset = .zero
        spamTableView?.layoutMargins = .zero
        spamTableView?.allowsSelectionDuringEditing = true
        spamTableView?.tableFooterView = UIView()
        spamTableView?.refreshControl = refreshControl4
        refreshControl4.addTarget(self, action: #selector(refreshSpamData(_:)), for: .valueChanged)
        
        filterBgImageView = UIImageView(frame: CGRect(x: 0, y: 66, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        filterBgImageView?.image = #imageLiteral(resourceName: "filter_more_white")
        filterBgImageView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterImageTapped))
        filterBgImageView?.isUserInteractionEnabled = true
        filterBgImageView?.addGestureRecognizer(tapGesture)
        self.view.addSubview(filterBgImageView!)
        filterBgImageView?.isHidden = true

        trashSpamBgImageView = UIImageView(frame: CGRect(x: 0.3146666666 * UIScreen.main.bounds.size.width, y: 0.146666666 * UIScreen.main.bounds.size.width, width: 0.68 * UIScreen.main.bounds.size.width, height: 0.3333333333 * UIScreen.main.bounds.size.width))
        trashSpamBgImageView?.image = #imageLiteral(resourceName: "trash_spam_header_bg")
        trashSpamBgImageView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        trashSpamBgImageView?.isUserInteractionEnabled = true
        self.view.addSubview(trashSpamBgImageView!)
        trashSpamBgImageView?.isHidden = true
        
        trashButton = UIButton.init(type: .custom)
        trashButton?.frame = CGRect(x: 0, y: 11, width: (trashSpamBgImageView?.frame.size.width)!, height: 48)
        trashButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        trashButton?.addTarget(self, action: #selector(self.trashButtonPressed), for: .touchUpInside)
        self.trashSpamBgImageView?.addSubview(trashButton!)
        
        spamButton = UIButton.init(type: .custom)
        spamButton?.frame = CGRect(x: 0, y: (trashButton?.frame.origin.y)! + (trashButton?.frame.size.height)! + 5, width: (trashSpamBgImageView?.frame.size.width)!, height: 48)
        spamButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        spamButton?.addTarget(self, action: #selector(self.spamButtonPressed), for: .touchUpInside)
        trashSpamBgImageView?.addSubview(spamButton!)
        
        alertButton = UIButton(type: .custom)
        let screenWidth = UIScreen.main.bounds.width
        
        let buttonOriginX = (94/375)*screenWidth
        var buttonOriginY = (500/375)*screenWidth
        let buttonHeight = (46/375)*screenWidth
        let buttonWidth = (185/375)*screenWidth
        let tabBarOriginY = tabBarController?.tabBar.frame.origin.y
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navigationControllerHeigh: CGFloat = 44
        if let navControllerHeigh = navigationController?.navigationBar.frame.height {
            navigationControllerHeigh = navControllerHeigh
        }
        buttonOriginY = tabBarOriginY! - buttonHeight - statusBarHeight - navigationControllerHeigh - 15
        
        if #available(iOS 11.0, *) {
            buttonOriginY -= ((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!
        }
        
        alertButton.frame = CGRect(x: buttonOriginX, y: buttonOriginY, width: buttonWidth, height: buttonHeight)
        alertButton.titleLabel?.textColor = .black
        alertButton.titleLabel?.font = ThreadsViewController.alertButtonFont
        self.view.addSubview(alertButton)
        self.alertButton.isHidden = true
        
        let labelOriginX = buttonOriginX
        let labelOriginY = buttonOriginY - (3/375)*screenWidth
        
        alertButtonLabel = UILabel.init(frame: CGRect(x: labelOriginX, y: labelOriginY, width: buttonWidth, height: buttonHeight))
        alertButtonLabel.textAlignment = .left
        alertButtonLabel.font = ThreadsViewController.AlertButtonLabelFont
        alertButtonLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertButtonLabel.backgroundColor = .clear
        alertButtonLabel.textAlignment = .center
        self.view.addSubview(alertButtonLabel)
        alertButtonLabel.isHidden = true
        
        self.noNewMessageLabel = UILabel(frame: CGRect(x: 0.096 * self.view.frame.size.width, y: 0.752 * self.view.frame.size.width, width: 0.8106666666 * self.view.frame.size.width, height: 0.0586666666 * self.view.frame.size.width))
        self.noNewMessageLabel.textColor = UIColor.gray
        self.noNewMessageLabel.font = ThreadsViewController.noNewMessageLabelFont
        self.noNewMessageLabel.text = Localized.string(forKey: LocalizedString.ThreadsViewNoNewMessageLabelTitle)
        self.noNewMessageLabel.textAlignment = .center
        self.view.addSubview(self.noNewMessageLabel)
        
        self.smileFaceImageView = UIImageView(frame: CGRect(x: 0.4346666666 * self.view.frame.size.width, y: 0.8613333333 * self.view.frame.size.width, width: 0.13066666666 * self.view.frame.size.width, height: 0.1306666666 * self.view.frame.size.width))
        self.smileFaceImageView.image = #imageLiteral(resourceName: "emoticon_square_smiling_face_with_closed_eyes")
        self.view.addSubview(self.smileFaceImageView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tap.numberOfTapsRequired = 1
        self.filterBgImageView?.isUserInteractionEnabled = true
        filterBgImageView?.addGestureRecognizer(tap)
        
    }
    
    @objc func backgroundTapped() {
        filterBgImageView?.isHidden = true
        trashSpamBgImageView?.isHidden = true
        
    }
    
    //MARK: - tap on filterImage
    @objc func filterImageTapped(_ sender: AnyObject) {
        self.filterBgImageView?.isHidden = true
        self.trashSpamBgImageView?.isHidden = true
        
        if lastSelectedTableViewTag == tableView?.tag {
            tableView?.reloadSections(IndexSet(integersIn: 0...0), with: .none)
        } else if lastSelectedTableViewTag == readTableView?.tag {
            readTableView?.reloadSections(IndexSet(integersIn: 0...0), with: .none)
        } else if lastSelectedTableViewTag == trashTableView?.tag {
            trashTableView?.reloadSections(IndexSet(integersIn: 0...0), with: .none)
        } else if lastSelectedTableViewTag == spamTableView?.tag {
            spamTableView?.reloadSections(IndexSet(integersIn: 0...0), with: .none)
        }
    }
    
    // table is empty
    func tableViewIsEmpty() {
        self.smileFaceImageView.isHidden = false
        self.noNewMessageLabel.isHidden = false
        self.tableView?.separatorStyle = .none
    }
    func tableViewIsNotEmpty() {
        self.smileFaceImageView.isHidden = true
        self.noNewMessageLabel.isHidden = true
        self.tableView?.separatorStyle = .singleLine
    }
    
    // New Messages
    func checkDataStore() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "unread = \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "category == %@", "conversations")
        let predicate3 = NSPredicate(format: "inbox = \(NSNumber(value:true))")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getThreadsFromBackend()
            } else {
                self.loadData()
                // check for new data after 0.1sec
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){ [weak self] in
                    guard let is_loading = self?.isLoading else {
                        return
                    }
                    if !is_loading {
                        self?.fetchNewMessagesData()
                        self?.fetchNewReadAndSentData()
                    }
                }
                let when2 = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when2, execute: {
                    self.fetchNewConversationMessagesIntheBackground()
                    self.fetchConversationMessagesIntheBackground()
                })

            }

        }
        catch {
            print("Error in counting")
        }
    }
    
    func checkDataStoreA() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "unread = \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "category == %@", "conversations")
        let predicate3 = NSPredicate(format: "inbox = \(NSNumber(value:true))")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getThreadsFromBackend()
            } else {
                self.loadData()
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.fetchNewMessagesData()
                    self.fetchNewReadAndSentData()
                }
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getLatestThreadsFromBackend() {
        let service = ThreadsAPIBridge()
        service.getUnreadConversationsDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadData() {
        self.threadsService = ThreadsService(parentVC: self)
        self.fetchedResultController = self.threadsService?.getAllUnreadConversations(withAscendingOrder: sortAscending)
        if self.fetchedResultController?.fetchedObjects?.count == 0 {
            self.tableViewIsEmpty()
        } else {
            self.tableViewIsNotEmpty()
        }
        self.fetchedResultController?.delegate = delegate
        self.tableView?.reloadData()
    }
    
    func getThreadsFromBackend() {
        
        self.isLoading = true
        loader.show()
        let service = ThreadsAPIBridge()
        service.getUnreadConversationsDataWith(completion: ) { [weak self] (result) in
            if let strongSelf = self {
                strongSelf.loader.hide()
                switch result {
                case .Success(let data):
                    strongSelf.threadsService = ThreadsService(parentVC: strongSelf)
                    strongSelf.threadsService?.saveInCoreDataWith(array: data)
                    strongSelf.totalNewMessagesCount = service.totalNewMessagesCount
                    strongSelf.fetchedCount = strongSelf.fetchedCount + Int32(data.count)
                    strongSelf.isLoading = false
                case .Error(let message):
                    print(message)
                    strongSelf.isLoading = false
                }
            }
        }
    }
    
    func listenToRealTimeEvents() {
        threadsRealTime.getRealTimeDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    self.threadsService = ThreadsService(parentVC: self)
                    let deadlineTime = DispatchTime.now() + 5
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.threadsService?.saveInCoreDataWithRealtimeEvents(array: data as [[String : AnyObject]])
                    }
                    
                }
            case .Error(let message):
                print(message)
            }
        }
    }
    
    
    // Read and Sent
    func checkDataStore2() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "unread = \(NSNumber(value:false))")
        let predicate2 = NSPredicate(format: "category == %@", "conversations")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getReadAndSentFromBackend()
                self.readTableView?.reloadData()
            } else {
                self.loadData2()
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.fetchNewMessagesData()
                    self.fetchNewReadAndSentData()
                }
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getReadAndSentFromBackend() {
        loader.show()
        let service = ThreadsAPIBridge()
        service.getReadConversationsDataWith(completion: ) { (result) in
            self.loader.hide()
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith2(array: data)
                self.totalNewMessagesCount2 = service.totalNewMessagesCount2
                self.fetchedCount2 = self.fetchedCount2 + Int32(data.count)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func getLatestReadAndSentFromBackend() {
        let service = ThreadsAPIBridge()
        service.getReadConversationsDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith2(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadData2() {
        self.threadsService = ThreadsService(parentVC: self)
//        self.fetchedResultController2 = nil
        self.fetchedResultController2 = self.threadsService?.getAllReadConversations(withAscendingOrder: sortAscending2)
        if self.fetchedResultController2?.fetchedObjects?.count == 0 {
            self.tableViewIsEmpty()
        } else {
            self.tableViewIsNotEmpty()
        }
        self.fetchedResultController2?.delegate = delegate
        self.readTableView?.reloadData()
    }
    
    //Trash
    func checkDataStore3() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "trash = \(NSNumber(value:true))")
        request.predicate = predicate1
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getTrashFromBackend()
            } else {
                self.loadData3()
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.fetchNewTrashData()
                }
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getTrashFromBackend() {
        loader.show()
        let service = ThreadsAPIBridge()
        service.getTrashDataWith(completion: ) { (result) in
            self.loader.hide()
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith3(array: data)
                self.totalNewMessagesCount3 = service.totalNewMessagesCount3
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func getLatestTrashFromBackend() {
        let service = ThreadsAPIBridge()
        service.getTrashDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith3(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadData3() {
        self.threadsService = ThreadsService(parentVC: self)
        self.fetchedResultController3 = nil
        self.fetchedResultController3 = self.threadsService?.getTrashConversations(withAscendingOrder: sortAscending3)
        if self.fetchedResultController3?.fetchedObjects?.count == 0 {
            self.tableViewIsEmpty()
        } else {
            self.tableViewIsNotEmpty()
        }
        self.fetchedResultController3?.delegate = delegate
    }
    
    //Spam
    func checkDataStore4() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "spam = \(NSNumber(value:true))")
        request.predicate = predicate1
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getSpamFromBackend()
            } else {
                self.loadData4()
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.fetchNewSpamData()
                }
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getSpamFromBackend() {
        loader.show()
        let service = ThreadsAPIBridge()
        service.getSpamDataWith(completion: ) { (result) in
            self.loader.hide()
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith4(array: data)
                self.totalNewMessagesCount4 = service.totalNewMessagesCount4
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func getLatestSpamFromBackend() {
        let service = ThreadsAPIBridge()
        service.getSpamDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                self.threadsService = ThreadsService(parentVC: self)
                self.threadsService?.saveInCoreDataWith4(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadData4() {
        self.threadsService = ThreadsService(parentVC: self)
        self.fetchedResultController4 = nil
        self.fetchedResultController4 = self.threadsService?.getSpamConversations(withAscendingOrder: sortAscending4)
        if self.fetchedResultController4?.fetchedObjects?.count == 0 {
            self.tableViewIsEmpty()
        } else {
            self.tableViewIsNotEmpty()
        }
        self.fetchedResultController4?.delegate = delegate
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }
    
    func pullUserFromFeathers() {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if userObject["primary_account_id"] != nil {
                let primaryAccountID = userObject["primary_account_id"] as! String
                let query = Query()
                    .eq(property: "account_id", value: primaryAccountID).limit(20)
                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
//                    print(response)
                }).startWithFailed { (error) in
                    print(error)
                }
            }
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView?.indexPathForRow(at: location) {
            //This will show the cell clearly and blur the rest of the screen for our peek.
            previewingContext.sourceRect = (tableView?.rectForRow(at: indexPath))!
            return viewControllerForIndexPath(indexPath: indexPath)
        }
        return nil
    }
    
    func viewControllerForIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let peepVC = ThreadsDetailViewController()
        let thread : Threads = self.fetchedResultController!.object(at: indexPath)
        if thread.id != nil {
            peepVC.threadId = thread.id
            peepVC.threadAccountId = thread.account_id
            peepVC.threadToRead = thread
            let subject = thread.subject
            if  let title = subject, !title.isEmpty {
                peepVC.subjectTitle = title
            }
            peepVC.starred = thread.starred
            peepVC.fromTableViewTag = tableView?.tag
            self.fromTableViewTag = tableView?.tag
            self.lastSelectedIndexPath = indexPath
        }
        return peepVC

    }
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }

    @objc func markThreadAsStarredOrUnstarred(threadId: String, starred: Bool, unread: Bool, accountId: String, tableViewTag: Int, indexPath: IndexPath) {

        let threadsService = ThreadsService.init(parentVC: self)
        threadsService.updateStarredValue(threadId: threadId, starredValue: starred, unreadValue: unread)
        if pendingRequestWorkItems[threadId] != nil {
            pendingRequestWorkItems[threadId]?.cancel()
        }
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard self != nil else { return }
            let service = ThreadsAPIBridge()
            service.markThreadAsStarredOrUnstarred(threadId: threadId, accountId: accountId, starred: starred, unread: unread, completion: { [weak self] (result) in
                guard self != nil else { return }
                switch result {
                case .Success( _):
                    print("success")
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        self?.isLoading = false
                    }
                case .Error(let message):
                    print(message)
                    self?.isLoading = false
                }
            })
        }
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItems[threadId] = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2,
                                      execute: requestWorkItem)
    }

    @objc func undoStarredUnstarredAction(threadId: String, starred: Bool, unread: Bool, accountId: String, tableViewTag: Int, indexPath: IndexPath) {
        
        var starredValue = starred
        let unreadValue = unread
        if !starredValue {
            starredValue = true
            self.alertButton.setBackgroundImage( nil, for: .normal)
            self.alertButtonLabel.text = ""
        } else {
            starredValue = false
            self.alertButton.setBackgroundImage( nil, for: .normal)
            self.alertButtonLabel.text = ""
        }
        self.markThreadAsStarredOrUnstarred(threadId: threadId, starred: starredValue, unread: unreadValue, accountId: accountId, tableViewTag: tableViewTag, indexPath: indexPath)
        self.alertButton.isHidden = true
        self.alertButtonLabel.isHidden = true
        
    }
    
    func undoDeletedStarredCell(threadId: String, starred: Bool, unread: Bool, accountId: String, tableViewTag: Int, indexPath: IndexPath) {
        
        let starredValue = false
        let unreadValue = true
        self.markThreadAsStarredOrUnstarred(threadId: threadId, starred: starredValue, unread: unreadValue, accountId: accountId, tableViewTag: tableViewTag, indexPath: indexPath)
        self.alertButton.isHidden = true
        self.alertButtonLabel.isHidden = true
    }
    
    func reload(tableView: UITableView) {
        let contentOffset = self.tableViewContentOffset
        if tableView.tag == 10 {
            self.tableView?.reloadData()
            self.tableView?.layoutIfNeeded()
            self.tableView?.setContentOffset(contentOffset, animated: false)
        } else if tableView.tag == 20 {
            self.readTableView?.reloadData()
            self.readTableView?.layoutIfNeeded()
            self.readTableView?.setContentOffset(contentOffset, animated: false)
        } else if tableView.tag == 30 {
            self.trashTableView?.reloadData()
            self.trashTableView?.layoutIfNeeded()
            self.trashTableView?.setContentOffset(contentOffset, animated: false)
        } else if tableView.tag == 40 {
            self.spamTableView?.reloadData()
            self.spamTableView?.layoutIfNeeded()
            self.spamTableView?.setContentOffset(contentOffset, animated: false)
        }
    }
    
    @objc private func refreshNewMessagesData(_ sender: Any) {
        // Fetch New Data
        fetchNewMessagesData()
    }
    
    private func fetchNewMessagesData() {
        self.isLoading = true
        let service = ThreadsAPIBridge()
        service.getUnreadConversationsDataWith(completion: ) { [weak self] result in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    strongSelf.threadsService = ThreadsService(parentVC: strongSelf)
                    strongSelf.threadsService?.saveInCoreDataWithRealtimeEvents(array: data)
                    strongSelf.loadData()
                    strongSelf.isLoading = false
                case .Error(let message):
                    print(message)
                    strongSelf.isLoading = false
                }
            }
        }
    }
    
    func refreshAccessToken() {

        let token = KeychainSwift().get(JuneConstants.Feathers.jwtToken)!
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": "local",
            "accessToken": token
            ])
            .on(value: { response in
                print("success")
            })
            .startWithFailed { (error) in
                print(error)
        }

    }
    
    @objc private func refreshReadAndSentData(_ sender: Any) {
        // Fetch New Data
        fetchNewReadAndSentData()
    }
    
    private func fetchNewReadAndSentData() {
        let service = ThreadsAPIBridge()
        service.getReadConversationsDataWith { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    strongSelf.threadsService = ThreadsService(parentVC: strongSelf)
                    strongSelf.threadsService?.saveInCoreDataWithRealtimeEvents(array: data)
                    strongSelf.loadData2()
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    @objc private func refreshTrashData(_ sender: Any) {
        // Fetch New Data
        fetchNewTrashData()
    }
    
    private func fetchNewTrashData() {
        let service = ThreadsAPIBridge()
        service.getTrashDataWith { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    strongSelf.threadsService = ThreadsService(parentVC: strongSelf)
                    strongSelf.threadsService?.saveInCoreDataWithRealtimeEvents(array: data)
                    strongSelf.loadData3()
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    @objc private func refreshSpamData(_ sender: Any) {
        // Fetch New Data
        fetchNewSpamData()
    }
    
    private func fetchNewSpamData() {
        let service = ThreadsAPIBridge()
        service.getSpamDataWith { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    strongSelf.threadsService = ThreadsService(parentVC: strongSelf)
                    strongSelf.threadsService?.saveInCoreDataWithRealtimeEvents(array: data)
                    strongSelf.loadData4()
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    private func fetchNewConversationMessagesIntheBackground() {
        if self.fetchedResultController?.fetchedObjects?.isEmpty == false {
            self.newConversationBackUpArray = Array((self.fetchedResultController?.fetchedObjects)!.prefix(10))
            self.fetchFirstTenMessagesFromEachThreadsOfNewConversations()
        }
    }
    
    private func fetchFirstTenMessagesFromEachThreadsOfNewConversations() {
        for thread in self.newConversationBackUpArray {
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                self.getMessagesFromBackendInTheBackgroundThread(thread: thread)
            }
        }
    }
    
    private func getMessagesFromBackendInTheBackgroundThread(thread: Threads) {
        print("This is run on the background queue")
        guard let thread_id = thread.id else {
            return
        }
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: thread_id) { (result) in
            switch result {
            case .Success(let data):
                let messagesService = ThreadsService(parentVC: self)
                messagesService.saveMessagesInCoreDataWith(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    private func fetchConversationMessagesIntheBackground() {
        if self.fetchedResultController2?.fetchedObjects?.isEmpty == false {
            self.conversationBackUpArray = Array((self.fetchedResultController2?.fetchedObjects)!.prefix(10))
            self.fetchFirstTenMessagesFromEachThreadsOfConversations()
        }
    }
    
    private func fetchFirstTenMessagesFromEachThreadsOfConversations() {
        for thread in self.conversationBackUpArray {
            DispatchQueue.global(qos: .background).async {
                self.getMessagesFromBackendInTheBackgroundThread2(thread: thread)
            }
        }
    }
    
    private func getMessagesFromBackendInTheBackgroundThread2(thread: Threads) {
        guard let thread_id = thread.id else {
            return
        }
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: thread_id) { (result) in
            switch result {
            case .Success(let data):
                let messagesService = ThreadsService(parentVC: self)
                messagesService.saveMessagesInCoreDataWith(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
}

extension ThreadsViewController: ThreadsDetailViewControllerDelegate {
    func actionInDetailViewController(_ controller: ThreadsDetailViewController, unread: Bool, seen: Bool, inbox: Bool, starredValueChanged: Bool, thread: Threads) {
        starredFromThreadsDetailVC = starredValueChanged
    }
    
    func controller(_ controller: ThreadsDetailViewController, starred isStarred: Bool) {
        starredFromThreadsDetailVC = isStarred
    }
    
    func recategorizeValue(_controller: ThreadsDetailViewController, category: String) {
        categoryFromThreadsDetailVC = category
    }
}
