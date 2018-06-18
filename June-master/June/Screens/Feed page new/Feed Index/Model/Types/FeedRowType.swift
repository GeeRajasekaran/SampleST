//
//  FeedRowType.swift
//  June
//
//  Created by Ostap Holub on 1/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum FeedRowType: Int {
    case todayHeader
    case generic
    case news
    case calendarInvite
    case amazonConfirmation
    case earlierHeader
    case briefHeader
    case briefCategory
    case briefRequests
    case briefGenericItem
    case briefWideItem
    case briefCategoryControl
    case emptyToday
    case emptyBookmarks
    case pendingSubscriptions
    
    static func bookmarkedRows(from repository: FeedDataRepository?) -> [FeedRowType] {
        guard let unwrappedRepository = repository else {
            return [.todayHeader]
        }
        var rows: [FeedRowType] = [.todayHeader]
        let resultArray = unwrappedRepository.bookmarkedItems
        
        if resultArray.isEmpty {
            rows.append(.emptyBookmarks)
            return rows
        }
        
        resultArray.forEach { item in
            if item.isNews() {
                rows.append(.news)
            } else {
                rows.append(.generic)
            }
        }
        return rows
    }
    
    static func rows(for section: FeedSectionType, items: [Any], dataRepository: FeedDataRepository? = nil) -> [FeedRowType] {
        var rows: [FeedRowType] = []
        if section == .brief {
            rows.append(.todayHeader)
            if dataRepository?.pendingSubscriptionsCount != 0 && dataRepository?.isPendingSubscriptionClosed == false {
                rows.append(.pendingSubscriptions)
            }
            guard let currentBrief = dataRepository?.briefsManager.currentBrief else { return rows }
            
            if currentBrief.categoriesMap.keys.count == 0 && currentBrief.pendingRequests.count == 0 { return rows }
            rows.append(.briefHeader)
            let sortedKeys = currentBrief.categoriesMap.keys.sorted(by: { firstId, secondId in
                guard let firstCategory = dataRepository?.category(with: firstId),
                    let secondCategory = dataRepository?.category(with: secondId) else { return false }
                return firstCategory.order < secondCategory.order
            })

            sortedKeys.forEach { category in
                rows.append(.briefCategory)
                if currentBrief.selectedCategoryId == category {
                    guard let threadsCount = currentBrief.categoriesMap[category]?.count else { return }

                    let itemsPerPage: Int = 10
                    var countOfItems: Int = currentBrief.viewMoreAttempts * itemsPerPage

                    if countOfItems > threadsCount {
                        countOfItems = threadsCount
                    }

                    if category == "news" || category == "promotions" {
                        let array = Array(repeating: FeedRowType.briefWideItem, count: countOfItems)
                        rows.append(contentsOf: array)
                    } else {
                        let array = Array(repeating: FeedRowType.briefGenericItem, count: countOfItems)
                        rows.append(contentsOf: array)
                    }
                    rows.append(.briefCategoryControl)
                }
            }
            rows.append(.briefRequests)
            return rows
        } else if section == .earlier {
            rows.append(.earlierHeader)
        } else if section == .mostRecent {
            if let currentBrief = dataRepository?.briefsManager.currentBrief {
                if currentBrief.categoriesMap.keys.count == 0 && currentBrief.pendingRequests.count == 0 && items.count == 0 {
                    rows.append(.emptyToday)
                }
            } else {
                if items.count == 0 { rows.append(.emptyToday) }
            }
        }
        
        rows.append(contentsOf: items.map { singleItem in
            guard let feedItem = singleItem as? FeedItem else { return .generic }
            return feedItem.isNews() ? .news : .generic
        })
        return rows
    }
}
