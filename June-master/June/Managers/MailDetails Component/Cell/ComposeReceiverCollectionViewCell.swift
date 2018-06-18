//
//  ComposeReceiverCollectionViewCell.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeReceiverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private let screenWidth = UIScreen.main.bounds.width
    private weak var currentReceiver: EmailReceiver?
    var onCloseAction: ((EmailReceiver) -> Void)?
    
    // MARK: - Views
    
    private var nameLabel: UILabel?
    private var removeButton: UIButton?
    
    // MARK: - Reuse logic
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeButton?.removeFromSuperview()
        nameLabel?.removeFromSuperview()
    }
    
    // MARK: - Public UI setup
    
    func setupViews() {
        drawBorder()
        addRemoveButton()
        addNameLabel()
    }
    
    func loadReceiver(_ receiver: EmailReceiver) {
        currentReceiver = receiver
        if receiver.name != "" {
            nameLabel?.text = receiver.name
        } else {
            nameLabel?.text = receiver.email
        }
    }
    
    // MARK: - Border drawing
    
    private func drawBorder() {
        clipsToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.composeReceiverBorderColor.withAlphaComponent(0.6).cgColor
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Name Label
    
    private func addNameLabel() {
        let leftInset: CGFloat = 15
        let nameFrame = CGRect(x: leftInset, y: 0, width: frame.width - 15 - 16, height: frame.height)
        
        let nameLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        
        nameLabel = UILabel(frame: nameFrame)
        nameLabel?.font = nameLabelFont // UIFont(name: LocalizedFontNameKey.ComposeHelper.ReceiverTitleFont, size: 12)
        nameLabel?.textColor = UIColor.composeReceiverLabelGray
        
        if nameLabel != nil {
            addSubviewIfNeeded(nameLabel!)
        }
    }
    
    // MARK: - Close Button
    
    private func addRemoveButton() {
        let width: CGFloat = 30
        let buttonFrame = CGRect(x: frame.width - width, y: 2, width: width, height: frame.height - 2)
        let image = UIImage(named: LocalizedImageNameKey.ComposeHelper.RemoveReceiver)
        
        removeButton = UIButton(frame: buttonFrame)
        removeButton?.setImage(image, for: .normal)
        removeButton?.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        
        if removeButton != nil {
            addSubviewIfNeeded(removeButton!)
        }
    }
    
    @objc private func handleCloseButtonTap() {
        if let unwrappedReceiver = currentReceiver {
            onCloseAction?(unwrappedReceiver)
        }
    }
}