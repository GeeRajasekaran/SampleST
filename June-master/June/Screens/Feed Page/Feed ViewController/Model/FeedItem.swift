//
//  NewsCard.swift
//  June
//
//  Created by Ostap Holub on 8/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedItem: Equatable {
    
    var vendorName: String? {
        get {
            var displayName = threadEntity?.last_message_from?.name
            if displayName == "" {
                displayName = threadEntity?.last_message_from?.email
            }
            return displayName
        }
    }
    
    var title: String? {
        get {
            return threadEntity?.subject
        }
    }
    
    var date: Int32? {
        get { return threadEntity?.last_message_timestamp }
    }
    
    var vendorPictureUrl: String? {
        get { return threadEntity?.last_message_from?.profile_pic }
    }
    
    var emailImageUrl: String? {
        get { return threadEntity?.cards?.email_image }
    }
    
    var category: String? {
        get { return threadEntity?.category }
    }
    
    var id: String? {
        get { return threadEntity?.id }
    }
    
    var starred: Bool {
        get { return threadEntity?.starred ?? false }
    }
    
    var unread: Bool {
        get { return threadEntity?.unread ?? false }
    }
    
    var type: FeedRowType {
        get { return isNews() == true ? .news : .generic }
    }
    
    var threadEntity: Threads?
    weak var feedCategory: FeedCategory?
    
    init() {
        
    }
    
    init(with entity: Threads, category: FeedCategory? = nil) {
        self.feedCategory = category
        threadEntity = entity
    }
    
    func isNews() -> Bool {
        var categoryId: String?
        
        if feedCategory?.id != nil {
            categoryId = feedCategory?.id
        } else if category != nil {
            categoryId = category
        }
        
        return categoryId == "news" || categoryId == "promotions"
    }
    
    func isCalendarInvite() -> Bool {
        return category == "calendar_invite"
    }
    
    func isAmazonItem() -> Bool {
        if threadEntity?.cards?.vendor?.name == "amazon" {
            return true
        }
        return false
    }
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.id == rhs.id
    }
}
