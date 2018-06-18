//
//  RequestsSectionType.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum RequestsSectionType: Int {
    case section = 0
    
    static func sections(for screenType: RequestsScreenType) -> [RequestsSectionType] {
        return [.section]
    }
}
