//
//  AmazonFeedItem.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class AmazonFeedItem: FeedItem {
    
    var amazonOrderItem: AmazonOrderItem?
    
    var template: String? {
        get { return threadEntity?.cards?.template }
    }
    
    var iconUrl: URL? {
        get {
            if let urlString = threadEntity?.cards?.vendor?.icon {
                return URL(string: urlString)
            }
            return nil
        }
    }
    
    var isOrderConfirmation: Bool {
        get { return template == "order_confirmation" }
    }
    
    override init(with entity: Threads, category: FeedCategory?) {
        super.init(with: entity, category: category)
        if let rawString = threadEntity?.cards?.items?.firstObject as? String {
            amazonOrderItem = AmazonOrderItem(rawString)
        }
    }
}
