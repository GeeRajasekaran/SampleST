//
//  FeedTableView.swift
//  June
//
//  Created by Ostap Holub on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedTableView: UITableView {
    
    // this method disable default floating header behavior
    // for table views with plain style
    
    @objc func allowsHeaderViewsToFloat() -> Bool {
        return false
    }
    
    // this method disable default floating footer behavior
    // for table views with plain style
    
    @objc func allowsFooterViewsToFloat() -> Bool {
        return false
    }
}
