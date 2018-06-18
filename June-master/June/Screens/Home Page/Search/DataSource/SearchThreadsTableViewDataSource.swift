//
//  SearchThreadsTableViewDataSource.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchThreadsTableViewDataSource: NSObject {
    
    var dataStorage: SearchThreadsDataRepository?
    var markAsClearedAction: ((ThreadsReceiver) -> Void)?
    // MARK: - Initialization
    init(with storage: SearchThreadsDataRepository?) {
        dataStorage = storage
        super.init()
    }
}
extension SearchThreadsTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dataStorage?.getCount() else { return 0 }
        if count == 0 {
            let label = NoResultsLabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            label.text = LocalizedStringKey.SearchViewHelper.NoSearchResultsTitle
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchThreadsTableViewCell.reuseIdentifier(), for: indexPath) as! SearchThreadsTableViewCell
        if let receiver = dataStorage?.receiver(by: indexPath.row) {
            cell.markAsClearedAction = markAsClearedAction
            cell.setupUI()
            cell.loadData(from: receiver)
        }
        return cell
    }
}
