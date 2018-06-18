//
//  RequestsTopView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsTopView: UIView {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let buttonFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    private let provider = ContactsDataProvider()
    private let contactsProxy = ContactsProxy()
    
    //MARK: - views
    private var peopleView: RequestsTopButton?
    private var subscriptionView: RequestsTopButton?
    private var blockedButton: UIButton?
    private var lineView: UIView?
    
    //MARK: - properties
    var onPeopleButtonClicked: (() -> Void)?
    var onSubscriptionButtonClicked: (() -> Void)?
    var onBlockedButtonClicked: (() -> Void)?
    
    func setupSubviews() {
        addPeopleView()
        addSubscriptionView()
        addBlockedButton()
        addLineView()
        requestTotalCategories()
    }
    
    func updatePeopleCount(count: Int) {
        peopleView?.update(with: count, shouldAdd: true)
    }
    
    func updateSubscriptionCount(count: Int) {
        subscriptionView?.update(with: count, shouldAdd: true)
    }
    
    //MARK: - private
    private func addPeopleView() {
        if peopleView != nil { return }
        let peopleFrame = CGRect(x: 0.09 * screenWidth, y: 0, width: 0.17 * screenWidth, height: frame.height)
        peopleView = RequestsTopButton(frame: peopleFrame, title: LocalizedStringKey.RequestsViewHelper.PeopleSectionTitle)
        peopleView?.addTarget(self, action: #selector(peopleButtonTapped), for: .touchUpInside)
        if peopleView != nil {
            addSubview(peopleView!)
        }
    }
    
    private func addSubscriptionView() {
        if subscriptionView != nil { return }
        let subscriptionFrame = CGRect(x: 0.387 * screenWidth, y: 0, width: 0.17 * screenWidth, height: frame.height)
        subscriptionView = RequestsTopButton(frame: subscriptionFrame, title: LocalizedStringKey.RequestsViewHelper.SubscriptionsSectionTitle)
        subscriptionView?.center.x = screenWidth/2
        subscriptionView?.addTarget(self, action: #selector(subscriptionButtonTapped(sender:)), for: .touchUpInside)
        subscriptionView?.isTapped = false
        if subscriptionView != nil {
            addSubview(subscriptionView!)
        }
    }
    
    private func addBlockedButton() {
        if blockedButton != nil { return }
        let buttonHeight = 0.043 * screenWidth
        let buttonWidth = 0.2 * screenWidth
        let originX = screenWidth - buttonWidth - UIView.narrowMargin
        let buttonFrame = CGRect(x: originX, y: frame.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight)
        blockedButton = UIButton(frame: buttonFrame)
        blockedButton?.setTitle(LocalizedStringKey.RequestsViewHelper.BlockedTitile, for: .normal)
        blockedButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BlockIconName), for: .normal)
        blockedButton?.imageView?.contentMode = .scaleAspectFit
        blockedButton?.titleLabel?.font = buttonFont
        blockedButton?.semanticContentAttribute = .forceRightToLeft
        blockedButton?.setTitleColor(UIColor.requestsUnSelectedTitleColor, for: .normal)
        blockedButton?.addTarget(self, action: #selector(blockedButtonTapped(sender:)), for: .touchUpInside)
        if blockedButton != nil {
            addSubview(blockedButton!)
        }
    }
    
    private func addLineView() {
        if lineView != nil { return }
        let lineHeight: CGFloat = 1
        lineView = UIView(frame: CGRect(x: 0, y: frame.height - lineHeight, width: frame.width, height: lineHeight))
        lineView?.backgroundColor = UIColor.lineGray.withAlphaComponent(0.41)
        if lineView != nil {
            addSubview(lineView!)
        }
    }
    
    // MARK: - Outside button actions
    
    func selectPeopleButton() {
        peopleView?.isTapped = true
        subscriptionView?.isTapped = false
        peopleView?.updateView(with: contactsProxy.fetchPeopleCount())
    }
    
    func selectSubscriptionsButton() {
        subscriptionView?.isTapped = true
        peopleView?.isTapped = false
        subscriptionView?.updateView(with: contactsProxy.fetchSubscriptionsCount())
    }
    
    //MARK: - actions
    @objc private func peopleButtonTapped(sender: RequestsTopButton) {
        sender.isTapped = true
        subscriptionView?.isTapped = false
        peopleView?.updateView(with: contactsProxy.fetchPeopleCount())
        onPeopleButtonClicked?()
    }
    
    @objc internal func subscriptionButtonTapped(sender: RequestsTopButton) {
        sender.isTapped = true
        peopleView?.isTapped = false
        subscriptionView?.updateView(with: contactsProxy.fetchSubscriptionsCount())
        onSubscriptionButtonClicked?()
    }
    
    @objc private func blockedButtonTapped(sender: RequestsTopButton) {
        onBlockedButtonClicked?()
    }
    
    //MARK: - load count
    func requestTotalCategories() {
        subscriptionView?.updateView(with: contactsProxy.fetchSubscriptionsCount())
        peopleView?.updateView(with: contactsProxy.fetchPeopleCount())
    }
    
    private func requestPeopleTotalCount() {
        provider.requestTotalPendingPeople(completion: { [weak self] result in
            switch result {
            case .Success(let count):
                self?.peopleView?.updateView(with: count)
            case .Error( _):
                break
            }
        })
    }
    
    private func requestSubscriptionsTotalCount() {
        provider.requestTotalPendingSubscriptions(completion: { [weak self] result in
            switch result {
            case .Success(let count):
                self?.subscriptionView?.updateView(with: count)
            case .Error( _):
                break
            }
        })
    }
}
