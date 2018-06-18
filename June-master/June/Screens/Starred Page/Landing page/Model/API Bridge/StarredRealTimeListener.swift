//
//  StarredRealTimeListener.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

import Foundation
import Feathers
import FeathersSwiftSocketIO

class StarredRealTimeListener {
    private var service = FeathersManager.Services.threads
    var eventAction: (([[String: Any]]) -> Void)?
    
    func subscribeForPatch(event: @escaping ([[String: Any]]) -> Void) {
        eventAction = event
        service.on(event: .patched).observeValues { entity in
            if self.eventAction != nil {
                let dataArray = [entity]
                self.eventAction?(dataArray)
            }
        }
        service.off(event: .patched)
    }
    
    func unsubscribe() {
        eventAction = nil
        service.off(event: .patched)
    }
}
