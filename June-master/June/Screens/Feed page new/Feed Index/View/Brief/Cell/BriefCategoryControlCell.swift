//
//  BriefCategoryControlCell.swift
//  June
//
//  Created by Ostap Holub on 2/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefCategoryControlCell: BaseBriefTableViewCell {
    
    // MARK: - Variables & Constants
    
    private var viewAllButton: UIButton?
    private var collapseButton: UIButton?
    
    var onCollapseBriefCategory: (() -> Void)?
    var onViewMoreAction: (() -> Void)?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewAllButton?.removeFromSuperview()
        viewAllButton = nil
        collapseButton?.removeFromSuperview()
        collapseButton = nil
    }
    
    // MARK: - Primary view setup
    
    func load(model: BaseTableModel?) {
        guard let info = model as? BriefCategoryControlInfo else { return }
        viewAllButton?.isHidden = !info.isViewMoreVisible
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addCollapseButton()
        addViewAllButton()
        addSeparatorView()
    }
    
    override func addContainerView() {
        super.addContainerView()
        containerView?.addSideBorders(color: UIColor.briefCellBorderColor)
    }
    
    // MARK: - Collapse button setup
    
    private func addCollapseButton() {
        guard collapseButton == nil else { return }
        guard let containerFrame = containerView?.frame else { return }
        
        let rightInset: CGFloat = 0.056 * screenWidth
        let width: CGFloat = 0.28 * screenWidth
        let height: CGFloat = 0.077 * screenWidth
        let rect = CGRect(x: containerFrame.width - rightInset - width, y: containerFrame.height / 2 - height / 2, width: width, height: height)
        collapseButton = UIButton(frame: rect)
        collapseButton?.setTitle(LocalizedStringKey.FeedBriefHelper.CollapseTitle, for: .normal)
        collapseButton?.titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .regular)
        collapseButton?.setTitleColor(UIColor.briefCollapseTitleColor, for: .normal)
        collapseButton?.addTarget(self, action: #selector(handleCollapseButtonClick), for: .touchUpInside)
        
        let image = UIImage(named: LocalizedImageNameKey.FeedBriefHelper.CollapseArrowIcon)
        collapseButton?.setImage(image, for: .normal)
        collapseButton?.makeRightSideImageButton()
        collapseButton?.imageEdgeInsets = UIEdgeInsets(top: 0.008 * screenWidth, left: -(0.04 * screenWidth), bottom: 0, right: 0)
        
        collapseButton?.layer.cornerRadius = height / 2
        collapseButton?.layer.borderWidth = 1
        collapseButton?.layer.borderColor = UIColor.briefCollapseBorderColor.cgColor

        if collapseButton != nil {
            containerView?.addSubview(collapseButton!)
        }
    }
    
    @objc private func handleCollapseButtonClick() {
//        onCollapseBriefCategory?()
    }
    
    // MARK: - View all button setup
    
    private func addViewAllButton() {
        guard viewAllButton == nil else { return }
        guard let containerFrame = containerView?.frame else { return }
        
        let leftInset: CGFloat = 0.056 * screenWidth
        let width: CGFloat = 0.28 * screenWidth
        let height: CGFloat = 0.077 * screenWidth
        let rect = CGRect(x: leftInset, y: containerFrame.height / 2 - height / 2, width: width, height: height)
        viewAllButton = UIButton(frame: rect)
        viewAllButton?.backgroundColor = .white
        viewAllButton?.setTitle(LocalizedStringKey.FeedBriefHelper.ViewAllTitle, for: .normal)
        viewAllButton?.titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .regular)
        viewAllButton?.setTitleColor(UIColor.briefViewAllTitleColor, for: .normal)
        viewAllButton?.addTarget(self, action: #selector(handleViewAllButtonClick), for: .touchUpInside)
        
        viewAllButton?.imageEdgeInsets = UIEdgeInsets(top: 0.008 * screenWidth, left: -(0.04 * screenWidth), bottom: 0, right: 0)
        viewAllButton?.layer.cornerRadius = height / 2
        
        // add shadow here
        viewAllButton?.layer.masksToBounds = false
        viewAllButton?.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        viewAllButton?.layer.shadowOpacity = 1
        viewAllButton?.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewAllButton?.layer.shadowRadius = 4

        if viewAllButton != nil {
            containerView?.addSubview(viewAllButton!)
        }
    }
    
    @objc private func handleViewAllButtonClick() {
//        onViewMoreAction?()
    }
}
