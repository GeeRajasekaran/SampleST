//
//  BriefCategoryCell.swift
//  June
//
//  Created by Ostap Holub on 1/26/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Haneke

class BriefCategoryCell: BaseBriefTableViewCell {

    // MARK: - Variables & Constants
    
    private var categoryIconImageView: UIImageView?
    private var categoryTitleLabel: UILabel?
    private var totalLabel: UILabel?
    private var moreButton: UIButton?
    
    private let maxImageViewsCount: Int = 4
    private var vendorImageViews: [UIImageView] = [UIImageView]()
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryIconImageView?.removeFromSuperview()
        categoryIconImageView = nil
        categoryTitleLabel?.removeFromSuperview()
        categoryTitleLabel = nil
        totalLabel?.removeFromSuperview()
        totalLabel = nil
        moreButton?.removeFromSuperview()
        moreButton = nil
        vendorImageViews.forEach { view in
            view.removeFromSuperview()
        }
        vendorImageViews.removeAll()
    }
    
    func load(model: BaseTableModel?) {
        guard let info = model as? BriefCategoryInfo else { return }
        categoryTitleLabel?.text = info.title
        totalLabel?.text = "\(info.newItemsCount) new"
        if let url = info.categoryIconUrl {
            categoryIconImageView?.hnk_setImageFromURL(url)
        }
        
        for index in 0..<vendorImageViews.count {
            if 0..<info.vendorImageURL.count ~= index {
                let url = info.vendorImageURL[index]
                vendorImageViews[index].hnk_setImageFromURL(url)
            }
        }
        
        let moreButtonTitle = "+\(info.newItemsCount - info.vendorImageURL.count)"
        moreButton?.setTitle(moreButtonTitle, for: .normal)
    }
    
    // MARK: - Primary view setup
    
    override func setupSubviews() {
        super.setupSubviews()
        addCategoryIconView()
        addCategoryTitleLabel()
        addTotalCountLabel()
        addVendorImageViews()
    }
    
    override func addContainerView() {
        super.addContainerView()
        containerView?.addSideBorders(color: UIColor.briefCellBorderColor)
        addSeparatorView()
    }
    
    // MARK: - Category icon setup
    
    private func addCategoryIconView() {
        guard categoryIconImageView == nil else { return }
        
        let dimension: CGFloat = 0.109 * screenWidth
        let rect = CGRect(x: 0.05 * screenWidth, y: 0.032 * screenWidth, width: dimension, height: dimension)
        
        categoryIconImageView = UIImageView(frame: rect)
        categoryIconImageView?.contentMode = .scaleAspectFit
        categoryIconImageView?.clipsToBounds = true
        categoryIconImageView?.layer.cornerRadius = dimension / 2
        
        if categoryIconImageView != nil {
            containerView?.addSubview(categoryIconImageView!)
        }
    }
    
    // MARK: - Category title label setup
    
    private func addCategoryTitleLabel() {
        guard categoryTitleLabel == nil else { return }
        guard let imageFrame = categoryIconImageView?.frame else { return }
        
        let rect = CGRect(x: imageFrame.origin.x + imageFrame.width + 0.021 * screenWidth, y: 0.034 * screenWidth, width: 0.330 * screenWidth, height: 0.058 * screenWidth)
        
        categoryTitleLabel = UILabel(frame: rect)
        categoryTitleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .large)
        categoryTitleLabel?.textColor = .black
        categoryTitleLabel?.textAlignment = .left
        
        if categoryTitleLabel != nil {
            containerView?.addSubview(categoryTitleLabel!)
        }
    }
    
    // MARK: - Total label setup
    
    private func addTotalCountLabel() {
        guard totalLabel == nil else { return }
        guard let titleFrame = categoryTitleLabel?.frame else { return }
        
        let height: CGFloat = 0.04 * screenWidth
        let rect = CGRect(x: titleFrame.origin.x, y: titleFrame.origin.y + titleFrame.height + 1, width: 0.122 * screenWidth, height: height)
        totalLabel = UILabel(frame: rect)
        totalLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .smallMedium)
        totalLabel?.textColor = UIColor.briefDodgerBlueColor
        totalLabel?.textAlignment = .center
        
        totalLabel?.layer.cornerRadius = height / 2
        totalLabel?.layer.borderColor = UIColor.briefDodgerBlueColor.cgColor
        totalLabel?.layer.borderWidth = 1
        
        if totalLabel != nil {
            containerView?.addSubview(totalLabel!)
        }
    }
    
    // MARK: - Vendor image views setup
    
    private func addVendorImageViews() {
        guard vendorImageViews.isEmpty else { return }
        
        for index in 0..<maxImageViewsCount {
            let relativeFrame = index == 0 ? .zero : vendorImageViews[index - 1].frame
            addImageVendorImageView(relativeTo: relativeFrame)
        }
    }
    
    private func addImageVendorImageView(relativeTo rect: CGRect) {
        var viewFrame: CGRect = .zero
        if rect == .zero {
            guard let containerFrame = containerView?.frame else { return }
            
            let rightInset: CGFloat = 0.037 * screenWidth
            let dimension: CGFloat = 0.08 * screenWidth
            viewFrame = CGRect(x: containerFrame.width - (rightInset + dimension), y: containerFrame.height / 2 - dimension / 2, width: dimension, height: dimension)
        } else {
            let dimension: CGFloat = rect.width
            let originX: CGFloat = rect.origin.x - 0.01 * screenWidth - dimension
            viewFrame = CGRect(x: originX, y: rect.origin.y, width: dimension, height: dimension)
        }
        
        let imageView = UIImageView(frame: viewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = viewFrame.height / 2
        
        containerView?.addSubview(imageView)
        vendorImageViews.append(imageView)
    }
}
