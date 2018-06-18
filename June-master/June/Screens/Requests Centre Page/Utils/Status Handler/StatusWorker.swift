//
//  StatusWorker.swift
//  June
//
//  Created by Oksana on 1/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class StatusWorker {

    private var statusHandler = StatusHandler()
    private var pendingRequestWorkItems: [DispatchWorkItem] = []
    
    //MARK: - change state
    func change(_ contact: Contacts, with state: Status, and time: Double = 0.0, completion: @escaping (String) -> Void) {
        pendingRequestWorkItems.first?.perform()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.sendRequest(contact, forChange: state, completion: completion)
        }
        
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when, execute: requestWorkItem)
        pendingRequestWorkItems.append(requestWorkItem)
    }
    
    func cancelLast() {
        pendingRequestWorkItems.last?.cancel()
        let lastItem = pendingRequestWorkItems.count - 1
        if lastItem >= 0 {
            pendingRequestWorkItems.remove(at: lastItem)
        }
    }
    
    func cancelAll() {
        pendingRequestWorkItems.removeAll()
    }
    
    //MARK: - request for changing status
    private func sendRequest(_ contact: Contacts, forChange status: Status, completion: @escaping (String) -> Void) {
        statusHandler.changeStatusAndSave(contact, with: status) { result in
            completion(result)
        }
    }
}
