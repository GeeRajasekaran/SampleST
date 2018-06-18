//
//  ISwipeView.swift
//  June
//
//  Created by Ostap Holub on 11/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ISwipeView {
    var indexPath: IndexPath? { get set }
    var parentCell: FeedSwipyCell? { get set }
}
