//
//  URL+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension URL {
    
    static func buildURL(_ baseURL: String, params: [String: String]) -> URL {
        let paramString = params.stringFromHttpParameters()
        return URL(string:"\(baseURL)?\(paramString)")!
    }
}
