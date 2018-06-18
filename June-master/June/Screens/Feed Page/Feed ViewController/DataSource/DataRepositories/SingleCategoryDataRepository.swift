//
//  SingleCategoryDataRepository.swift
//  June
//
//  Created by Ostap Holub on 12/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class SingleCategoryDataRepository {
    
    // MARK: - Variables & Constants
    
    weak var currentCategory: FeedCategory?
    private var uniqueDates: [Date] = [Date]()
    private var itemsMap: [Date: [FeedItem]] = [Date: [FeedItem]]()
    private var bookmarkedUniqeDates: [Date] = [Date]()
    private var bookmarkedItemsMap: [Date: [FeedItem]] = [Date: [FeedItem]]()
    
    var isBookmarksActive: Bool = false {
        didSet {
            if isBookmarksActive {
                filterByBookmarks()
            } else {
                bookmarkedUniqeDates.removeAll()
                bookmarkedItemsMap.removeAll()
            }
        }
    }
    
    // MARK: - Initialization
    
    init(category: FeedCategory?) {
        currentCategory = category
        uniqueDates = fetchUniqueDates()
        itemsMap = mapItems()
    }
    
    // MARK: - Public data accessing logic
    
    var sectionsCount: Int {
        get {
            if isBookmarksActive {
                return bookmarkedUniqeDates.count
            } else {
                return uniqueDates.count
            }
        }
    }
    
    func removeItem(at index: IndexPath) {
        if isBookmarksActive {
            if let currentDate = date(at: index.section) {
                if bookmarkedItemsMap[currentDate] != nil {
                    bookmarkedItemsMap[currentDate]?.remove(at: index.row)
                }
            }
        } else {
            if let currentDate = date(at: index.section) {
                if itemsMap[currentDate] != nil {
                    itemsMap[currentDate]?.remove(at: index.row)
                }
            }
        }
    }
    
    private func getIndex(of item: FeedItem, in map: [Date: [FeedItem]], to itemIndex: inout Int?, for itemDate: inout Date) {
        for (key, value) in map {
            itemIndex = index(of: item, in: value)
            if itemIndex != nil {
                itemDate = key
                break
            }
        }
    }
    
    func index(of item: FeedItem) -> IndexPath? {
        var itemIndex: Int?
        var itemDate: Date = Date()
        
        if isBookmarksActive {
            getIndex(of: item, in: bookmarkedItemsMap, to: &itemIndex, for: &itemDate)
            if let section = bookmarkedUniqeDates.index(of: itemDate), let row = itemIndex {
                return IndexPath(row: row, section: section)
            }
        } else {
            getIndex(of: item, in: itemsMap, to: &itemIndex, for: &itemDate)
            if let section = uniqueDates.index(of: itemDate), let row = itemIndex {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    
    func index(of item: FeedItem, in array: [FeedItem]) -> Int? {
        return array.index(of: item)
    }
    
    func countOfRows(in section: Int) -> Int {
        let datesArray = isBookmarksActive ? bookmarkedUniqeDates : uniqueDates
        guard let sectionDate = date(at: section, in: datesArray) else { return 0 }
        if let count = countOfItems(for: sectionDate) {
            return count
        }
        return 0
    }
    
    func item(in section: Int, at index: Int) -> FeedItem? {
        let datesArray = isBookmarksActive ? bookmarkedUniqeDates : uniqueDates
        guard let sectionDate = date(at: section, in: datesArray) else { return nil }
        
        if isBookmarksActive {
            guard let unwrappedArray = bookmarkedItemsMap[sectionDate] else { return nil }
            return item(at: index, from: unwrappedArray)
        } else {
            guard let unwrappedArray = itemsMap[sectionDate] else { return nil }
            return item(at: index, from: unwrappedArray)
        }
    }
    
    func updateData() {
        uniqueDates = fetchUniqueDates()
        itemsMap = mapItems()
        if isBookmarksActive {
            bookmarkedUniqeDates.removeAll()
            bookmarkedItemsMap.removeAll()
            filterByBookmarks()
        }
    }
    
    // MARK: - Private accessing logic
    
    private func countOfItems(for date: Date) -> Int? {
        if isBookmarksActive {
            return bookmarkedItemsMap[date]?.count
        } else {
            return itemsMap[date]?.count
        }
    }
    
    private func date(at index: Int, in array: [Date]) -> Date? {
        if index >= 0 && index < array.count {
            return array[index]
        }
        return nil
    }
    
    private func date(at index: Int) -> Date? {
        if index >= 0 && index < uniqueDates.count {
            return uniqueDates[index]
        }
        return nil
    }
    
    private func item(at index: Int, from array: [FeedItem]) -> FeedItem? {
        if index >= 0 && index < array.count {
            return array[index]
        }
        return nil
    }
    
    // MARK: - Feed items processing logic
    
    private func filterByBookmarks() {
        itemsMap.forEach { [weak self] key, value in
            let filteredItems = value.filter { $0.starred }
            if !filteredItems.isEmpty {
                self?.bookmarkedItemsMap[key] = filteredItems
                self?.bookmarkedUniqeDates.append(key)
            }
        }
        bookmarkedUniqeDates.sort(by: { $0 > $1 })
    }
    
    private func fetchUniqueDates() -> [Date] {
        guard let unwrappedCategory = currentCategory else { return [] }
        
        var set = Set<Date>()
        var result = [Date]()
        
        unwrappedCategory.newsCards.forEach { item in
            guard let timestamp = item.date else { return }
            let date = TimestampsConverter.date(from: timestamp)
            if !set.contains(date) {
                set.insert(date)
                result.append(date)
            }
        }
        return result
    }
    
    private func mapItems() -> [Date: [FeedItem]] {
        guard let unwrappedCategory = currentCategory else { return [:] }
        var result = [Date: [FeedItem]]()
        
        uniqueDates.forEach { date in
            guard let endTimestamp = TimestampsConverter.end(of: date)?.timeIntervalSince1970 else { return }
            let items = unwrappedCategory.newsCards.filter { filterPredicate($0, date.timeIntervalSince1970, endTimestamp) }
            result[date] = items
        }
        return result
    }
    
    private lazy var filterPredicate: (FeedItem, TimeInterval, TimeInterval) -> Bool = { item, start, end in
        guard let unwrappedTimestamp = item.date else { return false }
        let endTimstamp = Int32(end)
        let startTimestamp = Int32(start)
        return unwrappedTimestamp >= startTimestamp && unwrappedTimestamp <= endTimstamp
    }
}
