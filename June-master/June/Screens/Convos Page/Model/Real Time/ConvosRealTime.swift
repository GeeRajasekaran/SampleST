//
//  ConvosRealTime.swift
//  June
//
//  Created by Joshua Cleetus on 1/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import FeathersSwiftSocketIO

class ConvosRealTime: NSObject {
    
    private var service = FeathersManager.Services.threads
    var eventAction: ((Result<[[String: AnyObject]]>) -> Void)?
    
    func getRealTimeDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        self.eventAction = completion
        service.on(event: .patched).observeValues { (entity) in
            if self.eventAction != nil {
                let dataArray = [entity] as [[String: AnyObject]]
                DispatchQueue.main.async {
                    completion(.Success(dataArray))
                }
            }
        }
        service.off(event: .patched)
    }
    
    func switchOffThreadsRealtimeListener() -> Void {
        eventAction = nil
        service.off(event: .patched)
    }
    
}
