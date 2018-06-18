//
//  FeedAmazonCardTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedAmazonCardTableViewCell: FeedItemCell {
    
    // MARK: - Reuse section
    
    override class func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
