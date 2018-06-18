//
//  VendorDetailsView.swift
//  June
//
//  Created by Ostap Holub on 9/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class VendorDetailsView: UIView {
    
    // MARK: - Views
    
    private let screenWidth = UIScreen.main.bounds.width
    private var iconImageView = UIImageView()
    private var vendorNameLabel = UILabel()
    private var participantsLabel = UILabel()
    private var dateLabel = UILabel()
    
    var onHideResponder: (() -> Void)?
    
    // MARK: - Subviews Setup
    
    func setupSubviews() {
        addVendorIconView()
        addVendorNameLabel()
        addParticipanstLabel()
        addDateLabel()
    }
    
    func loadMessage(_ message: Message) {
        vendorNameLabel.text = message.senderName
        if let urlString = message.profilePictureUrl, let url = URL(string: urlString) {
            iconImageView.hnk_setImageFromURL(url, placeholder: nil, format: nil, failure: nil, success: { [weak self] image in
                self?.iconImageView.isHidden = false
                self?.iconImageView.image = image
            })
        }
        
        if let unwrappedTime = message.timestamp {
            let converter = FeedDateConverter()
            dateLabel.text = converter.feedDetailsTimeAgo(from: unwrappedTime)
            if converter.isToday(unwrappedTime) {
                dateLabel.textAlignment = .right
            }
        }
        
        let sort = NSSortDescriptor(key: "name", ascending: false)
        if let unwrappedList = message.toList?.sortedArray(using: [sort]) {
            var particiantsCount = unwrappedList.count
            var firstName = (unwrappedList.first as? Messages_To)?.name ?? ""
            
            if firstName == "" {
                firstName = (unwrappedList.first as? Messages_To)?.email ?? ""
            }
            particiantsCount -= 1
            if particiantsCount > 0 {
                participantsLabel.text = "to \(firstName) +\(particiantsCount) more"
            } else {
                participantsLabel.text = "to \(firstName)"
            }
        }
    }
    
    // MARK: - Private part
    
    private func addVendorIconView() {
        let iconHeight = 0.086 * screenWidth
        let iconWidth = 0.086 * screenWidth
        let iconFrame = CGRect(x: 0, y: frame.height/2 - iconHeight/2, width: iconWidth, height: iconHeight)
        
        iconImageView = UIImageView(frame: iconFrame)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 2
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.vendorImageViewBorderColor.cgColor
        iconImageView.isHidden = true
        
        addSubviewIfNeeded(iconImageView)
    }
    
    private func addVendorNameLabel() {
        let labelWidth = 0.5 * screenWidth
        let heigth = 0.053 * screenWidth
        let vendorNAmeLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        
        let nameFrame = CGRect(x: iconImageView.frame.width + 4, y: 0, width: labelWidth, height: heigth)
        vendorNameLabel = UILabel(frame: nameFrame)
        vendorNameLabel.font = vendorNAmeLabelFont
        vendorNameLabel.textColor = .black
        vendorNameLabel.lineBreakMode = .byTruncatingTail
        addSubviewIfNeeded(vendorNameLabel)
    }
    
    private func addParticipanstLabel() {
        let height = 0.053 * screenWidth
        let labelWidth = 0.7 * screenWidth
        let participantsLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        
        let participantsFrame = CGRect(x: iconImageView.frame.width + 4, y: frame.height - height, width: labelWidth, height: height)
        participantsLabel = UILabel(frame: participantsFrame)
        participantsLabel.font = participantsLabelFont
        participantsLabel.textColor = UIColor.participantsLabelGray
        
        addSubviewIfNeeded(participantsLabel)
    }
    
    private func addDateLabel() {
        let height = 0.09 * screenWidth 
        let labelWidth = 0.33 * screenWidth
        let dateLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        
        let dateFrame = CGRect(x: frame.width - labelWidth + 4, y: 2, width: labelWidth, height: height)
        dateLabel = UILabel(frame: dateFrame)
        
        dateLabel.textAlignment = .left
        dateLabel.font = dateLabelFont
        dateLabel.textColor = UIColor.textGray
        dateLabel.numberOfLines = 0
        
        addSubviewIfNeeded(dateLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onHideResponder?()
    }
}
