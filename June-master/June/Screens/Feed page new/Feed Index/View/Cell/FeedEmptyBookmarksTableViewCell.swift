//
//  FeedEmptyBookmarksTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 3/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SnapKit

class FeedEmptyBookmarksTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
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
        selectionStyle = .none
        backgroundColor = .clear
        addIconImageView()
        addTitleLabel()
    }
    
    // MARK: - Private icon image view setup
    
    private func addIconImageView() {
        guard iconImageView == nil else { return }
        
        iconImageView = UIImageView()
        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
        iconImageView?.contentMode = .scaleAspectFit
        iconImageView?.image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.EmptyBookmarksIcon)
        
        if iconImageView != nil {
            addSubview(iconImageView!)
            iconImageView?.snp.makeConstraints { make in
                let screenWidth: CGFloat = UIScreen.main.bounds.width
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-0.133 * screenWidth)
                make.height.equalTo(0.17 * screenWidth)
                make.width.equalTo(0.128 * screenWidth)
            }
        }
    }
    
    // MARK: - Private title label view setup
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .extra)
        titleLabel?.textColor = UIColor.noBookmarksTitleColor
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
        titleLabel?.text = LocalizedStringKey.FeedViewHelper.NoBookmarksTitle
        
        if titleLabel != nil {
            addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints { [weak self] make in
                guard let top = self?.iconImageView else { return }
                let screenWidth: CGFloat = UIScreen.main.bounds.width
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalTo(top.snp.bottom).offset(0.08 * screenWidth)
                make.height.equalTo(0.133 * screenWidth)
            }
        }
    }
}
