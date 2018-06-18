//
//  ReplyActionsDataSource.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyActionsDataSource: NSObject {

    var dataStorage: ReplyActionsDataRepository?
    var type: ActionsPopupType = .reply
    
    // MARK: - Initialization
    init(with storage: ReplyActionsDataRepository?, and type: ActionsPopupType) {
        dataStorage = storage
        self.type = type
        super.init()
    }
}

extension ReplyActionsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dataStorage?.getCount() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == .reply {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReplyTableViewCell.reuseIdentifier(), for: indexPath) as! ReplyTableViewCell
            var shouldShowLine = true
            if indexPath.row == 0 {
                shouldShowLine = false
            }
            cell.setupUI(shouldShowLine: shouldShowLine)
            if let currentMessage = dataStorage?.getAction(by: indexPath.row) {
                cell.loadData(from: currentMessage)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CannedResponcseTableViewCell.reuseIdentifier(), for: indexPath) as! CannedResponcseTableViewCell
            cell.setupUI()
            if let currentMessage = dataStorage?.getAction(by: indexPath.row) {
                cell.loadData(from: currentMessage)
            }
            return cell
        }
    }
}
