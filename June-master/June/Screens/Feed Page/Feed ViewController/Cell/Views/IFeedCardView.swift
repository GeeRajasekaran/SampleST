//
//  IFeedCardView.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol IFeedCardView {
    
    /// Typealias for more options action
    typealias RemoveBookmarkClosure = (IndexPath) -> Void
    
    /// Index of item
    var indexPath: IndexPath? { get set }
    
    /// Item that will be represented by view
    var itemInfo: FeedGenericItemInfo? { get set }
    
    /// Action for using on more action button tap, can be nil if more option button isn't at view
    var onRemoveBookmarkAction: RemoveBookmarkClosure? { get set }
    
    /// Returns self as view
    var view: UIView { get }
    
    /// Methods for loading data from stored item
    func loadItemData()
    
    /// Methods for setup subviews on view
    func setupSubviews()
    
    /// Method that will be called when is is necessary to update star state
    func changeStarState()
}
