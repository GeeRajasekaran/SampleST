//
//  FeedEmptyTodayTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 2/7/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedEmptyTodayTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var iconImageView: UIImageView?
    private var titleLabel: UILabel?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView?.removeFromSuperview()
        iconImageView = nil
        titleLabel?.removeFromSuperview()
        titleLabel = nil
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        addIconImageView()
        addTitleLabel()
    }
    
    // MARK: - Icon image view setup
    
    private func addIconImageView() {
        guard iconImageView == nil else { return }
        
        let dimension: CGFloat = 0.16 * screenWidth
        let originY = (frame.height / 2 - dimension / 2) - 10
        let originX = frame.width / 2 - dimension / 2
        
        let rect = CGRect(x: originX, y: originY, width: dimension, height: dimension)
        iconImageView = UIImageView(frame: rect)
        iconImageView?.contentMode = .scaleAspectFit
        iconImageView?.image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.EmptySectionIcon)
        
        if iconImageView != nil {
            addSubview(iconImageView!)
        }
    }
    
    // MARK: - Title label setup
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        guard let iconFrame = iconImageView?.frame else { return }
        
        let topInset: CGFloat = 0.042 * screenWidth
        let rect = CGRect(x: 0, y: iconFrame.origin.y + iconFrame.height + topInset, width: frame.width, height: 0.072 * screenWidth)
        titleLabel = UILabel(frame: rect)
        titleLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .extraMid)
        titleLabel?.textColor = UIColor.emptyStateTitleColor
        titleLabel?.textAlignment = .center
        titleLabel?.text = LocalizedStringKey.FeedViewHelper.EmptyStateTitle
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
}
