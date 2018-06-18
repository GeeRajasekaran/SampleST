//
//  FeedPageUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 1/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedPageUIInitializer {
    
    private unowned var feedVC: FeedPageViewController
    
    // MARK: - Public part
    
    init(with controller: FeedPageViewController) {
        feedVC = controller
    }
    
    func performBasicSetup() {
        feedVC.view.backgroundColor = .white
    }
    
    func layoutSubviews() {
        addNewsFeedTableView()
        addCategoryFilterCollectionView()
    }
    
    func hideCategoriesHeader() {
        guard let collectionView = feedVC.categoryFilterCollectionView else { return }
        if feedVC.newsFeedTableView.contentOffset.y < collectionView.frame.height {
            feedVC.newsFeedTableView.setContentOffset(CGPoint(x: 0, y: collectionView.frame.height), animated: false)
            collectionView.backgroundColor = .white
        }
    }
    
    // MARK: - Category filter collection view
    
    private func addCategoryFilterCollectionView() {
        let collectionView = buildCategoryFilterCollectionView()
        // collection view setup goes here
        collectionView.register(CategoryFilterCollectionViewCell.self, forCellWithReuseIdentifier: CategoryFilterCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.categoriesCollectionBackgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.delegate = feedVC.categoryFilterDelegate
        collectionView.dataSource = feedVC.categoryFilterDataSource
        addShadow(to: collectionView)
        
        feedVC.newsFeedTableView.tableHeaderView = collectionView
        feedVC.categoryFilterCollectionView = collectionView
    }
    
    private func addShadow(to collectionView: UICollectionView) {
        let shadowView = UIView(frame: CGRect(x: 0, y: collectionView.frame.height - 1, width: collectionView.frame.width, height: 1))
        shadowView.backgroundColor = UIColor.categoriesCollectionShadowColor
        collectionView.addSubview(shadowView)
    }
    
    private func buildCategoryFilterCollectionView() -> UICollectionView {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionViewFrame = CGRect(x: 0, y: 0, width: feedVC.view.frame.size.width, height: feedVC.view.frame.size.width * 0.173)
        return UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowLayout)
    }
    
    // MARK: - News feed table view
    
    private func addNewsFeedTableView() {
        guard let tableView = buildNewsFeedTableView() else { return }
        let shadowView = buildTableShadowView()
        // feed items cells
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.reuseIdentifier())
        tableView.register(FeedCalendarInviteTableViewCell.self, forCellReuseIdentifier: FeedCalendarInviteTableViewCell.reuseIdentifier())
        tableView.register(FeedGenericCardTableViewCell.self, forCellReuseIdentifier: FeedGenericCardTableViewCell.reuseIdentifier())
        tableView.register(FeedAmazonCardTableViewCell.self, forCellReuseIdentifier: FeedAmazonCardTableViewCell.reuseIdentifier())
        tableView.register(FeedMostRecentHeaderCell.self, forCellReuseIdentifier: FeedMostRecentHeaderCell.reuseIdentifier())
        tableView.register(FeedEarlierHeaderCell.self, forCellReuseIdentifier: FeedEarlierHeaderCell.reuseIdentifier())
        // morning brief cells
        
        tableView.register(BriefHeaderCell.self, forCellReuseIdentifier: BriefHeaderCell.reuseIdentifier())
        tableView.register(BriefCategoryCell.self, forCellReuseIdentifier: BriefCategoryCell.reuseIdentifier())
        tableView.register(BriefRequestsCell.self, forCellReuseIdentifier: BriefRequestsCell.reuseIdentifier())
        tableView.register(BriefItemCell.self, forCellReuseIdentifier: BriefItemCell.reuseIdentifier())
        tableView.register(BriefCategoryControlCell.self, forCellReuseIdentifier: BriefCategoryControlCell.reuseIdentifier())
        
        tableView.register(FeedEmptyTodayTableViewCell.self, forCellReuseIdentifier: FeedEmptyTodayTableViewCell.reuseIdentifier())
        tableView.register(FeedEmptyBookmarksTableViewCell.self, forCellReuseIdentifier: FeedEmptyBookmarksTableViewCell.reuseIdentifier())
        
        tableView.register(PendingRequestTableViewCell.self, forCellReuseIdentifier: PendingRequestTableViewCell.reuseIdentifier())
        
        tableView.backgroundColor = UIColor.clear
        addGradientBackground(for: tableView)
        
        tableView.dataSource = feedVC.dataSource
        tableView.delegate = feedVC.tableDelegate
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        feedVC.view.addSubview(shadowView)
        feedVC.view.addSubview(tableView)
        feedVC.newsFeedTableView = tableView
        
        tableView.leadingAnchor.constraint(equalTo: feedVC.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: feedVC.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: feedVC.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: feedVC.view.bottomAnchor, constant: -15).isActive = true
    }
    
    private func addGradientBackground(for tableView: UITableView) {
        let gradientView = GradientView()
        gradientView.frame = CGRect(x: 0, y: 0, width: feedVC.view.frame.width, height: feedVC.view.frame.height)
        gradientView.drawVerticalGradient(with: UIColor.tableViewBackgroundStartColor, and: UIColor.tableViewBackgroundEndColor)
        tableView.backgroundView = gradientView
    }
    
    private func buildTableShadowView() -> UIView {
        guard let collectionOriginY = feedVC.categoryFilterCollectionView?.frame.origin.y,
            let collectionHeight = feedVC.categoryFilterCollectionView?.frame.size.height else { return UIView() }
        
        let tableShadowOriginY = collectionOriginY + collectionHeight
        let tableShadowViewFrame = CGRect(x: 0, y: tableShadowOriginY, width: feedVC.view.frame.size.width, height: 10)
        
        let shadowView = UIView(frame: tableShadowViewFrame)
        shadowView.backgroundColor = .white
        shadowView.drawTopShadow()
        return shadowView
    }
    
    private func buildNewsFeedTableView() -> FeedTableView? {
        return FeedTableView(frame: .zero, style: .plain)
    }
}
