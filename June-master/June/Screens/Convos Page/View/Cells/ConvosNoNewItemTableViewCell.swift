//
//  ConvosNoNewItemTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ConvosNoNewItemTableViewCell: UITableViewCell {

    let itemLabel: UILabel = UILabel()
    let picView: UIImageView = UIImageView()
    var bottomSeperatorView: UIView?
    static let itemLabelWidth: CGFloat = 99
    static let itemLabelHeight: CGFloat = 21
    static let picViewWidth: CGFloat = 77
    static let picViewHeight: CGFloat = 52
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        contentView.backgroundColor = UIColor.white
        selectionStyle = .none
        
        itemLabel.backgroundColor = .clear
        itemLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
        itemLabel.textColor = .black
        itemLabel.sizeToFit()
        contentView.addSubview(itemLabel)
        
        picView.sizeToFit()
        contentView.addSubview(picView)
        
        bottomSeperatorView = setupFullWidthSeperator()
    }
    
    internal func setupConstraints() {
        itemLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView).offset(25)
            make.leading.equalTo(contentView).offset(101)
            make.width.equalTo(ConvosNoNewItemTableViewCell.itemLabelWidth)
            make.height.equalTo(ConvosNoNewItemTableViewCell.itemLabelHeight)
        }
        
        picView.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(contentView).offset(214)
            make.width.equalTo(ConvosNoNewItemTableViewCell.picViewWidth)
            make.height.equalTo(ConvosNoNewItemTableViewCell.picViewHeight)
        }
    }
    
    override func prepareForReuse() {
        itemLabel.text = nil
        picView.layer.removeAllAnimations()
        picView.image = nil
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "ConvosNoNewItemTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        var ht: CGFloat = 16
        ht += UIFont.systemFont(ofSize: 14).lineHeight
        ht += 16
        return ht
    }
    
    class func fixedHeight() -> CGFloat {
        return 75
    }
    
    class func headerHeight() -> CGFloat {
        return 45
    }

}
