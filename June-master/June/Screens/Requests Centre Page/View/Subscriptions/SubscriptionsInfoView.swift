//
//  SubscriptionInfoView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SubscriptionsInfoView: UIView {
    // MARK: - Variables & constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let nameFont = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
    private let emailFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private let leftOffset = UIScreen.main.bounds.width * 0.035
    
    private weak var info: PeopleInfo?
    
    var onViewTappedAction: (() -> Void)?
    
    // MARK: - Subviews
    private var profilePictureImageView: UIImageView?
    private var nameLabel: UILabel?
    private var emailLabel: UILabel?
    private var expandButton: UIButton?
    
    // MARK: - Layout setup logic
    func setupSubviews() {
        addContactImageView()
        addNameLabel()
        addEmailLabel()
        addExpandButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func loadData(info: PeopleInfo) {
        self.info = info
        if let url = info.pictureURL {
            profilePictureImageView?.hnk_setImageFromURL(url)
        }
        nameLabel?.text = info.name
        emailLabel?.text = info.email
    }
    
    func expandContent() {
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.Expand), for: .normal)
    }
    
    func collapseContent() {
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.ArrowRight), for: .normal)
    }
    
    //MARK: - Private part
    private func addContactImageView() {
        if profilePictureImageView != nil { return }
        let imageViewWidth = 0.112 * screenWidth
        let imageViewHeight = imageViewWidth
        let originX = 0.053 * screenWidth
        let imageViewFrame = CGRect(x: originX, y: 0, width: imageViewWidth, height: imageViewHeight)
        profilePictureImageView = UIImageView(frame: imageViewFrame)
        
        profilePictureImageView?.contentMode = .scaleAspectFill
        profilePictureImageView?.clipsToBounds = true
        profilePictureImageView?.layer.cornerRadius = imageViewHeight/2
        if profilePictureImageView != nil {
            addSubview(profilePictureImageView!)
        }
    }
    
    private func addNameLabel() {
        if nameLabel != nil { return }
        let nameLabelFrame = CGRect(x: 0.2 * screenWidth, y: 0, width: 0.733 * screenWidth, height: 0.058 * screenWidth)
        nameLabel = UILabel(frame: nameLabelFrame)
        nameLabel?.font = nameFont
        nameLabel?.textColor = UIColor.requestsNameColor
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
    
    private func addEmailLabel() {
        if emailLabel != nil { return }
        let emailFrame = CGRect(x: 0.2 * screenWidth, y: 0.053 * screenWidth, width: 0.733 * screenWidth, height: 0.045 * screenWidth)
        emailLabel = UILabel(frame: emailFrame)
        emailLabel?.font = emailFont
        emailLabel?.textColor = UIColor.requestsEmailColor
        if emailLabel != nil {
            addSubview(emailLabel!)
        }
    }
    
    private func addExpandButton() {
        if expandButton != nil { return }
        let originY = 0.016 * screenWidth
        let originX = 0.954 * screenWidth
        let height = 0.032 * screenWidth
        let width = height
        let expandButtonFrame = CGRect(x: originX, y: originY, width: width, height: height)
        expandButton = UIButton(frame: expandButtonFrame)
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.ArrowRight), for: .normal)
        if expandButton != nil {
            addSubview(expandButton!)
        }
    }
    
    //MARK: - actions
    @objc func onViewTapped() {
        onViewTappedAction?()
    }
}
