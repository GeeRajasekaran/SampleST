//
//  DetailViewInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/1/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class DetailViewInitializer {
 
    // MARK: - Variables & Constants
    
    private unowned var parentVC: DetailViewController
    private let screenWidth = UIScreen.main.bounds.width
    private var toolButtonsView = ToolPanelView()
    
    // MARK: - Initialization
    
    init(with rootVC: DetailViewController) {
        parentVC = rootVC
    }
    
    // MARK: - Public part
    
    func initialize() {
        parentVC.view.backgroundColor = .white
        addVendorTitleBar()
        addContentTableView()
    }
    
    func setStar(action: Selector, for target: Any) {
        toolButtonsView.bookmarkButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setMoreOptions(action: Selector, for target: Any) {
        toolButtonsView.moreOptionsButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setRecategorize(action: Selector, for target: Any) {
        toolButtonsView.recategorizeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setShare(action: Selector, for target: Any) {
        toolButtonsView.shareButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - Header building part
    
    func addColoredHeaderLine() {
        let imageName = LocalizedImageNameKey.HomeViewHelper.NavigationBarBottomImageName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: parentVC.view.frame.width, height: 4)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        parentVC.navigationController?.navigationBar.addSubview(imageView)
        parentVC.coloredLineView = imageView
    }
    
    func addNavigationView() {
//        this coomented code will be necessary in case when we will return transition animation back
//        let navigationViewFrame = CGRect(x: 0, y: 0.064 * screenWidth + 4, width: screenWidth, height: 0.133 * screenWidth)
//        let navigationView = UIView(frame: navigationViewFrame)
//        navigationView.backgroundColor = .white
        guard let navigationView = parentVC.navigationController?.navigationBar else { return }
        addBottomShadowView(to: navigationView)
        addToolPanel(to: navigationView)
        customizeBackButton()
//        addBackButton(to: navigationView)
//        parentVC.view.addSubview(navigationView)
//        parentVC.navigationView = navigationView
    }
    
    private func customizeBackButton() {
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.BackButton)?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -2, right: 0))
        let backButton = UIBarButtonItem(image: image, style: .plain, target: parentVC, action: #selector(DetailViewController.onBack))
        backButton.title = " "
        parentVC.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    private func addBottomShadowView(to view: UIView) {
        let shadowFrame = CGRect(x: 8, y: view.frame.height - 1, width: screenWidth - 16, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        
        view.addSubview(shadowView)
    }
    
    private func addTopShadowView(to view: UIView) {
        let shadowFrame = CGRect(x: 8, y: 0, width: screenWidth - 16, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        
        view.addSubview(shadowView)
    }
    
    private func addBackButton(to view: UIView) {
        let buttonFrame = CGRect(x: 0, y: 0, width: 0.2 * view.frame.width, height: view.frame.height)
        
        let button = UIButton(frame: buttonFrame)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        button.backgroundColor = .clear
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.BackButton)
        button.setImage(image, for: .normal)
        button.addTarget(parentVC, action: #selector(DetailViewController.onBack), for: .touchUpInside)
        
        view.addSubview(button)
        parentVC.backButton = button
    }
    
    // MARK: - Tool panel creation
    
    private func addToolPanel(to view: UIView) {
        let width = 0.428 * screenWidth
        
        let panelFrame = CGRect(x: view.frame.width - width - 16, y: 0, width: width, height: view.frame.height)
        toolButtonsView = ToolPanelView(frame: panelFrame)
        toolButtonsView.setupSubviews()
        toolButtonsView.backgroundColor = .clear
        
        view.addSubview(toolButtonsView)
        parentVC.toolView = toolButtonsView
    }
    
    // MARK: - Messages details bar
    
    private func addVendorTitleBar() {
        var originY: CGFloat = 0
        if parentVC.isFromSearch {
            if let navigationBarFrame = parentVC.navigationController?.navigationBar.frame {
                originY = navigationBarFrame.origin.y + navigationBarFrame.height
            }
        }
        
        let barFrame = CGRect(x: 0, y: originY, width: screenWidth, height: 0.109 * screenWidth)
        let barView = UIView(frame: barFrame)
        barView.backgroundColor = .white
        
        addSubjectLabel(to: barView)
        parentVC.view.addSubview(barView)
        parentVC.subjectBar = barView
    }
    
    private func addSubjectLabel(to view: UIView) {
        let textLAbelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .regMid)
        
        let labelFrame = CGRect(x: 8, y: 0, width: view.frame.width - 16, height: view.frame.height)
        let textLabel = UILabel(frame: labelFrame)
        textLabel.font = textLAbelFont
        textLabel.textColor = UIColor.tableHeaderTitleGray
        textLabel.textAlignment = .center
        
        view.addSubview(textLabel)
        parentVC.subjectLabel = textLabel
    }
    
    private func addVendorDetailBar(to view: UIView) {
        
        let detailsBarFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.176 * screenWidth)
        
        let detailsBar = UIView(frame: detailsBarFrame)
        detailsBar.backgroundColor = .white
        detailsBar.clipsToBounds = false
        addTopShadowView(to: detailsBar)
        addBottomGradientShadowView(to: detailsBar)
        
        let height = 0.093 * screenWidth
        let originX = 0.052 * screenWidth
        let vendorDetailsFrame = CGRect(x: originX, y: detailsBarFrame.height/2 - height/2, width: screenWidth - 2 * originX, height: height)
        
        let detailsView = VendorDetailsView(frame: vendorDetailsFrame)
        detailsView.setupSubviews()
        
        detailsBar.addSubviewIfNeeded(detailsView)
        
        view.addSubview(detailsBar)
        parentVC.vendorDetailsView = detailsView
        parentVC.vendorDetailsBar = detailsBar
    }
    
    private func addBottomGradientShadowView(to view: UIView) {
        let viewFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 7)
        
        let gradientView = GradientView(frame: viewFrame)
        gradientView.drawVerticalGradient(with: UIColor.bottomShadowColor)
        gradientView.backgroundColor = .blue
        view.addSubview(gradientView)
    }
    
    private func addContentTableView() {
        guard let subjectBarFrame = parentVC.subjectBar?.frame,
            let navigationBarFrame = parentVC.navigationController?.navigationBar.frame else { return }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let originY = subjectBarFrame.origin.y + subjectBarFrame.height
        var tableViewHeight = parentVC.view.frame.height - (originY + navigationBarFrame.height + statusBarHeight)
        if parentVC.isFromSearch {
            tableViewHeight = parentVC.view.frame.height - originY
        }
        let tableViewFrame = CGRect(x: 0, y: originY, width: screenWidth, height: tableViewHeight)
        
        let contentTableView = FeedTableView(frame: tableViewFrame)
        
        contentTableView.dataSource = parentVC.tableViewSource
        contentTableView.delegate = parentVC.tableViewDelegate
        contentTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier())
        contentTableView.separatorStyle = .none
        
        parentVC.view.addSubview(contentTableView)
        parentVC.contentTableView = contentTableView
    }
}
