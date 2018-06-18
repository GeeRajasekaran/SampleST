//
//  EmailsUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class EmailsUIInitializer {
    
    // MARK: - Variables & Constants
    
    private unowned var parentViewController: EmailsTableViewController
    
    // MARK: - Initialization
    
    init(parentVC: EmailsTableViewController) {
        parentViewController = parentVC
    }
    
    // MARK: - Public intialization
    
    func initialize() {
        parentViewController.view.backgroundColor = UIColor.senderEmailsBackgroundGray
        addTableView()
    }
    
    // MARK: - Table view creation
    
    func addTableView() {
        
        let tableView = UITableView(frame: parentViewController.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.register(EmailTableViewCell.self, forCellReuseIdentifier: EmailTableViewCell.reuseIdentifier())
        tableView.dataSource = parentViewController.dataSource
        tableView.delegate = parentViewController.tableDelegate
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        parentViewController.view.addSubview(tableView)
        parentViewController.emailsTableView = tableView
    }
}
