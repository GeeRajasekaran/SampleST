//
//  JuneSearchViewControllerInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class JuneSearchViewControllerInitializer: NSObject {
    
    // MARK: - Variables & Constants
    private unowned var parentVC: JuneSearchViewController
    private var navBarHeight: CGFloat = 44
    private var offset: CGFloat = 8
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Public part
    init(with controller: JuneSearchViewController) {
        parentVC = controller
        if let navItemHeight = parentVC.navigationController?.navigationBar.frame.height {
            navBarHeight = navItemHeight
        }
    }
    
    func performBasicSetup() {
        parentVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func layoutSubviews() {
        parentVC.navigationController?.navigationBar.barTintColor = .white
        addTopView()
        addTableView()
    }
    
    func hideTableView() {
        parentVC.tableView.frame.size.height = 0
    }
    
    func showTableViewIFNeeded() {
        let tableView = parentVC.tableView
        let dataCount = parentVC.dataRepository.getCount()
        if dataCount > 0 {
            let maxHeight = 0.677*screenWidth
            let oneCellHeight = parentVC.listDelegate.cellHeight
            let totalCellHeight = oneCellHeight*CGFloat(dataCount)
            if totalCellHeight >= maxHeight {
                tableView.frame.size.height = maxHeight
            } else {
                tableView.frame.size.height = totalCellHeight
            }
        } else {
            tableView.frame.size.height = 0
        }
    }
    
    //MARK: - private part
    private func addTopView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: navBarHeight)
        view.addSubview(buildSearchBar())
        view.addSubview(buildSearchIcon())
        view.tag = 1001
        parentVC.navigationController?.navigationBar.addSubview(view)
    }
    
    private func buildSearchBar() -> UISearchBar {
        // Setup the Search Controller
        let originX = 0.117 * screenWidth
        let width = screenWidth - originX
        let searchVC = parentVC.searchResultHandler.searchController
        let height = 0.091 * screenWidth
        let originY = navBarHeight/2 - height/2
        searchVC.searchBarRect = CGRect(x: originX, y: originY, width: width, height: height)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.dimsBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = LocalizedStringKey.SearchViewHelper.SearchTitle
        return searchVC.searchBar
    }
    
    private func buildSearchIcon() -> UIButton {
        let height = navBarHeight
        let width = height
        let frame = CGRect(x: offset, y: 0, width: width, height: height)
        let button = UIButton(frame: frame)
        button.setImage(UIImage(named: LocalizedImageNameKey.HomeViewHelper.SearchBackButtonName), for: .normal)
        return button
    }
    
    private func addTableView() {
        let parentView = parentVC.view
        guard let tableView = buildTableView() else { return }
        // table view setup goes here
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier())
        tableView.dataSource = parentVC.listDataSource
        tableView.delegate = parentVC.listDelegate
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        parentView?.addSubview(tableView)
        parentVC.tableView = tableView
    }
    
    private func buildTableView() -> UITableView? {
        var originY: CGFloat = UIApplication.shared.statusBarFrame.height
        if let originYNavItem = parentVC.navigationItem.titleView?.frame.height {
            originY += originYNavItem + 4
        }
        
        let tableViewFrame = CGRect(x: 0, y: originY, width: screenWidth, height: 0)
        return UITableView(frame: tableViewFrame, style: .plain)
    }
}
