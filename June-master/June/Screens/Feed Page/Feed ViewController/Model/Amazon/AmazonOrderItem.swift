//
//  AmazonOrderItem.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class AmazonOrderItem {
    
    var name: String?
    var arrivalTimestamp: Int32?
    
    init(_ rawJson: String) {
        let json = JSON(parseJSON: rawJson)
        if !json.isEmpty {
            name = json.array?.first?["name"].string
            arrivalTimestamp = json.array?.first?["eta"].array?.first?.int32
        }
    }
}
