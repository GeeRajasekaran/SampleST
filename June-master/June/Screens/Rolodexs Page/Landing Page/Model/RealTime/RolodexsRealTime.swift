//
//  RolodexsRealTime.swift
//  June
//
//  Created by Joshua Cleetus on 3/27/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftSocketIO

class RolodexsRealTime: NSObject {
    private var service = FeathersManager.Services.rolodexs
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
