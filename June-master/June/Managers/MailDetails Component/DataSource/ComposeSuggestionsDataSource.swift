//
//  ComposeSuggestionsDataSource.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ComposeSuggestionsDataSource: NSObject {
    
    // MARK: - Variables
    
    fileprivate weak var dataStorage: SuggestReceiversDataRepository?
    
    // MARK: - Initialization
    
    init(storage: SuggestReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension ComposeSuggestionsDataSource: UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ComposeSuggestionTableViewCell.reuseIdentifier(), for: indexPath) as! ComposeSuggestionTableViewCell
        
        if let receiver = dataStorage?.receiver(at: indexPath.row) {
            cell.selectionStyle = .none
            cell.setupSubViews(for: receiver)
        }
        return cell
    }
}
