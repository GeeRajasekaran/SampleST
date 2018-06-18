//
//  YesterdaySectionHeaderView.swift
//  June
//
//  Created by Ostap Holub on 12/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class YesterdaySectionHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var titleLabel: UILabel?
    private var expandButton: UIButton?
    
    var onExpandButton: (() -> Void)?
    
    // MARK: - Public view setup
    
    func setupSubviews(isExpanded: Bool, title: String) {
        titleLabel?.removeFromSuperview()
        titleLabel = nil
        expandButton?.removeFromSuperview()
        expandButton = nil
        addTitleLabel(title)
        addExpandButton(expanded: isExpanded)
    }
    
    // MARK: - Build title label
    
    private func addTitleLabel(_ title: String) {
        guard titleLabel == nil else { return }
        
        let origin = CGPoint(x: 0.042 * screenWidth, y: 0.037 * screenWidth)
        let size = CGSize(width: 0.488 * screenWidth, height: 0.042 * screenWidth)
        
        titleLabel = UILabel(frame: CGRect(origin: origin, size: size))
        titleLabel?.text = title
        titleLabel?.font = UIFont(name: LocalizedFontNameKey.FeedViewHelper.YesterdayHeaderTitleFont, size: 13)
        titleLabel?.textColor = UIColor.yesterdayFeedHeaderColor
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
    
    // MARK: - Expand button creation and tap handling
    
    private func addExpandButton(expanded: Bool) {
        guard expandButton == nil else { return }
        
        expandButton = UIButton()
        expandButton?.translatesAutoresizingMaskIntoConstraints = false
        expandButton?.addTarget(self, action: #selector(handleExpandButtonTap), for: .touchUpInside)
        expandButton?.backgroundColor = .clear
        
        let image = buttonImage(for: expanded)
        expandButton?.setImage(image, for: .normal)
        expandButton?.imageEdgeInsets = UIEdgeInsets(top: 0.013 * screenWidth, left: 0, bottom: 0, right: 0)
        
        if let unwrappedButton = expandButton {
            addSubview(unwrappedButton)
            unwrappedButton.widthAnchor.constraint(equalToConstant: 0.106 * screenWidth).isActive = true
            unwrappedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(0.013 * screenWidth)).isActive = true
            unwrappedButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            unwrappedButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
    
    private func buttonImage(for state: Bool) -> UIImage? {
        let imageName = state ? LocalizedImageNameKey.FeedViewHelper.HeaderCollapseIcon : LocalizedImageNameKey.FeedViewHelper.HeaderExpandIcon
        
        let imageWidth = 0.026 * screenWidth
        let imageHeight = 0.042 * screenWidth
        let finalSize = state ? CGSize(width: imageWidth, height: imageHeight) : CGSize(width: imageHeight, height: imageWidth)
        
        let image = UIImage(named: imageName)
        return image?.imageResize(sizeChange: finalSize)
    }
    
    @objc private func handleExpandButtonTap() {
        if let unwrappedAction = onExpandButton {
            unwrappedAction()
        }
    }
}
