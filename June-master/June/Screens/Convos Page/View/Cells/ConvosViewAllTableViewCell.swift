//
//  ConvosViewAllTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 1/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ConvosViewAllTableViewCell: UITableViewCell {
    let itemLabel: UILabel = UILabel()
    var bottomSeperatorView: UIView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        backgroundColor = .white
        selectionStyle = .none
        
        itemLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .regular)
        itemLabel.textColor = UIColor.init(hexString:"7F7F7F")
        itemLabel.sizeToFit()
        contentView.addSubview(itemLabel)
        
        bottomSeperatorView = setupFullWidthSeperator()
    }
    
    internal func setupConstraints() {
        itemLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(0)
            make.trailing.equalTo(contentView).offset(0)
        }
    }
    
    override func prepareForReuse() {
        itemLabel.text = nil
        self.backgroundColor = UIColor.white
        itemLabel.backgroundColor = .white
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "ConvosViewAllTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        var ht: CGFloat = 16
        ht += UIFont.systemFont(ofSize: 14).lineHeight
        ht += 16
        return ht
    }
    
    class func fixedHeight() -> CGFloat {
        return 103
    }
    
    class func headerHeight() -> CGFloat {
        return 45
    }
    
    class func footerHeight() -> CGFloat {
        return 35
    }
}
