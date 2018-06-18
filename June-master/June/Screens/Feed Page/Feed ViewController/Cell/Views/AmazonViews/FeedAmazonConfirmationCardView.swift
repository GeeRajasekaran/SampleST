//
//  FeedAmazonConfirmationCardView.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class FeedAmazonConfirmationCardView: UIView, IFeedCardView {
    
    // MARK: - Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Variables
    
    var indexPath: IndexPath?
    var itemInfo: FeedGenericItemInfo?
    var onRemoveBookmarkAction: RemoveBookmarkClosure?
    var view: UIView {
        get { return self }
    }
    
    // MARK: - Subviews
    
    private var amazonIconImageView: UIImageView?
    private var moreOptionsButton: UIButton?
    private var timeLabel: UILabel?
    private var boxImageView: UIImageView?
    private var viewOrManageOrderButton: UIButton?
    private var orderConfirmedTitle: UILabel?
    private var orderItemNameLabel: UILabel?
    private var estimatedToArriveTitleLabel: UILabel?
    private var estimatedToArriveDateLabel: UILabel?
    
    // MARK: - Data loading
    
    func loadItemData() {
//        guard let amazonItem = item as? AmazonFeedItem else { return }
//        if let url = amazonItem.iconUrl {
//            amazonIconImageView?.hnk_setImageFromURL(url)
//        }
//        if let timestamp = amazonItem.date {
//            let converter = FeedDateConverter()
//            timeLabel?.text = converter.timeAgoInWords(from: timestamp)
//        }
//        orderItemNameLabel?.text = amazonItem.amazonOrderItem?.name
//        if let timestamp = amazonItem.amazonOrderItem?.arrivalTimestamp {
//            estimatedToArriveDateLabel?.text = FeedDateConverter().eta(from: timestamp)
//        }
    }
    
    func changeStarState() {
        // TODO: add star icon
    }
    
    // MARK: - Layout setup
    
    func setupSubviews() {
        performBasicUISetup()
        addAmazonIconView()
        addMoreOptionsButton()
        addTimeLabel()
        addBoxImageView()
        addViewOrManagerOrderButton()
        addOrderConfirmedTitle()
        addOrderItemNameLabel()
        addEstimatedToArriveTitle()
        addEstimatedToArriveDateLabel()
    }
    
    func performBasicUISetup() {
        backgroundColor = .black
        clipsToBounds = false
        layer.cornerRadius = FeedGenericCardLayoutConstants.cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.newsCardBorderGray.cgColor
        drawFeedCellShadow()
    }
    
    // MARK: - Amazon icon view setup
    
    private func addAmazonIconView() {
        guard amazonIconImageView == nil else { return }
        
        let imageViewSize = CGSize(width: 0.125 * screenWidth, height: 0.077 * screenWidth)
        let imageViewOrigin = CGPoint(x: 0.001 * screenWidth, y: 0.029 * screenWidth)
        let imageFrame = CGRect(origin: imageViewOrigin, size: imageViewSize)
        
        amazonIconImageView = UIImageView(frame: imageFrame)
        amazonIconImageView?.contentMode = .scaleAspectFit
        amazonIconImageView?.image = UIImage(named: LocalizedImageNameKey.FeedCardHelper.amazonIcon)
        
        if amazonIconImageView != nil {
            addSubview(amazonIconImageView!)
        }
    }
    
    // MARK: - More options button setup
    
    private func addMoreOptionsButton() {
        guard moreOptionsButton == nil else { return }
        
        let rightInset = 0.034 * screenWidth
        let width = 0.053 * screenWidth
        
        let originX = frame.width - rightInset - width
        let originY = 0.021 * screenWidth
        
        let buttonFrame = CGRect(x: originX, y: originY, width: width, height: width)
        moreOptionsButton = UIButton(frame: buttonFrame)
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.MoreOptions)
        moreOptionsButton?.setImage(image, for: .normal)
//        moreOptionsButton?.addTarget(self, action: #selector(handleMoreOptionsTap), for: .touchUpInside)
        
        if moreOptionsButton != nil {
            addSubview(moreOptionsButton!)
        }
    }
    
