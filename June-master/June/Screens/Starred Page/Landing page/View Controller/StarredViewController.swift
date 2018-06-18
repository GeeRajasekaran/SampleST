//
//  StarredViewController.swift
//  June
//
//  Created by Tatia Chachua on 05/09/17.
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

struct CustomStarredAction: StarredSwipeAction {
    var title: String
    var color: UIColor
}

class StarredViewController: UIViewController, StarredTableViewCellDelegate, StarredHeaderViewCellDelegate, NVActivityIndicatorViewable {
    
    var tableView: UITableView?
    var feedTable: UITableView?
    var tapStyle: String?

    var dataSource: StarredDataSource?
    var delegate: StarredDelegate?
    
    var fetchedResultController: NSFetchedResultsController<Threads>!
    var starredService: StarredService?
    var threadToStar: Threads?
    var sortAscending = false
    var isLoading = false
    var dataArray: [NSFetchRequestResult] = []
    var totalNewMessagesCount = 0
    var fetchedCount: Int32 = 0
    private var pendingRequestWorkItem: DispatchWorkItem?
    var fetchMoreRequestWorkItem: DispatchWorkItem?
    private var alertButton: UIButton!
    private var alertButtonLabel = UILabel()
    var lastSelectedTableViewTag: Int?

    // StarredFeed
    var fetchedResultController2: NSFetchedResultsController<Threads>!
    var starredService2: StarredService?
    var sortAscending2 = false
    var starredList2 = [Threads]()
    var dataArray2: [NSFetchRequestResult] = []
    var totalNewMessagesCount2: Int32 = 0
    var fetchedCount2: Int32 = 0
    
    var realTimeListener: StarredRealTimeListener?
    
    // Empty state
    var noNewMessageLabel: UILabel!
    var smileFaceImageView: UIImageView!
    
    var shouldLoadNextMessages = true
    var shouldLoadNextFeedItems = true
    
    lazy var loader: Loader = {
        let loader = Loader(with: self)
        return loader
    }()
    var starredConversationBackUpArray = [Threads]()
    var feedConversationBackUpArray = [Threads]()
    
