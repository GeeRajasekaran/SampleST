//
//  LinkItemHolderInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//


class LinkItemHolderInfo: BaseTableModel {

    var value: String
    var linkPath: String
    
    init(value: String, linkPath: String) {
        self.value = value
        self.linkPath = linkPath
        super.init()
    }
    
}
