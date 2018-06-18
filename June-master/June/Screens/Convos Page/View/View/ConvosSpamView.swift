//
//  ConvosSpamView.swift
//  June
//
//  Created by Tatia Chachua on 31/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

protocol ConvosSpamViewDelegate: class {
    func convosSpamView(didTapItem sender: ConvosSpamView)
}

class ConvosSpamView: UIView {
    
    let profileImageView: JuneImageView = JuneImageView(viewType: .circle)
    let fromLabel: UILabel = UILabel()
    let bodyLabel: UILabel = UILabel()
    let dateLabel = UILabel()
    let warningIcon = UIImageView()
    
    static let imageSize: CGFloat = 36
    static let clearCircleSize: CGFloat = 20
    static let dateLabelWidth: CGFloat = 65
    weak var delegate: ConvosSpamViewDelegate?
    var thread: Threads? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        profileImageView.sizeToFit()
        addSubview(profileImageView)
        
        dateLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regular)
        dateLabel.textColor = UIColor.init(hexString: "000000")
        dateLabel.numberOfLines = 1
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textAlignment = .right
        addSubview(dateLabel)
        
        fromLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
        fromLabel.textColor = UIColor.init(hexString: "000000")
        fromLabel.numberOfLines = 1
        fromLabel.backgroundColor = UIColor.clear
        addSubview(fromLabel)
        
        bodyLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        bodyLabel.textColor = UIColor.init(hexString: "5E5E5E")
        bodyLabel.numberOfLines = 0
        addSubview(bodyLabel)
        
        warningIcon.image = #imageLiteral(resourceName: "warning")
        addSubview(warningIcon)
    }
    
    func setupConstraints() {
        profileImageView.snp.remakeConstraints { (make) in
            make.width.equalTo(ConvosNewPreviewView.imageSize)
            make.height.equalTo(ConvosNewPreviewView.imageSize)
            make.top.equalTo(self).offset(19)
            make.leading.equalTo(self).offset(12)
        }
        profileImageView.layoutIfNeeded()
        
        dateLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(fromLabel.snp.trailing).offset(11)
            make.top.equalTo(profileImageView.snp.top)
            make.width.equalTo(60)
        }
        dateLabel.layoutIfNeeded()
        
        fromLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(profileImageView.snp.top).offset(-3)
            make.trailing.equalTo(self).offset(-105)
        }
        fromLabel.layoutIfNeeded()
        
        bodyLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(fromLabel.snp.bottom).offset(-2)
            make.height.equalTo(41)
            make.leading.equalTo(fromLabel.snp.leading)
            make.trailing.equalTo(self).offset(-13)
        }
        
        warningIcon.snp.remakeConstraints { (make) in
            make.top.equalTo(17.5)
            make.height.equalTo(17)
            make.leading.equalTo(self.snp.trailing).offset(-27)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
        }
    }
    
    func configure(thread: Threads) {
        self.thread = thread
        bodyLabel.text = thread.summary
        if let imagePath = thread.threads_avatar?.profile_pic {
            profileImageView.configureImage(with: imagePath)
        } else {
            profileImageView.configurePlaceholder()
        }
        let dateInt = thread.last_message_timestamp
        dateLabel.text = FeedDateConverter().timeAgoInWords(from: dateInt)
        let convosVC = ConvosViewController()
        let fromText = convosVC.getRecipients(from : thread)
        if fromText.isEmpty {
            fromLabel.text = thread.last_message_from?.name
        } else {
            fromLabel.text = fromText
        }
    }
    
    func prepareForReuse() {
        fromLabel.text = nil
        bodyLabel.text = nil
        profileImageView.layer.removeAllAnimations()
        profileImageView.imageView.image = nil
        dateLabel.text = nil
        
    }

    static func heightForView() -> CGFloat {
        var ht: CGFloat = 10
        ht += UIFont.boldSystemFont(ofSize: 14).lineHeight
        ht += 8
        ht += (UIFont.systemFont(ofSize: 13).lineHeight*3)
        return ht
    }
    
    static func fixedHeight() -> CGFloat {
        return 95
    }
}
