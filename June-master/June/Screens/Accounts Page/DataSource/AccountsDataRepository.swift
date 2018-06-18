//
//  AccountsDataRepository.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccountsDataRepository: NSObject {

    var accounts = [Account]()
    
    var count: Int {
        get { return accounts.count }
    }
    
    func account(at index: Int) -> Account? {
        if index >= 0 && index < accounts.count {
            return accounts[index]
        }
        return nil
    }
    
    func append(_ account: Account) {
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
