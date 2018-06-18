//
//  FeedCalendarInviteTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 11/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedCalendarInviteTableViewCell: FeedItemCell {
    
    // MARK: - Reuse section
    
    override class func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
