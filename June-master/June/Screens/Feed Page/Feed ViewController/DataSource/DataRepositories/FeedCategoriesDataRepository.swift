//
//  FeedCategoriesDataRepository.swift
//  June
//
//  Created by Ostap Holub on 11/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedCategoriesDataRepository {
    
    // MARK: - Variables & Constants
    
    var categories = [FeedCategory]()
    
    // MARK: - Count of items
    
    var count: Int {
        get { return categories.count }
    }
    
    // MARK: - Category accessing methods
    
    func indexOfItem(with id: String, in category: FeedCategory?) -> Int? {
        guard let unwrappedCategory = category else { return nil }
        return unwrappedCategory.newsCards.index(where: { $0.id == id })
    }
    
    func category(at index: Int) -> FeedCategory? {
        if index >= 0 && index < categories.count {
            return categories[index]
        }
        return nil
    }
    
    func category(with id: String?) -> FeedCategory? {
        guard let unwrappedId = id else { return nil }
        if let index = categories.index(where: {$0.id == unwrappedId}) {
            return category(at: index)
        }
        return nil
    }
    
    // MARK: - Categories appending methods
    
    func append(_ category: FeedCategory?) {
        guard let unwrappedCategory = category else {
            print("\(#file) at line \(#line): Failed to append nil category")
            return
        }
        categories.append(unwrappedCategory)
    }
    
    func append(contentsOf array: [FeedCategory]?) {
        guard let unwarappedArray = array else {
            print("\(#file) at line \(#line): Failed to append nil array")
            return
        }
        categories.append(contentsOf: unwarappedArray)
    }
    
    func replace(with array: [FeedCategory]?) {
        guard let unwarappedArray = array else {
            print("\(#file) at line \(#line): Failed to replace with nil array")
            return
        }
        categories = unwarappedArray
    }
}
