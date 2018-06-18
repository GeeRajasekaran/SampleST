//
//  SearchTableViewDataSource.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchTableViewDataSource: NSObject {
    
    var dataStorage: SearchDataRepository?
    
    // MARK: - Initialization
    init(with storage: SearchDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension SearchTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dataStorage?.getCount() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier(), for: indexPath) as! SearchResultTableViewCell
        cell.setupUI()
        if let receiver = dataStorage?.receiver(by: indexPath.row) {
            cell.loadData(from: receiver)
        }
        return cell
    }
}
