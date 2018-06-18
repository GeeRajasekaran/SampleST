//
//  SpoolIndexUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SnapKit

class SpoolIndexUIInitializer {
    
    // MARK: - Variables & Constants
    
    private unowned var parentVC: SpoolIndexViewController
    private lazy var navigationViewsBuilder: SpoolsNavigationViewsBuilder = { [unowned self] in
        let builder = SpoolsNavigationViewsBuilder(target: self, action: #selector(onBackButtonClick))
        return builder
    }()
    
    // MARK: - Initializetion
    
    init(parent: SpoolIndexViewController) {
        parentVC = parent
    }
    
    // MARK: - Public view setup logic
    
    func initialize() {
        parentVC.view.backgroundColor = .white
        addTableView()
        addLeftNavigationView()
    }
    
    // MARK: - Private table view setup
    
    private func addTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // all additional setup like regesting a cell goes here
        tableView.backgroundColor = UIColor(hexString: "EFF1F2")
        tableView.separatorStyle = .none
        tableView.register(SpoolItemTableViewCell.self, forCellReuseIdentifier: SpoolItemTableViewCell.reuseIdentifier())
        
        parentVC.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        parentVC.tableView = tableView
    }
    
    // MARK: - Left navigation bar view setup
    
    private func addLeftNavigationView() {
        let views = navigationViewsBuilder.navigationView(for: .profile)
        parentVC.navigationItem.setLeftBarButtonItems(views, animated: true)
        
        if let profileView = views.last?.customView as? SpoolIndexLeftNavBarView {
            parentVC.leftNavBarView = profileView
        }
    }
    
    @objc private func onBackButtonClick() {
        parentVC.navigationController?.popViewController(animated: true)
    }
}
