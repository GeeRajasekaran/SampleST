//
//  MessagesRealTimeListener.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MessagesRealTimeListener: NSObject {
    private var service = FeathersManager.Services.message
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
