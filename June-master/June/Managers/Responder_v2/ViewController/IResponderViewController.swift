//
//  IResponderViewController.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderMovable {
    
    /// Method to move responder view controller up by delta
    ///
    /// - Parameter delta: Idicates how much should view moves up
    func moveUp(_ delta: CGFloat)
    
    /// Method to move responder view controller down by delta
    ///
    /// - Parameter delta: Idicates how much should view moves down
    func moveDown(_ delta: CGFloat)
}

protocol IResponderViewController: class, IResponderMovable {
    
    /// Accessory view, that containes all Responder related views inside
    var responderAccessoryView: ResponderAccessoryView? { get set }
    var metadata: ResponderMetadata? { get set }
}
