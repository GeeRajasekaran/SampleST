//
//  SettingsDataSource.swift
//  June
//
//  Created by Tatia Chachua on 10/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsDataSource: NSObject {
    
    private let screenWidth = UIScreen.main.bounds.width
    private weak var dataStorage: AccountDataRepository?
    
    // MARK: - Initialization
    init(with storage: AccountDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension SettingsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier(), for: indexPath) as! SettingsTableViewCell
        cell.setupUI()
        cell.selectionStyle = .none
        if let account = dataStorage?.account(at: indexPath.row), let storage = dataStorage  {
            cell.loadData(account, shouldShowPrimary: storage.shouldShowPrimary())
        }

        return cell
    }


    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let storage = dataStorage else { return 0 }
        return storage.count
    }
}

