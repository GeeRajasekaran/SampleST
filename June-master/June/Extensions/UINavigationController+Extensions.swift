//
//  UINavigationController+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var childViewControllerForStatusBarHidden : UIViewController? {
        return self.topViewController
    }
    
    open override var childViewControllerForStatusBarStyle : UIViewController? {
        return self.topViewController
    }
    
    open var rootViewController : UIViewController? {
        return self.viewControllers.first
    }
}
