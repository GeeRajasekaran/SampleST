//
//  ComposeUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeUIInitializer: NSObject {
    
    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    private let additionalHeight = 0.277 * UIScreen.main.bounds.width
    private let viewHeight = 0.134 * UIScreen.main.bounds.width
    private unowned var parentViewController: ComposeViewController
    
    private var expandDelta: CGFloat = 0
    
    // MARK: - Initialization
    
    init(parentVC: ComposeViewController) {
        parentViewController = parentVC
    }
    
    // MARK: - Public part
    
    func initialize() {
        parentViewController.view.backgroundColor = .white
        addTopHeaderView()
        addMailDetailsView()
        addActionView()
        addTextView()
    }
    
    // MARK: - Keyboard events handling
    //MARK: - Change action view frame relatively to inititalized frame
    func updateUIForShowedKeyboard(with height: CGFloat) {
        changeActionFrameWith(height)
    }
    
    func updatedUIForHidenKeyboard(with height: CGFloat) {
        setInitializedActionViewFrame()
    }
    
    func updateUIForKeyboardHeightChanges(with delta: CGFloat) {
        parentViewController.actionsView?.frame.origin.y -= delta
        parentViewController.textInputView?.frame.size.height -= delta
    }
    
    // MARK: - Animations of expand and collapse
    
    func expand() {
        UIView.animate(withDuration: 0.2, animations: {
            self.parentViewController.mailDetailsView?.frame.size.height += self.additionalHeight
            self.parentViewController.textInputView?.frame.origin.y += self.additionalHeight
            self.parentViewController.textInputView?.frame.size.height -= self.additionalHeight
            self.parentViewController.mailDetailsView?.moveDown(to: self.additionalHeight)
            self.parentViewController.view.layoutIfNeeded()
        })
    }
    
    func collapse() {
        UIView.animate(withDuration: 0.2, animations: {
            self.parentViewController.mailDetailsView?.frame.size.height -= self.additionalHeight
            self.parentViewController.textInputView?.frame.origin.y -= self.additionalHeight
            self.parentViewController.textInputView?.frame.size.height += self.additionalHeight
            self.parentViewController.mailDetailsView?.moveUp(to: self.additionalHeight)
            self.parentViewController.view.layoutIfNeeded()
        })
    }
    
    func expandToField(to position: CGFloat) {
        let delta = abs(0.134 * screenWidth - position)
        expandDelta = delta
        UIView.animate(withDuration: 0.2, animations: {
            self.parentViewController.mailDetailsView?.frame.size.height += delta
            self.parentViewController.receiversHandler.suggestionViewController.view.frame.origin.y += delta
            self.parentViewController.textInputView?.frame.origin.y += delta
            self.parentViewController.textInputView?.frame.size.height -= delta
            self.parentViewController.mailDetailsView?.moveSubjectDown(to: delta)
            self.parentViewController.view.layoutIfNeeded()
        })
    }
    
    func collapseToField() {
        guard let mailsBarFrame = parentViewController.mailDetailsView?.frame else { return }
        let originY = mailsBarFrame.origin.y + 2 * 0.134 * screenWidth
        UIView.animate(withDuration: 0.2, animations: {
            self.parentViewController.mailDetailsView?.frame.size.height -= self.expandDelta
            self.parentViewController.receiversHandler.suggestionViewController.view.frame.origin.y = originY
            self.parentViewController.textInputView?.frame.origin.y -= self.expandDelta
            self.parentViewController.textInputView?.frame.size.height += self.expandDelta
            self.parentViewController.mailDetailsView?.moveSubjectUp(to: self.expandDelta)
            self.parentViewController.view.layoutIfNeeded()
        })
    }
    
    func expandWithAttachments() {
        guard let mailBar = parentViewController.mailDetailsView else { return }
        let delta = 0.15 * UIScreen.main.bounds.width
        mailBar.frame.size.height += delta
        self.parentViewController.textInputView?.frame.origin.y += delta
        self.parentViewController.textInputView?.frame.size.height -= delta
    }
    
    func removeAttachments() {
        guard let mailBar = parentViewController.mailDetailsView else { return }
        let delta = 0.15 * UIScreen.main.bounds.width
        mailBar.removeAttachmentView()
        mailBar.frame.size.height -= delta
        self.parentViewController.textInputView?.frame.origin.y -= delta
        self.parentViewController.textInputView?.frame.size.height += delta
    }
    
    private func setInitializedActionViewFrame() {
        let height = 0.157 * screenWidth
        let actionFrame = CGRect(x: 0, y: parentViewController.view.frame.height - height, width: screenWidth, height: height)
        parentViewController.actionsView?.frame = actionFrame
        
        let actionViewOriginY = actionFrame.origin.y
        guard let textInputFrame = parentViewController.textInputView?.frame else { return }
        parentViewController.textInputView?.frame.size.height = actionViewOriginY - textInputFrame.origin.y
    }
    
    private func changeActionFrameWith(_ height: CGFloat) {
        setInitializedActionViewFrame()
        parentViewController.actionsView?.frame.origin.y -= height
        parentViewController.textInputView?.frame.size.height -= height
    }
    
    // MARK: - Top header view creation
    
    private func addTopHeaderView() {
        let headerHeight = 0.176 * screenWidth
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let headerFrame = CGRect(x: 0, y: statusBarHeight, width: screenWidth, height: headerHeight)
        let headerView = ComposeHeaderView(frame: headerFrame)
        headerView.onCloseAction = parentViewController.onCloseAction
        headerView.setupSubviews()
        
        parentViewController.view.addSubview(headerView)
        parentViewController.topHeaderView = headerView
    }
    
    // MARK: - Mail detailes view creation
    
    private func addMailDetailsView() {
        guard let topHeaderFrame = parentViewController.topHeaderView?.frame else { return }
        let height = 0.264 * screenWidth + 0.132 * screenWidth
        
        let detailsFrame = CGRect(x: 0, y: topHeaderFrame.origin.y + topHeaderFrame.height, width: screenWidth, height: height)
        let detailsView = MailDetailsView(frame: detailsFrame)
        detailsView.onExpandAction = parentViewController.onExpandAction
        detailsView.onToExpandAction = parentViewController.onToExpandAction
        detailsView.onToCollapseAction = parentViewController.onToCollapseAction
        detailsView.toFieldDataSource = parentViewController.receiversHandler.receiversDataSource
        detailsView.onOpenAttachment = parentViewController.onOpenAttachment
        detailsView.toFieldDelegate = parentViewController.receiversHandler.receiversDelegate
        detailsView.onRemovedAttachment = parentViewController.onRemovedAttachment
        detailsView.setupSubviews()
        parentViewController.view.addSubview(detailsView)
        parentViewController.mailDetailsView = detailsView
    }
    
    // MARK: - Text view creation
    
    private func addTextView() {
        guard let mailsBar = parentViewController.mailDetailsView?.frame,
            let actionFrame = parentViewController.actionsView?.frame else { return }
        
        let topIndent = 0.04 * screenWidth
        let originY = mailsBar.origin.y + mailsBar.height + topIndent
        let height = UIScreen.main.bounds.height - originY - actionFrame.height
        let textViewFrame = CGRect(x: 0.04 * screenWidth, y: originY, width: screenWidth - (0.04 * screenWidth + 0.02 * screenWidth), height: height)
        
        let textViewFont = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        
        let textView = ComposeTextView(frame: textViewFrame)
        textView.delegate = parentViewController
        textView.font = textViewFont
        textView.textColor = .black
        textView.autocorrectionType = .yes
        textView.layoutManager.delegate = self
        parentViewController.view.addSubview(textView)
        parentViewController.view.sendSubview(toBack: textView)
        parentViewController.textInputView = textView
    }
    
    // MARK: - Accessory action view creation
    
    private func addActionView() {
        let height = 0.157 * screenWidth
        
        let actionFrame = CGRect(x: 0, y: parentViewController.view.frame.height - height, width: screenWidth, height: height)
        let actionsView = AccessoryActionsView(frame: actionFrame)
        actionsView.setupSubviews(isFromCompose: true)
        actionsView.disableSendButton()
        actionsView.onSendAction = parentViewController.onSendAction
        actionsView.onAttachmentsAction = parentViewController.onAttachmentAction
        
        parentViewController.view.addSubview(actionsView)
        parentViewController.actionsView = actionsView
    }
}

extension ComposeUIInitializer: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
