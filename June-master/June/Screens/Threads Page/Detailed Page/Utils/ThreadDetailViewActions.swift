//
//  ThreadDetailViewActions.swift
//  June
//
//  Created by Joshua Cleetus on 3/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ThreadDetailViewActions: NSObject {

    unowned var parentVC: ThreadsDetailViewController
    init(parentVC: ThreadsDetailViewController) {
        self.parentVC = parentVC
        super.init()
    }

    func closeOpenedCell(indexPath: IndexPath) {
        self.parentVC.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        self.parentVC.tableView?.reloadRows(at: [indexPath], with: .right)
    }
}
