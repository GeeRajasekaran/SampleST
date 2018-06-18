//
//  UIInitializerFactory.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class UIInitializerFactory {
    
    class func initializer(for goal: ResponderOld.ResponderGoal, with root: ResponderViewControllerOld) -> IInitializer {
        if goal == .forward {
            return ForwardUIInitializer(parentVC: root)
        } else {
            return ReplyUIInitializer(parentVC: root)
        }
    }
}
