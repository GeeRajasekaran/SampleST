//
//  FeedEarlierHeaderCell.swift
//  June
//
//  Created by Ostap Holub on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedEarlierHeaderCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var titleLabel: UILabel?
    
    // MARK: - Reuse logic
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.removeFromSuperview()
        titleLabel = nil
    }
    
    // MARK: - Public view setup
    
    func setupSubviews(for model: BaseTableModel) {
        guard let castedModel = model as? FeedHeaderInfo else { return }
        backgroundColor = .clear
        selectionStyle = .none
        addTitleLabel(castedModel.title)
    }
    
    // MARK: - Build title label
    
    private func addTitleLabel(_ title: String) {
        guard titleLabel == nil else { return }
        
        let origin = CGPoint(x: 0.042 * screenWidth, y: 0.037 * screenWidth)
        let size = CGSize(width: 0.488 * screenWidth, height: 0.049 * screenWidth)
        
        titleLabel = UILabel(frame: CGRect(origin: origin, size: size))
        titleLabel?.text = title
        titleLabel?.font = UIFont(name: LocalizedFontNameKey.FeedViewHelper.YesterdayHeaderTitleFont, size: 16)
        titleLabel?.textColor = UIColor.yesterdayFeedHeaderColor
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
}
