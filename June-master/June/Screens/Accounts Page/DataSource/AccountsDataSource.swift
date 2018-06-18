//
//  AccountsDataSource.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccountsDataSource: NSObject {
    private let screenWidth = UIScreen.main.bounds.width
    private weak var dataStorage: AccountsDataRepository?
    private let single = 1
    
    // MARK: - Initialization
    init(with storage: AccountsDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension AccountsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let storage = dataStorage else { return 0 }
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.reuseIdentifier(), for: indexPath) as! AccountTableViewCell
        cell.setupUI()
        cell.selectionStyle = .none
        
            if let account = dataStorage?.account(at: indexPath.row), let storage = dataStorage  {
            cell.loadData(account, shouldShowPrimary: storage.shouldShowPrimary())
       
                if dataStorage?.count == single {
                    cell.showSingleAccount()
                }
            }
        
        return cell
    }
}
