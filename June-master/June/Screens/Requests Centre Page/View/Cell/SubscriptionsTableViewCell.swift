//
//  SubscriptionTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SubscriptionsTableViewCell: UITableViewCell {

    // MARK: - Variables & Constants
    weak var requestItem: RequestItem?
    var onViewChanged: ((RequestItem, CGFloat) -> Void)?
    private let screenWidth = UIScreen.main.bounds.width
    private let collapseHeight = 0.296 * UIScreen.main.bounds.width
    
    var onApprovedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onDeniedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onUnblockedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    
    // MARK: - Views
    var subscriptionInfoView: SubscriptionsInfoView?
    var buttonsView: RequestsButtonsView?
    var messageView: SubscriptionsMessageView?
    
    var separatorView: UIView?
    
    // MARK: - Initialization
    
    func loadData(_ requestItem: RequestItem, completion: @escaping (RequestItem, CGFloat) -> Void) {
        self.requestItem = requestItem
        self.onViewChanged = completion
        guard let subscriptionInfo = requestItem.peopleInfo else { return }
        subscriptionInfoView?.loadData(info: subscriptionInfo)
        if let lastMessage = requestItem.lastMessage {
            messageView?.loadData(info: lastMessage)
            if requestItem.isCollapsed {
                expandContent()
            }
        }
    }
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptionInfoView?.removeFromSuperview()
        subscriptionInfoView = nil
        buttonsView?.removeFromSuperview()
        buttonsView = nil
        separatorView?.removeFromSuperview()
        separatorView = nil
        messageView?.removeFromSuperview()
        messageView = nil
    }
    
    // MARK: - UI Setup
    func setupUI(with view: RequestsButtonsView) {
        addSubscriptionInfoView()
        addButtonsView(with: view)
        addSeparatorView()
        addMessageView()
    }
    
    //MARK: - actions
    private lazy var onApproveTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onApprovedCell?(button, sSelf, item)
        }
    }
    
    private lazy var onDenyTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onDeniedCell?(button, sSelf, item)
        }
    }
    
    private lazy var onUnBlockedTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onUnblockedCell?(button, sSelf, item)
        }
    }
    
    lazy var onExpandAction: () -> Void = { [weak self] in
        //MARK: - calculate expand/collapse heights
        guard let sSelf = self else { return }
        guard let item = self?.requestItem else { return }
        if item.isCollapsed {
            sSelf.collapseContent()
            item.isCollapsed = false
            sSelf.onViewChanged?(item, sSelf.collapseHeight)
        } else {
            self?.expandContent()
            item.isCollapsed = true
            if let totalMessagesHeight = sSelf.messageView?.messagesHeight {
                self?.onViewChanged?(item, sSelf.collapseHeight + totalMessagesHeight)
            }
        }
    }
    
    lazy var onWebViewLoadedAction: (CGFloat) -> Void = { [weak self] height in
        guard let sSelf = self else { return }
        guard let item = sSelf.requestItem else { return }
        if item.isCollapsed {
            sSelf.messageView?.isHidden = false
            sSelf.subscriptionInfoView?.expandContent()
            sSelf.onViewChanged?(item, sSelf.collapseHeight + height)
        }
    }
    //MARK: - expand/collapse
    private func expandContent() {
        subscriptionInfoView?.expandContent()
        messageView?.expandContent()
        
    }
    
    private func collapseContent() {
        subscriptionInfoView?.collapseContent()
        messageView?.collapseContent()
    }
    
    //MARK: - private part
    private func addSubscriptionInfoView() {
        if subscriptionInfoView != nil { return }
        let originY = 0.04 * screenWidth
        let height = 0.12 * screenWidth
        subscriptionInfoView = SubscriptionsInfoView(frame: CGRect(x: 0, y: originY, width: screenWidth, height: height))
        subscriptionInfoView?.onViewTappedAction = onExpandAction
        subscriptionInfoView?.setupSubviews()
        if subscriptionInfoView != nil {
            addSubview(subscriptionInfoView!)
        }
    }
    
    private func addButtonsView(with view: RequestsButtonsView) {
        if buttonsView != nil { return }
        buttonsView = view
        buttonsView?.onApprovedTapped = onApproveTapped
        buttonsView?.onDeniedTapped = onDenyTapped
        buttonsView?.onUnblockedTapped = onUnBlockedTapped
        if buttonsView != nil {
            addSubview(buttonsView!)
            buttonsView?.snp.makeConstraints { make in
                make.height.equalTo(0.104 * screenWidth)
                make.bottom.equalToSuperview().offset(-0.032 * screenWidth)
                make.leading.equalToSuperview().offset(0.368 * screenWidth)
                make.trailing.equalToSuperview()
            }
        }
    }
    
    private func addSeparatorView() {
        if separatorView != nil { return }
        separatorView = UIView()
        separatorView?.backgroundColor = UIColor.separatorGrayColor
        if separatorView != nil {
            addSubview(separatorView!)
            separatorView?.snp.makeConstraints { make in
                make.height.equalTo(0.002 * screenWidth)
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func addMessageView() {
        if messageView != nil { return }
        messageView = SubscriptionsMessageView()
        messageView?.onWebViewLoadedAction = onWebViewLoadedAction
        messageView?.setupSubviews()
        messageView?.isHidden = true
        if messageView != nil {
            addSubview(messageView!)
            messageView?.snp.makeConstraints { make in
                guard let top = subscriptionInfoView else { return }
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
                make.top.equalTo(top.snp.bottom)
            }
        }
    }
}
