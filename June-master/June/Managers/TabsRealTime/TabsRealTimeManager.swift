//
//  TabsRealTimeManager.swift
//  June
//
//  Created by Ostap Holub on 10/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class TabsRealTimeManager {
    
    // MARK: - Nested tabs struct
    
    enum RealTimeTabName: Int {
        case threads = 0
        case feed = 2
    }
    
    
    // MARK: - Variables & Constants
    
    private var timestampStorage = TimestampUserDefaults()
    private unowned var parentController: HomeViewController
    private var listeners = [IRealTimeListener]()
    
    var threadsTimestamp: Int? {
        get { return timestampStorage.threadsTimestamp }
    }
    
    var feedTimestamp: Int? {
        get { return timestampStorage.feedTimestamp }
    }
    
    var requestsTimestamp: Int? {
        get { return timestampStorage.requestsTimestamp }
    }
    
    // MARK: - Initialization
    
    init(parentVC: HomeViewController) {
        parentController = parentVC
        initializeListeners()
    }
    
    private func initializeListeners() {
        listeners.append(ThreadsTabRealTimeListener(event: onValidRealtimeEventFaired, for: .threads))
        listeners.append(FeedTabRealTimeListener(event: onValidRealtimeEventFaired, for: .feed))
    }
    
    // MARK: - Subscribing logic
    
    func loadInitialState() {
        update(timestamp: nil, for: .threads)
        setActive(true, for: .threads)
        setActive(false, for: .feed)
    }
    
    func subscribe() {
        listeners.forEach({ listener in
            listener.subscribe()
        })
    }
    
    func unsubscribe() {
        listeners.forEach({ listener in
            listener.unsubscribe()
        })
    }
    
    // MARK: - Active tab tracking
    
    func setActive(_ state: Bool, for tab: RealTimeTabName) {
        switch tab {
        case .threads:
            timestampStorage.isTreadsActive = state
        case .feed:
            timestampStorage.isFeedActive = state

        }
    }
    
    private func isActiveTab(with name: RealTimeTabName) -> Bool {
        switch name {
        case .threads:
            return timestampStorage.isTreadsActive
        case .feed:
            return timestampStorage.isFeedActive

        }
    }
    
    // MARK: - Updating timestamp
    
    func update(timestamp time: Int?, for tab: RealTimeTabName) {
        switch tab {
        case .threads:
            timestampStorage.threadsTimestamp = time
        case .feed:
            timestampStorage.feedTimestamp = time

        }
    }
    
    // MARK: - Realtime event handling
    
    lazy var onValidRealtimeEventFaired: (TabsRealTimeManager.RealTimeTabName) -> Void = { [weak self] tab in
        if self?.isActiveTab(with: tab) == false {
            self?.parentController.markWithRedDot(at: tab.rawValue)
        }
    }
}
