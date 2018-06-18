//
//  Brief.swift
//  June
//
//  Created by Ostap Holub on 1/26/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IFeedBrief {
    var categoriesMap: [String: [Threads]] { get set }
    var pendingRequests: [String] { get set }
    var sortedKeys: [String] { get set }
    var selectedCategoryId: String? { get set }
    
    var viewMoreAttempts: Int { get set }
}

class MorningBrief: IFeedBrief {
    
    var categoriesMap: [String: [Threads]]
    var pendingRequests: [String]
    var sortedKeys: [String]
    var selectedCategoryId: String?
    var viewMoreAttempts: Int
    
    init() {
        categoriesMap = [:]
        pendingRequests = []
        sortedKeys = []
        viewMoreAttempts = 1
    }
    
}
