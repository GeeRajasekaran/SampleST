//
//  FeedViewController.swift
//  June
//
//  Created by Joshua Cleetus on 8/1/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class FeedViewController: UIViewController {

    // MARK: - Views
    
    var categoryFilterCollectionView: UICollectionView?
    var newsFeedTableView = FeedTableView()
    private weak var pendingToReloadItem: FeedItem?
    private var temporaryRecategorizedItem: FeedItem?
    
    // MARK: - Variables
    
    lazy var feedDataRepository: FeedDataRepository = { [unowned self] in
        let repository = FeedDataRepository(onRecentItemsLoaded: self.onRecentItemsLoaded)
        return repository
    }()
    
    var categoriesDataProvider = CategoriesDataProvider()
    
    lazy var categoryFilterDataSource: CategoryFilterCollectionViewDataSource = { [weak self] in
        let source = CategoryFilterCollectionViewDataSource(self?.feedDataRepository)
        return source
    }()
    
    lazy var categoryFilterDelegate: CategoryFilterCollectionViewDelegate = { [weak self] in
        let delegate = CategoryFilterCollectionViewDelegate(self?.feedDataRepository, onSelect: self?.onSelectCategory)
        return delegate
    }()
    
    lazy var recentItemsDataSource: FeedRecentItemsDataSource = { [weak self] in
        let source = FeedRecentItemsDataSource(storage: self?.feedDataRepository, onStarAction: self?.onStarAction)
        source.onMoreOptions = self?.onMoreOptions
        source.onRecategorize = self?.onRecategorizeAction
        return source
    }()
    
    lazy var recentItemsDelegate: FeedRecentItemsDelegate = { [weak self] in
        let delegate = FeedRecentItemsDelegate(storage: self?.feedDataRepository)
        delegate.onSelectItem = self?.onSelectItem
        delegate.onBookmarkSwitchChanged = self?.onBookmarkSwitchAction
        delegate.swipyCellHandler = self?.recentItemsDataSource.swipyCellHandler
        return delegate
    }()
    
    lazy var navigationHandler: FeedNavigationHandler = {
        let handler = FeedNavigationHandler(with: self)
        return handler
    }()
    
    lazy var uiInitializer: FeedUIInitializer = {
        let initializer = FeedUIInitializer(with: self)
        return initializer
    }()
    
    private var recategorizeHandler: RecategorizeHandler?
    
    // MARK: - View lifecycle management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedDataRepository.threadsDataProvider.subscribeForRealTimeEvents()
        feedDataRepository.onThreadUpdated = onItemUpdated
        feedDataRepository.onNewItemsLoaded = onNewItemsLoaded
        feedDataRepository.threadsDataProvider.isOnSingleCategoryView = false
        uiInitializer.hideCategoriesHeader()
        
        if let item = pendingToReloadItem {
            reloadItem(item)
        }
        
        recategorizeHandler?.onRecategorizeStarted = onRecategorizeStarted
        recategorizeHandler?.onRecategorizeFailed = onRecategorizeFailed
        recategorizeHandler?.onRecategorizeCanceled = onRecategorizeCanceled
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        feedDataRepository.threadsDataProvider.unsubscribe()
    }
    
    // MARK: - Data loading
    
    private func requestData() {
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
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.feedDataRepository.requestRecentItems()
        }
    }
    
    private lazy var onRecentItemsLoaded: () -> Void = { [weak self] in
        DispatchQueue.main.async {
            self?.newsFeedTableView.tableFooterView?.isHidden = true
            self?.newsFeedTableView.tableFooterView = nil
            self?.newsFeedTableView.reloadData { [weak self] in
                self?.uiInitializer.hideCategoriesHeader()
            }
        }
    }
    
    private lazy var onNewItemsLoaded: ([Int]) -> Void = { [weak self] indices in
        var indexPaths = [IndexPath]()
        indices.forEach { index in
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        UIView.performWithoutAnimation {
            self?.newsFeedTableView.insertRows(at: indexPaths, with: .none)            
        }
    }
    
    private func loadDataIntoSources(_ categories: [FeedCategory]) {
        feedDataRepository.replaceCategories(with: categories)
        
        recategorizeHandler = RecategorizeHandler(rootVC: self, categories: feedDataRepository.categories())
        recategorizeHandler?.onRecategorizeStarted = onRecategorizeStarted
        recategorizeHandler?.onRecategorizeFailed = onRecategorizeFailed
        recategorizeHandler?.onRecategorizeCanceled = onRecategorizeCanceled
        DispatchQueue.main.async { [weak self] in
            self?.categoryFilterCollectionView?.reloadData()
        }
    }
    
    lazy var onItemUpdated: (IndexPath) -> Void = { [weak self] indexPath in
        if let cell = self?.newsFeedTableView.cellForRow(at: indexPath) as? FeedItemCell {
            cell.cardView?.changeStarState()
            if let item = self?.feedDataRepository.item(at: indexPath) {
                if let view = self?.recentItemsDataSource.swipyCellHandler.leftViewsMap[indexPath.section]?[indexPath.row] {
                    view.updateIcon(item.starred)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    lazy var onBookmarkSwitchAction: (Bool) -> Void = { [weak self] isOn in
        self?.feedDataRepository.isBookmarksActive = isOn
        self?.feedDataRepository.requestBookmarkedItems()
        self?.newsFeedTableView.reloadData()
    }
    
    lazy var onMoreOptions: (FeedItem) -> Void = { item in
        print(item)
    }
    
    lazy var onSelectCategory: (FeedCategory) -> Void = { [weak self] category in
        guard let sSelf = self else { return }
        sSelf.navigationHandler.showSingleCategoryView(with: category, using: sSelf.feedDataRepository, recategorizeHandler: sSelf.recategorizeHandler, with: sSelf)
    }
    
    lazy var onSelectItem: (FeedItem) -> Void = { [weak self] item in
        guard let categories = self?.feedDataRepository.categories() else {
            return
        }
        self?.pendingToReloadItem = item
        self?.navigationHandler.showDetailView(for: item, with: categories, provider: self?.feedDataRepository.threadsDataProvider)
    }
    
    lazy var onStarAction: (FeedItem) -> Void = { [weak self] item in
        self?.feedDataRepository.threadsDataProvider.changeState(of: item)
    }
    
    lazy var onRecategorizeAction: (FeedItem) -> Void = { [weak self] item in
        self?.recategorizeHandler?.startRecategorize(for: item)
    }

    // MARK: - Recategorization callbacks
    
    private func reloadItem(_ item: FeedItem) {
        if let itemIndex = feedDataRepository.index(of: item) {
            feedDataRepository.update(item, at: itemIndex)
            newsFeedTableView.reloadRows(at: [itemIndex], with: .none)
        }
        if item == pendingToReloadItem {
            pendingToReloadItem = nil
        }
    }
    
    lazy var onRecategorizeStarted: (FeedItem, FeedCategory, FeedCategory) -> Void = { [weak self] item, currentCategory, destinationCategory in
        item.feedCategory = destinationCategory
        if destinationCategory.id == "conversations" {
            if let index = self?.feedDataRepository.index(of: item) {
                self?.feedDataRepository.removeItem(at: index)
                self?.newsFeedTableView.deleteRows(at: [index], with: .automatic)
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
        if let index = feedDataRepository.index(of: item) {
            feedDataRepository.reset(item)
            newsFeedTableView.reloadRows(at: [index], with: .none)
        } else {
            feedDataRepository.reset(item)
            if let index = feedDataRepository.index(of: item) {
                newsFeedTableView.insertRows(at: [index], with: .automatic)
            }
        }
    }
 }

extension FeedViewController: SingleCategorySelectionDelegate {
    func delegate(_ selectionDelegate: SingleCategoryViewDelegate, didSelect card: FeedItem, with cardView: IFeedCardView?) {
        navigationHandler.hideSingleCategoryView()
        pendingToReloadItem = card
        navigationHandler.showDetailView(for: card, with: feedDataRepository.categories(), provider: feedDataRepository.threadsDataProvider)
    }

    func delegateDidRecategorize(card: FeedItem) {
        pendingToReloadItem = card
    }
}
