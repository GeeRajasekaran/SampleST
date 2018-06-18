//
//  UITabBar+RespondableViews.swift
//  June
//
//  Created by Ostap Holub on 10/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension UITabBar {
    
    func buttons() -> [UIView] {
        var views = [UIView]()
        self.subviews.forEach { view in
            if view.isUserInteractionEnabled {
                views.append(view)
            }
        }
        return views
    }
    
}
