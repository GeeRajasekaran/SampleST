//
//  SectionHeaderView.swift
//  June
//
//  Created by Ostap Holub on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class SectionHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Views
    
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var seeAllButton = UIButton()
    private var bottomSeparatorView = GradientView()
    var onSeeAllAction: ((FeedCategory) -> Void)?
    private var currentCategory: FeedCategory?
    
    // MARK: - Initialization
    
    func loadData(from category: FeedCategory) {
        currentCategory = category
        let scale = Int(UIScreen.main.scale)
        if let url = URL(string: category.icons[scale]) {
            iconImageView.hnk_setImageFromURL(url)
        }
        
        setCategoryNameAsPlainText(category.title)
    }
    
    // MARK: - UI setup
    
    func setupView(for category: FeedCategory) {
        // any UI setup goes here
        addIconView()
        
        let color = UIColor(hexString: category.colorHex)
        
        addSeparatorView(with: color)
        addSeeAllButton(with: color)
        addTitleLabel()
    }
    
    private func addIconView() {
        let iconFrame = CGRect(x: UIView.narrowMargin, y: UIView.midLargeMargin, width: 0.06 * screenWidth, height: 0.05 * screenWidth)
        
        iconImageView = UIImageView(frame: iconFrame)
        iconImageView.contentMode = .scaleAspectFit
        
        addSubviewIfNeeded(iconImageView)
    }
    
    private func addSeparatorView(with color: UIColor) {
        let separatorHeight = 0.002 * screenWidth
        let separatorFrame = CGRect(x: 0, y: 0.146 * screenWidth - separatorHeight, width: screenWidth, height: separatorHeight)
        
        bottomSeparatorView = GradientView(frame: separatorFrame)
        bottomSeparatorView.drawHorizontalGradient(with: color)
        
        addSubviewIfNeeded(bottomSeparatorView)
    }
    
    private func addSeeAllButton(with color: UIColor) {
        let buttonWidth = 0.158 * screenWidth
        let buttonFrame = CGRect(x: screenWidth - buttonWidth - UIView.midMargin, y: UIView.midLargeMargin, width: buttonWidth, height: 0.05 * screenWidth)
        let seeAllButtonFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .midSmall)
        
        seeAllButton = UIButton(frame: buttonFrame)
        seeAllButton.setTitle(LocalizedStringKey.FeedViewHelper.SeeAllTitle, for: .normal)
        seeAllButton.setTitleColor(color, for: .normal)
        seeAllButton.setTitleColor(color.highlighted(), for: .highlighted)
        seeAllButton.titleLabel?.font = seeAllButtonFont
        seeAllButton.addTarget(self, action: #selector(onSeeAllButtonClicked), for: .touchUpInside)
        
        let image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.SeeAllIconName)
        seeAllButton.setImage(image, for: .normal)
        seeAllButton.tintColor = color
        
        seeAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        seeAllButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        seeAllButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        seeAllButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        
        addSubviewIfNeeded(seeAllButton)
    }
    
    private func addTitleLabel() {
        
        let originX = iconImageView.frame.origin.x + iconImageView.frame.size.width + UIView.narrowMargin
        let width = seeAllButton.frame.origin.x - originX
        
        let titleFrame = CGRect(x: originX, y: UIView.midLargeMargin, width: width, height: 0.058 * screenWidth)
        let titleLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .medium)
        
        titleLabel = UILabel(frame: titleFrame)
        titleLabel.font = titleLabelFont
        titleLabel.textColor = UIColor.tableHeaderTitleGray
        
        addSubviewIfNeeded(titleLabel)
    }
    
    private func combine(_ categoryName: String, with unreadCount: Int) -> NSAttributedString {
        
        let nsName = NSString(string: categoryName)
        let nsUnreadCountString = NSString(string: String(unreadCount))
        let whiteSpace = "  "
        
        let nsTotalString = NSString(format: "%@%@%@", nsName, whiteSpace, nsUnreadCountString)
        let finalAttributedString = NSMutableAttributedString(string: categoryName + whiteSpace + String(unreadCount))
        
        let nameRange = nsTotalString.range(of: categoryName)
        let unreadRange = nsTotalString.range(of: String(unreadCount))
        
        let font: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .medium)
        let unreadCountFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .medium)
        
        finalAttributedString.addAttribute(NSAttributedStringKey.font, value: font, range: nameRange)
        finalAttributedString.addAttribute(NSAttributedStringKey.font, value: unreadCountFont, range: unreadRange)
        
        let categoryNameColor = UIColor.tableHeaderTitleGray
        let unreadCount = UIColor.unreadCountRed
        
        finalAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: categoryNameColor, range: nameRange)
        finalAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: unreadCount, range: unreadRange)
        
        return finalAttributedString
    }
    
    private func setCategoryNameAsPlainText(_ name: String) {
        titleLabel.text = name
    }
    
    // MARK: - Actions
    
    @objc private func onSeeAllButtonClicked() {
        if let unwrappedCategory = currentCategory {
            onSeeAllAction?(unwrappedCategory)
        }
    }
}
