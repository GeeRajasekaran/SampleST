//
//  SuggestedReceiversDataRepository.swift
//  June
//
//  Created by Ostap Holub on 9/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class SuggestReceiversDataRepository {
    
    // MARK: - Variables
    
    var receivers = [EmailReceiver]()
    
    // MARK: - Data access
    
    func clear() {
        receivers = []
    }
    
    var count: Int {
        get { return receivers.count }
    }
    
    func append(_ receiver: EmailReceiver) {
        receivers.append(receiver)
    }
    
    func replace(with array: [EmailReceiver]?) {
        guard let unwrappedArray = array else { return }
        receivers = unwrappedArray
    }
    
    func append(_ array: [EmailReceiver]?) {
        guard let unwrappedArray = array else { return }
        receivers.append(contentsOf: unwrappedArray)
    }
    
    func receiver(at index: Int) -> EmailReceiver? {
        if index >= 0 && index < receivers.count {
            return receivers[index]
        }
        return nil
    }
}
