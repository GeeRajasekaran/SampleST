//
//  CategoryFilterCollectionViewCell.swift
//  June
//
//  Created by Ostap Holub on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class CategoryFilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var titleLabel: UILabel?
    var iconImageView: UIImageView?
    
    weak var category: FeedCategory? {
        didSet {
            titleLabel?.text = category?.shortTitle
            let scale = Int(UIScreen.main.scale)
            if let urlString = category?.icons[scale], let url = URL(string: urlString) {
                iconImageView?.hnk_setImageFromURL(url)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.removeFromSuperview()
        iconImageView?.removeFromSuperview()
    }
    
    func setupUI() {
        // Please, note that methods callig order is important here
        backgroundColor = .clear
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupImageView() {
        let width = 0.056 * screenWidth
        let height = 0.048 * screenWidth
        
        let originX = frame.width / 2 - width / 2
        let imageFrame = CGRect(x: originX, y: 0.037 * screenWidth, width: width, height: height)
        iconImageView = UIImageView(frame: imageFrame)
        iconImageView?.contentMode = .scaleAspectFit
        
        if iconImageView != nil {
            addSubview(iconImageView!)
        }
    }
    
    private func setupTitleLabel() {
        guard let imageFrame = iconImageView?.frame else { return }
        let height = 0.034 * screenWidth
        let originY = imageFrame.origin.y + imageFrame.height + 0.01 * screenWidth
        let titleFrame = CGRect(x: 0, y: originY, width: frame.size.width, height: height)
        let titleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .small)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel?.font = titleLabelFont
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = UIColor.categoryTitleGray
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
}

