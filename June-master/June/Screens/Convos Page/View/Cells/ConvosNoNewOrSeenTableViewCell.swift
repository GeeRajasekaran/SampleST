//
//  ConvosNoNewOrSeenTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 1/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class ConvosNoNewOrSeenTableViewCell: UITableViewCell {

    let itemLabel: UILabel = UILabel()
    let picView: UIImageView = UIImageView()
    var bottomSeperatorView: UIView?
    static let itemLabelWidth: CGFloat = 99
    static let itemLabelHeight: CGFloat = 27
    static let picViewWidth: CGFloat = 138
    static let picViewHeight: CGFloat = 148
    
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
        itemLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .extraMid)
        itemLabel.textColor = UIColor.init(hexString: "0F113A")
        contentView.addSubview(itemLabel)
        
        picView.contentMode = .scaleAspectFill
        contentView.addSubview(picView)
        
    }
    
    internal func setupConstraints() {
        picView.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView).offset(0.2 * UIScreen.size.height)
            make.leading.equalTo(contentView.snp.leading).offset((contentView.frame.size.width * 0.5) - (ConvosNoNewOrSeenTableViewCell.itemLabelWidth * 0.5))
            make.width.equalTo(ConvosNoNewOrSeenTableViewCell.picViewWidth)
            make.height.equalTo(ConvosNoNewOrSeenTableViewCell.picViewHeight)
        }
        
        itemLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(picView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(0)
            make.width.equalTo(UIScreen.size.width)
            make.height.equalTo(ConvosNoNewOrSeenTableViewCell.itemLabelHeight)
        }
    }
    
    override func prepareForReuse() {
        itemLabel.text = nil
        picView.layer.removeAllAnimations()
        picView.image = nil
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "ConvosNoNewOrSeenTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        var ht: CGFloat = 16
        ht += UIFont.systemFont(ofSize: 14).lineHeight
        ht += 16
        return ht
    }
    
    class func fixedHeight() -> CGFloat {
        let convosVC = ConvosViewController()
        if let tableView = convosVC.tableView {
            return tableView.frame.size.height
        }
        return 75
    }
    
    class func headerHeight() -> CGFloat {
        return 45
    }

}
