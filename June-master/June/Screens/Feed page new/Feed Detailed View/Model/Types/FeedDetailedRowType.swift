//
//  FeedDetailedRowTypes.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum FeedDetailedRowType: Int {
    case header
    case subject
    case message
    
    static func rows(for messagesCount: Int) -> [FeedDetailedRowType] {
        var count: Int = 0
        var result: [FeedDetailedRowType] = [FeedDetailedRowType]()
        while count != messagesCount {
            result.append(contentsOf: [.header, .subject, .message])
            count += 1
        }
        return result
    }
}
