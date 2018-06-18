//
//  AccountDataRepository.swift
//  June
//
//  Created by Tatia Chachua on 16/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccountDataRepository: NSObject {

    var accounts = [AccountModel]()
    
    var count: Int {
        get { return accounts.count }
    }
    
    func account(at index: Int) -> AccountModel? {
        if index >= 0 && index < accounts.count {
            return accounts[index]
        }
        return nil
    }
    
    func append(_ account: AccountModel) {
        accounts.append(account)
    }
    
    func clear() {
        accounts.removeAll()
    }
    
    func shouldShowPrimary() -> Bool {
        if count > 0 {
            return true
        }
        return false
    }
}
