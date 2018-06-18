//
//  TableLabelInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//


class TableLabelInfo: BaseTableModel {
    var value: String
    var subValue: String

    init(value: String, subValue: String = "") {
        self.value = value
        self.subValue = subValue
        super.init()
    }
}
