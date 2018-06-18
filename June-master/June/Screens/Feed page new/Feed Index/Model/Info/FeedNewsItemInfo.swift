//
//  FeedNewsItemInfo.swift
//  June
//
//  Created by Ostap Holub on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedNewsItemInfo: FeedGenericItemInfo {
    
    // MARK: - Calculated properties
    
    var newsImageURL: URL? {
        get { return loadNewsImageURL() }
    }
    
    // MARK: - Private processing
    
    private func loadNewsImageURL() -> URL? {
        if let urlString = thread?.cards?.email_image {
            return URL(string: urlString)
        }
        return nil
    }
}
