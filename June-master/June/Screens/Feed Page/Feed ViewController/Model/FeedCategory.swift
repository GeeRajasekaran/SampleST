//
//  CategoryFilter.swift
//  June
//
//  Created by Ostap Holub on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedCategory: Equatable {
    
    var id: String
    var title: String
    var icons: [String]
    var selected: Bool
    var colorHex: String
    var shouldLoad: Bool
    var shortTitle: String
    var order: Int
    var graphics: [URL?] = [URL?]()
    
    var newsCards: [FeedItem]
    
    var currentGraphic: URL? {
        get {
            let currentScale = Int(UIScreen.main.scale) - 1
            if 0..<graphics.count ~= currentScale {
                return graphics[currentScale]
            }
            return nil
        }
    }
    
    init(with jsonObject: JSON) {
        icons = []
        newsCards = []
        
        id = jsonObject["id"].stringValue
        title = jsonObject["title"].stringValue
        colorHex = jsonObject["color"].stringValue
        shortTitle = jsonObject["abbrev"].stringValue
        order = jsonObject["order"].intValue - 1
        
        if let iconsArray = jsonObject["icons"].array {
            for icon in iconsArray {
                icons.append(icon.stringValue)
            }
        }
        selected = false
        shouldLoad = true
        graphics = graphicsUrls(from: jsonObject)
    }
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
        shouldLoad = true
        icons = []
        selected = true
        colorHex = ""
        shortTitle = ""
        order = 0
        newsCards = []
    }
    
    func isNews() -> Bool {
        return id == "news"
    }
    
    static func == (lhs: FeedCategory, rhs: FeedCategory) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func graphicsUrls(from json: JSON) -> [URL?] {
        guard let array = json["graphics"].array else { return [] }
        return array.compactMap{ return URL(string: $0.stringValue) }
    }
}
