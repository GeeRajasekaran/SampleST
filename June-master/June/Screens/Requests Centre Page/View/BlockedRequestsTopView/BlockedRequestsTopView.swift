//
//  BlockedRequestsTopView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class BlockedRequestsTopView: UIView {

    private let screenWidth = UIScreen.main.bounds.width
    
    //MARK: - views
    private var peopleView: BlockedRequestsTopButton?
    private var subscriptionView: BlockedRequestsTopButton?
    private var backButton: UIButton?
    private var lineView: UIView?
    private var bottomLineView: UIView?
    
    //MARK: - properties
    var onPeopleButtonClicked: (() -> Void)?
    var onSubscriptionButtonClicked: (() -> Void)?
    var onBackButtonClicked: (() -> Void)?
    
    func setupSubviews() {
        backgroundColor = .white
        addVerticalLine()
        addBackButton()
        addPeopleView()
        addSubscriptionView()
        addBottomLineView()
    }
    
    //MARK: - private part
    private func addVerticalLine() {
        if lineView != nil { return }
        let lineViewFrame = CGRect(x: 0.104 * screenWidth, y: 0, width: 1, height: frame.height)
        lineView = UIView(frame: lineViewFrame)
        lineView?.backgroundColor = UIColor.lineGray.withAlphaComponent(0.41)
        if lineView != nil {
            addSubview(lineView!)
        }
    }
    
    private func addBackButton() {
        if backButton != nil { return }
        let buttonHeight = frame.height
        let buttonWidth = 0.104 * screenWidth
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        backButton = UIButton(frame: buttonFrame)
        backButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BackIconName), for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton?.addGestureRecognizer(tapGesture)
        if backButton != nil {
            addSubview(backButton!)
        }
    }
    
    private func addPeopleView() {
        if peopleView != nil { return }
        let peopleFrame = CGRect(x: 0.208 * screenWidth, y: 0, width: 0.232 * screenWidth, height: frame.height)
        peopleView = BlockedRequestsTopButton(frame: peopleFrame, title: LocalizedStringKey.RequestsViewHelper.PeopleSectionTitle)
        peopleView?.addTarget(self, action: #selector(peopleButtonTapped), for: .touchUpInside)
        if peopleView != nil {
            addSubview(peopleView!)
        }
    }
    
    private func addSubscriptionView() {
        if subscriptionView != nil { return }
        let subscriptionFrame = CGRect(x: 0.512 * screenWidth, y: 0, width: 0.32 * screenWidth, height: frame.height)
        subscriptionView = BlockedRequestsTopButton(frame: subscriptionFrame, title: LocalizedStringKey.RequestsViewHelper.SubscriptionsSectionTitle)
        subscriptionView?.addTarget(self, action: #selector(subscriptionButtonTapped(sender:)), for: .touchUpInside)
        subscriptionView?.isTapped = false
        if subscriptionView != nil {
            addSubview(subscriptionView!)
        }
    }
    
    private func addBottomLineView() {
        if bottomLineView != nil { return }
        let lineHeight: CGFloat = 1
        bottomLineView = UIView(frame: CGRect(x: 0, y: frame.height - lineHeight, width: frame.width, height: lineHeight))
        bottomLineView?.backgroundColor = UIColor.lineGray.withAlphaComponent(0.41)
        if bottomLineView != nil {
            addSubview(bottomLineView!)
        }
    }

    //MARK: - actions
    @objc private func peopleButtonTapped(sender: BlockedRequestsTopButton) {
        sender.isTapped = true
        subscriptionView?.isTapped = false
        onPeopleButtonClicked?()
    }
    
    @objc internal func subscriptionButtonTapped(sender: BlockedRequestsTopButton) {
        sender.isTapped = true
        peopleView?.isTapped = false
        onSubscriptionButtonClicked?()
    }
    
    @objc func backButtonClicked() {
        onBackButtonClicked?()
    }
}
