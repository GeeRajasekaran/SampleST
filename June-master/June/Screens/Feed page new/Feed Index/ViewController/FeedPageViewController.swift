//
//  FeedPageViewController.swift
//  June
//
//  Created by Ostap Holub on 1/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import AlertBar

class FeedPageViewController: UIViewController {
    
    var categoryFilterCollectionView: UICollectionView?
    var newsFeedTableView: FeedTableView = FeedTableView()
    private weak var pendingToReloadItem: FeedItem?
    private var pendingToBookmarkItem: FeedItem?
    
    var categoriesDataProvider = CategoriesDataProvider()
    var tapStyle: String?
    
    lazy var categoryFilterDataSource: CategoryFilterCollectionViewDataSource = { [weak self] in
        let source = CategoryFilterCollectionViewDataSource(self?.dataRepository)
        return source
        }()
    
    lazy var categoryFilterDelegate: CategoryFilterCollectionViewDelegate = { [weak self] in
        let delegate = CategoryFilterCollectionViewDelegate(self?.dataRepository, onSelect: self?.onSelectCategory)
        return delegate
        }()
    
    private lazy var uiInitializer: FeedPageUIInitializer = { [unowned self] in
        let initializer = FeedPageUIInitializer(with: self)
        return initializer
    }()
    
    lazy var dataRepository: FeedDataRepository = { [unowned self] in
        let repo = FeedDataRepository(onRecentItemsLoaded: self.onRecentItemsLoaded)
        return repo
    }()
    
    lazy var dataSource: FeedPageDataSource = { [weak self] in
        let source = FeedPageDataSource(builder: self?.screenBuilder)
        source.onBookmarkedSwitchAction = self?.onBookmarkSwitchAction
        source.onRequestNotificationClosed = self?.onCloseSubscriptionsNotifications
//        source.onCollapseBriefCategory = self?.onCollapseBriefCategoryAction
//        source.onViewMoreAction = self?.onViewMoreAction
//        source.onRequestItemClicked = self?.onRequestItemClicked
        return source
    }()
    
    lazy var tableDelegate: FeedPageDelegate = { [weak self] in
        let delegate = FeedPageDelegate(builder: self?.screenBuilder)
        delegate.dataRepository = self?.dataRepository
        delegate.onSelectItem = self?.onSelectItemAt
        delegate.onBriefClicked = self?.onBriefClickedAt
        delegate.onBirefItemSelected = self?.onSelectItemsWith
        delegate.onRequestItemClicked = self?.onRequestItemClicked
        delegate.onPendingSubscriptionsClicked = self?.onOpenPendingSubscriptions
        return delegate
    }()
    
    lazy var screenBuilder: FeedScreenBuilder = { [weak self] in
        let builder = FeedScreenBuilder(model: nil, storage: self?.dataRepository)
        builder.onBookmarkItem = self?.onBookmarkAction
        builder.onRecategorizeItem = self?.onRecategorize
        builder.onShareItem = self?.onShare
        return builder
    }()
    
    lazy var navigationHandler: FeedNavigationHandler = { [unowned self] in
        let handler = FeedNavigationHandler(with: self)
        return handler
    }()
    
    lazy var shareViewPresenter: ShareViewPresenter = { [unowned self] in
        let presenter = ShareViewPresenter(with: self)
        return presenter
    }()
    
    private lazy var notificationViewPresenter: NotificationViewPresenter = { [weak self] in
        let presenter = NotificationViewPresenter()
        presenter.delegate = self
        return presenter
    }()
    
