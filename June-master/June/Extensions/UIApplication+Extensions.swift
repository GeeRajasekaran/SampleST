//
//  UIApplication+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

private var firstLaunch : Bool = false

extension UIApplication {

    func addSubviewOnFrontWindow(view:UIView) {
        if let window = self.windows.last {
            window.addSubview(view)
        }
    }
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }        
        return viewController
    }
    
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "isFirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            firstLaunch = isFirstLaunch
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
        }
        return firstLaunch || isFirstLaunch
    }
    
}
