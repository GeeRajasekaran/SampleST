//
//  JuneSearchResultsViewControllerInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class JuneSearchResultsViewControllerInitializer: NSObject {
    
    // MARK: - Variables & Constants
    private unowned var parentVC: JuneSearchResultViewController
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    // MARK: - Public part
    init(with controller: JuneSearchResultViewController) {
        parentVC = controller
    }
    
    func performBasicSetup() {
        parentVC.navigationItem.hidesBackButton = true
        parentVC.view.backgroundColor = .white
    }
    
    func layoutSubviews() {
        parentVC.navigationController?.navigationBar.barTintColor = .white
        addTableView()
    }
    
    //MARK: - private part
    private func addTableView() {
        let parentView = parentVC.view
        guard let tableView = buildTableView() else { return }
        // table view setup goes here
        tableView.register(SearchThreadsTableViewCell.self, forCellReuseIdentifier: SearchThreadsTableViewCell.reuseIdentifier())
        tableView.dataSource = parentVC.listDataSource
        tableView.delegate = parentVC.listDelegate
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        parentView?.addSubview(tableView)
        parentVC.tableView = tableView
    }
    
    private func buildTableView() -> FeedTableView? {
        var originY: CGFloat = UIApplication.shared.statusBarFrame.height
        if let originYNavItem = parentVC.navigationItem.titleView?.frame.height {
            originY += originYNavItem + 4
        }
        let tableViewHeight: CGFloat = screenHeight - originY
        let tableViewFrame = CGRect(x: 0, y: originY, width: screenWidth, height: tableViewHeight)
        return FeedTableView(frame: tableViewFrame, style: .plain)
    }
}
