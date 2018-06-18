//
//  AccountsUIInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccountsUIInitializer: NSObject {
    
    // MARK: - Variables & Constants
    private unowned var parentVC: AccountsViewController
    private let screenWidth = UIScreen.main.bounds.width
    private let topOffset: CGFloat = 15
    private var tableColapsed = false
    private var tableHeight = 0
    private var line = UIView()
    
    let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "angle-arrow-down"), for: .normal)
        return button
    }()
    
    // MARK: - Public part
    init(with controller: AccountsViewController) {
        parentVC = controller
    }
    
    func performBasicSetup() {
        parentVC.view.backgroundColor = .white
    }
    
    func layoutSubviews() {
        addTableView()
    }
    
    func updateTableViewHeightIFNeeded() {
        let tableView = parentVC.accountsTableView
        let dataCount = parentVC.dataRepository.count
        if dataCount > 0 {
            let maxHeight = 0.448 * screenWidth
            let oneCellHeight = parentVC.accountsDelegate.oneCellHeight
            let totalCellHeight = oneCellHeight*CGFloat(dataCount)
            
            tableView.isScrollEnabled = false
            self.tableHeight = Int(totalCellHeight)
            
            if totalCellHeight > maxHeight {
                tableView.isScrollEnabled = true
                tableView.frame.size.height = maxHeight
            } else {
                tableView.frame.size.height = totalCellHeight
            }
        } else {
            tableView.frame.size.height = 0
        }
        
        if dataCount == 1 {
            parentVC.emailAccountsLabel.text = "Account"
        }
        
        if dataCount > 1 {
            if self.tableColapsed == false {
                addViewAllAccounts()
                parentVC.accountsTableView.frame = CGRect(x: 0, y: 379, width: 0.827 * screenWidth, height: 0)
            }
        }
    }
    
    //MARK: - table view
    private func addTableView() {
        guard let tableView = buildTableView() else { return }
        // table view setup goes here
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.reuseIdentifier())
        tableView.dataSource = parentVC.accountsDataSource
        tableView.delegate = parentVC.accountsDelegate
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        parentVC.view.addSubview(tableView)
        parentVC.accountsTableView = tableView
        
        line.frame = CGRect(x: 0, y: 379, width: self.parentVC.view.frame.size.width, height: 2)
        line.backgroundColor = UIColor.init(hexString:"#A19FAB")
        line.alpha = 0.15
        parentVC.view.addSubview(line)
    }
    
    private func buildTableView() -> UITableView? {
        let screenWidth = parentVC.view.frame.size.width
        let height = 0.448 * screenWidth
        let tableViewFrame = CGRect(x: 0, y: 0.88 * screenWidth, width: 0.827 * screenWidth, height: height)
        return UITableView(frame: tableViewFrame, style: .plain)
    }
    
    //MARK: - all accounts label, button & functionality logic
    func addViewAllAccounts() {
        let viewAllLabel = UILabel()
        viewAllLabel.frame = CGRect(x: 26, y: 347, width: 88, height: 19)
        viewAllLabel.text = "All Accounts"
        viewAllLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
        parentVC.view.addSubview(viewAllLabel)
        
        self.arrowButton.frame = CGRect(x: 270.6, y: 344.6, width: 26, height: 22)
        self.arrowButton.addTarget(self, action: #selector(self.arrowButtonClicked), for: .touchUpInside)
        self.arrowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 3)
        self.parentVC.view.addSubview(arrowButton)
        
    }
    
    //MARK: - arrow button action to show all accounts
    @objc func arrowButtonClicked() {

        if tableColapsed == false {
            UIView.animate(withDuration: 0.2, animations: {
                self.parentVC.accountsTableView.frame.size.height = CGFloat(self.tableHeight)
                self.line.frame.origin.y += CGFloat(self.tableHeight)
                self.arrowButton.setImage(UIImage(named: "angle-arrow"), for: .normal)
                self.arrowButton.contentEdgeInsets = UIEdgeInsetsMake(7.5, 12, 7.5, 2)
                
            })
            self.tableColapsed = true
            
        } else if tableColapsed == true {
            UIView.animate(withDuration: 0.2, animations: {
                self.parentVC.accountsTableView.frame.size.height = 0
                self.line.frame.origin.y -= CGFloat(self.tableHeight)
                self.arrowButton.setImage(UIImage(named: "angle-arrow-down"), for: .normal)
                self.arrowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 3)
            })
            self.tableColapsed = false
        }
    }

}

