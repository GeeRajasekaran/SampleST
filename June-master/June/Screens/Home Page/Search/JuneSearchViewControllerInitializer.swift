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
    private var offset: CGFloat = 16
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
        addBottomLine()
        addTableView()
    }
    
    func hideTableView() {
        parentVC.tableView.frame.size.height = 0
    }
    
    func showTableView() {
        parentVC.tableView.frame.size.height = 0.677*screenWidth
    }
    
    //MARK: - private part
    private func addTopView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: navBarHeight)
        view.addSubview(buildBackButton())
        view.addSubview(buildSearchBar())
        
        parentVC.navigationItem.titleView = view
    }
    
    private func buildSearchBar() -> UISearchBar {
        // Setup the Search Controller
        let originX = parentVC.backButton.frame.origin.x + parentVC.backButton.frame.width - self.offset
        let offset = 0.04*screenWidth
        let width = screenWidth - originX - offset
        let searchVC = parentVC.searchController
        searchVC.searchResultsUpdater = parentVC
        
        searchVC.searchBarRect = CGRect(x: originX, y: 0, width: width, height: navBarHeight)
        searchVC.searchBar.searchBarStyle = .prominent
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.dimsBackgroundDuringPresentation = false
        searchVC.searchBar.showsCancelButton = false
        searchVC.searchBar.placeholder = "Search"
        parentVC.definesPresentationContext = true
        
        return searchVC.searchBar
    }
    
    private func buildBackButton() -> UIButton {
        let height = navBarHeight
        let width = height
        let frame = CGRect(x: -offset, y: 0, width: width, height: height)
        let button = UIButton(frame: frame)
        button.addGestureRecognizer(UITapGestureRecognizer(target: parentVC, action: #selector(parentVC.onBackButtonTapped(sender:))))
        button.setImage(UIImage(named: LocalizedImageNameKey.HomeViewHelper.SearchBackButtonName), for: .normal)
        parentVC.backButton = button
        return button
    }
    
    private func addBottomLine() {
        let imageName = LocalizedImageNameKey.HomeViewHelper.NavigationBarBottomImageName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        var originY: CGFloat = UIApplication.shared.statusBarFrame.height
        if let originYNavItem = parentVC.navigationItem.titleView?.frame.height {
            originY += originYNavItem
        }
        imageView.frame = CGRect(x: 0, y: originY, width: parentVC.view.frame.width, height: 4)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        parentVC.view.addSubview(imageView)
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
