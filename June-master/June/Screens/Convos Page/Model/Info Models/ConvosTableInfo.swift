//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 12/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ConvosNewPreview: BaseTableModel {
    var previewMails: [ConvosTableInfo] = []
}

class ConvosTableInfo: BaseTableModel {
    var thread: Threads?
    var from: String = ""
    var body: String = ""
    var subject: String = ""
    var type: ConvosType = ConvosType.new
    
    init(thread: Threads? = nil) {
        self.thread = thread
    }
}


enum ConvosType {
    case new
    case seen
    case cleared
    case spam
}
