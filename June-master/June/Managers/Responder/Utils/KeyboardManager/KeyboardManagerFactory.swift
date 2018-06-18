//
//  KeyboardManagerFactory.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class KeyboardManagerFactory {
    
    class func manager(for goal: ResponderOld.ResponderGoal, with root: ResponderViewControllerOld) -> IResponderKeyboardManager {
        if goal == .forward {
            return ReplyKeyboardManager(rootVC: root)
        } else {
            return ReplyKeyboardManager(rootVC: root)
        }
    }
    
}
