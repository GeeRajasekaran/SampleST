//
//  FeedDataRepository.swift
//  June
//
//  Created by Ostap Holub on 11/3/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import AlertBar
import Feathers

class FeedDataRepository {
    
    // MARK: - Variables & Constants

    private var categoriesDataRepository: FeedCategoriesDataRepository
    private lazy var recentItemsDataRepository: FeedRecentItemsDataRepository = { [weak self] in
        let repository = FeedRecentItemsDataRepository(store: self)
        return repository
    }()
    
    private let messagesPreloader = MessagesPreloader()
    lazy var briefsManager: FeedBriefsManager = { [weak self] in
        let loader = FeedBriefsManager(onLoad: self?.onBriefLoaded)
        return loader
    }()
    
    var isBookmarksActive: Bool = false {
        didSet {
            recentItemsDataRepository.updateThreads()
        }
    }
    
    lazy var threadsDataProvider: ThreadsDataProvider = { [unowned self] in
        let provider = ThreadsDataProvider(with: self)
        provider.onRecentTreadsLoaded = self.onRecentThreadsUpdated
        return provider
    }()
    
    private var threadsProxy = ThreadsProxy()
    
    var bookmarkedItems: [FeedItem] {
        get {
            return recentItemsDataRepository.bookmarkedItems
        }
    }
    
    var mostRecentItems: [FeedItem] {
        get {
            return recentItemsDataRepository.mostRecentItems
        }
    }
    
    var earlierItems: [FeedItem] {
        get {
            return recentItemsDataRepository.recentItems
        }
    }
    
    // MARK: - Actions
    
    private var onRecentItemsLoaded: (() -> Void)
    var onNewItemsLoaded: (([Int]) -> Void)?
    var onCategoryCardsLoaded: ((FeedCategory) -> Void)?
    var onThreadUpdated: ((IndexPath) -> Void)?
    var onCategoryThreadUpdated: ((FeedItem) -> Void)?
    
    var onNewItemInserted: ((IndexPath) -> Void)?
    
    // MARK: - Initialization
    
    init(onRecentItemsLoaded: @escaping () -> Void) {
        self.onRecentItemsLoaded = onRecentItemsLoaded
        categoriesDataRepository = FeedCategoriesDataRepository()
    }
    
    // MARK: - Count of items

    var categoriesCount: Int {
        get { return categoriesDataRepository.count }
    }
    
    var recentItemsCount: Int {
        get { return recentItemsDataRepository.count }
    }
    
    var mostRecentItemsCount: Int {
        get { return recentItemsDataRepository.mostRecentCount }
    }
    
    // MARK: - Category accessing methods
    
    func categories() -> [FeedCategory] {
        return categoriesDataRepository.categories
    }

    func category(at index: Int) -> FeedCategory? {
        return categoriesDataRepository.category(at: index)
    }
    
    func category(with id: String) -> FeedCategory? {
        return categoriesDataRepository.category(with: id)
    }

    // MARK: - Categories appending methods
    
    func index(of category: FeedCategory?) -> Int? {
        if let unwrappedCategory = category {
            return categoriesDataRepository.categories.index(of: unwrappedCategory)
        }
        return nil
    }

    func append(_ category: FeedCategory?) {
        categoriesDataRepository.append(category)
    }

    func append(contentsOf array: [FeedCategory]?) {
        categoriesDataRepository.append(contentsOf: array)
    }

    func replaceCategories(with array: [FeedCategory]?) {
        categoriesDataRepository.replace(with: array)
    }
    
    // MARK: - Recent items accessing methods
    
    func update(_ item: FeedItem, at index: IndexPath) {
        recentItemsDataRepository.update(item, at: index)
    }
    
    func item(at index: Int, in category: FeedCategory?) -> FeedItem? {
        guard let unwrappedCategory = category else { return nil }
        if index >= 0 && index < unwrappedCategory.newsCards.count {
            return unwrappedCategory.newsCards[index]
        }
        return nil
    }
    
    func item(at index: IndexPath) -> FeedItem? {
        return recentItemsDataRepository.item(at: index)
    }
    
    func todayItem(at index: Int) -> FeedItem? {
        return recentItemsDataRepository.mostRecentItem(at: index)
    }
    
    func mostRecentTimestamp() -> Int32? {
        return recentItemsDataRepository.mostRecentItems.first?.date
    }
    
    func index(of item: FeedItem) -> IndexPath? {
        guard let itemId = item.id else { return nil }
        return recentItemsDataRepository.indexOfItem(with: itemId)
    }
    
    // MARK: - Recent items appending methods
    
    func reset(_ item: FeedItem) {
        guard let id = item.id, let initialThread = threadsProxy.fetchThread(by: id), let feedItem = feedItems(from: [initialThread]).first else { return }
        if let index = index(of: feedItem) {
            recentItemsDataRepository.update(feedItem, at: index)
        } else {
            let threads = threadsProxy.fetchRecentThreads()
            convertToFeedItems(threads)
            if isBookmarksActive {
                recentItemsDataRepository.filterBookmarks()
            }
        }
    }
    
    private var sortPredicate: (FeedItem, FeedItem) throws -> Bool = { first, second in
        if let firstDate = first.date, let secondDate = second.date {
            return firstDate > secondDate
        }
        return false
    }
    
    func refilterThreads() {
        recentItemsDataRepository.updateThreads()
    }
    
    func append(_ recentItem: FeedItem?) {
        recentItemsDataRepository.append(recentItem)
    }
    
