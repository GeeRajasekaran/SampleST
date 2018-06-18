//
//  NSError+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

extension NSError {
    
    static func parseError() -> NSError {
        return  NSError(domain:"error parsing response", code: -11, userInfo: nil)
    }

    static func noDataError() -> NSError {
        return NSError(domain:"no data received", code: -10, userInfo: nil)
    }

}
