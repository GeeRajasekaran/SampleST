//
//  BriefCategoryControlInfo.swift
//  June
//
//  Created by Ostap Holub on 2/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefCategoryControlInfo: BaseTableModel {
    
    var isViewMoreVisible: Bool
    
    init(brief: IFeedBrief) {
        isViewMoreVisible = false
        guard let selectedCategoryId = brief.selectedCategoryId,
            let threadsCount = brief.categoriesMap[selectedCategoryId]?.count else { return }
        
        let itemsPerPage: Int = 10
        let countOfItems = itemsPerPage * brief.viewMoreAttempts
        
        isViewMoreVisible = countOfItems < threadsCount
    }
}
