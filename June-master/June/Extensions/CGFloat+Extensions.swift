//
//  CGFloat+Extensions.swift
//  Romio
//
//  Created by Joshua Cleetus on 8/22/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import UIKit

extension CGFloat {
    
    static let lightGrayBaseValue: CGFloat  = 140.0
    
    static var lightGrayOffset: CGFloat {
        let lightGrayPiDiff = (CGFloat.lightGrayBaseValue / CGFloat.pi) / CGFloat.lightGrayBaseValue
        let offset = CGFloat.lightGrayBaseValue + lightGrayPiDiff
        return offset
    }
    
    static var topBottomGradiantXOffset: CGFloat {
        let baseMultiplier: Float = 0.03
        let baseExponent: Float = 1/8
        let result = powf(Float(baseMultiplier * Float.pi), baseExponent)
        return CGFloat(result)
    }
    
    var plusOne: CGFloat {
        return self + 1
    }
    
    var minusOne: CGFloat {
        return self - 1
    }
    
    var inverse: CGFloat {
        return -self
    }
    
}
