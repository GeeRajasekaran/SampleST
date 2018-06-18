//
//  JuneSearchResultViewController.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol JuneSearchResultViewControllerDelegate: class {
    func closeController(_ searchController: JuneSearchResultViewController)
}

class JuneSearchResultViewController: UIViewController {

    //Variables
    var searchText: String?
    weak var delegate: JuneSearchResultViewControllerDelegate?
    var tableView = FeedTableView()
    var searchEngine = SearchEngine()
    var spinnerProvider = SpinnerProvider()

    let threadsDataProvider = ThreadsDataProvider()
    
    var isDetailPageOpened = false
    
    private var lastSelectedInexPath: IndexPath?
    
    var searchResultHandler: SearchResultHandler?
    
    lazy var uiInitializer: JuneSearchResultsViewControllerInitializer = { [unowned self] in
        let initializer = JuneSearchResultsViewControllerInitializer(with: self)
        return initializer
    }()
    
    //Data repository
    var dataRepository: SearchThreadsDataRepository = SearchThreadsDataRepository()
    
    //Data source
    lazy var listDataSource: SearchThreadsTableViewDataSource = { [unowned self] in
        var source = SearchThreadsTableViewDataSource(with: dataRepository)
        source.markAsClearedAction = markAsClearedAction
        return source
    }()
    
    //Delegate
    lazy var listDelegate: SearchThreadsTableViewDelegate = { [unowned self] in
        var delegate = SearchThreadsTableViewDelegate(with: dataRepository)
        delegate.tableViewDidSelectRowAction = self.tableViewDidSelectRowAction
        delegate.onMoreThreads = self.onMoreThreads
        delegate.tableViewStartScrolling = self.tableViewStartScrolling
        return delegate
    }()
    
    lazy var tableViewDidSelectRowAction: ((IndexPath, ThreadsReceiver) -> Void) = { [weak self] indexPath, receiver in
        if receiver.sectionType == .feeds {
            self?.openFeedDetailViewController(receiver)
        } else {
            self?.openThreadsDetailViewController(receiver)
        }
        self?.lastSelectedInexPath = indexPath
    }
    
    lazy var markAsClearedAction: (ThreadsReceiver) -> Void = { [weak self] receiver in
        self?.mark(receiver)
    }
    
    //MARK: - load more threads
    lazy fileprivate var onMoreThreads: () -> Void = { [weak self] in
        self?.requestMoreThreads()
    }
    
    //MARK: - search result
    lazy var didTapOnCancelButton: (() -> Void) = { [weak self] in
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateConvosAfterSearch"), object: nil)
        self?.onCloseSearchResults()
    }
    
    lazy var didTapOnExitButton: (() -> Void) = { [weak self] in
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateConvosAfterSearch"), object: nil)
        self?.navigationController?.popViewController(animated: false)
    }
    
    lazy var updateSearchResults: ((UISearchController) -> Void) = { [weak self] searchVC in
        self?.updateSearch(searchVC)
    }
    
    lazy var didTapOnReturnButton: ((UITextField, UISearchController) -> Void) = { [weak self] _ ,searchVC in
         self?.updateSearch(searchVC)
    }
    
