//
//  FeedItemsFactory.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedItemsFactory {
    
    class func item(for thread: Threads, and category: FeedCategory? = nil) -> FeedItem {
        if thread.cards?.vendor?.name == "amazon" {
            return AmazonFeedItem(with: thread, category: category)
        } else if thread.category == "calendar_invite" {
            return CalendarInviteFeedItem(with: thread, category: category)
        } else {
            return FeedItem(with: thread, category: category)
        }
    }
}
