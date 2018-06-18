//
//  PeopleTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class PeopleTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    weak var requestItem: RequestItem?
    var onViewChanged: ((RequestItem, CGFloat) -> Void)?
    var onHeightChanged: ((RequestItem, CGFloat) -> Void)?
    
    var onReplyCell: ((RequestItem, RightImageButton) -> Void)?
    
    var onDiscardDraftAction: ((RequestItem, DraftInfo) -> Void)?
    var onEditDraftAction: ((RequestItem, DraftInfo) -> Void)?
    
    var onApprovedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onIgnoredCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onBlockedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onUnblockedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    
    var onOpenAttachment: ((Attachment) -> Void)?
    
    private let screenWidth = UIScreen.main.bounds.width
    private let collapseHeight = 0.376 * UIScreen.main.bounds.width
    private let contentWidth = 0.816 * UIScreen.main.bounds.width
    
    // MARK: - Views
    var peopleInfoView: PeopleInfoView?
    var buttonsView: RequestsButtonsView?
    var messagesView: PeopleMessagesView?
    var separatorView: UIView?
    
    // MARK: - Initialization
    func loadData(_ requestItem: RequestItem, completion: @escaping (RequestItem, CGFloat) -> Void) {
        self.requestItem = requestItem
        self.onViewChanged = completion
        guard let peopleInfo = requestItem.peopleInfo else { return }
        peopleInfoView?.loadData(info: peopleInfo)
        if let messages = requestItem.lastMessages {
             messagesView?.loadData(messages: messages)
        }
    }
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        peopleInfoView?.removeFromSuperview()
        peopleInfoView = nil
        buttonsView?.removeFromSuperview()
        buttonsView = nil
        separatorView?.removeFromSuperview()
        separatorView = nil
        messagesView?.removeFromSuperview()
        messagesView = nil
    }
    
    //MARK: - actions
    private lazy var onReply: (RightImageButton, MessageInfo) -> Void = { [weak self] button, info in
        guard let item = self?.requestItem else { return }
        self?.onReplyCell?(item, button)
    }
    
    private lazy var onApprovedTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onApprovedCell?(button, sSelf, item)
        }
    }
    
    lazy var onIgnoredTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onIgnoredCell?(button, sSelf, item)
        }
    }
    
    lazy var onBlockedTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onBlockedCell?(button, sSelf, item)
        }
    }
    
    lazy var onUnBlockedTapped: (UISelectableButton) -> Void = { [weak self] button in
        if let sSelf = self {
            guard let item = sSelf.requestItem else { return }
            sSelf.onUnblockedCell?(button, sSelf, item)
        }
    }
    
    //MARK: - draft actions
    private lazy var onDiscardDraft: (DraftView, DraftInfo) -> Void = { [weak self] view, info in
        guard let item = self?.requestItem else { return }
        self?.onDiscardDraftAction?(item, info)
    }
    
    private lazy var onEditDraft: (DraftView, DraftInfo) -> Void = { [weak self] view, info in
        guard let item = self?.requestItem else { return }
        self?.onEditDraftAction?(item, info)
    }
    
    //MARK: - height calculation
    lazy var onExpandAction: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        guard let item = sSelf.requestItem else { return }
        if item.isCollapsed {
            item.isCollapsed = false
            sSelf.collapseContent()
            sSelf.onViewChanged?(item, sSelf.collapseHeight)
        } else {
            item.isCollapsed = true
            sSelf.expandContent()
            if let totalMessagesHeight = sSelf.messagesView?.messagesHeight {
                sSelf.onViewChanged?(item, sSelf.collapseHeight + totalMessagesHeight)
            }
        }
    }
    
    lazy var onMessagesViewHeightChanged: (CGFloat) -> Void = { [weak self] height in
        guard let sSelf = self else { return }
        guard let item = sSelf.requestItem else { return }
        if item.isCollapsed {
            sSelf.expandContent()
            sSelf.onHeightChanged?(item, sSelf.collapseHeight + height)
        }
    }
    
    private func collapseContent() {
        messagesView?.collapse()
        peopleInfoView?.collapseContent()
    }
    
    private func expandContent() {
        messagesView?.expand()
        peopleInfoView?.expandContent()
    }

    // MARK: - UI Setup
    func setupUI(with view: RequestsButtonsView) {
        addPeopleInfoView()
        addButtonsView(with: view)
        addSeparatorView()
        addMessagesView()
    }
    
    //MARK: - private part
    private func addPeopleInfoView() {
        if peopleInfoView != nil { return }
        let originY = 0.04 * screenWidth
        let height = 0.168 * screenWidth
        peopleInfoView = PeopleInfoView(frame: CGRect(x: 0, y: originY, width: screenWidth, height: height))
        peopleInfoView?.onViewTappedAction = onExpandAction
        peopleInfoView?.setupSubviews()
        if peopleInfoView != nil {
            addSubview(peopleInfoView!)
        }
    }
    
    private func addButtonsView(with view: RequestsButtonsView) {
        if buttonsView != nil { return }
        buttonsView = view
        buttonsView?.onApprovedTapped = onApprovedTapped
        buttonsView?.onIgnoredTapped = onIgnoredTapped
        buttonsView?.onBlockedTapped = onBlockedTapped
        buttonsView?.onUnblockedTapped = onUnBlockedTapped
        
        if buttonsView != nil {
            addSubview(buttonsView!)
            buttonsView?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(0.2 * screenWidth)
                make.width.equalTo(contentWidth)
                make.bottom.equalToSuperview().offset(-0.032 * screenWidth)
                make.height.equalTo(0.104 * screenWidth)
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
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    private func addMessagesView() {
        if messagesView != nil { return }
        messagesView = PeopleMessagesView()
        messagesView?.onReply = onReply
        messagesView?.onDiscardDraftAction = onDiscardDraft
        messagesView?.onEditDraftAction = onEditDraft
        messagesView?.onHeightChange = onMessagesViewHeightChanged
        messagesView?.onOpenAttachment = onOpenAttachment
        messagesView?.setupSubviews()
        messagesView?.collapse()
        if messagesView != nil {
            addSubview(messagesView!)
            messagesView?.snp.makeConstraints { make in
                guard let top = peopleInfoView else { return }
                make.leading.equalToSuperview().offset(0.181 * screenWidth)
                make.width.equalTo(contentWidth)
                make.top.equalTo(top.snp.bottom)
            }
        }
    }
}
