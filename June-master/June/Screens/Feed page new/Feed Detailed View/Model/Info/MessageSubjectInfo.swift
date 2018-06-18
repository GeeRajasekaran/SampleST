//
//  MessageSubjectInfo.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class MessageSubjectInfo: BaseTableModel {
    
    var subject: String?
    
    init(thread: Threads) {
        subject = thread.subject
    }
    
}
