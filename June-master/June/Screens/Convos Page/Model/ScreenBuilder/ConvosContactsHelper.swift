//
//  ConvosContactsHelper.swift
//  June
//
//  Created by Ostap Holub on 3/28/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ConvosContactsHelper {
    
    // MARK: - Variables & Cosntatns
    
    var pendingContactsCount: Int = 0
    var isPendingContactsNotificationClosed: Bool = false
    
    private var contactsDataProvider = ContactsDataProvider()
    
    var onCountUpdated: (() -> Void)?
    
    func requestPendingContactsCount() {
        contactsDataProvider.requestTotalPendingPeople(completion: onPendingContactsCountFetched)
    }
    
    private lazy var onPendingContactsCountFetched: (Result<Int>) -> Void = { [weak self] result in
        switch result {
        case .Success(let count):
            self?.pendingContactsCount = count
            self?.isPendingContactsNotificationClosed = false
            if self?.pendingContactsCount != 0 {
                self?.onCountUpdated?()
            }
        case .Error(let error):
            print(error)
        }
    }
}
