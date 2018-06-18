//
//  Bool+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

extension Bool: IntValue {
    func intValue() -> Int {
        if self {
            return 1
        }
        return 0
    }
}

protocol IntValue {
    func intValue() -> Int
}
