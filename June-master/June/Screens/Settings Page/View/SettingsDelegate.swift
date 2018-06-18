//
//  SettingsDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 8/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsDelegate: NSObject {
    
    private let screenWidth = UIScreen.main.bounds.width
    private weak var dataStorage: AccountDataRepository?

    let oneCellHeight = UIScreen.main.bounds.width * 0.149
    var onReauthenticateAccount: ((AccountModel) -> Void)?

    // MARK: - Initialization
    init(with storage: AccountDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

// MARK: - tableview delegate
extension SettingsDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

