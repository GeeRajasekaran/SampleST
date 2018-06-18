//
//  SpoolMessageHeaderView.swift
//  June
//
//  Created by Ostap Holub on 4/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit
import Haneke

class SpoolMessageHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var profileIcon: UIImageView?
    private var dateLabel: UILabel?
    private var senderLabel: UILabel?
    
    var nameLeading: ConstraintItem? {
        return senderLabel?.snp.leading
    }
    
    var nameX: CGFloat {
        return senderLabel?.frame.minX ?? 0
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        backgroundColor = .white
        addProfileIcon()
        addDateLabel()
        addSenderLabel()
    }
    
    
    // MARK: - Model loading
    
    func load(_ model: SpoolMessageInfo) {
        if let url = model.profileIconUrl {
            profileIcon?.hnk_setImageFromURL(url)
        }
        senderLabel?.text = model.senderName
        if let tmsp = model.date {
            dateLabel?.text = FeedDateConverter().timeAgoInWords(from: tmsp)
        }
    }
    
    // MARK: - Private profile icon setup
    
    private func addProfileIcon() {
        guard profileIcon == nil else { return }
        
        let dimension: CGFloat = 0.082 * screenWidth
        let iconFrame = CGRect(x: 0.032 * screenWidth, y: 0.032 * screenWidth, width: dimension, height: dimension)
        
        profileIcon = UIImageView(frame: iconFrame)
        profileIcon?.layer.cornerRadius = dimension / 2
        profileIcon?.contentMode = .scaleAspectFit
        profileIcon?.clipsToBounds = true
        
        if profileIcon != nil {
            addSubview(profileIcon!)
        }
    }
    
    // MARK: - Private date label setup
    
    private func addDateLabel() {
        guard dateLabel == nil else { return }
        
        dateLabel = UILabel()
        dateLabel?.translatesAutoresizingMaskIntoConstraints = false
        dateLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        dateLabel?.textColor = UIColor(hexString: "9A9CA2")
        dateLabel?.textAlignment = .right
        
        if dateLabel != nil {
            addSubview(dateLabel!)
            dateLabel?.snp.makeConstraints { [weak self] make in
                guard let centerY = self?.profileIcon?.snp.centerY else { return }
                make.trailing.equalToSuperview().offset(-12)
                make.width.greaterThanOrEqualTo(48)
                make.centerY.equalTo(centerY)
            }
        }
    }
    
    // MARK: - Private sender label setup
    
    private func addSenderLabel() {
        guard senderLabel == nil else { return }
        
        senderLabel = UILabel()
        senderLabel?.translatesAutoresizingMaskIntoConstraints = false
        senderLabel?.font = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        senderLabel?.textColor = UIColor(hexString: "0E0E0E")
        senderLabel?.textAlignment = .left
        
        if senderLabel != nil {
            addSubview(senderLabel!)
            senderLabel?.snp.makeConstraints { [weak self] make in
                guard let left = self?.profileIcon?.snp.trailing,
                    let right = self?.dateLabel?.snp.leading,
                    let top = self?.profileIcon?.snp.top else { return }
                
                make.leading.equalTo(left).offset(8)
                make.trailing.equalTo(right).offset(-8)
                make.top.equalTo(top)
            }
        }
    }
}
