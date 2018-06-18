//
//  FeedCardTemplate.swift
//  June
//
//  Created by Ostap Holub on 1/24/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedCardTemplate {
    
    // MARK: - Variables & Constants
    
    private struct Key {
        static let id: String = "id"
        static let category: String = "category"
        static let icons: String = "small_graphics"
    }
    
    var id: String
    var category: String
    var icons: [URL?] = [URL?]()
    
    // MARK: - Initialization
    
    init(json: JSON) {
        id = json[Key.id].stringValue
        category = json[Key.category].stringValue
        icons = iconsUrls(from: json)
    }
    
    // MARK: - Private processing
    
    private func iconsUrls(from json: JSON) -> [URL?] {
        guard let array = json[Key.icons].array else { return [] }
        return array.compactMap{ return URL(string: $0.stringValue) }
    }

}
