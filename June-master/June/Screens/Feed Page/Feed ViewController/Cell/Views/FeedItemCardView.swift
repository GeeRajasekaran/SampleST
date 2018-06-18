//
//  FeedItemCardView.swift
//  June
//
//  Created by Ostap Holub on 11/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class FeedItemCardView: UIView, IFeedCardView {
    
    var view: UIView {
        get { return self }
    }
    
    var indexPath: IndexPath?
    
    // MARK: - Variables & constants
    
    let numberOfSubjectLines: Int = 2
    let screenWidth = UIScreen.main.bounds.width
    let rightTextInset = 0.114 * UIScreen.main.bounds.width
    let rightVendorNameInset = 0.256 * UIScreen.main.bounds.width
    
    var onRemoveBookmarkAction: RemoveBookmarkClosure?
    var itemInfo: FeedGenericItemInfo?
    
    // MARK: - Subviews
    
    var vendorIconImageView: UIImageView?
    var vendorNameLabel: UILabel?
    var subjectLabel: UILabel?
    private var categoryIconImageView: UIImageView?
    var moreOptionsButton: UIButton?
    var timeLabel: UILabel?
    var bookmarkImageView: UIImageView?
    
    private let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.medium)
    private var gesture: UITapGestureRecognizer?
    
    // MARK: - Data loading
    
    func loadItemData() {
        if let unwrappedUrl = itemInfo?.pictureUrl {
            vendorIconImageView?.hnk_setImageFromURL(unwrappedUrl)
        } else {
            updateLayoutWithoutImage()
        }
        
        subjectLabel?.text = itemInfo?.subject
        vendorNameLabel?.text = itemInfo?.vendor
        if let unwrappedUrl = itemInfo?.categoryPictureURL {
            categoryIconImageView?.hnk_setImageFromURL(unwrappedUrl, placeholder: nil, format: nil, failure: nil, success: { [weak self] image in
                let processedImage = image.imageResize(sizeChange: CGSize(width: image.size.width * 0.7, height: image.size.height * 0.7))
                self?.categoryIconImageView?.backgroundColor = UIColor.categoryIconBackground
                self?.categoryIconImageView?.image = processedImage
            })
        } else {
            guard let timestampFrame = timeLabel?.frame, let bookmarksFrame = bookmarkImageView?.frame else { return }
            let originX: CGFloat = frame.width - 0.042 * screenWidth - timestampFrame.width - bookmarksFrame.width
            timeLabel?.frame.origin.x = originX
        }
    
        if let timestamp = itemInfo?.date {
            let converter = FeedDateConverter()
            timeLabel?.text = converter.timeAgoInWords(from: timestamp)
        }
        changeStarState()
    }
    
    func changeStarState() {
        if itemInfo?.starred == true {
            bookmarkImageView?.isHidden = false
        } else if itemInfo?.starred == false {
            bookmarkImageView?.isHidden = true
        }
    }
    
    // MARK: - Layout setup logic
    
    func setupSubviews() {
        performBasicUISetup()
        addVendorIconImageView()
        addVendorNameLabel()
        addSubjectLabel()
        addCategoryIcon()
        addTimeLabel()
        addBookmarkImageView()
    }
    
    private func updateLayoutWithoutImage() {
        vendorIconImageView = nil
        vendorNameLabel?.frame.origin.x = leftEdgeOriginX()
        subjectLabel?.frame.origin.x = leftEdgeOriginX()
    }
    
    private func performBasicUISetup() {
        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = FeedGenericCardLayoutConstants.cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.newsCardBorderGray.cgColor
        drawFeedCellShadow()
    }
    
    // MARK: - Vendor icon image view setup
    
    private func addVendorIconImageView() {
        guard vendorIconImageView == nil else { return }
        vendorIconImageView = UIImageView(frame: vendorImageViewFrame())
        vendorIconImageView?.backgroundColor = .clear
        vendorIconImageView?.contentMode = .scaleAspectFit
        vendorIconImageView?.clipsToBounds = true
        vendorIconImageView?.layer.cornerRadius = vendorImageViewFrame().height / 2
        
        if vendorIconImageView != nil {
            addSubview(vendorIconImageView!)
        }
    }
    
    // MARK: - Subject label setup
    
    func addSubjectLabel() {
        guard subjectLabel == nil else { return }
        let subjectLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .regMid)

        subjectLabel = UILabel(frame: subjectLabelFrame())
        subjectLabel?.font = subjectLabelFont
        subjectLabel?.backgroundColor = .clear
        subjectLabel?.textColor = .black
        subjectLabel?.textAlignment = .left
        subjectLabel?.numberOfLines = numberOfSubjectLines
        subjectLabel?.lineBreakMode = .byTruncatingTail
        
        if subjectLabel != nil {
            addSubview(subjectLabel!)
        }
    }
    
    // MARK: - Vendor name label setup
    
    private func addVendorNameLabel() {
        guard vendorNameLabel == nil else { return }
        
        let vendorNameLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
        
        vendorNameLabel = UILabel(frame: vendorNameLabelFrame())
        vendorNameLabel?.font = vendorNameLabelFont
        vendorNameLabel?.textColor = UIColor.black.withAlphaComponent(0.56)
        vendorNameLabel?.textAlignment = .left
        vendorNameLabel?.backgroundColor = .clear
        vendorNameLabel?.lineBreakMode = .byTruncatingTail
        
        if vendorNameLabel != nil {
            addSubview(vendorNameLabel!)
        }
    }
    
    // MARK: - Category icon setup
    
    private func addCategoryIcon() {
        guard categoryIconImageView == nil else { return }
        if categoryIconFrame() == .zero { return }

        categoryIconImageView = UIImageView(frame: categoryIconFrame())
        categoryIconImageView?.contentMode = .center
        categoryIconImageView?.backgroundColor = .clear
        categoryIconImageView?.layer.cornerRadius = categoryIconFrame().height / 2
        
        if categoryIconImageView != nil {
            addSubview(categoryIconImageView!)
        }
    }
    
    // MARK: - Time label setup
    
    func addTimeLabel() {
        guard timeLabel == nil else { return }
        
        let timeLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)

        timeLabel = UILabel(frame: timeLabelFrame())
        timeLabel?.font = timeLabelFont
        timeLabel?.textColor = UIColor.categoryTitleGray
        timeLabel?.textAlignment = .right
        timeLabel?.backgroundColor = .clear
        
        if timeLabel != nil {
            addSubview(timeLabel!)
        }
    }
    
    // MARK: - Star image view setup
    
    func addBookmarkImageView() {
        guard bookmarkImageView == nil else { return }
        
        bookmarkImageView = UIImageView(frame: bookmarkImageViewFrame())
        bookmarkImageView?.contentMode = .scaleAspectFit
        bookmarkImageView?.image = UIImage(named: LocalizedImageNameKey.FeedCardHelper.bookmarkIcon)
        bookmarkImageView?.isHidden = true
        selectionFeedbackGenerator.prepare()
        
        bookmarkImageView?.isUserInteractionEnabled = true
        gesture = UITapGestureRecognizer(target: self, action: #selector(handleBookmarkTap(_:)))
        gesture?.numberOfTapsRequired = 1
        gesture?.delegate = self
        bookmarkImageView?.addGestureRecognizer(gesture!)
        
        if bookmarkImageView != nil {
            addSubview(bookmarkImageView!)
        }
    }
    
    @objc private func handleBookmarkTap(_ gesture: UIGestureRecognizer) {
        if let unwrappedIndexPath = indexPath {
            onRemoveBookmarkAction?(unwrappedIndexPath)
            selectionFeedbackGenerator.impactOccurred()
        }
    }
    
    // MARK: - Star image view frame
    
    func bookmarkImageViewFrame() -> CGRect {
        let rightInset = 0.018 * screenWidth
        let width = 0.042 * screenWidth
        let height = 0.061 * screenWidth
        return CGRect(x: frame.width - rightInset - width, y: 0, width: width, height: height)
    }
    
    // MARK: - Frames calculations
    
    func leftEdgeOriginX() -> CGFloat {
        var originX: CGFloat = 0.061 * screenWidth
        if let imageFrame = vendorIconImageView?.frame {
            originX = imageFrame.origin.x + imageFrame.width + 0.024 * screenWidth
        }
        return originX
    }
    
    // MARK: - Vendor icon frame
    
    func vendorImageViewFrame() -> CGRect {
        let imageViewSize = CGSize(width: 0.106 * screenWidth, height: 0.106 * screenWidth)
        let imageViewOrigin = CGPoint(x: 0.042 * screenWidth, y: frame.height / 2 - imageViewSize.height / 2)
        return CGRect(origin: imageViewOrigin, size: imageViewSize)
    }
    
    // MARK: - Vendor name label frame
    
    func vendorNameLabelFrame() -> CGRect {
        let originY = 0.04 * screenWidth
        let originX = leftEdgeOriginX()
        return CGRect(x: originX, y: originY, width: (frame.width - rightVendorNameInset) - originX, height: 0.045 * screenWidth)
    }
    
    // MARK: - Subject label frame
    
    func subjectLabelFrame() -> CGRect {
        guard let vendorFrame = vendorNameLabel?.frame else { return .zero }
        let originY = vendorFrame.origin.y + vendorFrame.height + 0.01 * screenWidth
        let originX = leftEdgeOriginX()
        return CGRect(x: originX, y: originY, width: (frame.width - rightTextInset) - originX, height: 0.1 * screenWidth)
    }
    
    // MARK: - Time label frame
    
    func timeLabelFrame() -> CGRect {
        let rightInset = 0.138 * screenWidth
        let width = 0.17 * screenWidth
        let height = 0.04 * screenWidth
        let originY = 0.021 * screenWidth
        let originX = frame.width - rightInset - width
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    // MARK: - Category icon frame
    
    func categoryIconFrame() -> CGRect {
        let rightInset = 0.021 * screenWidth
        let topInset = 0.021 * screenWidth
        let dimension = 0.109 * screenWidth
        let originX = frame.width - rightInset - dimension
        
        return CGRect(x: originX, y: topInset, width: dimension, height: dimension)
    }
}

extension FeedItemCardView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