//    @objc private func handleMoreOptionsTap() {
//        if let unwrappedItem = item, let action = onMoreOptionsAction {
//            action(unwrappedItem)
//        }
//    }
    
    // MARK: - Time label setup
    
    func addTimeLabel() {
        guard timeLabel == nil else { return }
        
        let timeLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        
        timeLabel = UILabel(frame: timeLabelFrame())
        timeLabel?.font = timeLabelFont
        timeLabel?.textColor = UIColor.categoryTitleGray
        timeLabel?.textAlignment = .left
        timeLabel?.backgroundColor = .clear
        
        if timeLabel != nil {
            addSubview(timeLabel!)
        }
    }
    
    private func timeLabelFrame() -> CGRect {
        let originX = 0.04 * screenWidth
        let originY = frame.height - 0.069 * screenWidth
        let width = 0.17 * screenWidth
        let height = 0.04 * screenWidth
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    // MARK: - Left edge coordinate
    
    private func leftEdgeOriginX() -> CGFloat {
        return 0.05 * screenWidth
    }
    
    // MARK: - Box icon view setup
    
    private func addBoxImageView() {
        guard boxImageView == nil else { return }
        
        let width = 0.17 * screenWidth
        let height = 0.22 * screenWidth
        
        let boxFrame = CGRect(x: frame.width - width, y: 0.1 * screenWidth, width: width, height: height)
        boxImageView = UIImageView(frame: boxFrame)
        boxImageView?.contentMode = .scaleAspectFit
        boxImageView?.image = UIImage(named: LocalizedImageNameKey.FeedCardHelper.amazonBoxIcon)
        
        if boxImageView != nil {
            addSubview(boxImageView!)
        }
    }
    
    // MARK: - View or manage order button setup
    
    private func addViewOrManagerOrderButton() {
        guard viewOrManageOrderButton == nil else { return }
        
        let viewOrManageOrderButtonFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .midSmall)
        
        viewOrManageOrderButton = UIButton(frame: manageOrderButtonFrame())
        viewOrManageOrderButton?.setTitle(LocalizedStringKey.FeedAmazonCardHelper.ViewOrManageOrder, for: .normal)
        viewOrManageOrderButton?.setTitleColor(UIColor.amazonCardActionColor, for: .normal)
        viewOrManageOrderButton?.clipsToBounds = true
        viewOrManageOrderButton?.layer.borderWidth = 1
        viewOrManageOrderButton?.layer.borderColor = UIColor.amazonCardActionColor.cgColor
        viewOrManageOrderButton?.layer.cornerRadius = manageOrderButtonFrame().height / 2
        viewOrManageOrderButton?.titleLabel?.font = viewOrManageOrderButtonFont
        viewOrManageOrderButton?.addTarget(self, action: #selector(handleManageOrderClick), for: .touchUpInside)
        
        if viewOrManageOrderButton != nil {
            addSubview(viewOrManageOrderButton!)
        }
    }
    
    @objc private func handleManageOrderClick() {
        print("Manage order clicked")
    }
    
    private func manageOrderButtonFrame() -> CGRect {
        let rightInset = 0.034 * screenWidth
        let bottomInset = 0.024 * screenWidth
        
        let width = 0.413 * screenWidth
        let height = 0.077 * screenWidth
        
        return CGRect(x: frame.width - (rightInset + width), y: frame.height - (bottomInset + height), width: width, height: height)
    }
    
    // MARK: - Order confirmed label setup
    
    private func addOrderConfirmedTitle() {
        guard orderConfirmedTitle == nil else { return }
        
        let orderConfirmedTitleFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .large)
        
        let confirmedFrame = CGRect(x: leftEdgeOriginX(), y: 0.129 * screenWidth, width: 0.6 * screenWidth, height: 0.053 * screenWidth)
        orderConfirmedTitle = UILabel(frame: confirmedFrame)
        orderConfirmedTitle?.font = orderConfirmedTitleFont
        orderConfirmedTitle?.textColor = .white
        orderConfirmedTitle?.textAlignment = .left
        orderConfirmedTitle?.text = LocalizedStringKey.FeedAmazonCardHelper.OrderConfirmed
        
        if orderConfirmedTitle != nil {
            addSubview(orderConfirmedTitle!)
        }
    }
    
    // MARK: - Order item name label setup
    
    private func addOrderItemNameLabel() {
        guard orderItemNameLabel == nil else { return }
        guard let orderConfirmedFrame = orderConfirmedTitle?.frame else { return }
        let orderItemNameLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        
        let itemNameFrame = CGRect(x: leftEdgeOriginX(), y: orderConfirmedFrame.origin.y + orderConfirmedFrame.height, width: 0.6 * screenWidth, height: 0.05 * screenWidth)
        orderItemNameLabel = UILabel(frame: itemNameFrame)
        orderItemNameLabel?.font = orderItemNameLabelFont
        orderItemNameLabel?.textColor = .white
        orderItemNameLabel?.textAlignment = .left
        orderItemNameLabel?.numberOfLines = 1
        orderItemNameLabel?.lineBreakMode = .byTruncatingTail
        
        if orderItemNameLabel != nil {
            addSubview(orderItemNameLabel!)
        }
    }
    
    // MARK: - Estimated to arrive title label setup
    
    private func addEstimatedToArriveTitle() {
        guard estimatedToArriveTitleLabel == nil else { return }
        guard let orderItemFrame = orderItemNameLabel?.frame else { return }
        
        let estimatedToArriveTitleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .regular)
        
        let etaFrame = CGRect(x: leftEdgeOriginX(), y: orderItemFrame.origin.y + orderItemFrame.height + 0.005 * screenWidth, width: 0.6 * screenWidth, height: 0.045 * screenWidth)
        estimatedToArriveTitleLabel = UILabel(frame: etaFrame)
        estimatedToArriveTitleLabel?.font = estimatedToArriveTitleLabelFont
        estimatedToArriveTitleLabel?.textColor = UIColor.estimatedToArriveColor
        estimatedToArriveTitleLabel?.textAlignment = .left
        estimatedToArriveTitleLabel?.text = LocalizedStringKey.FeedAmazonCardHelper.EstimatedToArrive
        
        if estimatedToArriveTitleLabel != nil {
            addSubview(estimatedToArriveTitleLabel!)
        }
    }
    
    // MARK: - Estimated to arrive date label setup
    
    private func addEstimatedToArriveDateLabel() {
        guard estimatedToArriveDateLabel == nil else { return }
        guard let estimatedTitleFrame = estimatedToArriveTitleLabel?.frame else { return }
        
        let estimatedToArriveDateLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .regular)
        
        let etaFrame = CGRect(x: leftEdgeOriginX(), y: estimatedTitleFrame.origin.y + estimatedTitleFrame.height, width: 0.6 * screenWidth, height: 0.045 * screenWidth)
        estimatedToArriveDateLabel = UILabel(frame: etaFrame)
        estimatedToArriveDateLabel?.font = estimatedToArriveDateLabelFont
        estimatedToArriveDateLabel?.textAlignment = .left
        estimatedToArriveDateLabel?.textColor = .white
        
        if estimatedToArriveDateLabel != nil {
            addSubview(estimatedToArriveDateLabel!)
        }
    }
}
