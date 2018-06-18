//
//  PendingRequestItemInfo.swift
//  June
//
//  Created by Ostap Holub on 3/28/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class PendingRequestItemInfo: BaseTableModel {
    
    var title: String
    var count: Int
    var names: [String]
    
    init(title: String, count: Int) {
        self.title = title
        self.count = count
        names = [String]()
    }
}
