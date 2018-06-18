//
//  OneMessageView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/15/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class PeopleMessagesView: UIView {
    
    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let actionButtosHeight = 0.168 * UIScreen.main.bounds.width
    private let draftViewHeight = 0.12 * UIScreen.main.bounds.width
    private let separatorHeight = 0.0032 * UIScreen.main.bounds.width
    private let subjectFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)

    private var messages: [MessageInfo]?
    
    var messagesHeight: CGFloat {
        get {
            return totalHeight()
        }
    }
    
    //MARK: - subviews
    
    private var stackView: UIStackView?
    private var actionButtons: ActionButtonsView?
    private var topSeparatorView: UIView?
    private var bottomSeparatorView: UIView?
    private var draftView: DraftView?
    
    var onReply: ((RightImageButton, MessageInfo) -> Void)?
    var onHeightChange: ((CGFloat) -> Void)?
    var onDiscardDraftAction: ((DraftView, DraftInfo) -> Void)?
    var onEditDraftAction: ((DraftView, DraftInfo) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    
    private var loadedViewsCount = 0
    
    private lazy var onMessageViewLoaded: (MessageInfo, CGFloat) -> Void = { [weak self] message, messagesHeight in
        guard let sSelf = self else { return }
        guard let messages = sSelf.messages else { return }
        sSelf.loadedViewsCount += 1
        if sSelf.loadedViewsCount == messages.count {
            sSelf.onHeightChange?(sSelf.totalHeight())
            sSelf.loadedViewsCount = 0
        }
    }

    // MARK: - Layout setup logic
    func setupSubviews() {
        addTopSeperatorView()
        addActionButtonsView()
        addStackView()
        //TODO: - uncomment when draft will be
        //addDraftView()
        addBottomSeperatorView()
    }
    
    //MARK: - collapse and expand content
    func collapse() {
        isHidden = true
    }
    
    func expand() {
        isHidden = false
        //TODO: - uncomment when action buttons will have
        //hideActionButtonsIfNeeded()
        showDraftIfNeeded()
    }

    //MARK: - Data loading
    func loadData(messages: [MessageInfo]) {
        self.messages = messages
        messages.forEach { (message) in
            loadMessage(message)
        }
    }
    
    private func loadMessage(_ message: MessageInfo) {
        if let isCurrenUserAnswer = message.isCurrentUserMessage {
            var view: IMessageView? = nil
            if isCurrenUserAnswer {
                view = ReplyView()
            } else {
                view = ExpandMessageView()
            }
            view?.messageLoaded = onMessageViewLoaded
            view?.onOpenAttachment = onOpenAttachment
            view?.setupSubviews()
            view?.loadData(info: message)
            if view != nil {
                if let messageView = view! as? UIView {
                    stackView?.addArrangedSubview(messageView)
                }
            }
        }
    }
    
    private func hideActionButtonsIfNeeded() {
        guard let lastMessage = messages?.last else { return }
        if let isCurrenUserAnswer = lastMessage.isCurrentUserMessage, let isDraftExist = lastMessage.isDraftExist {
            if isCurrenUserAnswer || isDraftExist {
                actionButtons?.isHidden = true
            } else {
                actionButtons?.isHidden = false
            }
        }
    }
    
    private func showDraftIfNeeded() {
        if let draftInfo = messages?.last?.draftInfo {
            draftView?.loadData(draft: draftInfo)
            draftView?.isHidden = false
            draftView?.snp.updateConstraints { make in
                make.height.equalTo(draftViewHeight)
            }
        } else {
            draftView?.isHidden = true
        }
    }
    
    //MARK: - Private part
    private func addStackView() {
        if stackView != nil { return }
        stackView = UIStackView()
        stackView?.axis = .vertical
        stackView?.distribution = .fill
        stackView?.alignment = .fill
        if stackView != nil {
            addSubview(stackView!)
            stackView?.snp.makeConstraints { make in
                guard let top = topSeparatorView else { return }
                make.top.equalTo(top.snp.bottom)
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            }
        }
    }
    
    private func addActionButtonsView() {
        if actionButtons != nil { return }
        actionButtons = ActionButtonsView()
        actionButtons?.delegate = self
        actionButtons?.isHidden = true
        if actionButtons != nil {
            addSubview(actionButtons!)
            actionButtons?.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview().offset(0.04 * screenWidth)
                make.height.equalTo(actionButtosHeight)
                make.bottom.equalToSuperview().offset(-separatorHeight)
            }
        }
    }
    
    private func addDraftView() {
        if draftView != nil { return }
        draftView = DraftView()
        draftView?.onViewTapped = onEditDraftAction
        draftView?.onDiscardButtonTapped = onDiscardDraftAction
        draftView?.setupSubviews()
        draftView?.isHidden = true
        if draftView != nil {
            addSubview(draftView!)
            draftView?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(0.02 * screenWidth)
                make.trailing.equalToSuperview().offset(-0.04 * screenWidth)
                make.bottom.equalToSuperview().offset(-0.032 * screenWidth)
                make.height.equalTo(0)
            }
        }
    }
    
    private func addTopSeperatorView() {
        if topSeparatorView != nil { return }
        topSeparatorView = UIView()
        topSeparatorView?.backgroundColor = UIColor.separatorGrayColor
        if topSeparatorView != nil {
            addSubview(topSeparatorView!)
            topSeparatorView?.snp.makeConstraints { make in
                make.height.equalTo(separatorHeight)
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            }
        }
    }
    
    private func addBottomSeperatorView() {
        if bottomSeparatorView != nil { return }
        bottomSeparatorView = UIView()
        bottomSeparatorView?.backgroundColor = UIColor.separatorGrayColor
        if bottomSeparatorView != nil {
            addSubview(bottomSeparatorView!)
            bottomSeparatorView?.snp.makeConstraints { make in
                guard let top = stackView else { return }
                make.height.equalTo(separatorHeight)
                make.top.equalTo(top.snp.bottom)
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            }
        }
    }
    
    //MARK: - total height calculation
    private func totalHeight() -> CGFloat {
        var total: CGFloat = 0
        guard let view = stackView else { return total }
        view.arrangedSubviews.forEach { (view) in
            if let messageView = view as? IMessageView {
                total += messageView.iMessageViewHeight
            }
        }
        var bottomViewHeigth: CGFloat = 0
        if actionButtons?.isHidden == false || draftView?.isHidden == false {
            bottomViewHeigth = actionButtosHeight
        }
        return total + bottomViewHeigth + 2 * separatorHeight
    }
}

extension PeopleMessagesView: ActionButtonsDelegate {
    func didTapOnReplyButton(_ button: RightImageButton) {
        if let firstMessage = messages?.first {
            onReply?(button, firstMessage)
        }
    }
}
