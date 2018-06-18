//
//  SuggestedReceiversDataSource.swift
//  June
//
//  Created by Ostap Holub on 9/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class SuggestedReceiversDataSource: NSObject {
    
    // MARK: - Variables
    
    fileprivate weak var dataStorage: SuggestReceiversDataRepository?
    
    // MARK: - Initialization
    
    init(storage: SuggestReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension SuggestedReceiversDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataStorage?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedReceiverTableViewCell.reuseIdentifier(), for: indexPath) as! SuggestedReceiverTableViewCell
        
        if let receiver = dataStorage?.receiver(at: indexPath.row) {
            cell.setupSubViews(for: receiver)
        }
        return cell
    }
}
