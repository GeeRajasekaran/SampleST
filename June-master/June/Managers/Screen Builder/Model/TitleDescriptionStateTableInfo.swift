//
//  TitleDescriptionStateTableInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

class TitleDescriptionStateTableInfo: BaseTableModel {
    var value: String
    var subTitle: String
    var state: Bool
    
    init(value: String, description: String, state: Bool) {
        self.value = value
        self.subTitle = description
        self.state = state
        super.init()
    }
}

