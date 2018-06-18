//
//  AttachmentCollectionViewCell.swift
//  June
//
//  Created by Ostap Holub on 10/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class AttachmentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables & Constants
    

    private let formatHeight: CGFloat = 0.024 * UIScreen.main.bounds.width
    
    private let screenWidth = UIScreen.main.bounds.width
    private var attachmentFormatLabel: UILabel?
    private var attachmentNameLabel: UILabel?
    private var removeButton: UIButton?
    
    private var currentAttachment: Attachment?
    
    var onCloseAction: ((Attachment) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    
    // MARK: - Reuse logic
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentAttachment = nil
        attachmentNameLabel?.removeFromSuperview()
        attachmentFormatLabel?.removeFromSuperview()
        attachmentNameLabel = nil
        attachmentFormatLabel = nil
    }
    
    // MARK: - Public UI init
    
    func setupSubviews(for attachment: Attachment, showRemoveButton: Bool = false) {
        currentAttachment = attachment
        backgroundColor = .white
        drawBorder()
        addFormatLabel()
        addNameLabel()
        if showRemoveButton {
            addRemoveButton()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenAttachmentTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Border drawing
    
    private func drawBorder() {
        clipsToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.composeReceiverBorderColor.cgColor
        
        layer.cornerRadius = 0.016 * screenWidth
    }
    
    // MARK: - Image view creation
    
    private func addFormatLabel() {
        if attachmentFormatLabel != nil { return }
        var width: CGFloat = 0
        var formatText = ""
        if let formatString = currentAttachment?.filename.components(separatedBy: ".").last {
            formatText = formatString.capitalized
            width = formatText.width(usingFont: AttachmentsHelper.formatFont) + AttachmentsHelper.formatLabelOffset
        }
        
        let formatFrame = CGRect(x: AttachmentsHelper.leftInset, y: frame.height / 2 - formatHeight / 2, width: width, height: formatHeight)
        
        attachmentFormatLabel = UILabel(frame: formatFrame)
        attachmentFormatLabel?.font = AttachmentsHelper.formatFont
        attachmentFormatLabel?.textColor = .white
        attachmentFormatLabel?.text = formatText.uppercased()
        attachmentFormatLabel?.backgroundColor = UIColor.attachmentRed
        attachmentFormatLabel?.layer.cornerRadius = 0.0056 * screenWidth
        attachmentFormatLabel?.clipsToBounds = true
        attachmentFormatLabel?.textAlignment = .center
        
        addSubview(attachmentFormatLabel!)
    }
    
    // MARK: - Name label creation
    
    private func addNameLabel() {
        if attachmentNameLabel != nil { return }
        guard let formatLabelFrame = attachmentFormatLabel?.frame else { return }
        var width: CGFloat = 0
        guard let currentWidth = currentAttachment?.filename.width(usingFont: AttachmentsHelper.labelFont), let height = currentAttachment?.filename.height(withConstrainedWidth: width, font: AttachmentsHelper.labelFont) else { return }
        width = currentWidth
        let maxWidth = AttachmentsHelper.maxNameLabelWidth
        if width > maxWidth {
            width = maxWidth
        }
        let nameFrame = CGRect(x: formatLabelFrame.origin.x + formatLabelFrame.width + AttachmentsHelper.leftInset, y: frame.height/2 - height/2, width: width, height: height)
        
        attachmentNameLabel = UILabel(frame: nameFrame)
        attachmentNameLabel?.font = AttachmentsHelper.labelFont
        attachmentNameLabel?.text = currentAttachment?.filename
        attachmentNameLabel?.textColor = .black
        attachmentNameLabel?.textAlignment = .center
        
        addSubview(attachmentNameLabel!)
    }
    
    // MARK: - Close Button
    
    private func addRemoveButton() {
         if removeButton != nil { return }
        let width: CGFloat = 18
        let buttonFrame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
        let image = UIImage(named: LocalizedImageNameKey.ResponderHelper.RemoveReceiver)
        
        removeButton = UIButton(frame: buttonFrame)
        removeButton?.setImage(image, for: .normal)
        removeButton?.tintColor = .black
        removeButton?.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        
        if removeButton != nil {
            addSubviewIfNeeded(removeButton!)
        }
    }
    
    @objc private func handleCloseButtonTap() {
        if let unwrappedAttachment = currentAttachment {
            onCloseAction?(unwrappedAttachment)
        }
    }
    
    @objc private func handleOpenAttachmentTap() {
        if let unwrappedAttachment = currentAttachment {
            onOpenAttachment?(unwrappedAttachment)
        }
    }
}
