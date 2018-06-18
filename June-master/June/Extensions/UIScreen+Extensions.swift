//
//  UIScreen+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit


extension UIScreen {
    
    class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    static func is4S() -> Bool {
        let iPhone4ScreenHeight: CGFloat = 480.0
        if size.height <= iPhone4ScreenHeight {
            return true
        } else {
            return false
        }
    }
    static func isSmallerScreen() -> Bool {
        let iPhone5ScreenHeight: CGFloat = 568.0
        if size.height <= iPhone5ScreenHeight {
            return true
        } else {
            return false
        }
    }
    
    static func is6Or6S() -> Bool {
        if size.height > 480 && size.height < 736 {
            return true
        } else {
            return false
        }
    }
    
    static func is6PlusOr6SPlus() -> Bool {
        if size.height >= 736 {
            return true
        } else {
            return false
        }
    }
    
    static func isLargeScreen() -> Bool {
        if size.height > 568.0 {
            return true
        } else {
            return false
        }
    }
    
    static func isWideScreen() -> Bool {
        if size.width > 375.0 {
            return true
        }
        else {
            return false
        }
    }
    
    static func isNarrowScreen() -> Bool {
        if size.width <= 320.0 {
            return true
        }
        else {
            return false
        }
    }
    
    static var isPhoneX: Bool {
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        return min(width, height) == 375 && max(width, height) == 812
    }
    
}
