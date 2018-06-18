//
//  MessageBodyInfo.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class MessageBodyInfo: BaseTableModel {
    
    var body: String?
    
    init(message: Messages) {
        body = message.body
    }
}
