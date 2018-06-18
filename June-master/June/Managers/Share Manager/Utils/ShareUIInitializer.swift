//
//  ShareUIInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/8/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ShareUIInitializer: NSObject {

    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private unowned var parentViewController: ShareViewController
    
    var bottomViewHeight: CGFloat = 0.04 * UIScreen.main.bounds.width
    
    var totalMesasgeInfoHeight: CGFloat {
        get { return 0.744 * UIScreen.main.bounds.width + bottomViewHeight }
    }
    // MARK: - Initialization
    
    init(parentVC: ShareViewController) {
        parentViewController = parentVC
    }
    
    // MARK: - Public part
    
    func performBasicSetup() {
        parentViewController.view.backgroundColor = UIColor.shareBackgroundColor.withAlphaComponent(0.78)
        setupBaseView()
    }
    
    func layoutSubviews() {
        addTopHeaderView()
        addMailDetailsView()
        addTextView()
        addActionView()
        addBottomView()
    }
    
    //MARK: - private part
    
    //MARK: - base view configuration
    private func setupBaseView() {
        let originX = UIView.slimMargin
        let frame = CGRect(x: originX, y: statusBarHeight, width: screenWidth - 2 * originX, height: totalMesasgeInfoHeight)
        let baseView = UIScrollView(frame: frame)
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 0.04 * screenWidth
        parentViewController.view.addSubview(baseView)
        parentViewController.baseView = baseView
    }
    
    // MARK: - Top header view creation
    
    private func addTopHeaderView() {
        let headerHeight = 0.16 * screenWidth
        
        let headerFrame = CGRect(x: 0, y: 0, width: parentViewController.baseView.frame.width, height: headerHeight)
        let headerView = ComposeHeaderView(frame: headerFrame)
        headerView.onCloseAction = parentViewController.onCloseAction
        headerView.setupSubviews()
        headerView.loadData(text: LocalizedStringKey.ShareHelper.HeaderTitle)
        parentViewController.baseView.addSubview(headerView)
        parentViewController.topHeaderView = headerView
    }
    
    // MARK: - Mail detailes view creation
    
    private func addMailDetailsView() {
        guard let topHeaderFrame = parentViewController.topHeaderView?.frame else { return }
        let height = 0.264 * screenWidth
        
        let detailsFrame = CGRect(x: 0, y: topHeaderFrame.origin.y + topHeaderFrame.height, width: screenWidth, height: height)
        let detailsView = MailDetailsView(frame: detailsFrame)
        detailsView.toFieldDataSource = parentViewController.receiversHandler.receiversDataSource
        detailsView.toFieldDelegate = parentViewController.receiversHandler.receiversDelegate
        detailsView.setupSubviews()
        parentViewController.baseView.addSubview(detailsView)
        parentViewController.mailDetailsView = detailsView
    }
    
    // MARK: - Text view creation
    
    private func addTextView() {
        guard let mailsBar = parentViewController.mailDetailsView?.frame else { return }
        
        let topIndent = 0.032 * screenWidth
        let originY = mailsBar.origin.y + mailsBar.height + topIndent
        let height = 0.144 * screenWidth
        let textViewFrame = CGRect(x: 0.04 * screenWidth, y: originY, width: parentViewController.baseView.frame.width -  2 * 0.04 * screenWidth, height: height)
        
        let textViewFont = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        
        let textView = ComposeTextView(frame: textViewFrame)
        textView.font = textViewFont
        textView.textColor = .black
        textView.autocorrectionType = .yes
        textView.layoutManager.delegate = self
        textView.delegate = parentViewController
        addPlaceholderLabel(to: textView)
        parentViewController.baseView.addSubview(textView)
        parentViewController.textInputView = textView
    }
    
    private func addPlaceholderLabel(to textView: UITextView) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Include a message ..."
        placeholderLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 6)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    // MARK: - Accessory action view creation
    
    private func addActionView() {
        guard let topView = parentViewController.textInputView else { return }
        let height = 0.144 * screenWidth
        
        let actionFrame = CGRect(x: 0, y: topView.frame.origin.y + topView.frame.height, width: parentViewController.baseView.frame.width, height: height)
        let actionsView = AccessoryActionsView(frame: actionFrame)
        actionsView.setupSubviews(isFromCompose: true, shouldShowAttachments: false)
        actionsView.onSendAction = parentViewController.onSendAction
    
        parentViewController.baseView.addSubview(actionsView)
        parentViewController.actionsView = actionsView
    }
    
    private func addBottomView() {
        guard let topViewFrame = parentViewController.actionsView?.frame else { return }
        guard let cardViewFrame = parentViewController.cardView?.view.frame else { return }
        bottomViewHeight += cardViewFrame.height
        let bottomView = ShareBottomView(frame: CGRect(x: 0, y: topViewFrame.origin.y + topViewFrame.height, width: parentViewController.baseView.frame.width, height: bottomViewHeight))
        bottomView.setupSubviews()
        bottomView.loadData(cardView: parentViewController.cardView)
        parentViewController.baseView.addSubview(bottomView)
        parentViewController.bottomView = bottomView
        
        parentViewController.baseView.frame.size.height = totalMesasgeInfoHeight
    }
}

extension ShareUIInitializer: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
