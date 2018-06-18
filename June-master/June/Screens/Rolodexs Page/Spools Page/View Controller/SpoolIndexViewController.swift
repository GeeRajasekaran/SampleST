//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 3/26/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

struct FeedDemoContent {
    var subject: String
    var username: String
    var summary: String
}

class SpoolIndexViewController: UIViewController {
    
    // MARK: - Variables & Constants
    
    private lazy var uiInitializer: SpoolIndexUIInitializer = { [unowned self] in
        let initializer = SpoolIndexUIInitializer(parent: self)
        return initializer
    }()
    
    private lazy var dataProvider: SpoolsDataProvider = { [weak self] in
        let provider = SpoolsDataProvider(onLoad: self?.onSpoolsReceived)
        return provider
    }()
    
    private lazy var screenBuilder: SpoolIndexScreenBuilder = { [weak self] in
        let builder = SpoolIndexScreenBuilder(model: self?.rolodex)
        return builder
    }()
    
    private lazy var dataSource: SpoolIndexDataSource = { [weak self] in
        let source = SpoolIndexDataSource(builder: self?.screenBuilder)
        return source
    }()
    
    private lazy var tableDelegate: SpoolIndexTableDelegate = { [weak self] in
        let delegate: SpoolIndexTableDelegate = SpoolIndexTableDelegate()
        delegate.onSelectSpool = self?.onSelectSpool
        return delegate
    }()
    
    var leftNavBarView: SpoolIndexLeftNavBarView?
    var tableView: UITableView?
    var rolodexIds: [String] = []
    var rolodex: Rolodexs?
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
        tableView?.dataSource = dataSource
        tableView?.delegate = tableDelegate
        
        dataProvider.requestsSpools(by: rolodexIds)
        if let headerModel = screenBuilder.headerInfo {
            leftNavBarView?.load(headerModel)
        }
        
        let spools = SpoolsProxy().spools(by: (rolodexIds.first)!)
        screenBuilder.updateModel(model: spools, type: [])
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        leftNavBarView?.removeFromSuperview()
        leftNavBarView = nil
    }
    
    // MARK: - Data loading callbacks
    
    private lazy var onSpoolsReceived: () -> Void = { [weak self] in
        let spools = SpoolsProxy().spools(by: (self?.rolodexIds.first)!)
        self?.screenBuilder.updateModel(model: spools, type: [])
        DispatchQueue.main.async {
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: - Navigation

    private lazy var onSelectSpool: (IndexPath) -> Void = { [weak self] index in
//        let vc: SpoolDetailsViewController = SpoolDetailsViewController()
//        vc.selectedSpool = self?.screenBuilder.dataRepository.spoolItems[index.section].spool
//        self?.navigationController?.pushViewController(vc, animated: true)
        
        let vc: ThreadsDetailViewController = ThreadsDetailViewController()
        let selectedSpool: Spools? = self?.screenBuilder.dataRepository.spoolItems[index.section].spool
        vc.threadId = selectedSpool?.last_messages_thread_id
        if let headerModel = self?.screenBuilder.headerInfo {
            if let url = headerModel.profileURL {
                vc.avatarURL = url
            }
            if let name = headerModel.name {
                vc.nameString = name
            }
        }
        if let avatar_pic = self?.leftNavBarView?.avatarImageView?.image {
            vc.avatar = avatar_pic
        }
//        self?.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self?.navigationController?.pushViewController(vc, animated: true)
    }
}
