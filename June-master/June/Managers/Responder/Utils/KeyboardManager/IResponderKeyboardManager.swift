//
//  IResponderKeyboardManager.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol IResponderKeyboardManager {
    
    var parentViewController: ResponderViewControllerOld { get }
    
    init(rootVC: ResponderViewControllerOld)
    
    func subscribeForKeyboardNotifications()
    func unsubscribeForKeyboardNotifications()
}
