//
//  UITableViewCell+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

extension UITableViewCell {
    
    var seperatorHeight : CGFloat {
        get {
            return 1
        }
    }
    
    @discardableResult
    func setupStandardSeperator(with color: UIColor = .romioLightGray) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = color
        contentView.addSubview(seperator)
        seperator.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(UIView.midMargin)
            make.right.equalTo(contentView)
            make.height.equalTo(seperatorHeight)
            make.bottom.equalTo(contentView)
        }
        return seperator
    }
    
    @discardableResult
    func setupStandardSeperator(withOffset offset: CGFloat, bothSides: Bool = false, color: UIColor = .romioLightGray) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = color
        contentView.addSubview(seperator)
        seperator.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(offset)
            if bothSides {
                make.right.equalTo(contentView).offset(-offset)
            } else {
                make.right.equalTo(contentView)
            }
            make.height.equalTo(seperatorHeight)
            make.bottom.equalTo(contentView)
        }
        return seperator
    }
    
    @discardableResult
    func setupSeperator(leadingOffset: CGFloat, trailingOffset: CGFloat, color: UIColor = .romioLightGray) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = color
        contentView.addSubview(seperator)
        seperator.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(leadingOffset)
            make.right.equalTo(contentView).offset(-trailingOffset)
            make.height.equalTo(seperatorHeight)
            make.bottom.equalTo(contentView)
        }
        return seperator
    }
    @discardableResult
    func setupStandardSeperator(withOffset offset: CGFloat, bothSides: Bool = false, backgroundColor: UIColor, height: CGFloat) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = backgroundColor
        contentView.addSubview(seperator)
        seperator.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(offset)
            if bothSides {
                make.right.equalTo(contentView).offset(-offset)
            } else {
                make.right.equalTo(contentView)
            }
            make.height.equalTo(height)
            make.bottom.equalTo(contentView)
        }
        return seperator
    }
    
    func setupFullWidthSeperator(atPosition position: CGFloat, with color: UIColor = .romioLightGray) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = color
        contentView.addSubview(seperator)
        seperator.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(seperatorHeight)
            make.top.equalTo(contentView).offset(position)
        }
        return seperator
    }
    
    @discardableResult
    func setupStandardTopSeperator(with color: UIColor = .romioLightGray) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = color
        contentView.addSubview(seperator)
        seperator.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(UIView.midMargin)
            make.right.equalTo(contentView)
            make.height.equalTo(seperatorHeight)
            make.top.equalTo(contentView)
        }
        return seperator
    }
    
    @discardableResult
    func setupFullWidthSeperator(withColor color: UIColor = .romioLightGray, customConstraints: Bool = false) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = color
        contentView.addSubview(seperator)
        if !customConstraints {
            seperator.snp.remakeConstraints { (make) -> Void in
                make.left.equalTo(contentView)
                make.right.equalTo(contentView)
                make.height.equalTo(seperatorHeight)
                make.bottom.equalTo(contentView)
            }
        }
        return seperator
    }
    
    @discardableResult
    func setupArrowAccessoryView(color: UIColor? = nil) -> UIView {
        let accessoryView: UIView = UIView()
        contentView.addSubview(accessoryView)
        
        if let arrowImage = UIImage(named: "right-arrow") {
            var actualImage = arrowImage
            let imageView = UIImageView(image: actualImage)
            if let tintColor = color {
                actualImage = arrowImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                imageView.image = actualImage
                imageView.tintColor = tintColor
            }
            imageView.sizeToFit()
            imageView.center = accessoryView.center
            accessoryView.addSubview(imageView)
            
            imageView.snp.remakeConstraints({ (make) in
                make.center.equalTo(accessoryView)
            })
            
            accessoryView.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-UIView.midMargin)
                make.centerY.equalTo(contentView)
                make.width.equalTo(imageView)
                make.height.equalTo(imageView)
            }
        }
        
        return accessoryView
    }
    
    func setupCheckmarkAccessoryView() -> UIView {
        let accessoryView: UIView = UIView()
        contentView.addSubview(accessoryView)
        
        if let checkmarkImage = UIImage(named: "checkmark-icon") {
            let imageView = UIImageView(image: checkmarkImage)
            imageView.sizeToFit()
            imageView.center = accessoryView.center
            accessoryView.addSubview(imageView)
            
            imageView.snp.remakeConstraints({ (make) in
                make.center.equalTo(accessoryView)
            })
            
            accessoryView.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-UIView.midMargin)
                make.centerY.equalTo(contentView)
                make.width.equalTo(imageView)
                make.height.equalTo(imageView)
            }
        }
        
        return accessoryView
    }
    
    func setupRoundedCheckmarkAccessoryView() -> UIView {
        let accessoryView: UIView = UIView()
        contentView.addSubview(accessoryView)
        
        if let checkmarkImage = UIImage(named: "checkbox-green") {
            let imageView = UIImageView(image: checkmarkImage)
            imageView.sizeToFit()
            imageView.center = accessoryView.center
            accessoryView.addSubview(imageView)
            
            imageView.snp.remakeConstraints({ (make) in
                make.center.equalTo(accessoryView)
            })
            
            accessoryView.snp.remakeConstraints { (make) in
                make.right.equalTo(self).offset(-UIView.midMargin)
                make.centerY.equalTo(contentView)
                make.width.equalTo(imageView)
                make.height.equalTo(imageView)
            }
        }
        
        return accessoryView
    }
    
    func setupBorderedSeperator() -> UIView {
        let borderView = UIView()
        borderView.layer.borderColor = UIColor.romioLightGray.withAlphaComponent(0.8).cgColor
        borderView.layer.borderWidth = seperatorHeight*0.8
        borderView.layer.cornerRadius = 4.0
        contentView.addSubview(borderView)
        
        borderView.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(UIView.narrowMargin)
            make.right.equalTo(contentView).offset(-UIView.narrowMargin)
            make.top.equalTo(contentView).offset(UIView.narrowMargin)
            make.bottom.equalTo(contentView).offset(-UIView.narrowMargin)
        }
        return borderView
    }
    
    func setupSelectedCell() {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.selectedCellBackgroundColor
        selectedBackgroundView = selectedView
    }
    
    func addFeedDetailedViewSeparator() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(hexString: "CBCECE")
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorView)
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return separatorView
    }

}
