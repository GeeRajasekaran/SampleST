//
//  FeedDetailedUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedDetailedUIInitializer: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Variables & Constants
    
    private unowned var parentViewController: FeedDetailedViewController
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    // MARK: - Initialization
    
    init(vc: FeedDetailedViewController) {
        parentViewController = vc
    }
    
    // MARK: - Public initialization logic
    
    func initialize() {
        parentViewController.automaticallyAdjustsScrollViewInsets = false
        parentViewController.view.backgroundColor = .white
        addContentTableView()
        customizeBackButton()
        if let view = parentViewController.navigationController?.navigationBar {
            addToolPanel(to: view)
        }
    }
    
    // MARK: - Private table view building logic
    
    private func addContentTableView() {
        let tableView = UITableView()
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(MessageHeaderTableViewCell.self, forCellReuseIdentifier: MessageHeaderTableViewCell.reuseIdentifier())
        tableView.register(MessageSubjectTableViewCell.self, forCellReuseIdentifier: MessageSubjectTableViewCell.reuseIdentifier())
        tableView.register(MessageBodyTableViewCell.self, forCellReuseIdentifier: MessageBodyTableViewCell.reuseIdentifier())
        
        tableView.dataSource = parentViewController.dataSource
        tableView.delegate = parentViewController.delegate
        
        addTableView(tableView)
    }
    
    private func addTableView(_ tableView: UITableView) {
        parentViewController.view.addSubview(tableView)
        parentViewController.contentTableView = tableView
        
        //MARK: - add top margin is isFromSearch
        var topConstant: CGFloat = 0
        if parentViewController.isFromSearch {
            if let navBarHeight = parentViewController.navigationController?.navigationBar.frame.height {
                topConstant += navBarHeight
            }
            topConstant += UIApplication.shared.statusBarFrame.height
        }
        tableView.leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: parentViewController.view.topAnchor, constant: CGFloat(topConstant)).isActive = true
        
        parentViewController.bottomConstraint = tableView.bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor)
        parentViewController.bottomConstraint?.isActive = true
    }
    
    // MARK: - Tool panel creation
    
    private func addToolPanel(to view: UIView) {
        let width = 0.428 * screenWidth
        
        let panelFrame = CGRect(x: view.frame.width - width - 8, y: 0, width: width, height: view.frame.height)
        let toolButtonsView = ToolPanelView(frame: panelFrame)
        toolButtonsView.setupSubviews()
        toolButtonsView.backgroundColor = .clear
        
        view.addSubview(toolButtonsView)
        parentViewController.toolView = toolButtonsView
    }
    
    func setStar(action: Selector, for target: Any) {
        parentViewController.toolView?.bookmarkButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setMoreOptions(action: Selector, for target: Any) {
        parentViewController.toolView?.moreOptionsButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setRecategorize(action: Selector, for target: Any) {
        parentViewController.toolView?.recategorizeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setShare(action: Selector, for target: Any) {
        parentViewController.toolView?.shareButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - Back button customization
    
    private func customizeBackButton() {
        let image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.BackButton)?.withAlignmentRectInsets(UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        let backButton = UIBarButtonItem(image: image, style: .plain, target: parentViewController, action: #selector(parentViewController.onBack))
        backButton.title = " "
        parentViewController.navigationController?.interactivePopGestureRecognizer?.delegate = self
        parentViewController.navigationItem.setLeftBarButton(backButton, animated: false)
    }
}
