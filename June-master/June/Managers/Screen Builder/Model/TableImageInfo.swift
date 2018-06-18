//
//  TableImageInfo.swift
//  June
//
//  Created by Joshua Cleetus on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

class TableImageInfo: BaseTableModel {
    var value: String
    var image: UIImage
    
    init(value: String, image: UIImage) {
        self.value = value
        self.image = image
        super.init()
    }
}
