//
//  ButtonItemHolderInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//


class ButtonItemHolderInfo: BaseTableModel {
    
    var header: String = ""
    var value: String
    var enableButton: Bool
    
    init(value: String, enableButton: Bool) {
        self.value = value
        self.enableButton = enableButton
        super.init()
    }

}
