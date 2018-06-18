//
//  NavigationHandlerFactory.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class NavigationHandlerFactory {
    
    class func handler(for goal: ResponderOld.ResponderGoal, with root: UIViewController) -> INavigationHandler {
        if goal == .forward {
            return ForwardNavigationHandler(rootVC: root)
        } else {
            return ReplyNavigationHandler(rootVC: root)
        }
    }
}
