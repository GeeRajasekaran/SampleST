//
//  DisplayRecipientItemView.swift
//  June
//
//  Created by Ostap Holub on 2/23/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class DisplayRecipientItemView: RecipientItemView {
 
    // MARK: - Subviews
    
    private var nameLabel: UILabel?
    private var removeButton: UIButton?
    
    // MARK: - Public UI setup
    
    override func setupViews(for recipient: EmailReceiver) {
        super.setupViews(for: recipient)
        drawBorder()
        addRemoveButton()
        addNameLabel()
        loadReceiver()
    }
    
    private func loadReceiver() {
        guard let recipient = currentRecipient else { return }
        if recipient.name != "" {
            nameLabel?.text = recipient.name
        } else {
            nameLabel?.text = recipient.email
        }
    }
    
    // MARK: - Border drawing
    
    private func drawBorder() {
        clipsToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.receiverBorderGrey.cgColor
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Name Label
    
    private func addNameLabel() {
        let leftInset: CGFloat = 15
        let nameFrame = CGRect(x: leftInset, y: 0, width: frame.width - 15 - 16, height: frame.height)
        
        nameLabel = UILabel(frame: nameFrame)
        nameLabel?.font = UIFont(name: LocalizedFontNameKey.ResponderHelper.ReceiverTitleFont, size: 13)
        nameLabel?.textColor = UIColor.tableHeaderTitleGray
        
        if nameLabel != nil {
            addSubviewIfNeeded(nameLabel!)
        }
    }
    
    // MARK: - Close Button
    
    private func addRemoveButton() {
        let width: CGFloat = 30
        let buttonFrame = CGRect(x: frame.width - width, y: 2, width: width, height: frame.height - 2)
        let image = UIImage(named: LocalizedImageNameKey.ResponderHelper.RemoveReceiver)
        
        removeButton = UIButton(frame: buttonFrame)
        removeButton?.tintColor = .black
        removeButton?.setImage(image, for: .normal)
        removeButton?.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        
        if removeButton != nil {
            addSubviewIfNeeded(removeButton!)
        }
    }
    
    @objc private func handleCloseButtonTap() {
        if let unwrappedReceiver = currentRecipient {
            removeAction?(unwrappedReceiver)
        }
    }
}
