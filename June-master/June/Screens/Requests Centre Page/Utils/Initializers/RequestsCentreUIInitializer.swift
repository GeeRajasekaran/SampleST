//
//  RequestsCentreUIInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsCentreUIInitializer: NSObject {

    // MARK: - Variables & Constants
    private unowned var requestsVC: RequestsCentreViewController
    private let topViewHeight = UIScreen.main.bounds.width * 0.133
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Public part
    init(with controller: RequestsCentreViewController) {
        requestsVC = controller
    }

    func performBasicSetup() {
        
    }
    
    func layoutSubviews() {
        addRequestsTableView()
        addTopView()
    }
    
    //MARK: - Top View
    private func addTopView() {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: topViewHeight)
        let topView = RequestsTopView(frame: frame)
        topView.setupSubviews()
        topView.onPeopleButtonClicked = requestsVC.onPeopleTableLoaded
        topView.onSubscriptionButtonClicked = requestsVC.onSubscriptionTableLoaded
        topView.onBlockedButtonClicked = requestsVC.onBlockedClicked
        requestsVC.view.addSubview(topView)
        requestsVC.topView = topView
    }
    
    //MARK: - Requests table view
    
    private func addRequestsTableView() {
        guard let tableView = buildRequestsTableView() else { return }

        let tapGesture = UITapGestureRecognizer(target: requestsVC, action: #selector(requestsVC.tapAction))
        //tapGesture.delegate = requestsVC
        tableView.addGestureRecognizer(tapGesture)
        
        // table view setup goes here
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.reuseIdentifier())
        tableView.register(SubscriptionsTableViewCell.self, forCellReuseIdentifier: SubscriptionsTableViewCell.reuseIdentifier())

        tableView.delegate = requestsVC.delegate
        tableView.dataSource = requestsVC.dataSource
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        requestsVC.view.addSubview(tableView)
        requestsVC.requestsTableView = tableView
        requestsVC.statusButtonsHandler.tableView = requestsVC.requestsTableView
        
        tableView.leadingAnchor.constraint(equalTo: requestsVC.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: requestsVC.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: requestsVC.view.topAnchor, constant: topViewHeight).isActive = true
        tableView.bottomAnchor.constraint(equalTo: requestsVC.view.bottomAnchor).isActive = true
    }
    
    private func buildRequestsTableView() -> UITableView? {
        return UITableView(frame: .zero, style: .plain)
    }
}
