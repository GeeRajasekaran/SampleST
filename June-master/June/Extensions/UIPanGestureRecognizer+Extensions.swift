//
//  UIPanGestureRecognizer + Extension.swift
//  June
//
//  Created by Joshua Cleetus on 1/18/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
    
    func isLeft(theViewYouArePassing: UIView) -> Bool {
        let detectionLimit: CGFloat = 40
        let velocityPan : CGPoint = velocity(in: theViewYouArePassing)
        if velocityPan.x > detectionLimit {
            print("Gesture went right")
            return false
        } else if velocityPan.x < -detectionLimit {
            print("Gesture went left")
            return true
        }
        
        return false
    }
    
}
