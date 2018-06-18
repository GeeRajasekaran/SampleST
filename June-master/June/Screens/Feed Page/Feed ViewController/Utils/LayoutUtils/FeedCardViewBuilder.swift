//
//  FeedCardViewBuilder.swift
//  June
//
//  Created by Ostap Holub on 11/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedCardViewBuilder {
    
    // MARK: - Constants
    
    static let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Card view creation logic
    
    class func cardView(for rowType: FeedRowType, at rect: CGRect, at indexPath: IndexPath) -> IFeedCardView {
        let containerViewFrame = CGRect(x: FeedGenericCardLayoutConstants.leftInset, y: FeedGenericCardLayoutConstants.topInset, width: rect.width - (FeedGenericCardLayoutConstants.leftInset + FeedGenericCardLayoutConstants.rightInset), height: rect.height - (FeedGenericCardLayoutConstants.topInset + FeedGenericCardLayoutConstants.bottomInset))
        
        switch rowType {
        case .generic, .briefGenericItem:
            let view = FeedItemCardView(frame: containerViewFrame)
            view.indexPath = indexPath
            return view
        case .news, .briefWideItem:
            let view = FeedNewsCardView(frame: containerViewFrame)
            view.indexPath = indexPath
            return view
        default:
            let view = FeedItemCardView(frame: containerViewFrame)
            view.indexPath = indexPath
            return view
        }
    }
    
    // MARK: - Amazon card views creation logic
    
    class func amazonCardView(for item: FeedItem, at rect: CGRect) -> IFeedCardView {
        guard let amazonItem = item as? AmazonFeedItem else {
            return FeedItemCardView(frame: rect)
        }
        if amazonItem.isOrderConfirmation {
            return FeedAmazonConfirmationCardView(frame: rect)
        } else {
            return FeedItemCardView(frame: rect)
        }
    }
    
    // MARK: - Height calculation logic
    
    class func height(for item: FeedItem) -> CGFloat {
        var cardHeight: CGFloat = 0
        if item.isNews() {
            cardHeight = 0.37 * screenWidth
        } else if item.isAmazonItem() {
            cardHeight = amazonHeight(for: item)
        } else if item.isCalendarInvite() {
            if let eventItem = item as? CalendarInviteFeedItem {
                cardHeight = eventItem.eventEntity == nil ? 0.224 * screenWidth : 0.304 * screenWidth
            }
        } else {
            cardHeight = 0.224 * screenWidth
        }
        return FeedGenericCardLayoutConstants.topInset + cardHeight + FeedGenericCardLayoutConstants.bottomInset
    }
    
    // MARK: - Height for amazon item
    
    class func amazonHeight(for item: FeedItem) -> CGFloat {
        guard let amazonItem = item as? AmazonFeedItem else {
            return 0.224 * screenWidth
        }
        if amazonItem.isOrderConfirmation {
            return 0.447 * screenWidth
        } else {
            return 0.224 * screenWidth
        }
    }
}
