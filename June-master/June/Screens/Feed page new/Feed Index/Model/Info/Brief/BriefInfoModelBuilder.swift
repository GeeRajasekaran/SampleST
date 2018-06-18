//
//  BriefInfoModelBuilder.swift
//  June
//
//  Created by Ostap Holub on 1/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefInfoModelBuilder {
    
    func briefCategoryInfo(dataRepository: FeedDataRepository?, at indexPath: IndexPath) -> BriefCategoryInfo? {
        guard var brief = dataRepository?.briefsManager.currentBrief,
            let categories = dataRepository?.categories() else { return nil }
        
        var sortedKeys = brief.categoriesMap.keys.sorted(by: { sortPredicate($0, $1, categories) })
        brief.categoriesMap.forEach { key, value in
            if key == brief.selectedCategoryId {
                guard let threadsCount = brief.categoriesMap[key]?.count else { return }
                
                let itemsPerPage: Int = 10
                var countOfItems: Int = brief.viewMoreAttempts * itemsPerPage
                
                if countOfItems > threadsCount {
                    countOfItems = threadsCount
                }
                
                let items = Array(repeating: "item", count: countOfItems)
                if let index = sortedKeys.index(of: brief.selectedCategoryId!) {
                    sortedKeys.insert(contentsOf: items, at: index + 1)
                    sortedKeys.insert("control", at: index + 1 + countOfItems)
                }
            }
        }
        brief.sortedKeys = sortedKeys
        
        let currentCategoryId = sortedKeys[indexPath.row]
        guard let currentCategory = dataRepository?.category(with: currentCategoryId),
            let threads = brief.categoriesMap[currentCategoryId] else { return nil }
        
        return BriefCategoryInfo(threads: threads, category: currentCategory)
    }
    
    func briefRequestsInfo(dataRepository: FeedDataRepository?) -> BriefReqeustsInfo? {
        guard let brief = dataRepository?.briefsManager.currentBrief else { return nil }
        return BriefReqeustsInfo(names: brief.pendingRequests)
    }
    
    func briefControlInfo(dataRepository: FeedDataRepository?) -> BriefCategoryControlInfo? {
        guard let currentBrief = dataRepository?.briefsManager.currentBrief else { return nil }
        return BriefCategoryControlInfo(brief: currentBrief)
    }
    
    private lazy var sortPredicate: (String, String, [FeedCategory]) -> Bool = { firstId, secondId, categories in
        guard let firstCategory = categories.first(where: { $0.id == firstId }),
            let secondCategory = categories.first(where: { $0.id == secondId }) else { return false }
        
        return firstCategory.order < secondCategory.order
    }
    
}
