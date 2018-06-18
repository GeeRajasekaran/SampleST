//
//  IRealTimeValidatable.swift
//  June
//
//  Created by Ostap Holub on 10/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IRealTimeValidateable {
    
    /// Method that can validate objects received in real time event handlers
    ///
    /// - Parameter object: Object that was received in real time event
    /// - Returns: Value that indicates whether object is valid or not
    func validate(_ object: [String: Any]) -> Bool
}
