//
//  FavsTableInfo.swift
//  June
//
//  Created by Joshua Cleetus on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FavsTableInfo: BaseTableModel {
    var favorites: Favorites?
    var from: String = ""
    var body: String = ""
    var subject: String = ""
    
    init(favorites: Favorites? = nil) {
        self.favorites = favorites
    }
}
