//
//  FavsView.swift
//  June
//
//  Created by Joshua Cleetus on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class FavsView: UIView {

    let picView: UIImageView = UIImageView()
    let profileImageView: JuneImageView = JuneImageView(viewType: .circle)
    let fromLabel: UILabel = UILabel()
    let newCountLabel: UILabel = UILabel()
    let pinIconLabel: UILabel = UILabel()
    let placeholder = #imageLiteral(resourceName: "june_profile_pic_bg")
    static let imageSize: CGFloat = 36
    var favorites: Favorites? = nil
    
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

    }
    
    func setupConstraints() {
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

        newCountLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(15)
            make.trailing.equalTo(self).offset(-5)
            make.top.equalTo(self).offset(8)
            make.width.equalTo(41)
        }
        newCountLabel.layoutIfNeeded()
            
    }
    
    func configure(favorites: Favorites) {
        self.favorites = favorites
        if let toArray = favorites.favorites_participants?.allObjects as? [Favorites_Participants], toArray.count > 0, let toObject: Favorites_Participants = toArray.first, let profile_pic = toObject.profile_pic {
            profileImageView.configureImage(with: profile_pic)
        } else {
            profileImageView.configurePlaceholder()
        }
        if let name = favorites.name {
            fromLabel.text = name
        }
        let unread = favorites.unread
        if unread {
            fromLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
        } else {
            fromLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
        }
        
        let unreadSpoolCount = favorites.unread_spool_count
        if unreadSpoolCount > 0 {
            newCountLabel.text = "\(unreadSpoolCount)" + " New"
            newCountLabel.isHidden = false
        } else {
            newCountLabel.isHidden = true
        }
        
        let starredPoolCount = favorites.starred_spool_count
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
        pinIconLabel.addIconBeforeStringToLabel(imageName: "office-push-pin", labelText: String(favorites.starred_spool_count), bounds_x: 0, bounds_y: 0, boundsWidth: Double(12), boundsHeight: Double(12))

    }
    
    func prepareForReuse() {

    }
    
    static func heightForView() -> CGFloat {
        var ht: CGFloat = 10
        ht += UIFont.boldSystemFont(ofSize: 14).lineHeight
        ht += 8
        ht += (UIFont.systemFont(ofSize: 13).lineHeight*3)
        return ht
    }
    
    static func fixedHeight() -> CGFloat {
        return 60
    }
}
