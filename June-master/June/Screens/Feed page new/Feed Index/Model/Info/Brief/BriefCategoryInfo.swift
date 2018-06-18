//
//  BriefCategoryInfo.swift
//  June
//
//  Created by Ostap Holub on 1/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefCategoryInfo: BaseTableModel {
    
    // MARK: - Variables & Constants
    
    var title: String
    var newItemsCount: Int
    var vendorImageURL: [URL]
    var categoryIconUrl: URL?
    
    private let templatesReader: ITemplateReadable = TemplatesHandler()
    private let countOfVendorIcons: Int = 4
    
    // MARK: - Initialization
    
    init(threads: [Threads], category: FeedCategory) {
        self.title = category.title
        self.newItemsCount = threads.count
        self.vendorImageURL = [URL]()
        self.categoryIconUrl = category.currentGraphic
        super.init()
        loadVendorIcons(from: threads)
    }
    
    // MARK: - Vendor images loading
    
    private func loadVendorIcons(from threads: [Threads]) {
        let lastThreads = threads.suffix(countOfVendorIcons)
        lastThreads.forEach { [weak self] singleThread in
            if let urlString = singleThread.last_message_from?.profile_pic, let url = URL(string: urlString) {
                self?.vendorImageURL.append(url)
            }
        }
    }
}
