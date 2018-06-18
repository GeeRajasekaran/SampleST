//
//  FeedHeaderInfo.swift
//  June
//
//  Created by Ostap Holub on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedHeaderInfo: BaseTableModel {
    
    var title: String
    var buttonValue: Bool
    
    init(title: String, value: Bool) {
        self.title = title
        self.buttonValue = value
    }
}