    lazy var tableViewStartScrolling: () -> Void = { [weak self] in
        self?.searchResultHandler?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        searchResultHandler?.didTapOnCancelButton = didTapOnCancelButton
        searchResultHandler?.didTapOnExitButton = didTapOnExitButton
        searchResultHandler?.updateSearchResults = updateSearchResults
        searchResultHandler?.didTapOnReturnButton = didTapOnReturnButton
        if !isDetailPageOpened {
            searchResultHandler?.set(searchText)
        } 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = lastSelectedInexPath {
            if dataRepository.receiver(by: indexPath.row) != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    guard self.tableView.cellForRow(at: indexPath) != nil else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    self.tableView.deselectRow(at: indexPath, animated: false)
                })
            }
        }
    }
    
    //MARK: - actions
    func onCloseSearchResults() {
        delegate?.closeController(self)
        spinnerProvider.stopSpinner()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - navigation
    func openThreadsDetailViewController(_ receiver: ThreadsReceiver) {
        dataRepository.markAsRead(receiver)
        guard let unwrappedThread = receiver.threadEntity else { return }
        let detailVC = ThreadsDetailViewController()
        detailVC.threadToRead = unwrappedThread
        detailVC.threadId = unwrappedThread.id
        detailVC.threadAccountId = unwrappedThread.account_id
        detailVC.subjectTitle = unwrappedThread.subject
        detailVC.unread = unwrappedThread.unread
        detailVC.seen = unwrappedThread.seen
        detailVC.inbox = unwrappedThread.inbox
        detailVC.categoryName = unwrappedThread.category
        detailVC.controllerDelegate = self
        detailVC.isFromSearch = true
        open(detailVC)
    }
    
    func openFeedDetailViewController(_ receiver: ThreadsReceiver) {
        guard let unwrappedThread = receiver.threadEntity else { return }
        let feedItem = FeedItem(with: unwrappedThread)
        let feedDetailVC = FeedDetailedViewController()
        feedDetailVC.currentCard = feedItem
        var feedCategory: FeedCategory? = nil
        if let category = unwrappedThread.category {
            feedCategory = FeedCategory(id: category, title: category.capitalizingFirstLetter())
        }
        feedDetailVC.pendingCategory = feedCategory
        feedDetailVC.threadsDataProvider = dataRepository.threadsDataProvider
        feedDetailVC.isFromSearch = true
        open(feedDetailVC)
    }
    
    private func open(_ vc: UIViewController) {
        isDetailPageOpened = true
        navigationController?.pushViewController(vc, animated: true)
        hideNavigationBar()
    }
    
    private func hideNavigationBar() {
        guard let subviews = navigationController?.navigationBar.subviews else { return }
        for view in subviews {
            if view.tag == 1001 {
                view.isHidden = true
                searchResultHandler?.resignFirstResponder()
            }
        }
    }
    
    func showNavigationBar() {
        guard let subviews = navigationController?.navigationBar.subviews else { return }
        for view in subviews {
            if view.tag == 1001 {
                view.isHidden = false
            }
        }
    }
    
    //MARK: - more threads
    func requestMoreThreads() {
        guard let handler = searchResultHandler else { return }
        if !handler.searchBarIsEmpty() {
            if let query = handler.searchController.searchBar.text {
                searchEngine.searchThreads(by: query, completion: { [weak self] receivers, shouldAppend in
                    if shouldAppend && receivers.count > 0 {
                        self?.dataRepository.append(receivers)
                    }
                    self?.tableView.reloadData()
                })
            }
        } else {
            dataRepository.clean()
            tableView.reloadData()
        }
    }
    
    //MARK: - update search
    func updateSearch(_ searchController: UISearchController) {
        guard let handler = searchResultHandler else { return }
        let searchBar = searchController.searchBar
        if !handler.searchBarIsEmpty() {
            if searchBar.text == searchEngine.previousQuery { return }
            spinnerProvider.startSpinner()
            if let query = searchBar.text {
                searchEngine.searchThreads(by: query, completion: { [weak self] receivers, shouldAppend in
                    self?.spinnerProvider.stopSpinner()
                    if handler.searchState == .started {
                        self?.dataRepository.receivers = receivers
                        self?.tableView.reloadData()
                    }
                })
            }
        } else {
            dataRepository.clean()
            tableView.reloadData()
        }
    }
    
    //MARK: - mark thread as cleared
    func mark(_ threadReceiver: ThreadsReceiver) {
        guard let isCleared = threadReceiver.isCleared else { return }
        if isCleared {
            dataRepository.markAsSeen(threadReceiver)
        } else {
            dataRepository.markAsCleared(threadReceiver)
        }
        if let index = dataRepository.index(of: threadReceiver) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension JuneSearchResultViewController: ThreadsDetailViewControllerDelegate {
    func actionInDetailViewController(_ controller: ThreadsDetailViewController, unread: Bool, seen: Bool, inbox: Bool, starredValueChanged: Bool, thread: Threads) {
        //let userInfo: [AnyHashable: Any] = ["seen": seen, "unread": unread, "starredValueChanged": starredValueChanged, "thread": thread, "inbox": inbox]
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateConvosAfterSearch"), object: nil, userInfo: userInfo)
    }
    
    func controller(_ controller: ThreadsDetailViewController, starred isStarred: Bool) {
    }
    
    func recategorizeValue(_controller: ThreadsDetailViewController, category: String) {
    }
}

