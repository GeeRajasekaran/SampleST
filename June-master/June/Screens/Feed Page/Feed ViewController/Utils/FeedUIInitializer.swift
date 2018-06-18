//
//  FeedUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedUIInitializer {
    
    private unowned var feedVC: FeedViewController
    
    // MARK: - Public part
    
    init(with controller: FeedViewController) {
        feedVC = controller
    }
    
    func performBasicSetup() {
        feedVC.view.backgroundColor = .white
        
        let imageName = LocalizedImageNameKey.HomeViewHelper.NavigationBarBottomImageName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: feedVC.view.frame.width, height: 4)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        feedVC.view.addSubview(imageView)
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
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.delegate = feedVC.categoryFilterDelegate
        collectionView.dataSource = feedVC.categoryFilterDataSource
        
        feedVC.newsFeedTableView.tableHeaderView = collectionView
        feedVC.categoryFilterCollectionView = collectionView
    }
    
    private func buildCategoryFilterCollectionView() -> UICollectionView {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionViewFrame = CGRect(x: 0, y: 4, width: feedVC.view.frame.size.width, height: feedVC.view.frame.size.width * 0.173)
        return UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowLayout)
    }
    
    // MARK: - News feed table view
    
    private func addNewsFeedTableView() {
        guard let tableView = buildNewsFeedTableView() else { return }
        let shadowView = buildTableShadowView()
        // table view setup goes here
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.reuseIdentifier())
        tableView.register(FeedCalendarInviteTableViewCell.self, forCellReuseIdentifier: FeedCalendarInviteTableViewCell.reuseIdentifier())
        tableView.register(FeedGenericCardTableViewCell.self, forCellReuseIdentifier: FeedGenericCardTableViewCell.reuseIdentifier())
        tableView.register(FeedAmazonCardTableViewCell.self, forCellReuseIdentifier: FeedAmazonCardTableViewCell.reuseIdentifier())
        tableView.backgroundColor = UIColor.recentTableViewBackgroundColor
        tableView.dataSource = feedVC.recentItemsDataSource
        tableView.delegate = feedVC.recentItemsDelegate
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        feedVC.view.addSubview(shadowView)
        feedVC.view.addSubview(tableView)
        feedVC.newsFeedTableView = tableView
        
        tableView.leadingAnchor.constraint(equalTo: feedVC.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: feedVC.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: feedVC.view.topAnchor, constant: 4).isActive = true
        tableView.bottomAnchor.constraint(equalTo: feedVC.view.bottomAnchor, constant: -15).isActive = true
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
