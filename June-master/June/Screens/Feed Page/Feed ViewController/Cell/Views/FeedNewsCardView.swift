//
//  FeedNewsCardView.swift
//  June
//
//  Created by Ostap Holub on 11/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class FeedNewsCardView: FeedItemCardView {
    
    // MARK: - Constants
    
    var leftEdgeInset: CGFloat = 0.013 * UIScreen.main.bounds.width
    var rightImageWidth: CGFloat = 0.301 * UIScreen.main.bounds.width
    
    // MARK: - Subviews
    
    private var itemImageView: UIImageView?
    
    // MARK: - Overriding parent methods
    
    override func loadItemData() {
        super.loadItemData()
        guard let newsItemInfo = itemInfo as? FeedNewsItemInfo else { return }
        
        if newsItemInfo.category == "promotions" {
            let promosImage = UIImage(named: LocalizedImageNameKey.FeedCardHelper.promosDefaultImage)?.imageResize(sizeChange: CGSize(width: 37, height: 42))
            itemImageView?.contentMode = .center
            itemImageView?.backgroundColor = UIColor.promosBackgroundColor
            itemImageView?.image = promosImage
            if let url = newsItemInfo.newsImageURL {
                itemImageView?.hnk_setImageFromURL(url)
            }
        } else {
            let placeholderImage = UIImage(named: LocalizedImageNameKey.FeedCardHelper.newsDefaultImage)
            if let url = newsItemInfo.newsImageURL {
                itemImageView?.contentMode = .center
                itemImageView?.hnk_setImageFromURL(url, placeholder: placeholderImage, format: nil, failure: nil, success: { [weak self] image in
                    self?.itemImageView?.image = image
                })
            }
        }
        timeLabel?.frame = timeLabelFrame()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addItemImageView()
        if bookmarkImageView != nil {
            bringSubview(toFront: bookmarkImageView!)
        }
    }
    
    override func addSubjectLabel() {
        super.addSubjectLabel()
        let subJectLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        subjectLabel?.font = subJectLabelFont
    }
    
    // MARK: - Item image view creation
    
    private func addItemImageView() {
        let originX = frame.width - rightImageWidth
        
        let imageViewFrame = CGRect(x: originX, y: 0, width: rightImageWidth, height: frame.height)
        itemImageView = UIImageView(frame: imageViewFrame)
        itemImageView?.contentMode = .scaleToFill
        itemImageView?.backgroundColor = .clear
        itemImageView?.clipsToBounds = true
        itemImageView?.image = UIImage(named: LocalizedImageNameKey.FeedCardHelper.newsDefaultImage)
        itemImageView?.roundCorners([.topRight, .bottomRight], radius: FeedGenericCardLayoutConstants.cornerRadius)
        
        if itemImageView != nil {
            addSubview(itemImageView!)
        }
    }
    
    // MARK: - Left edge coordinate

    override func leftEdgeOriginX() -> CGFloat {
        var originX: CGFloat = 0.042 * screenWidth
        if let imageFrame = vendorIconImageView?.frame {
            originX = imageFrame.origin.x + imageFrame.width + 0.021 * screenWidth
        }
        return originX
    }
    
    // MARK: - Vendor icon frame
    
    override func vendorImageViewFrame() -> CGRect {
        let imageViewSize = CGSize(width: 0.106 * screenWidth, height: 0.106 * screenWidth)
        let imageViewOrigin = CGPoint(x: 0.042 * screenWidth, y: 0.032 * screenWidth)
        return CGRect(origin: imageViewOrigin, size: imageViewSize)
    }
    
    // MARK: - Vendor name label frame
    
    override func vendorNameLabelFrame() -> CGRect {
        guard let imageFrame = vendorIconImageView?.frame else { return .zero }
        let height = 0.045 * screenWidth
        
        let originX = leftEdgeOriginX()
        let originY = (imageFrame.origin.y + imageFrame.height / 2) - 0.01 * screenWidth
        let width = frame.width - rightImageWidth - originX - 0.05 * screenWidth
        return CGRect(x: originX, y: originY, width: width, height: height)
    }

    // MARK: - Subject label frame
    
    override func subjectLabelFrame() -> CGRect {
        let originY = 0.137 * screenWidth
        let originX = 0.042 * screenWidth
        
        let width = frame.width - rightImageWidth - originX - 0.013 * screenWidth
        let height = 0.155 * screenWidth
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    // MARK: - Time label frame
    
    override func timeLabelFrame() -> CGRect {
        let originY = 0.021 * screenWidth
        let width = 0.2 * screenWidth
        let height = 0.04 * screenWidth
        let originX = frame.width - rightImageWidth - 0.021 * screenWidth - width
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    // MARK: - Category icon frame
    
    override func categoryIconFrame() -> CGRect {
        return .zero
    }
}
