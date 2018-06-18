//
//  ConvosClearedView.swift
//  June
//
//  Created by Joshua Cleetus on 1/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

protocol ConvosClearedViewDelegate: class {
    func convosClearedView(didTapItem sender: ConvosClearedView)
}

class ConvosClearedView: UIView {

    let profileImageView: JuneImageView = JuneImageView(viewType: .circle)
    let fromLabel: UILabel = UILabel()
    let subjectLabel: UILabel = UILabel()
    let bodyLabel: UILabel = UILabel()
    let clearButton: UIButton = UIButton()
    let clearButtonOverlay: UIButton = UIButton()
    let dateLabel = UILabel()
    let placeholder = #imageLiteral(resourceName: "june_profile_pic_bg")
    static let imageSize: CGFloat = 36
    static let clearCircleSize: CGFloat = 20
    static let dateLabelWidth: CGFloat = 70
    weak var delegate: ConvosClearedViewDelegate?
    var thread: Threads? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        
        profileImageView.sizeToFit()
        addSubview(profileImageView)
        
        fromLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
        fromLabel.textColor = UIColor.init(hexString: "28282C")
        fromLabel.numberOfLines = 1
        fromLabel.backgroundColor = UIColor.clear
        addSubview(fromLabel)
        
        dateLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regular)
        dateLabel.textColor = UIColor.init(hexString: "9A9CA2")
        dateLabel.numberOfLines = 1
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textAlignment = .right
        addSubview(dateLabel)
        
        subjectLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        subjectLabel.textColor = UIColor.black
        subjectLabel.numberOfLines = 1
        addSubview(subjectLabel)
        
        bodyLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        bodyLabel.textColor = UIColor.init(hexString: "5E5E5E")
        bodyLabel.numberOfLines = 1
        addSubview(bodyLabel)
        
        clearButton.sizeToFit()
        clearButton.setImage(#imageLiteral(resourceName: "clear-circle-checked"), for: .normal)
        clearButton.setImage( #imageLiteral(resourceName: "clear-circle"), for: .highlighted)
        clearButton.addTarget(self, action: #selector(ConvosClearedView.clearButtonPressed(_:)), for: .touchUpInside)
        addSubview(clearButton)
        
        clearButtonOverlay.sizeToFit()
        clearButtonOverlay.addTarget(self, action: #selector(ConvosClearedView.clearButtonPressed(_:)), for: .touchUpInside)
        addSubview(clearButtonOverlay)
        clearButtonOverlay.autoresizingMask = .flexibleHeight
        clearButtonOverlay.backgroundColor = .clear
    }
    
    func setupConstraints() {
        profileImageView.snp.remakeConstraints { (make) in
            make.width.equalTo(ConvosNewPreviewView.imageSize)
            make.height.equalTo(ConvosNewPreviewView.imageSize)
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(12)
        }
      
        profileImageView.layoutIfNeeded()
        
        fromLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(profileImageView.snp.top).offset(-3)
            make.trailing.equalTo(self).offset(-105)
        }
        fromLabel.layoutIfNeeded()
        
        dateLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(fromLabel.snp.trailing).offset(-5)
            make.top.equalTo(profileImageView.snp.top).offset(-3)
            make.width.equalTo(ConvosNewPreviewView.dateLabelWidth)
        }
        dateLabel.layoutIfNeeded()
        
        subjectLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(fromLabel.snp.bottom)
            make.height.equalTo(subjectLabel)
            make.leading.equalTo(fromLabel.snp.leading)
            make.trailing.equalTo(self).offset(-10)
        }
        
        bodyLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(subjectLabel.snp.bottom).offset(4)
            make.height.equalTo(bodyLabel)
            make.leading.equalTo(fromLabel.snp.leading)
            make.trailing.equalTo(subjectLabel.snp.trailing)
        }
        
        clearButton.snp.remakeConstraints { (make) in
            make.width.equalTo(ConvosView.clearCircleSize)
            make.height.equalTo(ConvosView.clearCircleSize)
            make.top.equalTo(self).offset(18)
            if UIScreen.isPhoneX {
                make.leading.equalTo(self).offset(348)
            } else if UIScreen.is6PlusOr6SPlus() {
                make.leading.equalTo(self).offset(380)
            } else {
                make.leading.equalTo(self).offset(348)
            }
        }
        
        clearButtonOverlay.snp.remakeConstraints { (make) in
            make.width.equalTo(ConvosView.clearCircleSize + 20)
            make.height.equalTo(ConvosView.clearCircleSize + 30)
            make.top.equalTo(self).offset(0)
            if UIScreen.isPhoneX {
                make.leading.equalTo(self).offset(348 - 10)
            } else if UIScreen.is6PlusOr6SPlus() {
                make.leading.equalTo(self).offset(380 - 10)
            } else {
                make.leading.equalTo(self).offset(348 - 10)
            }
        }
    }
    
    func configure(thread: Threads) {
        self.thread = thread
        subjectLabel.text = thread.subject
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
    
    @objc func clearButtonPressed(_ sender: UIButton) {
        clearButton.setImage(#imageLiteral(resourceName: "clear-circle"), for: .normal)
        if let delegate = self.delegate {
            delegate.convosClearedView(didTapItem: self)
        }
    }
    
    func prepareForReuse() {
        fromLabel.text = nil
        bodyLabel.text = nil
        profileImageView.layer.removeAllAnimations()
        profileImageView.imageView.image = nil
        subjectLabel.text = nil
        clearButton.isHighlighted = false
        clearButton.setImage( #imageLiteral(resourceName: "clear-circle-checked"), for: .normal)
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
        return 103
    }

}
