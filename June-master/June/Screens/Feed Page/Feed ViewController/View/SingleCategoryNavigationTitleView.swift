//
//  SingleCategoryNavigationTitleView.swift
//  June
//
//  Created by Ostap Holub on 11/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class SingleCategoryNavigationTitleView: UIView {
    
    // MARK: - Variables & Constants
    
    private var imageView: UIImageView?
    private var titleLabel: UILabel?
    
    // MARK: - View setup
    
    func setupSubviews(for category: FeedCategory) {
        addTitleLabel(with: category.title)
        setupImageView(for: category)
    }
    
    // MARK: - Image view setup
    
    private func setupImageView(for category: FeedCategory) {
        let height = 0.05 * UIScreen.main.bounds.width
        let imageFrame = CGRect(x: 0, y: frame.height / 2 - height / 2, width: 30, height: height)
        
        imageView = UIImageView(frame: imageFrame)
        imageView?.contentMode = .scaleAspectFit
        
        let scale = Int(UIScreen.main.scale)
        if let url = URL(string: category.icons[scale]) {
            imageView?.hnk_setImageFromURL(url)
        }
        
        addSubview(imageView!)
    }
    
    // MARK: - Title label setup
    
    private func addTitleLabel(with title: String) {
        let font: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extraMid)
        let width = title.width(usingFont: font)
        let labelFrame = CGRect(x: 30, y: 0, width: width + 10, height: frame.height)
        
        titleLabel = UILabel(frame: labelFrame)
        titleLabel?.font = font
        titleLabel?.text = title
        titleLabel?.textAlignment = .center
        
        addSubview(titleLabel!)
    }
}
