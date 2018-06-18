//
//  ContactRealTimeListener.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/9/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftSocketIO

class ContactRealTimeListener: NSObject {
    private var service = FeathersManager.Services.contacts
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

