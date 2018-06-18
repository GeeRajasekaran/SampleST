//
//  SearchTableViewDelegate.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchTableViewDelegate: NSObject {
    let screenWidth = UIScreen.main.bounds.width
    var dataStorage: SearchDataRepository?
    var cellHeight = UIScreen.main.bounds.width*0.117
    var tableViewDidSelectRowAction: ((Int, ContactReceiver) -> Void)?
    var onMoreContacts: (() -> Void)?
    
    // MARK: - Initialization
    init(with storage: SearchDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension SearchTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let receiver = dataStorage?.receiver(by: indexPath.row) else { return }
        tableViewDidSelectRowAction?(indexPath.row, receiver)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let unwrappedSource = dataStorage else { return }
        if indexPath.item == unwrappedSource.getCount() - 1 {
            onMoreContacts?()
        }
    }
}
