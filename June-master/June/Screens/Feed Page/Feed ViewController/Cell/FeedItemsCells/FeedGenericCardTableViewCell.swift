//
//  FeedGenericCardTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 11/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

/// This class should be used to place container view on cell and for calculating necessary cell height
class FeedGenericCardLayoutConstants {
    
    static let verticalInset: CGFloat = 0.016
    static let horizontalInset: CGFloat = 0.032
    static let cornerRadius: CGFloat = 0.026 * UIScreen.main.bounds.width
    
    static var topInset: CGFloat {
        get { return verticalInset * UIScreen.main.bounds.width }
    }
    
    static var bottomInset: CGFloat {
        get { return verticalInset * UIScreen.main.bounds.width }
    }
    
    static var leftInset: CGFloat {
        get { return horizontalInset * UIScreen.main.bounds.width }
    }
    
    static var rightInset: CGFloat {
        get { return horizontalInset * UIScreen.main.bounds.width }
    }
}

class FeedGenericCardTableViewCell: FeedItemCell {
    
    // MARK: - Reuse section
    
    override class func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
