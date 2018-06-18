//
//  BriefDataLoader.swift
//  June
//
//  Created by Ostap Holub on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

class BriefDataLoader {
    
    // MARK: - Variables & Constants
    
    private var pendingCategoriesCount: Int?
    private var pendingData: [String: JSON] = [:]
    private var pendingContacts: JSON?
    private var onDataLoaded: ((IFeedBrief) -> Void)?
    
    private var threadsProxy: ThreadsProxy = ThreadsProxy()
    private var parser: ThreadsParser = ThreadsParser()
    
    // MARK: - Categories data loading
    
    func loadBrief(with categories: [String], completion: @escaping (IFeedBrief) -> Void) {
        pendingData = [:]
        pendingContacts = []
        pendingCategoriesCount = categories.count
        onDataLoaded = completion
        categories.forEach { [weak self] id in
            self?.loadBriefData(for: id)
        }
    }
    
    // MARK: - Categories data request logic
    
    private func loadBriefData(for categoryId: String) {
        guard let timeRange = BriefDateHandler().morningBriefTimeRange() else { return }
        guard let accountId = fetchAccountId() else { return }
        
        let query = Query()
            .eq(property: "account_id", value: accountId)
            .eq(property: "category", value: categoryId)
            .eq(property: "approved", value: 1)
            .eq(property: "inbox", value: true)
            .eq(property: "spam", value: false)
            .eq(property: "trash", value: false)
            .eq(property: "section", value: "feeds")
            .lt(property: "last_message_timestamp", value: timeRange.1)
            .gte(property: "last_message_timestamp", value: timeRange.0)
            .sort(property: "last_message_timestamp", ordering: .orderedDescending)
            .limit(50)
        
        FeathersManager.Services.threads.request(.find(query: query))
            .on(value: { [weak self] response in
                let briefData = JSON(response.data.value)
                self?.pendingData[categoryId] = briefData
                self?.sendRequestsCallIfNeeded()
            }).startWithFailed({ [weak self] error in
                if let count = self?.pendingCategoriesCount {
                    self?.pendingCategoriesCount = count - 1
                    self?.sendRequestsCallIfNeeded()
                }
            })
    }
    
    // MARK: - Contacts request logic
    
    private func loadPendingContacts() {
        guard let accountId = fetchAccountId() else { return }
        
        let query = Query()
            .eq(property: "account_id", value: accountId)
            .eq(property: "list_name", value: "people")
            .nin(property: "status", values: ["approved", "ignored", "blocked"])
            .sort(property: "last_message_date", ordering: .orderedDescending)
            .limit(50)
        
        FeathersManager.Services.contacts.request(.find(query: query))
            .on(value: { [weak self] response in
                self?.pendingContacts = JSON(response.data.value)
                self?.processPendingData()
            }).startWithFailed({ [weak self] error in
                self?.processPendingData()
            })
    }
    
    // MARK: - Private categories data processing
    
    private func sendRequestsCallIfNeeded() {
        guard let count = pendingCategoriesCount else { return }
        if pendingData.keys.count == count {
            loadPendingContacts()
        }
    }
    
    private func processPendingData() {
        var brief: IFeedBrief = MorningBrief()
        
        pendingData.forEach { key, value in
            if let threads = value.array {
                if threads.count == 0 { return }
                brief.categoriesMap[key] = saveThreads(threads)
            }
        }
        
        // Temporary solution until Oksansa is implementing saving contacts into CoreData - Ostap
        if let contacts = pendingContacts?.array {
            brief.pendingRequests = contacts.map { element -> String in
                return element["name"].stringValue
            }
        }
        onDataLoaded?(brief)
    }
    
    private func fetchAccountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        return serializedUserObject["primary_account_id"] as? String
    }
    
    // MARK: - Process section
    
    private func saveThreads(_ threadsJson: [JSON]) -> [Threads] {
        var result = [Threads]()
        threadsJson.forEach({ element -> Void in
            if let savedThread = saveThread(element) {
                result.append(savedThread)
            }
        })
        return result
    }
    
    private func saveThread(_ threadJson: JSON) -> Threads? {
        guard let threadId = threadJson["id"].string else { return nil }
        if let threadEntity = threadsProxy.fetchThread(by: threadId) {
            parser.loadData(from: threadJson, to: threadEntity)
            threadsProxy.saveContext()
            return threadEntity
        } else {
            let thread = threadsProxy.addNewEmptyThread()
            parser.loadData(from: threadJson, to: thread)
            threadsProxy.saveContext()
            return thread
        }
    }
    
}
