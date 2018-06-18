//
//  TitleDescriptionTableInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

class TitleDescriptionTableInfo: BaseTableModel {

    var value: String
    var subTitle: String
    
    init(value: String, description: String) {
        self.value = value
        self.subTitle = description
        super.init()
    }
    
}
