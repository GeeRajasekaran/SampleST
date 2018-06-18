//
//  ThreadIdValidator.swift
//  June
//
//  Created by Ostap Holub on 12/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ThreadIdValidator {
    
    /// Method that validates thread id
    ///
    /// - Parameter threadId: Thread id that you want to check
    /// - Returns: thread id if id is valid and empty, otherwise -> nil
    class func validate(threadId: String?) -> String? {
        guard let unwrappedThreadId = threadId else {
            print("\(#file).\(#line) Failed to unwrap the thread id")
            return nil
        }
        
        if unwrappedThreadId.isEmpty {
            print("\(#file).\(#line) Thread id is empty")
            return nil
        }
        return unwrappedThreadId
    }
}
