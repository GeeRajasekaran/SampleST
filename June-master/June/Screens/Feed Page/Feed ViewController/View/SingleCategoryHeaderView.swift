//
//  SingleCategoryHeaderView.swift
//  June
//
//  Created by Ostap Holub on 12/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SingleCategoryHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let dateConverter: FeedDateConverter = FeedDateConverter()
    private var titleLabel: UILabel?
    
    // MARK: - Public view setup
    
    func setupSubviews(with timestamp: Int32) {
        addTitleLabel(timestamp)
    }
    
    // MARK: - Create title label
    
    private func addTitleLabel(_ timestamp: Int32) {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        titleLabel?.text = dateConverter.isToday(timestamp) ? LocalizedStringKey.FeedViewHelper.Today : dateConverter.timeAgoInWords(from: timestamp)
        titleLabel?.font = UIFont(name: LocalizedFontNameKey.FeedViewHelper.SingleCategoryTitleFont, size: 14)
        titleLabel?.textColor = UIColor.categoryTitleGray
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if titleLabel != nil {
            addSubview(titleLabel!)
            titleLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.045 * screenWidth).isActive = true
            titleLabel?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(0.034 * screenWidth)).isActive = true
            titleLabel?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            titleLabel?.heightAnchor.constraint(equalToConstant: 0.053 * screenWidth).isActive = true
        }
    }
}
