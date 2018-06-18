//
//  SingleCategoryUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 8/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SingleCategoryUIInitializer: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Variables & Constants
    
    private let placeholderViewWidth: CGFloat = 100
    private let placeholderViewHeight: CGFloat = 50
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private unowned var parentVC: SingleCategoryViewController
    
    // MARK: - Initialization
    
    init(with parentVC: SingleCategoryViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
    // MARK: - Public interface
    
    func initialize() {
        parentVC.view.backgroundColor = .white
        addTableView()
        customizeNavigationBar()
    }
    
    // MARK: - Navigation bar customization
    
    private func customizeNavigationBar() {
        
        addBookmarkSwitchButton()
        customizeBackButton()
        
        if let category = parentVC.selectedCategory {
            let font: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extraMid)
            let width = category.title.width(usingFont: font)
            let imageViewWidth: CGFloat = 40
            
            let frame = CGRect(x: 0, y: -10, width: width + imageViewWidth, height: 30)
            let titleView = SingleCategoryNavigationTitleView(frame: frame)
            titleView.setupSubviews(for: category)
            parentVC.navigationItem.titleView = titleView
        }
    }
    
    private func addBookmarkSwitchButton() {
        let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: placeholderViewWidth, height: placeholderViewHeight))
        placeholderView.backgroundColor = .clear
        placeholderView.clipsToBounds = false
        
        let size = CGSize(width: 0.136 * screenWidth, height: 0.082 * screenWidth)
        let origin = CGPoint(x: (placeholderViewWidth - size.width) + 0.013 * screenWidth, y: (placeholderViewHeight / 2 - size.height / 2) - 0.01 * screenWidth)
        
        let customSwitch = SevenSwitch(frame: CGRect(origin: origin, size: size))
        customSwitch.onTintColor = UIColor.bookmarkedSwitchRed
        customSwitch.backgroundColor = UIColor(hexString: "C6C6CF")
        customSwitch.layer.cornerRadius = customSwitch.frame.height / 2
        customSwitch.addTarget(parentVC, action: #selector(parentVC.onSwitchValueChanged), for: .valueChanged)
        customSwitch.thumbImageView.image = switchButtonImage(for: false)
        
        placeholderView.addSubview(customSwitch)
        parentVC.bookmarksSwitch = customSwitch
        
        let item = UIBarButtonItem(customView: placeholderView)
        parentVC.navigationItem.setRightBarButtonItems([item], animated: true)
    }
    
    private func addGradientBackground(for tableView: UITableView) {
        let gradientView = GradientView()
        gradientView.frame = CGRect(x: 0, y: 0, width: parentVC.view.frame.width, height: parentVC.view.frame.height)
        gradientView.drawVerticalGradient(with: UIColor.tableViewBackgroundStartColor, and: UIColor.tableViewBackgroundEndColor)
        tableView.backgroundView = gradientView
    }
    
    func switchButtonImage(for value: Bool) -> UIImage? {
        let imageName = value ? LocalizedImageNameKey.FeedViewHelper.SwitchOnImage : LocalizedImageNameKey.FeedViewHelper.SwitchOffImage
        return UIImage(named: imageName)
    }
    
    private func customizeBackButton() {
        guard let navController = parentVC.navigationController else { return }
        let image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.BackButton)?.withAlignmentRectInsets(UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        let backButton = UIBarButtonItem(image: image, style: .plain, target: navController, action: #selector(navController.popViewController(animated:)))
        backButton.title = " "
        parentVC.navigationController?.interactivePopGestureRecognizer?.delegate = self
        parentVC.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: - Table view part
    
    private func addTableView() {
        let tableView = buildTableView()
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.reuseIdentifier())
        tableView.register(FeedCalendarInviteTableViewCell.self, forCellReuseIdentifier: FeedCalendarInviteTableViewCell.reuseIdentifier())
        tableView.register(FeedGenericCardTableViewCell.self, forCellReuseIdentifier: FeedGenericCardTableViewCell.reuseIdentifier())
        tableView.register(FeedAmazonCardTableViewCell.self, forCellReuseIdentifier: FeedAmazonCardTableViewCell.reuseIdentifier())
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.dataSource = parentVC.dataSource
        tableView.delegate = parentVC.categoryDelegate
        
        addGradientBackground(for: tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        parentVC.view.addSubview(tableView)
        parentVC.cardsTableView = tableView
    }
    
    private func buildTableView() -> FeedTableView {
        guard let navigationFrame = parentVC.navigationController?.navigationBar.frame else { return FeedTableView() }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tableViewFrame = CGRect(x: 0, y: 0, width: parentVC.view.frame.width, height: parentVC.view.frame.height - (navigationFrame.height + statusBarHeight))
        return FeedTableView(frame: tableViewFrame)
    }
}
