//
//  ThreadsDataProvider.swift
//  June
//
//  Created by Ostap Holub on 8/18/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

    // MARK: - ThreadsDataProviderDelegate
    // inteface for communication with FeedViewController

protocol ThreadsDataProviderDelegate: class {
    func provider(_ threadsProvider: ThreadsDataProvider, didReceiveCardsFor category: FeedCategory)
    func provider(_ threadsProvider: ThreadsDataProvider, didReceive error: String)
    func provider(_ threadsProvider: ThreadsDataProvider, didUpdateThreadWith id: String, at category: String, isOnCategoryView: Bool)
}

class ThreadsDataProvider {
    
    weak var delegate: ThreadsDataProviderDelegate?
    private var threadsProxy = ThreadsProxy()
    private var realTimeListener: FeedRealTimeListener?
    private var parser: ThreadsParser
    private var starringHandler = BookmarkHandler()
    
    var onRecentTreadsLoaded: (() -> Void)?
    var onMoreThreadsLoaded: (([Threads]) -> Void)?
    var onMoreRecentThreadsLoaded: (() -> Void)?
    var isOnSingleCategoryView: Bool = false
    var shouldLoadMoreRecentThreads: Bool = true
    
    var onSingleThreadLoaded: ((String) -> Void)?
    
    private let defaultLimit: Int = 10
    
    // MARK: - Real-time
    
    lazy var onPatch: ([String: Any]) -> Void = { [weak self] e in
        guard let sSelf = self else { return }
        let json = JSON(e)
        let threadId = json["id"].stringValue
        let categoryId = json["category"].stringValue
        
        if let entity = sSelf.threadsProxy.fetchThread(by: threadId) {
            sSelf.parser.loadData(from: json, to: entity)
            sSelf.threadsProxy.saveContext()
            sSelf.delegate?.provider(sSelf, didUpdateThreadWith: threadId, at: categoryId, isOnCategoryView: sSelf.isOnSingleCategoryView)
        }
    }
    
    // MARK: - Initialization
    
    init(with calbackResponder: ThreadsDataProviderDelegate) {
        delegate = calbackResponder
        parser = ThreadsParser()
    }
    
    init() {
        parser = ThreadsParser()
    }
    
    // MARK: - Request section
    
    private func prepareSkipCount(_ skip: Int) -> Int {
        if skip % 10 != 0 {
            return skip - (skip % 10)
        }
        return skip
    }
    
    func requestRecentThreads(skipCount: Int, bookmarkedOnly: Bool = false) {
        guard shouldLoadMoreRecentThreads == true else { return }
        var query = Query().ne(property: "category", value: "conversations")
            .sort(property: "last_message_timestamp", ordering: .orderedDescending)
            .eq(property: "spam", value: 0)
            .eq(property: "trash", value: 0)
            .eq(property: "approved", value: 1)
            .eq(property: "section", value: "feeds")
            .skip(prepareSkipCount(skipCount))
            .limit(defaultLimit)
        
        if bookmarkedOnly {
            query = query.eq(property: "starred", value: true)
        }
        
        FeathersManager.Services.threads.request(.find(query: query))
            .on(value: { [weak self] response in
                if let array = JSON(response.data.value).array, let strongSelf = self {
                    if array.count != 0 {
                        strongSelf.saveThreads(array)
                        strongSelf.onRecentTreadsLoaded?()
                    } else if array.count == 0 || array.count < strongSelf.defaultLimit {
                        strongSelf.shouldLoadMoreRecentThreads = false
                    }
                }
            }).startWithFailed({ error in
                self.delegate?.provider(self, didReceive: error.localizedDescription)
            })
    }
    
    func requestThread(for threadId: String) {
        FeathersManager.Services.threads.request(.get(id: threadId, query: nil))
            .on(value: { [weak self] response in
                if let strongSelf = self {
                    let jsonObject = JSON(response.data.value)
                    strongSelf.saveThread(jsonObject)
                    strongSelf.onSingleThreadLoaded?(jsonObject["id"].stringValue)
                }
            }).startWithFailed({ error in
                self.delegate?.provider(self, didReceive: error.localizedDescription)
            })
    }
    