    static let alertButtonTitleFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let noNewMessagesLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .extraMid)
    
    func cellSwipedLeft(indexPath: IndexPath) {
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        //unstar messages
        if tableView?.isHidden == false {
            let isIndexValid = self.fetchedResultController.fetchedObjects?.indices.contains(indexPath.row)
            if isIndexValid! {
                threadToStar = fetchedResultController.object(at: indexPath)
                let threadId = threadToStar?.id
                let accountId = threadToStar?.account_id
                let starred = false
                self.starredService = StarredService(parentVC: self)
                self.starredService?.updateStarredValue(threadId: threadId!, starredValue: starred)
                self.tableView?.reloadData()
                let tableViewTag = self.tableView?.tag
                let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                })
                self.alertButton.removeActions(for: .allEvents)
                self.alertButton.add(event: .touchUpInside) {
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                    timer.invalidate()
                    self.undoDeletedStarredCell(threadId: threadId!, starred: starred, accountId: accountId!, tableViewTag: tableViewTag!)
                }
                self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
                self.alertButtonLabel.text = ""
                self.alertButton.isHidden = false
                self.alertButtonLabel.isHidden = false
                
                pendingRequestWorkItem?.cancel()
                // Wrap our request in a work item
                let requestWorkItem = DispatchWorkItem { //[weak self] in
                    let service = StarredAPIBridge()
                    service.markAsUnstarred(threadId: threadId!, accountId: accountId!) { (result) in
                        switch result {
                        case .Success(let data):
                            print(data)
                        case .Error(let message):
                            print(message)
                        }
                    }
                }
                // Save the new work item and execute it after 250 ms
                pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 5,
                                              execute: requestWorkItem)
            }
        }
        
        // unstar feed
        if feedTable?.isHidden == false {
             let isIndexValid = self.fetchedResultController2.fetchedObjects?.indices.contains(indexPath.row)
            if isIndexValid! {
                threadToStar = fetchedResultController2.object(at: indexPath)
                let threadId = threadToStar?.id
                let accountId = threadToStar?.account_id
                let starred = false
                self.starredService2 = StarredService(parentVC: self)
                self.starredService2?.updateStarredValue(threadId: threadId!, starredValue: starred)
                self.feedTable?.reloadData()
                let tableViewTag = self.feedTable?.tag
                let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                })
                self.alertButton.removeActions(for: .allEvents)
                self.alertButton.add(event: .touchUpInside) {
                    timer.invalidate()
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                    self.undoDeletedStarredCell(threadId: threadId!, starred: starred, accountId: accountId!, tableViewTag: tableViewTag!)
                }
                self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
                self.alertButtonLabel.text = ""
                self.alertButton.isHidden = false
                self.alertButtonLabel.isHidden = false
                
                pendingRequestWorkItem?.cancel()
                // Wrap our request in a work item
                let requestWorkItem = DispatchWorkItem { //[weak self] in
                    let service = StarredAPIBridge()
                    service.markAsUnstarred(threadId: threadId!, accountId: accountId!) { (result) in
                        switch result {
                        case .Success(let data):
                            print(data)
                        case .Error(let message):
                            print(message)
                        }
                    }
                }
                // Save the new work item and execute it after 250 ms
                pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 5,
                                              execute: requestWorkItem)
                
            }
        }
    }
    
    func cellSwipedRight(indexPath: IndexPath) {
        
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false
        
        // unstar messages
        if tableView?.isHidden == false {
            let isIndexValid = self.fetchedResultController.fetchedObjects?.indices.contains(indexPath.row)
            if isIndexValid! {
                threadToStar = fetchedResultController.object(at: indexPath)
                let threadId = threadToStar?.id
                let accountId = threadToStar?.account_id
                let starred = false
                self.starredService = StarredService(parentVC: self)
                self.starredService?.updateStarredValue(threadId: threadId!, starredValue: starred)
                self.tableView?.reloadData()
                let tableViewTag = self.tableView?.tag
                let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                })
                self.alertButton.removeActions(for: .allEvents)
                self.alertButton.add(event: .touchUpInside) {
                    timer.invalidate()
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                    self.undoDeletedStarredCell(threadId: threadId!, starred: starred, accountId: accountId!, tableViewTag: tableViewTag!)
                }
                self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
                self.alertButtonLabel.text = ""
                self.alertButton.isHidden = false
                self.alertButtonLabel.isHidden = false
                pendingRequestWorkItem?.cancel()
                // Wrap our request in a work item
                let requestWorkItem = DispatchWorkItem { //[weak self] in
                    let service = StarredAPIBridge()
                    service.markAsUnstarred(threadId: threadId!, accountId: accountId!) { (result) in
                        switch result {
                        case .Success(let data):
                            print(data)
                        case .Error(let message):
                            print(message)
                        }
                    }
                }
                // Save the new work item and execute it after 250 ms
                pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 5,
                                              execute: requestWorkItem)
            }
        }
        
        // unstar feed
        if feedTable?.isHidden == false {
            let isIndexValid = self.fetchedResultController2.fetchedObjects?.indices.contains(indexPath.row)
            if isIndexValid! {
                threadToStar = fetchedResultController2.object(at: indexPath)
                let threadId = threadToStar?.id
                let accountId = threadToStar?.account_id
                let starred = false
                self.starredService2 = StarredService(parentVC: self)
                self.starredService2?.updateStarredValue(threadId: threadId!, starredValue: starred)
                self.feedTable?.reloadData()
                let tableViewTag = self.feedTable?.tag
                let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                })
                self.alertButton.removeActions(for: .allEvents)
                self.alertButton.add(event: .touchUpInside) {
                    timer.invalidate()
                    self.alertButton.isHidden = true
                    self.alertButtonLabel.isHidden = true
                    self.undoDeletedStarredCell(threadId: threadId!, starred: starred, accountId: accountId!, tableViewTag: tableViewTag!)
                }
                self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
                self.alertButtonLabel.text = ""
                self.alertButton.isHidden = false
                self.alertButtonLabel.isHidden = false
                pendingRequestWorkItem?.cancel()
                // Wrap our request in a work item
                let requestWorkItem = DispatchWorkItem { //[weak self] in
                    let service = StarredAPIBridge()
                    service.markAsUnstarred(threadId: threadId!, accountId: accountId!) { (result) in
                        switch result {
                        case .Success(let data):
                            print(data)
                        case .Error(let message):
                            print(message)
                        }
                    }
                }
                // Save the new work item and execute it after 250 ms
                pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 5,
                                              execute: requestWorkItem)
            }
        }
    }
    
    func showMessages() {
        tableViewIsEmpty()

        self.tableView?.isHidden = false
        self.feedTable?.isHidden = true
        self.tableView?.tag = 10
        self.lastSelectedTableViewTag = 10
        if (self.fetchedResultController == nil || (self.fetchedResultController.fetchedObjects?.count) == 0) {
            self.checkDataStore()
        } else {
            loadData()
//            self.tableView?.reloadData()
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewStarredMessagesData()
            }
        }
        self.tableView?.reloadData()
    }
    
    func showStarredFeeds() {
        
        self.tableView?.isHidden = true
        self.feedTable?.isHidden = false
        self.feedTable?.tag = 20
        self.lastSelectedTableViewTag = 20
        if (self.fetchedResultController2 == nil || (self.fetchedResultController2.fetchedObjects?.count) == 0) {
            self.checkDataStore2()
        } else {
            loadData2()
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewFeedData()
            }
        }
        self.feedTable?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupView()
        self.checkDataStore()
        self.lastSelectedTableViewTag = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeForRealTimeEvents()
        NotificationCenter.default.addObserver(self, selector:#selector(appWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
        NotificationCenter.default.removeObserver(self)
        self.fetchedResultController?.delegate = nil
        self.fetchedResultController2?.delegate = nil
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchedResultController?.delegate = delegate
        self.fetchedResultController2?.delegate = delegate

    }
    
    //MARK: - real time listener
    func subscribeForRealTimeEvents() {
        realTimeListener = StarredRealTimeListener()
        realTimeListener?.subscribeForPatch(event: onPatch)
    }
    
    func unsubscribe() {
        realTimeListener?.unsubscribe()
        realTimeListener = nil
    }
    
    //MARK: - on patch
    lazy var onPatch: ([[String: Any]]) -> Void = { [weak self] data in
        if let unwrappedSelf = self {
            if data.count > 0 {
                unwrappedSelf.starredService = StarredService(parentVC: unwrappedSelf)
                unwrappedSelf.starredService?.saveInCoreDataWithRealtimeEvents(array: data as [[String : AnyObject]])
            }
        }
    }
    
    @objc func appWillEnterForeground() -> Void {
        if self.lastSelectedTableViewTag == 10 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewStarredMessagesData()
            }
        } else if self.lastSelectedTableViewTag == 20 {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.fetchNewFeedData()
            }
        }
    }
    
    override func loadViewIfNeeded() {
        if let tapStyleString = self.tapStyle {
            if tapStyleString.isEqualToString(find: "double") {
                self.doubleTappedTabBar()
            } else if (tapStyleString.isEqualToString(find: "single")) {
                //                let when = DispatchTime.now() + 0.1
                //                DispatchQueue.main.asyncAfter(deadline: when){
                //                    self.fetchNewMessagesData()
                //                    self.fetchNewReadAndSentData()
                //                }
            }
        }
    }
    
    func doubleTappedTabBar() -> Void {
        tableViewIsEmpty()
        self.tableView?.isHidden = false
        self.feedTable?.isHidden = true
        self.tableView?.tag = 10
        loadData()
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            self.fetchNewStarredMessagesData()
        }
    }
    
    func setupView() {
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 66 - (self.tabBarController?.tabBar.frame.size.height)!))
        self.dataSource = StarredDataSource(parentVC: self)
        self.delegate = StarredDelegate(parentVC: self)
        self.tableView?.delegate = delegate
        self.tableView?.dataSource = dataSource
        self.tableView?.separatorInset = .zero
        self.tableView?.layoutMargins = .zero
        self.tableView?.scrollsToTop = true
        self.tableView?.isHidden = false
        self.tableView?.tag = 10
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        self.tableView?.register(StarredTableViewCell.self, forCellReuseIdentifier: StarredTableViewCell.reuseIdentifier())
        self.tableView?.allowsSelection = true
        self.tableView?.allowsSelectionDuringEditing = true
        
        self.feedTable = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 66 - (self.tabBarController?.tabBar.frame.size.height)!))
        self.feedTable?.delegate = delegate
        self.feedTable?.dataSource = dataSource
        self.feedTable?.separatorInset = .zero
        self.feedTable?.layoutMargins = .zero
        self.feedTable?.scrollsToTop = true
        self.feedTable?.tag = 20
        self.feedTable?.tableFooterView = UIView()
        self.view.addSubview(self.feedTable!)
        self.feedTable?.register(StarredTableViewCell.self, forCellReuseIdentifier: StarredTableViewCell.reuseIdentifier())
        self.feedTable?.isHidden = true
        
        alertButton = UIButton(type: .custom)
        alertButton.frame = CGRect(x: 94, y: 500, width: 185, height: 46)
        alertButton.titleLabel?.textColor = .black
        alertButton.titleLabel?.font = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
        self.view.addSubview(alertButton)
        self.alertButton.isHidden = true
        
        alertButtonLabel = UILabel.init(frame: CGRect(x: 94, y: 497, width: 185, height: 46))
        alertButtonLabel.textAlignment = .left
        alertButtonLabel.font = StarredViewController.alertButtonTitleFont
        alertButtonLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertButtonLabel.backgroundColor = .clear
        alertButtonLabel.textAlignment = .center
        self.view.addSubview(alertButtonLabel)
        alertButtonLabel.isHidden = true
        
        self.noNewMessageLabel = UILabel(frame: CGRect(x: 0.096 * self.view.frame.size.width, y: 0.752 * self.view.frame.size.width, width: 0.8106666666 * self.view.frame.size.width, height: 0.0586666666 * self.view.frame.size.width))
        self.noNewMessageLabel.textColor = UIColor.gray
        self.noNewMessageLabel.font = StarredViewController.noNewMessagesLabelFont
        self.noNewMessageLabel.text = "No new messages"
        self.noNewMessageLabel.textAlignment = .center
        self.view.addSubview(self.noNewMessageLabel)

        self.smileFaceImageView = UIImageView(frame: CGRect(x: 0.4346666666 * self.view.frame.size.width, y: 0.8613333333 * self.view.frame.size.width, width: 0.13066666666 * self.view.frame.size.width, height: 0.1306666666 * self.view.frame.size.width))
        self.smileFaceImageView.image = #imageLiteral(resourceName: "emoticon_square_smiling_face_with_closed_eyes")
        self.view.addSubview(self.smileFaceImageView)
    }
    
    // tableview empty 
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
    
    // Starred
    func checkDataStore() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "starred = \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "section == %@", "convos")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            print(threadsCount as Any)
            if threadsCount == 0 {
                self.getStarredMessagesFromBackend()
            } else {
                self.loadData()
                let when = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.fetchNewStarredMessagesData()
                }
                let when2 = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when2, execute: {
                    self.fetchStarredConversationMessagesIntheBackground()
                    self.fetchStarredFeedMessagesIntheBackground()
                })
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func loadData() {
        self.starredService = StarredService(parentVC: self)
        self.fetchedResultController = self.starredService?.getAllStarreddConversations(withAscendingOrder: sortAscending)
        if self.fetchedResultController?.fetchedObjects?.count == 0 {
            self.tableViewIsEmpty()
        } else {
            self.tableViewIsNotEmpty()
        }
        self.fetchedResultController.delegate = delegate
//        self.tableView?.reloadData()
    }
    
    func getStarredMessagesFromBackend() {
        let service = StarredAPIBridge()
        service.getStarredConversationsDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                print(data)
                self.starredService = StarredService(parentVC: self)
                self.starredService?.saveInCoreDataWith(array: data)
                self.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                self.fetchedCount = self.fetchedCount + Int32(data.count)
            case .Error(let message):
                print(message)
                self.showErrorAlert(message: message)
            }
        }
    }
    
    func fetchMoreStarredMessages(_withSkip skip:Int) {
        self.isLoading = true
        let service = StarredAPIBridge()
        service.getStarredConversationsDataWith(_withSkip: skip) { (result) in
            switch result {
            case .Success(let data):
                self.isLoading = false
                self.tableView?.tableFooterView?.isHidden = true
                if data.count == 0 {
                    self.tableView?.tableFooterView = nil
                    self.shouldLoadNextMessages = false
                    return
                }
                self.starredService = StarredService(parentVC: self)
                self.starredService?.saveInCoreDataWith(array: data)
                self.totalNewMessagesCount = Int(service.totalNewMessagesCount)

                print(self.totalNewMessagesCount)
                
            case .Error(let message):
                print(message)
                self.isLoading = false
                self.tableView?.tableFooterView?.isHidden = true
                self.showErrorAlert(message: message)
            }
        }
    }
    
    // Starred feeds
    func checkDataStore2() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "starred = \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "section == %@", "feeds")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            print(threadsCount as Any)
            if threadsCount == 0 {
                self.getStarredFeedsFromBackend2()
            } else {
                self.loadData2()
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func loadData2() {
        self.starredService2 = StarredService(parentVC: self)
        self.fetchedResultController2 = self.starredService2?.getStarredFeedConversations(withAscendingOrder: sortAscending)
        if self.fetchedResultController2?.fetchedObjects?.count == 0 {
            self.tableViewIsEmpty()
        } else {
            self.tableViewIsNotEmpty()
        }
        self.fetchedResultController2.delegate = delegate
    }
    
    func getStarredFeedsFromBackend2() {
        loader.show()
        let service = StarredAPIBridge()
        service.getStarredFeedDataWith(completion: ) { (result) in
            self.loader.hide()
            switch result {
            case .Success(let data):
                self.starredService2 = StarredService(parentVC: self)
                self.starredService2?.saveInCoreDataWith2(array: data)
                self.totalNewMessagesCount2 = service.totalNewMessagesCount2
                self.fetchedCount2 = self.fetchedCount2 + Int32(data.count)
            case .Error(let message):
                print("this is" + message)
                self.showErrorAlert(message: message)
            }
        }
    }
    
    func fetchMoreStarredFeeds2(_withSkip skip:Int) {
        loader.show()
        self.isLoading = true
        let service = StarredAPIBridge()
        service.getStarredFeedDataWith(_withSkip: skip) { (result) in
            self.loader.hide()
            switch result {
            case .Success(let data):
                self.isLoading = false
                self.feedTable?.tableFooterView?.isHidden = true
                if data.count == 0 {
                    self.feedTable?.tableFooterView = nil
                    self.shouldLoadNextFeedItems = false
                    return
                }
                self.starredService2 = StarredService(parentVC: self)
                self.starredService2?.saveInCoreDataWith2(array: data)
                
                self.totalNewMessagesCount2 = service.totalNewMessagesCount2
            case .Error(let message):
                print(message)
                self.isLoading = false
                self.feedTable?.tableFooterView?.isHidden = true
                self.showErrorAlert(message: message)
            }
        }
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }
    
    func undoDeletedStarredCell(threadId: String, starred: Bool, accountId: String, tableViewTag: Int) {
        self.alertButton.removeActions(for: .allEvents)
        let starredValue = true
        self.markThreadAsStarredOrUnstarred(threadId: threadId, starred: starredValue, accountId: accountId, tableViewTag: tableViewTag)
        
    }
    
    @objc func markThreadAsStarredOrUnstarred(threadId: String, starred: Bool, accountId: String, tableViewTag: Int) {
        
        let threadsService = StarredService.init(parentVC: self)
        threadsService.updateStarredValue(threadId: threadId, starredValue: starred)
        if tableViewTag == 10 {
            self.loadData()
            self.tableView?.reloadData()
        } else if tableViewTag == 20 {
            self.loadData2()
            self.feedTable?.reloadData()
        }
        
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { //[weak self] in
            let service = StarredAPIBridge()
            service.markThreadAsStarredOrUnstarred(threadId: threadId, accountId: accountId, starred: starred, completion: { (result) in
                switch result {
                case .Success(let data):
                    print(data)
                case .Error(let message):
                    print(message)
                }
            })
        }
        
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3,
                                      execute: requestWorkItem)
    }
    
    private func fetchNewStarredMessagesData() {
        self.isLoading = true
        let service = StarredAPIBridge()
        service.getStarredConversationsDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                print(data)
                self.starredService = StarredService(parentVC: self)
                self.starredService?.saveInCoreDataWithRealtimeEvents(array: data)
                self.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                self.fetchedCount = self.fetchedCount + Int32(data.count)
                self.isLoading = false
                self.loadData()
            case .Error(let message):
                print(message)
                self.isLoading = false
            }
        }
    }
    
    private func fetchNewFeedData() {
        self.isLoading = true
        let service = StarredAPIBridge()
        service.getStarredFeedDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                
                self.starredService2 = StarredService(parentVC: self)
                self.starredService2?.saveInCoreDataWithRealtimeEvents(array: data)
                self.totalNewMessagesCount2 = service.totalNewMessagesCount2
                self.fetchedCount2 = self.fetchedCount2 + Int32(data.count)
                self.isLoading = false
                self.loadData2()
            case .Error(let message):
                print("this is" + message)
                self.isLoading = false
            }
        }
    }
    
    private func fetchStarredConversationMessagesIntheBackground() {
        if self.fetchedResultController?.fetchedObjects?.isEmpty == false {
            self.starredConversationBackUpArray = Array((self.fetchedResultController?.fetchedObjects)!.prefix(10))
            self.fetchFirstTenMessagesFromEachThreadsOfStarredConversations()
        }
    }
    
    private func fetchFirstTenMessagesFromEachThreadsOfStarredConversations() {
        for thread in self.starredConversationBackUpArray {
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
                let messagesService = StarredService(parentVC: self)
                messagesService.saveMessagesInCoreDataWith(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    private func fetchStarredFeedMessagesIntheBackground() {
        if self.fetchedResultController2?.fetchedObjects?.isEmpty == false {
            self.feedConversationBackUpArray = Array((self.fetchedResultController2?.fetchedObjects)!.prefix(10))
            self.fetchFirstTenMessagesFromEachThreadsOfConversations()
        }
    }
    
    private func fetchFirstTenMessagesFromEachThreadsOfConversations() {
        for thread in self.feedConversationBackUpArray {
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                self.getMessagesFromBackendInTheBackgroundThread2(thread: thread)
            }
        }
    }

    private func getMessagesFromBackendInTheBackgroundThread2(thread: Threads) {
        print("This is run on the background queue")
        guard let thread_id = thread.id else {
            return
        }
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: thread_id) { (result) in
            switch result {
            case .Success(let data):
                let messagesService = StarredService(parentVC: self)
                messagesService.saveMessagesInCoreDataWith(array: data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
}
