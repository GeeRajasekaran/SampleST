//
//  TableLabelAttributedInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

class TableLabelAttributedInfo: BaseTableModel {
    var value: NSAttributedString
    
    init(value: NSAttributedString) {
        self.value = value
        super.init()
    }
}
