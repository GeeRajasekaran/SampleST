//
//  FeedRealTimeListener.swift
//  June
//
//  Created by Ostap Holub on 8/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import FeathersSwiftSocketIO

class FeedRealTimeListener {
    
    private var service = FeathersManager.Services.threads
    var eventAction: (([String: Any]) -> Void)?
    
    func subscribeForPatch(event: @escaping ([String: Any]) -> Void) {
        eventAction = event
        service.on(event: .patched).observeValues { entity in
            if self.eventAction != nil {
                self.eventAction?(entity)
            }
        }
        service.off(event: .patched)
    }
    
    func unsubscribe() {
        eventAction = nil
        service.off(event: .patched)
    }
}
