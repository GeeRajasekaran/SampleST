//
//  IKeyboardController.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

/// Interface for communication between concrete implentation of keyboard controller and its owner
protocol KeyboardControllerDelegate: class {
    func controller(_ controller: IKeyboardController, willShowKeyboardWith height: CGFloat)
    func controller(_ controller: IKeyboardController, willHideKeyboardWith height: CGFloat)
    
    func controller(_ controller: IKeyboardController, willIncreaseHeight delta: CGFloat)
    func controller(_ controller: IKeyboardController, willDecreaseHeight delta: CGFloat)
}

protocol IKeyboardController {
    
    /// Current events listener
    var delegate: KeyboardControllerDelegate? { get }
    
    /// Subscribes a delegate to keyboard events
    ///
    /// - Parameter delegate: object that wants to listern keyboard changes
    func subscribe(_ delegate: KeyboardControllerDelegate?)
    
    /// Unsubscribe current event listener for keyboard changes
    func unsubscribe()
}
