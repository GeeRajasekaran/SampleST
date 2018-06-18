//
//  EmailsTableViewController.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class EmailsTableViewController: UIViewController {
    
    // MARK: - Varialbes & Constants
    
    var emailsTableView: UITableView?
    var dataSource = EmailsDataSource()
    
    var onSelect: ((SenderEmail) -> Void)?
    
    lazy private var uiInitializer: EmailsUIInitializer = {
        let initializer = EmailsUIInitializer(parentVC: self)
        return initializer
    }()
    
    lazy var tableDelegate: EmailsDelegate = {
        let delegate = EmailsDelegate(action: self.onSelectEmail)
        return delegate
    }()
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
        dataSource.loadData()
    }
    
    // MARK: - On select action
    
    lazy var onSelectEmail: (Int) -> Void = { [weak self] index in
        guard let strongSelf = self else { return }
        if let email = strongSelf.dataSource.email(at: index) {
            strongSelf.onSelect?(email)
        }
    }
}
