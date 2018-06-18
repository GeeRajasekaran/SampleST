//
//  FeedItemCell.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedItemCell: FeedSwipyCell {
    
    // MARK: - Variables
    
    var cardView: IFeedCardView?
    
    // MARK: - Reuse logic
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView?.view.removeFromSuperview()
        cardView = nil
    }
    
    // MARK: - View setup
    
    func performBasicUISetup() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func set(feedView: IFeedCardView) {
        performBasicUISetup()
        cardView = feedView
        addSubview(feedView.view)
        cardView?.setupSubviews()
        cardView?.loadItemData()
    }
    
    func performScaleDown() {
        guard let view = cardView?.view else { return }
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        })
    }
    
    func performScaleUp() {
        guard let view = cardView?.view else { return }
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
