//
//  FeedRecentItemsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 11/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedRecentItemsDataRepository {
    
    // MARK: - Variables & Constants
    
    var recentItems: [FeedItem]
    var mostRecentItems: [FeedItem]
    var bookmarkedItems: [FeedItem] = []
    
    private weak var repository: FeedDataRepository?
    
    // MARK: - Initialization
    
    init(store: FeedDataRepository?) {
        repository = store
        recentItems = [FeedItem]()
        mostRecentItems = [FeedItem]()
    }
    
    // MARK: - Count of items
    
    var count: Int {
        get {
            return recentItems.count
        }
    }
    
    var mostRecentCount: Int {
        get {
            return mostRecentItems.count
        }
    }
    
    // MARK: - Items accessing methods
    
    func mostRecentItem(at index: Int) -> FeedItem? {
        if repository?.isBookmarksActive == true {
            return item(at: index, from: bookmarkedItems)
        } else {
            return item(at: index, from: mostRecentItems)
        }
    }
    
    func item(at index: IndexPath) -> FeedItem? {
        if repository?.isBookmarksActive == true {
            return item(at: index.row, from: bookmarkedItems)
        } else {
            let array: [FeedItem] = index.section == 0 ? mostRecentItems : recentItems
            return item(at: index.row, from: array)
        }
    }
    
    private func item(at index: Int, from array: [FeedItem]) -> FeedItem? {
        if index >= 0 && index < array.count {
            return array[index]
        }
        return nil
    }
    
    func update(_ item: FeedItem, at index: IndexPath) {
        if repository?.isBookmarksActive == true {
            bookmarkedItems[index.row] = item
        } else {
            if index.section == 0 {
                mostRecentItems[index.row] = item
            } else if index.section == 1 {
                recentItems[index.row] = item
            }
        }
    }
    
    func indexOfItem(with id: String) -> IndexPath? {
        if repository?.isBookmarksActive == true {
            if let mostRecentIndex = indexOfItem(with: id, in: bookmarkedItems) {
                return IndexPath(row: mostRecentIndex, section: 0)
            }
            return nil
        } else {
            if let mostRecentIndex = indexOfItem(with: id, in: mostRecentItems) {
                return IndexPath(row: mostRecentIndex, section: 0)
            } else if let earlierIndex = indexOfItem(with: id, in: recentItems) {
                return IndexPath(row: earlierIndex, section: 1)
            }
        }
        return nil
    }
    
    private func indexOfItem(with id: String, in array: [FeedItem]) -> Int? {
        return array.index(where: { $0.id == id })
    }
    
    func removeItem(at indexPath: IndexPath) {
        if repository?.isBookmarksActive == true {
            bookmarkedItems.remove(at: indexPath.row)
        } else {
            if indexPath.section == 0 {
                mostRecentItems.remove(at: indexPath.row)
            } else {
                recentItems.remove(at: indexPath.row)
            }
        }
    }
    
    // MARK: - Items appending methods
    
    func append(_ item: FeedItem?) {
        guard let unwrappedItem = item else {
            print("\(#file) at line \(#line): Failed to append nil item")
            return
        }
        recentItems.append(unwrappedItem)
    }
    
    func append(contentsOf array: [FeedItem]?) {
        guard let unwarappedArray = array else {
            print("\(#file) at line \(#line): Failed to append nil array")
            return
        }
        recentItems.append(contentsOf: unwarappedArray)
    }
    
    func replace(with array: [FeedItem]?) {
        guard let unwarappedArray = array else {
            print("\(#file) at line \(#line): Failed to replace with nil array")
            return
        }
        recentItems = unwarappedArray
        mostRecentItems = mostRecentThreads()
    }
    
    // MARK: - Items filtering methods
    
    func updateThreads() {
        if repository?.isBookmarksActive == true {
            filterBookmarks()
        }
    }
    
    func filterBookmarks() {
        let bookmarkedMostRecentItems = mostRecentItems.filter { $0.starred == true }
        let bookmarkedRecentItems = recentItems.filter { $0.starred == true }
        bookmarkedItems = bookmarkedMostRecentItems + bookmarkedRecentItems
    }
    
    private func mostRecentThreads() -> [FeedItem] {
        guard let firstTimestamp = recentItems.first?.date else { return [] }
        
        let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = TimeZone.current
        
        let midnightTimestamp = currentCalendar.startOfDay(for: firstDate).timeIntervalSince1970
        let filteredItems = recentItems.filter { filterPredicate($0, midnightTimestamp) }
        
        filteredItems.forEach { [weak self] element in
            if let index = self?.recentItems.index(of: element) {
                self?.recentItems.remove(at: index)
            }
        }
        return filteredItems
    }
    
    private lazy var filterPredicate: (FeedItem, TimeInterval) -> Bool = { item, timestamp in
        guard let unwrappedTimestamp = item.date else { return false }
        return unwrappedTimestamp > Int32(timestamp)
    }
}
