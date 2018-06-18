//
//  RolodexsLoading.swift
//  June
//
//  Created by Joshua Cleetus on 3/19/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class RolodexsLoading: NSObject {
    
    unowned var parentVC: RolodexsViewController
    init(parentVC: RolodexsViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
    // Realtime Loading
    func listenToRealTimeEvents() {
        self.parentVC.rolodexsRealTime.getRealTimeDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                print(data as Any)
                if data.count > 0 {
                    let rolodexsService = RolodexsService(parentVC: self.parentVC)
                    rolodexsService.saveInCoreDataWith(array: data as [[String : AnyObject]])
                }
            case .Error(let message):
                print(message)
            }
        }
    }
}
