//
//  LabelItemTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 12/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class LabelItemTableViewCell: UITableViewCell {
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
        contentView.backgroundColor = UIColor.init(hexString:"F8FAFA")
        selectionStyle = .none
        
        itemLabel.backgroundColor = UIColor.init(hexString:"F8FAFA")
        itemLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
        itemLabel.sizeToFit()
        contentView.addSubview(itemLabel)
        
        bottomSeperatorView = setupFullWidthSeperator()
    }
    
    internal func setupConstraints() {
        itemLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    override func prepareForReuse() {
        itemLabel.text = nil
        itemLabel.backgroundColor = UIColor.init(hexString:"F8FAFA")
        contentView.backgroundColor = UIColor.init(hexString:"F8FAFA")
        self.backgroundColor = .white
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "LabelItemTableViewCell"
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
}

