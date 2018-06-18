//
//  BriefRequestsCell.swift
//  June
//
//  Created by Ostap Holub on 1/26/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefRequestsCell: BaseBriefTableViewCell {
    
    // MARK: - Variables & Constants
    
    private var profileIcon: UIImageView?
    private var viewButton: UIButton?
    private var messageLabel: UILabel?
    
    var onRequestItemClicked: (() -> Void)?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileIcon?.removeFromSuperview()
        profileIcon = nil
        viewButton?.removeFromSuperview()
        viewButton = nil
        messageLabel?.removeFromSuperview()
        messageLabel = nil
    }
    
    // MARK: - Primary view setup
    
    func load(model: BaseTableModel?) {
        guard let info = model as? BriefReqeustsInfo else { return }
        messageLabel?.attributedText = info.message
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addProfileIcon()
        addViewButton()
        addMessageLabel()
    }
    
    override func addContainerView() {
        super.addContainerView()
        containerView?.roundCorners([.bottomLeft, .bottomRight], radius: LayoutConstant.cornerRadius)
        containerView?.toplessBorder(radius: LayoutConstant.cornerRadius, color: UIColor.briefCellBorderColor)
    }
    
    // MARK: - Profile icon view setup
    
    private func addProfileIcon() {
        guard profileIcon == nil else { return }
        guard let containerFrame = containerView?.frame else { return }
        
        let dimension: CGFloat = 0.058 * screenWidth
        let rect = CGRect(x: 0.058 * screenWidth, y: containerFrame.height / 2 - dimension / 2, width: dimension, height: dimension)
        profileIcon = UIImageView(frame: rect)
        profileIcon?.contentMode = .scaleAspectFit
        profileIcon?.image = UIImage(named: LocalizedImageNameKey.FeedBriefHelper.RequestsProfileIcon)
        
        if profileIcon != nil {
            containerView?.addSubview(profileIcon!)
        }
    }
    
    // MARK: - View button setup
    
    private func addViewButton() {
        guard viewButton == nil else { return }
        guard let containerFrame = containerView?.frame else { return }
        
        let rightInset: CGFloat = 0.045 * screenWidth
        let height: CGFloat = 0.053 * screenWidth
        let width: CGFloat = 0.112 * screenWidth
        let rect = CGRect(x: containerFrame.width - rightInset - width, y: containerFrame.height / 2 - height / 2, width: width, height: height)
        
        viewButton = UIButton(frame: rect)
        viewButton?.setTitle(LocalizedStringKey.FeedBriefHelper.ViewButtonTitle, for: .normal)
        viewButton?.titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .smallMedium)
        viewButton?.setTitleColor(.black, for: .normal)
        viewButton?.addTarget(self, action: #selector(handleViewButtonTap), for: .touchUpInside)
        
        viewButton?.layer.cornerRadius = height / 2
        viewButton?.layer.borderColor = UIColor.black.withAlphaComponent(0.17).cgColor
        viewButton?.layer.borderWidth = 1

        if viewButton != nil {
            containerView?.addSubview(viewButton!)
        }
    }
    
    @objc private func handleViewButtonTap() {
//        onRequestItemClicked?()
    }
    
    // MARK: - Message label setup
    
    private func addMessageLabel() {
        guard messageLabel == nil else { return }
        guard let viewButtonFrame = viewButton?.frame,
            let iconFrame = profileIcon?.frame,
            let containerFrame = containerView?.frame else { return }
        
        let leftInset: CGFloat = 0.037 * screenWidth
        let rightInset: CGFloat = 0.042 * screenWidth
        let originX: CGFloat = iconFrame.origin.x + iconFrame.width + leftInset
        let width: CGFloat = (viewButtonFrame.origin.x - rightInset) - originX
        let height: CGFloat = 0.11 * screenWidth
        
        let rect = CGRect(x: originX, y: containerFrame.height / 2 - height / 2, width: width, height: height)
        messageLabel = UILabel(frame: rect)
        messageLabel?.textAlignment = .left
        messageLabel?.numberOfLines = 0
        
        if messageLabel != nil {
            containerView?.addSubview(messageLabel!)
        }
    }
}
