//
//  FeedGenericItemInfo.swift
//  June
//
//  Created by Ostap Holub on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedGenericItemInfo: BaseTableModel {
    
    // MARK: - Variables
    
    var thread: Threads?
    private var feedCategory: FeedCategory?
    
    // MARK: - Calculated properties
    
    var subject: String? {
        get { return thread?.subject }
    }
    
    var vendor: String? {
        get { return loadVendorName() }
    }
    
    var date: Int32? {
        get { return thread?.last_message_timestamp }
    }
    
    var pictureUrl: URL? {
        get { return loadVendorImageURL() }
    }
    
    var categoryPictureURL: URL? {
        get { return loadCategoryImageURL() }
    }
    
    var starred: Bool {
        get { return thread?.starred ?? false }
    }
    
    var category: String? {
        get { return thread?.category ?? "" }
    }
    
    var template: FeedCardTemplate?
    
    // MARK: - Initialization
    
    init(thread: Threads?, template: FeedCardTemplate? = nil, category: FeedCategory? = nil) {
        self.thread = thread
        self.feedCategory = category
        self.template = template
    }
    
    // MARK: - Private processing logic
    
    private func loadVendorName() -> String? {
        var displayName = thread?.last_message_from?.name
        if displayName == "" {
            displayName = thread?.last_message_from?.email
        }
        return displayName
    }
    
    private func loadVendorImageURL() -> URL? {
        if let urlString = thread?.last_message_from?.profile_pic {
            return URL(string: urlString)
        }
        return nil
    }
    
    private func loadCategoryImageURL() -> URL? {
        if template?.icons.isEmpty == true { return nil }
        let screenScale = Int(UIScreen.main.scale) - 1
        if let count = template?.icons.count {
            if 0..<count ~= screenScale {
                return template?.icons[screenScale]
            }
        }
        return nil
    }
}
