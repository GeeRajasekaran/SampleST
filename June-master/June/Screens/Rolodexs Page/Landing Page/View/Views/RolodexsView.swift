//
//  RolodexsView.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RolodexsView: UIView {

    let picView: UIImageView = UIImageView()
    let profileImageView: JuneImageView = JuneImageView(viewType: .circle)
    let fromLabel: UILabel = UILabel()
    let subjectLabel: UILabel = UILabel()
    let bodyLabel: UILabel = UILabel()
    let clearButton: UIButton = UIButton()
    let clearButtonOverlay: UIButton = UIButton()
    let dateLabel: UILabel = UILabel()
    let newCountLabel: UILabel = UILabel()
    let pinIconLabel: UILabel = UILabel()
    let placeholder = #imageLiteral(resourceName: "june_profile_pic_bg")
    static let imageSize: CGFloat = 36
    static let clearCircleSize: CGFloat = 20
    static let dateLabelWidth: CGFloat = 50
    var rolodexs: Rolodexs? = nil
    
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
        fromLabel.autoresizingMask = .flexibleHeight
        
        dateLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        dateLabel.textColor = UIColor.init(hexString: "B2B3B4")
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .right
        dateLabel.adjustsFontSizeToFitWidth = true
        addSubview(dateLabel)
        dateLabel.autoresizingMask = .flexibleHeight
        
        newCountLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .smallMedium)
        newCountLabel.textColor = UIColor.white
        newCountLabel.numberOfLines = 1
        newCountLabel.textAlignment = .center
        newCountLabel.adjustsFontSizeToFitWidth = true
        newCountLabel.backgroundColor = UIColor.init(hexString: "256CFF")
        addSubview(newCountLabel)
        newCountLabel.layer.cornerRadius = 5
        newCountLabel.clipsToBounds = true
        newCountLabel.autoresizingMask = .flexibleHeight
        
        pinIconLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        pinIconLabel.textColor = UIColor.init(hexString: "727B80")
        pinIconLabel.numberOfLines = 1
        addSubview(pinIconLabel)
        pinIconLabel.textAlignment = .right
        pinIconLabel.autoresizingMask = .flexibleHeight
        
        subjectLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
        subjectLabel.textColor = UIColor.init(hexString: "808092")
        subjectLabel.numberOfLines = 1
        addSubview(subjectLabel)
        subjectLabel.autoresizingMask = .flexibleHeight
        
        bodyLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        bodyLabel.textColor = UIColor.init(hexString: "808092")
        bodyLabel.numberOfLines = 1
        addSubview(bodyLabel)
        bodyLabel.autoresizingMask = .flexibleHeight
        
        clearButton.sizeToFit()
        clearButton.setImage( #imageLiteral(resourceName: "clear-circle"), for: .normal)
        clearButton.addTarget(self, action: #selector(ConvosView.clearButtonPressed(_:)), for: .touchUpInside)
        clearButton.autoresizingMask = .flexibleHeight
        
        clearButtonOverlay.sizeToFit()
        clearButtonOverlay.addTarget(self, action: #selector(ConvosView.clearButtonPressed(_:)), for: .touchUpInside)
        clearButtonOverlay.autoresizingMask = .flexibleHeight
        clearButtonOverlay.backgroundColor = .clear
    }
    
    func setupConstraints() {
        profileImageView.snp.remakeConstraints { (make) in
            make.width.equalTo(RolodexsView.imageSize)
            make.height.equalTo(RolodexsView.imageSize)
            make.top.equalTo(self).offset(16)
            make.leading.equalTo(self).offset(13)
        }
        profileImageView.layoutIfNeeded()
        
        fromLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(self).offset(12)
            make.trailing.equalTo(self).offset(-105)
        }
        fromLabel.layoutIfNeeded()
        
        dateLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(15)
            make.trailing.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(8)
            make.width.equalTo(RolodexsView.dateLabelWidth)
        }
        dateLabel.layoutIfNeeded()
        
        newCountLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(15)
            make.trailing.equalTo(self.dateLabel.snp.leading).offset(-5)
            make.top.equalTo(self.dateLabel.snp.top).offset(0)
            make.width.equalTo(41)
        }
        newCountLabel.layoutIfNeeded()
        
        subjectLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(fromLabel.snp.bottom)
            make.height.equalTo(17)
            make.leading.equalTo(fromLabel.snp.leading)
            make.trailing.equalTo(self).offset(-10)
        }
        subjectLabel.layoutIfNeeded()

        bodyLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(subjectLabel.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.leading.equalTo(fromLabel.snp.leading)
            make.trailing.equalTo(subjectLabel.snp.trailing)
        }
        bodyLabel.layoutIfNeeded()

    }
    
    func configure(rolodexs: Rolodexs) {
        self.rolodexs = rolodexs

        let dateInt = Int32(rolodexs.last_message_date)
        dateLabel.text = FeedDateConverter().timeAgoInWords(from: dateInt)
        let rolodexsVC = RolodexsViewController()
        let fromText = rolodexsVC.getRecipients(from: rolodexs)
        print("From Name = ", fromText as Any)
        if fromText.isEmpty {
            fromLabel.text = rolodexs.rolodexs_last_message_from?.name
        } else {
            fromLabel.text = fromText
        }
        if let imagePath = rolodexs.rolodexs_last_message_from?.profile_pic {
            profileImageView.configureImage(with: imagePath)
        } else {
            profileImageView.configurePlaceholder()
        }
        let starredPoolCount = rolodexs.starred_spool_count
        if rolodexs.last_message_unread == true {
            profileImageView.snp.remakeConstraints { (make) in
                make.width.equalTo(RolodexsView.imageSize)
                make.height.equalTo(RolodexsView.imageSize)
                make.top.equalTo(self).offset(16)
                make.leading.equalTo(self).offset(12)
            }
            profileImageView.layoutIfNeeded()
            fromLabel.snp.remakeConstraints { (make) in
                make.height.equalTo(20)
                make.leading.equalTo(profileImageView.snp.trailing).offset(8)
                make.top.equalTo(self).offset(12)
                make.trailing.equalTo(self).offset(-105)
            }
            subjectLabel.text = rolodexs.last_message_subject
            bodyLabel.text = rolodexs.last_message_snippet
            fromLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
            
            if starredPoolCount > 0 {
                subjectLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(fromLabel.snp.bottom)
                    make.height.equalTo(17)
                    make.leading.equalTo(fromLabel.snp.leading)
                    make.trailing.equalTo(self).offset(-40)
                }
                subjectLabel.layoutIfNeeded()
                bodyLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(subjectLabel.snp.bottom).offset(4)
                    make.height.equalTo(17)
                    make.leading.equalTo(fromLabel.snp.leading)
                    make.trailing.equalTo(subjectLabel.snp.trailing)
                }
                bodyLabel.layoutIfNeeded()
                pinIconLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(bodyLabel.snp.bottom).offset(-10)
                    make.height.equalTo(16)
                    make.width.equalTo(35)
                    make.trailing.equalTo(self).offset(-10)
                }
                pinIconLabel.layoutIfNeeded()
                pinIconLabel.isHidden = false

            } else {
                subjectLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(fromLabel.snp.bottom)
                    make.height.equalTo(17)
                    make.leading.equalTo(fromLabel.snp.leading)
                    make.trailing.equalTo(self).offset(-10)
                }
                subjectLabel.layoutIfNeeded()
                bodyLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(subjectLabel.snp.bottom).offset(4)
                    make.height.equalTo(17)
                    make.leading.equalTo(fromLabel.snp.leading)
                    make.trailing.equalTo(subjectLabel.snp.trailing)
                }
                bodyLabel.layoutIfNeeded()
                pinIconLabel.isHidden = true
            }
        } else {
            profileImageView.snp.remakeConstraints { (make) in
                make.width.equalTo(RolodexsView.imageSize)
                make.height.equalTo(RolodexsView.imageSize)
                make.top.equalTo(self).offset(12)
                make.leading.equalTo(self).offset(12)
            }
            profileImageView.layoutIfNeeded()
            fromLabel.snp.remakeConstraints { (make) in
                make.height.equalTo(RolodexsView.imageSize)
                make.leading.equalTo(profileImageView.snp.trailing).offset(8)
                make.top.equalTo(self).offset(12)
                make.trailing.equalTo(self).offset(-35)
            }
            fromLabel.layoutIfNeeded()
            fromLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
            
            if starredPoolCount > 0 {
                pinIconLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(fromLabel.snp.bottom).offset(-10)
                    make.height.equalTo(16)
                    make.width.equalTo(35)
                    make.trailing.equalTo(self).offset(-10)
                }
                pinIconLabel.layoutIfNeeded()
                pinIconLabel.isHidden = false
            } else {
                pinIconLabel.isHidden = true
            }
        }
        let unreadSpoolCount = rolodexs.unread_spool_count
        if unreadSpoolCount > 0 {
            newCountLabel.text = "\(unreadSpoolCount)" + " New"
            newCountLabel.isHidden = false
        } else {
            newCountLabel.isHidden = true
        }

        pinIconLabel.addIconBeforeStringToLabel(imageName: "office-push-pin", labelText: String(rolodexs.starred_spool_count), bounds_x: 0, bounds_y: 0, boundsWidth: Double(12), boundsHeight: Double(12))
    }
    
    @objc func clearButtonPressed(_ sender: UIButton) {
        clearButton.setImage(#imageLiteral(resourceName: "clear-circle-checked"), for: .normal)
    }
    
    func prepareForReuse() {
        fromLabel.text = nil
        bodyLabel.text = nil
        profileImageView.layer.removeAllAnimations()
        profileImageView.imageView.image = nil
        subjectLabel.text = nil
        clearButton.isHighlighted = false
        clearButton.setImage( #imageLiteral(resourceName: "clear-circle"), for: .normal)
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
        return 87
    }
    
    static func readCellHeight() -> CGFloat {
        return 60
    }

}
