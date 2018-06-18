//
//  AccountsDelegate.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccountsDelegate: NSObject {

    private let screenWidth = UIScreen.main.bounds.width
    private weak var dataStorage: AccountsDataRepository?
    
    let oneCellHeight = UIScreen.main.bounds.width * 0.149
    var onReauthenticateAccount: ((Account) -> Void)?
    
    // MARK: - Initialization
    init(with storage: AccountsDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension AccountsDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return oneCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let account = dataStorage?.account(at: indexPath.row) {
            if account.shouldReauthenticate() {
                onReauthenticateAccount?(account)
            }
        }
    }
}
