//
//  ResponderConfig.swift
//  June
//
//  Created by Ostap Holub on 9/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderConfig {
    
    // MARK: - Variables
    
    var goal: ResponderOld.ResponderGoal?
    var thread: Threads
    var message: Messages
    var isMinimizationEnabled: Bool
    
    var shouldClearOnSend: Bool = true
    var shouldAutoExpand: Bool = false
    
    var isExpandAvailable: Bool {
        get { return goal == .reply || goal == .replyAll }
    }
    
    var isHeaderAvailabe: Bool {
        get { return goal == .forward }
    }
    
    // MARK: - Initialization
    
    convenience init(with thread:Threads, message: Messages, minimized: Bool) {
        self.init(with: .reply, thread: thread, message: message, minimized: minimized)
    }
    
    init(with goal: ResponderOld.ResponderGoal, thread: Threads, message: Messages, minimized: Bool) {
        self.goal = goal
        self.thread = thread
        self.message = message
        self.isMinimizationEnabled = minimized
    }
}
