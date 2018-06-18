//
//  SpoolDetailsUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 4/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SnapKit

class SpoolDetailsUIInitializer {
    
    // MARK: - Variables & Constants
    
    private unowned var parentVC: SpoolDetailsViewController
    private lazy var navigationViewsBuilder: SpoolsNavigationViewsBuilder = { [unowned self] in
        let builder = SpoolsNavigationViewsBuilder(target: self, action: #selector(onBackButtonClick))
        return builder
        }()
    
    // MARK: - Initialization
    
    init(vc: SpoolDetailsViewController) {
        parentVC = vc
    }
    
    // MARK: - Public UI initialization
    
    func initialize() {
        parentVC.view.backgroundColor = .white
        addTableView()
        addLeftNavigationView()
    }
    
    // MARK: - Private table view setup
    
    func addTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.register(SpoolMessageTableViewCell.self, forCellReuseIdentifier: SpoolMessageTableViewCell.reuseIdentifier())
        tableView.register(SpoolOlderMessageTableViewCell.self, forCellReuseIdentifier: SpoolOlderMessageTableViewCell.reuseIdentifier())
        
        parentVC.view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: parentVC.view.topAnchor).isActive = true
        
        parentVC.bottomConstraint = tableView.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor)
        parentVC.bottomConstraint?.isActive = true
        parentVC.tableView = tableView
    }
    
    // MARK: - Left navigation bar view setup
    
    private func addLeftNavigationView() {
        let views = navigationViewsBuilder.navigationView(for: .details)
        parentVC.navigationItem.setLeftBarButtonItems(views, animated: true)
        
        if let profileView = views.last?.customView as? SpoolDetailsLeftNavBarView {
            parentVC.leftNavBarView = profileView
        }
    }
    
    @objc private func onBackButtonClick() {
        parentVC.navigationController?.popViewController(animated: true)
    }
}
