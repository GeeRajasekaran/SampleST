//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 3/29/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

enum RolodexsSegmentType: Int {
    case recent
    case favorites

    static var segments: [RolodexsSegmentType] = [recent, favorites]
    
    func stringValue() -> String {
        switch self {
        case .recent:
            return "Recent"
        case .favorites:
            return "Favorites"
        }
    }
}
