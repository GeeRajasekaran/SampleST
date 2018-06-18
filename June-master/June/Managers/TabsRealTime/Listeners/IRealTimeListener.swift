//
//  IRealTimeListener.swift
//  June
//
//  Created by Ostap Holub on 10/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IRealTimeListener {
    
    /// Lambda which are called after receiving a real time update
    var onEvent: (TabsRealTimeManager.RealTimeTabName) -> Void { get }
    
    /// Tab which listener is related to
    var tab: TabsRealTimeManager.RealTimeTabName { get }
    
    /// Required initializer for any real time listener
    ///
    /// - Parameters:
    ///   - event: Lambda for handling a real time update
    ///   - tab: Tab which listener is related to
    init(event: @escaping (TabsRealTimeManager.RealTimeTabName) -> Void, for tab: TabsRealTimeManager.RealTimeTabName)
    
    /// Subscribes for real time events
    func subscribe()
    
    /// Unsubscribes for real time events
    func unsubscribe()
}
