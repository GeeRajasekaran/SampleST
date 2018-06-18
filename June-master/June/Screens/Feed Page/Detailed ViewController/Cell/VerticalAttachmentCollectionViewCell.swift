//
//  VerticalAttachmentCollectionViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class VerticalAttachmentCollectionViewCell: UICollectionViewCell {
    
    private var currentAttachment: Attachment?
    
    private let screenWidth = UIScreen.main.bounds.width
    private let leftInset = UIScreen.main.bounds.width * 0.042
    
    private var attachmentNameLabel: UILabel?
    private var attachmentSizeLabel: UILabel?
    private var iconImageView: UIImageView?
    
    // MARK: - Reuse logic
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentAttachment = nil
        attachmentNameLabel?.removeFromSuperview()
        attachmentSizeLabel?.removeFromSuperview()
        iconImageView?.removeFromSuperview()
        attachmentNameLabel = nil
        attachmentSizeLabel = nil
        iconImageView = nil
    }
    
    // MARK: - Public UI init
    
    func setupSubviews(for attachment: Attachment) {
        currentAttachment = attachment
        backgroundColor = .white
        drawBorderAndShadow()
        addImageIcon()
        addNameLabel()
        addFileSizeLabel()
    }
    
    // MARK: - Border drawing
    
    private func drawBorderAndShadow() {
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 0.4
    
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    //MARK: - Image icon creation
    private func addImageIcon() {
        if iconImageView != nil { return }
        let iconWidth = 0.085*screenWidth
        let iconHeight = iconWidth
        let iconFrame = CGRect(x: frame.height/2 - iconHeight/2, y: 0.056*screenWidth, width: iconWidth, height: iconHeight)
        iconImageView = UIImageView(frame: iconFrame)
        iconImageView?.image = UIImage(named: LocalizedImageNameKey.AttachmentHelper.ImageIcon)
        addSubview(iconImageView!)
    }
    
    // MARK: - Name label creation
    private func addNameLabel() {
        if attachmentNameLabel != nil { return }

        let font: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
        var width = currentAttachment?.filename.width(usingFont: font)
        let maxWidth = 0.525*screenWidth
        if width! > maxWidth {
            width = maxWidth
        }
        let height = 0.045*screenWidth
        var iconFrame: CGRect = .zero
        if let unwrappedFrame = iconImageView?.frame {
            iconFrame = unwrappedFrame
        }
        let nameFrame = CGRect(x: iconFrame.origin.x + iconFrame.width + leftInset, y: iconFrame.origin.y, width: width!, height: height)

        attachmentNameLabel = UILabel(frame: nameFrame)
        attachmentNameLabel?.font = font
        attachmentNameLabel?.text = currentAttachment?.filename
        attachmentNameLabel?.textAlignment = .left

        addSubview(attachmentNameLabel!)
    }
    
    private func addFileSizeLabel() {
        if  attachmentSizeLabel != nil { return }
        //TODO: convert size to string
        let text = currentAttachment?.size.convertToMB()
        let font = UIFont(name: LocalizedFontNameKey.FeedViewHelper.AttachmentSizeFont, size: 12)
        let width = text?.width(usingFont: font!)
        let height = 0.037*screenWidth
        var nameFrame: CGRect = .zero
        if let unwrappedFrame = attachmentNameLabel?.frame {
            nameFrame = unwrappedFrame
        }
        let sizeFrame = CGRect(x: nameFrame.origin.x, y: nameFrame.origin.y + nameFrame.size.height, width: width!, height: height)

        attachmentSizeLabel = UILabel(frame: sizeFrame)
        attachmentSizeLabel?.font = font
        attachmentSizeLabel?.text = text
        attachmentSizeLabel?.textAlignment = .left
        
        addSubview(attachmentSizeLabel!)
    }
}