    func append(contentsOf array: [FeedItem]?) {
        recentItemsDataRepository.append(contentsOf: array)
    }
    
    func replace(with array: [FeedItem]?) {
        recentItemsDataRepository.replace(with: array)
    }
    
    func removeItem(at index: IndexPath) {
        recentItemsDataRepository.removeItem(at: index)
    }
    
    // MARK: - Data loading
    
    func requestBookmarkedItems() {
        // request bookmarked items here
        guard mostRecentItemsCount == 0 && recentItemsCount == 0 else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.threadsDataProvider.requestRecentThreads(skipCount: 0, bookmarkedOnly: true)
        }
    }
    
    func requestRecentItems() {
        
        // Temporary solution, John asked me to comment the brief loading - Ostap
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            self?.briefsManager.requestMorningBrief()
//        }
        
        //request threads from database
//        let threads = threadsProxy.fetchRecentThreads()
//        convertToFeedItems(threads)
        //request threads update from backend
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.threadsDataProvider.requestRecentThreads(skipCount: 0)
        }
        onRecentItemsLoaded()
    }
    
    private func feedItems(from threads: [Threads]) -> [FeedItem] {
        var feedItems = [FeedItem]()
        threads.forEach({ [weak self] thread -> Void in
            let categoryId = thread.category
            let feedCategory = self?.categoriesDataRepository.category(with: categoryId)
            let item = FeedItemsFactory.item(for: thread, and: feedCategory)
            feedItems.append(item)
        })
        return feedItems
    }
    
    private func convertToFeedItems(_ threads: [Threads]) {
        let convertedThreads = feedItems(from: threads)
        self.recentItemsDataRepository.replace(with: convertedThreads)
        if isBookmarksActive {
            recentItemsDataRepository.updateThreads()
        }
    }
    
    lazy var onRecentThreadsUpdated: () -> Void = { [weak self] in
        if let threads = self?.threadsProxy.fetchRecentThreads() {
//            self?.messagesPreloader.preloadMessages(for: threads)
            self?.convertToFeedItems(threads)
            self?.onRecentItemsLoaded()
        }
    }
    
    lazy var onBriefLoaded: (IFeedBrief) -> Void = { [weak self] brief in
//        self?.onRecentItemsLoaded()
    }
    
    // MARK: - Fetching cards for categories
    
    private func loadCategoriesItems() {
        categoriesDataRepository.categories.forEach { [weak self] category in
            self?.requestFeedItems(for: category)
        }
    }
    
    func requestFeedItems(for category: FeedCategory) {
        category.newsCards = threadsDataProvider.cards(for: category)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.threadsDataProvider.requestThreads(for: category)
        }
    }
    
    // MARK: - Requests loading logic
    
    var pendingSubscriptionsCount: Int = 0
    var isPendingSubscriptionClosed: Bool = false
    private var contactsDataProvider = ContactsDataProvider()
    
    var onSubscriptionsCountLoaded: (() -> Void)?
    
    func reuqestSubscriptionsCount() {
        contactsDataProvider.requestTotalPendingSubscriptions(completion: onSubscriptionsCountFetched)
    }
    
    private lazy var onSubscriptionsCountFetched: (Result<Int>) -> Void = { [weak self] result in
        switch result {
        case .Success(let count):
            self?.isPendingSubscriptionClosed = false
            self?.pendingSubscriptionsCount = count
            if self?.pendingSubscriptionsCount != 0 {
                self?.onSubscriptionsCountLoaded?()
            }
        case .Error(let description):
            print(description)
        }
    }
}

extension FeedDataRepository: ThreadsDataProviderDelegate {
    
    func provider(_ threadsProvider: ThreadsDataProvider, didReceiveCardsFor category: FeedCategory) {
        if let index = categoriesDataRepository.categories.index(of: category) {
            categoriesDataRepository.categories[index].newsCards = threadsDataProvider.cards(for: category)
            onCategoryCardsLoaded?(category)
        }
    }
    
    func provider(_ threadsProvider: ThreadsDataProvider, didReceive error: String) {
        AlertBar.show(.error, message: error)
    }
    
    func provider(_ threadsProvider: ThreadsDataProvider, didUpdateThreadWith id: String, at category: String, isOnCategoryView: Bool) {
        if category == "conversations" || category == "uncategorized" { return }
        if isOnCategoryView {
            if let modifiedCategory = categoriesDataRepository.category(with: category), let index = categoriesDataRepository.indexOfItem(with: id, in: modifiedCategory), let item = item(at: index, in: modifiedCategory) {
                onCategoryThreadUpdated?(item)
            } else {
                guard let modifiedCategory = categoriesDataRepository.category(with: category) else { return }
                modifiedCategory.newsCards = threadsDataProvider.cards(for: modifiedCategory)
                if let index = categoriesDataRepository.indexOfItem(with: id, in: modifiedCategory), let item = item(at: index, in: modifiedCategory) {
                    onCategoryThreadUpdated?(item)
                }
            }
        } else {
            if let index = recentItemsDataRepository.indexOfItem(with: id) {
                onThreadUpdated?(index)
            } else {
                let threads = threadsProxy.fetchRecentThreads()
                convertToFeedItems(threads)
                if isBookmarksActive {
                    recentItemsDataRepository.filterBookmarks()
                }
                if let index = recentItemsDataRepository.indexOfItem(with: id) {
                    onNewItemInserted?(index)
                }
            }
        }
        messagesPreloader.preloadMessages(for: id)
    }
}
