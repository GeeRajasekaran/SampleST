//
//  SingleCategoryViewController.swift
//  June
//
//  Created by Ostap Holub on 8/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class SingleCategoryViewController: UIViewController {
    
    // MARK: - Variables
    
    weak var selectedCategory: FeedCategory?
    weak var selectionDelegate: SingleCategorySelectionDelegate?
    
    weak var oldPendingCategory: FeedCategory?
    weak var newPendingCategory: FeedCategory?
    
    lazy var categoryDataRepository: SingleCategoryDataRepository = { [weak self] in
        let repo = SingleCategoryDataRepository(category: self?.selectedCategory)
        return repo
    }()
    
    lazy var uiInitializer: SingleCategoryUIInitializer = {
        let initializer = SingleCategoryUIInitializer(with: self)
        return initializer
    }()
    
    lazy var dataSource: SingleCategoryViewDataSource = { [weak self] in
        let source = SingleCategoryViewDataSource(storage: self?.categoryDataRepository, category: self?.selectedCategory)
        source.onStar = self?.onStarAction
        source.onMoreOptionsAction = self?.onMoreOptionsAction
        source.onRecategorize = self?.onRecategorizeAction
        source.onShare = self?.onShareAction
        return source
    }()
    
    lazy var categoryDelegate: SingleCategoryViewDelegate = { [weak self] in
        let delegate = SingleCategoryViewDelegate(storage: self?.categoryDataRepository, category: self?.selectedCategory, provider: self?.dataRepository?.threadsDataProvider)
        delegate.delegate = self?.selectionDelegate
        delegate.swipyCellHandler = self?.dataSource.swipyCellHandler
        return delegate
    }()
    
    lazy var searchViewPresenter: JuneSearchViewControllerPresenter = { [unowned self] in
        let presenter = JuneSearchViewControllerPresenter(with: self)
        return presenter
    }()
    
    lazy var shareViewPresenter: ShareViewPresenter = { [unowned self] in
        let presenter = ShareViewPresenter(with: self)
        return presenter
    }()
    
    weak var recategorizeHandler: RecategorizeHandler? {
        didSet {
            recategorizeHandler?.onRecategorizeStarted = onRecategorizeStarted
            recategorizeHandler?.onRecategorizeFailed = onRecategorizeFailed
            recategorizeHandler?.onRecategorizeCanceled = onRecategorizeCanceled
        }
    }
    
    weak var dataRepository: FeedDataRepository?
    
    // MARK: - Views
    
    var cardsTableView: FeedTableView?
    var bookmarksSwitch: SevenSwitch?
    
    // MARK: - View lifecycle management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
        dataRepository?.onCategoryCardsLoaded = onCategoryCardsLoaded
        dataRepository?.onCategoryThreadUpdated = onItemUpdated
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataRepository?.threadsDataProvider.isOnSingleCategoryView = true
        dataRepository?.threadsDataProvider.subscribeForRealTimeEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataRepository?.threadsDataProvider.unsubscribe()
    }
    
    //MARK: - load data
    func requestData() {
        if let unwrappedCategory = selectedCategory {
            dataRepository?.requestFeedItems(for: unwrappedCategory)
        }
    }
    
    // MARK: - Actions
    
    @objc func onSwitchValueChanged() {
        guard let isOn = bookmarksSwitch?.isOn() else { return }
        bookmarksSwitch?.thumbImageView.image = uiInitializer.switchButtonImage(for: isOn)
        categoryDataRepository.isBookmarksActive = isOn
        cardsTableView?.reloadData()
    }
    
    lazy var onCategoryCardsLoaded: (FeedCategory) -> Void = { [weak self] category in
        if category.id == self?.selectedCategory?.id {
            DispatchQueue.main.async {
                self?.categoryDataRepository.updateData()
                self?.cardsTableView?.reloadData()
            }
        }
    }
    
    lazy var onItemUpdated: (FeedItem) -> Void = { [weak self] item in        
        if self?.categoryDataRepository.isBookmarksActive == true {
            self?.categoryDataRepository.updateData()
            self?.cardsTableView?.reloadData()
        } else {
            if let indexPath = self?.categoryDataRepository.index(of: item) {
                self?.cardsTableView?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    lazy var onStarAction: (FeedItem) -> Void = { [weak self] item in
        self?.dataRepository?.threadsDataProvider.changeState(of: item)
    }
    
    lazy var onMoreOptionsAction: (FeedItem) -> Void = { item in
        print(item)
    }
    
    @objc func handleSearchTap() {
        searchViewPresenter.show()
    }
    
    @objc func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Recategorization actions and callbacks
    
    lazy var onRecategorizeAction: (FeedItem) -> Void = { [weak self] item in
        self?.recategorizeHandler?.startRecategorize(for: item)
    }
    
    lazy var onRecategorizeStarted: (FeedItem, FeedCategory, FeedCategory) -> Void = { [weak self] item, currentCategory, destinationCategory in

        self?.selectionDelegate?.delegateDidRecategorize(card: item)
        self?.oldPendingCategory = currentCategory
        self?.newPendingCategory = destinationCategory
        
        if let index = currentCategory.newsCards.index(of: item) {
            currentCategory.newsCards.remove(at: index)
        }
        
        if let index = self?.categoryDataRepository.index(of: item) {
            self?.categoryDataRepository.removeItem(at: index)
            self?.cardsTableView?.deleteRows(at: [index], with: .automatic)
        }
        
        item.feedCategory = destinationCategory
        destinationCategory.newsCards.append(item)
        if let unwrappedSortPredicate = self?.sortPredicate {
            do {
                try destinationCategory.newsCards.sort(by: unwrappedSortPredicate)
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    lazy var onRecategorizeFailed: (FeedItem, String) -> Void = { [weak self] item, error in
        self?.resetItem(item)
        AlertBar.show(.error, message: error)
    }
    
    lazy var onRecategorizeCanceled: (FeedItem) -> Void = { [weak self] item in
        self?.resetItem(item)
    }
    
    //MARK: - on share item
    lazy var onShareAction: (FeedItem, IndexPath) -> Void = { [weak self] item, indexPath in
        self?.shareViewPresenter.show(self?.buildCardForSharing(item, and: indexPath))
    }
    
    private func buildCardForSharing(_ item: FeedItem, and indexPathToUpdate: IndexPath) -> IFeedCardView? {
        if let cell = cardsTableView?.cellForRow(at: indexPathToUpdate) as? FeedItemCell {
            let model = item.type == .news ? FeedNewsItemInfo(thread: item.threadEntity) : FeedGenericItemInfo(thread: item.threadEntity)
            var view = FeedCardViewBuilder.cardView(for: item.type, at: cell.frame, at: indexPathToUpdate)
            view.itemInfo = model
            view.setupSubviews()
            view.loadItemData()
            return view
        }
        return nil
    }
    
    private func resetItem(_ item: FeedItem) {
        item.feedCategory = selectedCategory
        if let index = newPendingCategory?.newsCards.index(of: item) {
            newPendingCategory?.newsCards.remove(at: index)
        }
        selectedCategory?.newsCards.append(item)
        do {
            try selectedCategory?.newsCards.sort(by: sortPredicate)
        } catch (let error) {
            print(error.localizedDescription)
        }
        categoryDataRepository.currentCategory = selectedCategory
        categoryDataRepository.updateData()
        if let index = categoryDataRepository.index(of: item) {
            cardsTableView?.insertRows(at: [index], with: .automatic)
        }
        newPendingCategory = nil
        oldPendingCategory = nil
    }
    
    private var sortPredicate: (FeedItem, FeedItem) throws -> Bool = { first, second in
        if let firstDate = first.date, let secondDate = second.date {
            return firstDate > secondDate
        }
        return false
    }
}