    private var recategorizeHandler: RecategorizeHandler?
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataRepository.requestRecentItems()
        requestData()
        dataRepository.threadsDataProvider.isOnSingleCategoryView = false
        dataRepository.onThreadUpdated = onItemUpdated
        dataRepository.onNewItemInserted = onNewInserted
        dataRepository.onSubscriptionsCountLoaded = onSubscriptionsCountFetched
        dataRepository.reuqestSubscriptionsCount()
        tabBarController?.title = LocalizedStringKey.FeedViewHelper.FeedTitle
    }
    
    // MARK: - Real time listening logic
    
    @objc private func handleApplicationDidBecomeActive() {
        dataRepository.threadsDataProvider.subscribeForRealTimeEvents()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            self?.dataRepository.requestRecentItems()
        })
    }
    
    @objc private func handleApplicationWillResignActive() {
        dataRepository.threadsDataProvider.unsubscribe()
    }
    
    func requestData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.categoriesDataProvider.requestCategories(completion: { result in
                switch result {
                case .Success(let categories):
                    self?.loadDataIntoSources(categories)
                case .Error(let error):
                    AlertBar.show(.error, message: error)
                }
            })
        }
    }
    
    private func loadDataIntoSources(_ categories: [FeedCategory]) {
        dataRepository.replaceCategories(with: categories)
        
        recategorizeHandler = RecategorizeHandler(rootVC: self, categories: dataRepository.categories())
        recategorizeHandler?.onRecategorizeStarted = onRecategorizeStarted
        recategorizeHandler?.onRecategorizeFailed = onRecategorizeFailed
        recategorizeHandler?.onRecategorizeCanceled = onRecategorizeCanceled
        DispatchQueue.main.async { [weak self] in
            self?.categoryFilterCollectionView?.reloadData()
        }
    }
    
    private lazy var onBookmarkAction: (FeedItem) -> Void = { [weak self] item in
        if self?.dataRepository.isBookmarksActive == true {
            self?.pendingToBookmarkItem = item
            self?.pendingToBookmarkItem?.threadEntity?.starred = false
            self?.notificationViewPresenter.show(animated: true, title: LocalizedStringKey.FeedViewHelper.RemovedBookmark)
            if let index = self?.dataRepository.index(of: item) {
                self?.onItemUpdated(index)
            }
        } else if self?.dataRepository.isBookmarksActive == false {
            self?.dataRepository.threadsDataProvider.changeState(of: item)
        }
    }
    
    private lazy var onItemUpdated: (IndexPath) -> Void = { [weak self] indexPath in
        guard let indexToUpdate = self?.screenBuilder.uiIndex(from: indexPath) else { return }
        if self?.dataRepository.isBookmarksActive == true {
            self?.dataRepository.refilterThreads()
            self?.newsFeedTableView.reloadData()
        } else {
            if let cell = self?.newsFeedTableView.cellForRow(at: indexToUpdate) {
                if self?.newsFeedTableView.visibleCells.contains(cell) == true {
                    self?.newsFeedTableView.reloadRows(at: [indexToUpdate], with: .none)
                } else {
                    self?.newsFeedTableView.reloadData()
                }
            }
        }
    }
    
    private lazy var onNewInserted: (IndexPath) -> Void = { [weak self] indexPath in
        guard let indexToUpdate = self?.screenBuilder.uiIndex(from: indexPath) else { return }
        if self?.dataRepository.isBookmarksActive == true {
            self?.dataRepository.refilterThreads()
            self?.newsFeedTableView.reloadData()
        } else {
            if self?.dataRepository.mostRecentItemsCount ?? 0 == 1 || self?.dataRepository.recentItemsCount ?? 0 == 1 {
                self?.newsFeedTableView.reloadData()
                return
            } else {
                if self?.newsFeedTableView.cellForRow(at: indexToUpdate) != nil {
                    self?.newsFeedTableView.insertRows(at: [indexToUpdate], with: .none)
                }
            }
        }
    }
    
    private lazy var onRecentItemsLoaded: () -> Void = { [weak self] in
        DispatchQueue.main.async { [weak self] in
            self?.newsFeedTableView.reloadData()
        }
    }
    
    private lazy var onSubscriptionsCountFetched: () -> Void = { [weak self] in
//        let indexSet = IndexSet([0])
//        self?.newsFeedTableView.reloadSections(indexSet, with: .none)
        self?.newsFeedTableView.reloadData()
    }
    
    private lazy var onCloseSubscriptionsNotifications: () -> Void = { [weak self] in
//        let indexSet = IndexSet([0])
//        self?.newsFeedTableView.reloadSections(indexSet, with: .none)
        self?.dataRepository.isPendingSubscriptionClosed = true
        self?.newsFeedTableView.reloadData()
    }
    
    private lazy var onOpenPendingSubscriptions: () -> Void = {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "OnOpenRequestsWithSubscriptions"), object: nil)
    }
    
    // MARK: - Actions
    
    lazy var onCollapseBriefCategoryAction: () -> Void = { [weak self] in
        guard var currentBrief = self?.dataRepository.briefsManager.currentBrief else { return }
        currentBrief.selectedCategoryId = nil
        currentBrief.viewMoreAttempts = 1
        self?.newsFeedTableView.reloadData()
    }
    
    lazy var onViewMoreAction: () -> Void = { [weak self] in
        guard var currentBrief = self?.dataRepository.briefsManager.currentBrief else { return }
        currentBrief.viewMoreAttempts += 1
        self?.newsFeedTableView.reloadData()
    }
    
    lazy var onSelectCategory: (FeedCategory) -> Void = { [weak self] category in
        guard let sSelf = self else { return }
        sSelf.navigationHandler.showSingleCategoryView(with: category, using: sSelf.dataRepository, recategorizeHandler: sSelf.recategorizeHandler, with: sSelf)
    }
    
    lazy var onBookmarkSwitchAction: (Bool) -> Void = { [weak self] isOn in
        self?.dataRepository.isBookmarksActive = isOn
        self?.dataRepository.requestBookmarkedItems()
        self?.newsFeedTableView.reloadData()
    }
    
    lazy var onSelectItemAt: (IndexPath) -> Void = { [weak self] indexPath in
        guard let item = self?.dataRepository.item(at: indexPath), let categories = self?.dataRepository.categories() else { return }
        self?.navigationHandler.showDetailView(for: item, with: categories, cardView: self?.buildCardForSharing(item), provider: self?.dataRepository.threadsDataProvider)
    }
    
    lazy var onSelectItemsWith: (Threads?) -> Void = { [weak self] thread in
        guard let unwrappedThread = thread, let categories = self?.dataRepository.categories() else { return }
        let item = FeedItem(with: unwrappedThread)
        
        self?.navigationHandler.showDetailView(for: item, with: categories, cardView: self?.buildCardForSharing(item), provider: self?.dataRepository.threadsDataProvider)
    }
    
    private lazy var onBriefClickedAt: (IndexPath) -> Void = { [weak self] indexPath in
        guard var currentBrief = self?.dataRepository.briefsManager.currentBrief else { return }
        
        let clickedCategoryId = currentBrief.sortedKeys[indexPath.row]
        if currentBrief.selectedCategoryId == clickedCategoryId {
            currentBrief.selectedCategoryId = nil
        } else {
            currentBrief.selectedCategoryId = clickedCategoryId
        }
        self?.newsFeedTableView.reloadData()
    }
    
    lazy var onRequestItemClicked: () -> Void = { [weak self] in
        self?.tabBarController?.selectedIndex = 4
    }
    
    // MARK: - Recategorization actions
    
    lazy var onRecategorize: (FeedItem) -> Void = { [weak self] item in
        self?.recategorizeHandler?.startRecategorize(for: item)
    }
    
    lazy var onRecategorizeStarted: (FeedItem, FeedCategory, FeedCategory) -> Void = { [weak self] item, currentCategory, destinationCategory in
        item.feedCategory = destinationCategory
        if destinationCategory.id == "conversations" {
            if let index = self?.dataRepository.index(of: item) {
                self?.dataRepository.removeItem(at: index)
                if self?.dataRepository.mostRecentItemsCount ?? 0 == 0 || self?.dataRepository.recentItemsCount ?? 0 == 0 {
                    self?.newsFeedTableView.reloadData()
                    return
                }
                guard let indexToRemove = self?.screenBuilder.uiIndex(from: index) else { return }
                if self?.newsFeedTableView.cellForRow(at: indexToRemove) != nil {
                    self?.newsFeedTableView.deleteRows(at: [indexToRemove], with: .automatic)
                }
            }
        } else {
            self?.reloadItem(item)
        }
    }
    
    lazy var onRecategorizeFailed: (FeedItem, String) -> Void = { [weak self] item, error in
        self?.resetItem(item)
        AlertBar.show(.error, message: error)
    }
    
    lazy var onRecategorizeCanceled: (FeedItem) -> Void = { [weak self] item in
        self?.resetItem(item)
    }
    
    private func resetItem(_ item: FeedItem) {
        if let index = dataRepository.index(of: item) {
            dataRepository.reset(item)
            guard let indexToReload = screenBuilder.uiIndex(from: index) else { return }
            if newsFeedTableView.cellForRow(at: indexToReload) != nil {
                newsFeedTableView.reloadRows(at: [indexToReload], with: .none)
            }
        } else {
            dataRepository.reset(item)
            if let index = dataRepository.index(of: item) {
                if dataRepository.mostRecentItemsCount == 1 || dataRepository.recentItemsCount == 1 {
                    newsFeedTableView.reloadData()
                    return
                } else {
                    guard let indexToReload = screenBuilder.uiIndex(from: index) else { return }
                    newsFeedTableView.insertRows(at: [indexToReload], with: .automatic)
                }
            }
        }
    }
    
    private func reloadItem(_ item: FeedItem) {
        if let itemIndex = dataRepository.index(of: item) {
            dataRepository.update(item, at: itemIndex)
            guard let indexToReload = screenBuilder.uiIndex(from: itemIndex) else { return }
            if newsFeedTableView.cellForRow(at: indexToReload) != nil {
                newsFeedTableView.reloadRows(at: [indexToReload], with: .none)
            }
        }
        if item == pendingToReloadItem {
            pendingToReloadItem = nil
        }
    }
    
    //MARK: - share item
    lazy var onShare: (FeedItem) -> Void = { [weak self] item in
        self?.shareViewPresenter.show(self?.buildCardForSharing(item))
    }
    
    private func buildCardForSharing(_ item: FeedItem) -> IFeedCardView? {
        if let index = dataRepository.index(of: item) {
            guard let indexPathToUpdate = screenBuilder.uiIndex(from: index) else { return nil }
            if let cell = newsFeedTableView.cellForRow(at: indexPathToUpdate) as? FeedItemCell {
                guard let section = (screenBuilder.loadSections() as? [FeedSectionType])?[indexPathToUpdate.section],
                    let row = (screenBuilder.loadRows(withSection: section) as? [FeedRowType])?[indexPathToUpdate.row],
                    let model = screenBuilder.loadModel(for: section, rowType: row, forPath: indexPathToUpdate) as? FeedGenericItemInfo else { return nil }
                var view = FeedCardViewBuilder.cardView(for: row, at: cell.frame, at: indexPathToUpdate)
                view.itemInfo = model
                view.setupSubviews()
                view.loadItemData()
                return view
            }
        }
        return nil
    }
    
    override func loadViewIfNeeded() {
        guard let tapStyleString = self.tapStyle else { return }
        if tapStyleString.isEqualToString(find: "double") {
            self.scrollToFirstRow()
        }
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        if indexPathIsValid(indexPath: indexPath) == true {
            self.newsFeedTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.newsFeedTableView.numberOfSections && indexPath.row < self.newsFeedTableView.numberOfRows(inSection: indexPath.section)
    }
}
    


extension FeedPageViewController: SingleCategorySelectionDelegate {
    func delegate(_ selectionDelegate: SingleCategoryViewDelegate, didSelect card: FeedItem, with cardView: IFeedCardView?) {
        navigationHandler.hideSingleCategoryView()
        pendingToReloadItem = card
        navigationHandler.showDetailView(for: card, with:  dataRepository.categories(), cardView: cardView, provider: dataRepository.threadsDataProvider)
    }

    func delegateDidRecategorize(card: FeedItem) {
        pendingToReloadItem = card
    }
}

extension FeedPageViewController: NotificationViewPresenterDelegate {
    
    func didTapOnUndoButton(_ button: UIButton) {
        guard let item = pendingToBookmarkItem else { return }
        item.threadEntity?.starred = true
        resetItem(item)
        pendingToBookmarkItem = nil
    }
    
    func didHideViewAfterDelay(_ view: NotificationView) {
        guard let item = pendingToBookmarkItem else { return }
        dataRepository.threadsDataProvider.changeState(of: item, to: false)
        pendingToBookmarkItem = nil
    }
}
