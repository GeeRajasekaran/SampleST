//
//  SpoolIndexDataSource.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolIndexDataSource: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var builder: SpoolIndexScreenBuilder?
    
    // MARK: - Initialization
    
    init(builder: SpoolIndexScreenBuilder?) {
        self.builder = builder
    }
}

extension SpoolIndexDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = builder?.dataRepository.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = builder?.loadModel(for: SpoolsSectionType.all, rowType: SpoolsRowType.item, forPath: indexPath) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: SpoolItemTableViewCell.reuseIdentifier(), for: indexPath) as! SpoolItemTableViewCell
        cell.setupSubviews()
        cell.load(model: model)
        return cell
    }
}
