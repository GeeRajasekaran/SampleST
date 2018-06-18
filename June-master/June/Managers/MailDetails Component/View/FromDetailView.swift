//
//  FromDetailView.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FromDetailView: UIView {
    
    // MARK: - Varibles & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private var fromLabel: UILabel?
    private var expandButton: UIButton?
    
    private var senderView: SenderView?
    
    var onExpandAction: (() -> Void)?
    
    // MARK: - Subview setup
    
    func setupSubviews() {
        // note that calling order of this methods should be saved
        // to keep layout of this view clear for all devices
        
        addFromLabel()
        addSenderView()
        addExpandButton()
        addComposeShadowView()
    }
    
    func changeExpandButton(to value: Bool) {
        var imageName = ""
        if value {
            imageName = LocalizedImageNameKey.ComposeHelper.Collapse
        } else {
            imageName = LocalizedImageNameKey.ComposeHelper.Expand
        }
        let image = UIImage(named: imageName)
        expandButton?.setImage(image, for: .normal)
    }
    
    func set(email sender: SenderEmail) {
        guard let view = senderView else { return }
        view.set(email: sender)
        view.frame.size.width = view.totalWidth()
    }
    
    // MARK: - From label setup
    
    private func addFromLabel() {
        guard fromLabel == nil else { return }
        let height = 0.048 * screenWidth
        let width = 0.096 * screenWidth
        
        let fromLabelFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        
        let fromFrame = CGRect(x: 0.048 * screenWidth, y: frame.height / 2 - height / 2, width: width, height: height)
        fromLabel = UILabel(frame: fromFrame)
        fromLabel?.font = fromLabelFont
        fromLabel?.textColor = UIColor.composeTitleGray.withAlphaComponent(0.65)
        fromLabel?.text = LocalizedStringKey.ComposeHelper.FromTitle
        
        if fromLabel != nil {
            addSubview(fromLabel!)
        }
    }
    
    // MARK: - Sender view
    
    private func addSenderView() {
        guard senderView == nil else { return }
        guard let fromFrame = fromLabel?.frame else { return }
        let height = 0.073 * screenWidth
        let originX = fromFrame.origin.x + fromFrame.size.width + 0.037 * screenWidth
        senderView = SenderView(frame: CGRect(x: originX, y: frame.height / 2 - height / 2, width: 0, height: height))
        senderView?.setupViews()
        if senderView != nil {
            addSubview(senderView!)
        }
    }
    
    // MARK: - Expand button setup
    
    private func addExpandButton() {
        guard expandButton == nil else { return }
        let width = 0.117 * screenWidth
        let expandImage = UIImage(named: LocalizedImageNameKey.ComposeHelper.Expand)
        
        let expandFrame = CGRect(x: screenWidth - width, y: 0, width: width, height: frame.height)
        expandButton = UIButton(frame: expandFrame)
        expandButton?.setImage(expandImage, for: .normal)
        expandButton?.addTarget(self, action: #selector(handleExpandButtonTap), for: .touchUpInside)
        // Please, note that it is temporary solution, cause we have only one email for each account.
        // After adding multiple accounts support, just remove next line of code and table view
        // with emails should appear after click on this button
        expandButton?.isHidden = true
        
        if expandButton != nil {
            addSubview(expandButton!)
        }
    }
    
    @objc private func handleExpandButtonTap() {
        onExpandAction?()
    }
    
}

class SenderView: UIView {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let inset = 0.024 * UIScreen.main.bounds.width
    private var envelopeImageView: UIImageView?
    private var senderLabel: UILabel?
    
    func setupViews() {
        addSenderLabel()
    }
    
    func set(email sender: SenderEmail) {
        setSenderText(sender.email)
        var imageName = LocalizedImageNameKey.ComposeHelper.SenderDefaultImage
        if sender.profilePictureURL != "" {
            imageName = sender.profilePictureURL
        }
        let image = UIImage(named: imageName)
        envelopeImageView?.image = image
    }
    
    func totalWidth() -> CGFloat {
        var total = 0.106 * screenWidth
        if let labelWidth = senderLabel?.frame.width {
            total += labelWidth
        }
        return total
    }
    
    // MARK: - Sender title label setup
    
    private func addSenderLabel() {
        guard senderLabel == nil else { return }
        let height = 0.048 * screenWidth
        let senderLabelFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        
        let senderLabelFrame = CGRect(x: 0, y: frame.height / 2 - height / 2, width: 0, height: height)
        senderLabel = UILabel(frame: senderLabelFrame)
        senderLabel?.font = senderLabelFont
        senderLabel?.textColor = UIColor.receiverTitleGrey
        if senderLabel != nil {
            addSubview(senderLabel!)
        }
    }
    
    //MARK: - culculate sender width
    private func setSenderText(_ text: String) {
        guard let label = senderLabel else { return }
        label.text = text
        let width = text.width(usingFont: label.font)
        label.frame.size.width = width
    }
}

