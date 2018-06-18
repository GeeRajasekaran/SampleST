//
//  ForwardUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ForwardUIInitializer: IInitializer {
    
    // MARK: - Vairables
    
    private let screenWidth = UIScreen.main.bounds.width
    unowned var parentViewController: ResponderViewControllerOld
    
    // MARK: - Initialization
    
    required init(parentVC: ResponderViewControllerOld) {
        parentViewController = parentVC
    }
    
    // MARK: - Public part
    
    func initialize() {
        parentViewController.view.backgroundColor = .clear
        addAccessoryView()
//        addHeaderView()
//        addContentWebView()
//        addVendorDetailsView()
    }
    
    // MARK: - Public part
    
    private func addAccessoryView() {
        var height: CGFloat = 0
        if parentViewController.config?.isMinimizationEnabled == true {
            height = 0.144 * screenWidth
        } else {
            height = 0.336 * screenWidth + 0.096 * screenWidth
        }
        
        let frame = CGRect(x: 0, y: 0, width: parentViewController.view.frame.width, height: height)
        let accessoryView = ResponderAccessoryViewOld(frame: frame)
        accessoryView.backgroundColor = .white
        accessoryView.onExpandAction = parentViewController.onExapandAction
        accessoryView.onAttachementsAction = parentViewController.onAttachmentAction
        accessoryView.onSendAction = parentViewController.onSendAction
        accessoryView.onTextViewExpanded = parentViewController.onTextViewExpanded
        accessoryView.onOpenAttachment = parentViewController.onOpenAttachment
        accessoryView.onRemovedAttachment = parentViewController.onRemovedAttachment
        accessoryView.dataSource = parentViewController.dataSource
        accessoryView.delegate = parentViewController.delegate
        
        if let config = parentViewController.config, let unwrappedResponder = parentViewController.responder {
            accessoryView.setupSubviews(for: config, using: unwrappedResponder)
        }
        
        parentViewController.view.addSubview(accessoryView)
        parentViewController.accessoryView = accessoryView
    }
    
    // MARK: - Header view
    
    private func addHeaderView() {
        guard let accessoryViewFrame = parentViewController.accessoryView?.frame else { return }
        let height = 0.096 * screenWidth
        let originY = accessoryViewFrame.origin.y - height
        
        let headerFrame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
        let headerView = UIView(frame: headerFrame)
        headerView.backgroundColor = .white
        addTopShadowView(to: headerView)
        addBottomShadowView(to: headerView)
        addTitleLabel(to: headerView)
        
        parentViewController.view.addSubview(headerView)
        parentViewController.headerView = headerView
    }
    
    private func addBottomShadowView(to view: UIView) {
        let shadowFrame = CGRect(x: 0, y: view.frame.height - 1, width: screenWidth, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        
        view.addSubview(shadowView)
    }
    
    private func addTopShadowView(to view: UIView) {
        let shadowFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        
        view.addSubview(shadowView)
    }
    
    private func addTitleLabel(to view: UIView) {
        let height = 0.032 * screenWidth
        let titleFrame = CGRect(x: UIView.midMargin, y: view.frame.height / 2 - height / 2, width: screenWidth - 2 * UIView.midMargin, height: height)
        
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = LocalizedStringKey.ResponderHelper.HeaderTitle
        titleLabel.font = UIFont(name: LocalizedFontNameKey.ResponderHelper.HeaderTitleFont, size: 10)
        titleLabel.textColor = UIColor.participantsLabelGray
        
        view.addSubview(titleLabel)
    }
    
    // MARK: - Content web view
    
    private func addContentWebView() {
        
    }
    
    // MARK: - Vendor details view
    
    private func addVendorDetailsView() {
        guard let headerFrame = parentViewController.headerView?.frame else { return }
        let detailsBarFrame = CGRect(x: 0, y: headerFrame.height + headerFrame.origin.y, width: screenWidth, height: 0.176 * screenWidth)
        
        let detailsBar = UIView(frame: detailsBarFrame)
        detailsBar.backgroundColor = .white
        detailsBar.clipsToBounds = false
        
        let height = 0.093 * screenWidth
        let originX = 0.052 * screenWidth
        let vendorDetailsFrame = CGRect(x: originX, y: detailsBarFrame.height/2 - height/2, width: screenWidth - 2 * originX, height: height)
        
        let detailsView = VendorDetailsView(frame: vendorDetailsFrame)
        detailsView.setupSubviews()
        
        detailsBar.addSubviewIfNeeded(detailsView)
        
        parentViewController.view.addSubview(detailsBar)
    }
}
