//
//  ThreadsRealTime.swift
//  June
//
//  Created by Joshua Cleetus on 8/24/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import FeathersSwiftSocketIO

class ThreadsRealTime: NSObject {
    
    private var service = FeathersManager.Services.threads
    var eventAction: ((Result<[[String: Any]]>) -> Void)?

    func getRealTimeDataWith(completion: @escaping (Result<[[String: Any]]>) -> Void) {
        self.eventAction = completion
        service.on(event: .patched).observeValues { (entity) in
            if self.eventAction != nil {
                let dataArray = [entity]
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
    
    enum Result<T> {
        case Success(T)
        case Error(String)
    }
}


