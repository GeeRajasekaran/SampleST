//
//  SearchDataRepository.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchDataRepository: NSObject {

    // MARK: - Variables
    var receivers = [ContactReceiver]()
    
    func clean() {
        receivers.removeAll()
    }
    
    func append(_ receivers: [ContactReceiver]) {
        self.receivers.append(contentsOf: receivers)
    }
    
    func replace(with array: [ContactReceiver]?) {
        guard let unwrappedArray = array else { return }
        receivers = unwrappedArray
    }
    
    //MARK: - getting
    func receiver(by index: Int) -> ContactReceiver? {
        if index < receivers.count {
            return receivers[index]
        }
        return nil
    }
    
    func getCount() -> Int {
        return receivers.count
    }
}