    func requestThread(for threadId: String, completion: @escaping (Result<JSON>) -> Void) {
        FeathersManager.Services.threads.request(.get(id: threadId, query: nil))
            .on(value: { [weak self] response in
                if let strongSelf = self {
                    let jsonObject = JSON(response.data.value)
                    strongSelf.saveThread(jsonObject)
                    completion(.Success(jsonObject))
                }
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })
    }
    
    func requestThreads(for category: FeedCategory, shouldSkip: Bool = false) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let skipCount = shouldSkip == true ? category.newsCards.count : 0
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accountId = serializedUserObject["primary_account_id"] as? String {
            let query = Query()
                .eq(property: "account_id", value: accountId)
                .eq(property: "category", value: category.id)
                .eq(property: "section", value: "feeds")
                .eq(property: "spam", value: false)
                .skip(skipCount)
                .limit(10)
            
            FeathersManager.Services.threads.request(.find(query: query))
                .on(value: { [weak self] response in
                    if let array = JSON(response.data.value).array, let strongSelf = self {
                        if array.count == 0 { category.shouldLoad = false }
                        strongSelf.saveThreads(array)
                        strongSelf.delegate?.provider(strongSelf, didReceiveCardsFor: category)
                    }
                }).startWithFailed({ error in
                    self.delegate?.provider(self, didReceive: error.localizedDescription)
                })
        }
    }
    
    func changeState(of card: FeedItem) {
        guard let thread = card.threadEntity else { return }
        starringHandler.changeState(of: thread, completion: { [weak self] result in
            if result != "" {
                self?.delegate?.provider(self!, didReceive: result)
            }
        })
    }
    
    func changeState(of card: FeedItem, to value: Bool) {
        guard let thread = card.threadEntity else { return }
        starringHandler.changeState(of: thread, to: value, completion: { [weak self] result in
            if result != "" {
                self?.delegate?.provider(self!, didReceive: result)
            }
        })
    }
    
    func subscribeForRealTimeEvents() {
        realTimeListener = FeedRealTimeListener()
        realTimeListener?.subscribeForPatch(event: onPatch)
    }
    
    func unsubscribe() {
        realTimeListener?.unsubscribe()
        realTimeListener = nil
    }
    
    func cards(for category: FeedCategory) -> [FeedItem] {
        let threads = threadsProxy.fetchFeedThreads(for: category)
        return threads.compactMap({ singleThread -> FeedItem in
            return FeedItemsFactory.item(for: singleThread, and: category)
        })
    }
    
    private func accountCreatedAt() -> Int? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]] {
            if let firstAccount = accounts.first {
                return firstAccount["created_at"] as? Int
            }
        }
        return nil
    }
    
    // MARK: - Process section
    
    private func saveThreads(_ threadsJson: [JSON]) {
        threadsJson.forEach({ element -> Void in
            saveThread(element)
        })
    }
    
    private func saveThread(_ threadJson: JSON) {
        guard let threadId = threadJson["id"].string else { return }
        if let threadEntity = threadsProxy.fetchThread(by: threadId) {
            parser.loadData(from: threadJson, to: threadEntity)
        } else {
            let thread = threadsProxy.addNewEmptyThread()
            parser.loadData(from: threadJson, to: thread)
        }
        threadsProxy.saveContext()
    }
    
    //MARK: - update thread
    func update(_ thread: Threads?, unread: Bool, seen: Bool, inbox: Bool) {
        guard let threadId = thread?.id else { return }
        if threadsProxy.fetchThread(by: threadId) != nil {
            thread?.unread = unread
            thread?.seen = seen
            thread?.inbox = inbox
            threadsProxy.saveContext()
        }
    }
    
    func update(_ thread: Threads?, inbox: Bool) {
        guard let threadId = thread?.id else { return }
        if threadsProxy.fetchThread(by: threadId) != nil {
            thread?.inbox = inbox
            threadsProxy.saveContext()
        }
    }
}
