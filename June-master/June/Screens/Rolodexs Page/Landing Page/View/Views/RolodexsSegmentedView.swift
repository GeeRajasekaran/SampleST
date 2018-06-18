//
//  RolodexsSegmentedView.swift
//  June
//
//  Created by Joshua Cleetus on 3/29/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class RolodexsSegmentedView: UIView {

    var segmentControl: UISegmentedControl!
    let segments: [RolodexsSegmentType] = RolodexsSegmentType.segments
    var segmentTypes: [String] {
        get {
            var segs: [String] = []
            for s in segments {
                segs.append(s.stringValue())
            }
            return segs
        }
    }
    let segmentHorizontalOffset : CGFloat = UIView.midMargin
    static let segmentHeight: CGFloat = 48
    static let segmentWidth: CGFloat = 84
    var bottomSeperatorView: UIView?
    let filter: UIImageView = UIImageView()
    var unread: UIImageView = UIImageView()
    var pinned: UIImageView = UIImageView()

    init(frame: CGRect, headline: String) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        self.drawBottomSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        backgroundColor = .white
        
        filter.sizeToFit()
        filter.image = #imageLiteral(resourceName: "rolodex-filter")
        addSubview(filter)
        
        unread.contentMode = .scaleAspectFit
        unread.image = #imageLiteral(resourceName: "rolodex-unread-close")
        addSubview(unread)
        unread.isUserInteractionEnabled = true
        unread.isHidden = true
        
        pinned.contentMode = .scaleAspectFit
        pinned.image = #imageLiteral(resourceName: "rolodex-pinned-close")
        addSubview(pinned)
        pinned.isUserInteractionEnabled = true
        pinned.isHidden = true
        
        segmentControl = UISegmentedControl(items: segmentTypes)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = UIColor.clear
        segmentControl.backgroundColor = .clear
        segmentControl.sizeToFit()
        addSubview(segmentControl)

        let fontAttribute = [NSAttributedStringKey.font: UIFont.latoStyleAndSize(style: .bold, size: .regMid),
                             NSAttributedStringKey.foregroundColor: UIColor(red:0.18, green:0.22, blue:0.33, alpha:0.3)]
        let fontSelectedAttribute = [NSAttributedStringKey.font: UIFont.latoStyleAndSize(style: .bold, size: .regMid),
                             NSAttributedStringKey.foregroundColor: UIColor(red:0.18, green:0.22, blue:0.33, alpha:1.0)]

        segmentControl.setTitleTextAttributes(fontAttribute, for: .normal)
        segmentControl.setTitleTextAttributes(fontSelectedAttribute, for: .selected)
        
        if segmentControl.selectedSegmentIndex == 0 {
            self.filter.isHidden = false
        } else {
            self.filter.isHidden = true
        }
    }
    
    internal func setupConstraints() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        filter.snp.remakeConstraints { (make) in
            make.leading.equalTo(0.896 * screenWidth)
            make.width.equalTo(21)
            make.height.equalTo(16)
            make.top.equalTo(16)
        }
        unread.snp.remakeConstraints { (make) in
            make.trailing.equalTo(self).offset(-18)
            make.width.equalTo(70)
            make.height.equalTo(17)
            make.top.equalTo(15.5)
        }
        pinned.snp.remakeConstraints { (make) in
            make.trailing.equalTo(self).offset(-18)
            make.width.equalTo(70)
            make.height.equalTo(17)
            make.top.equalTo(15.5)
        }
        segmentControl.snp.remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.width.equalTo(RolodexsSegmentedView.segmentWidth * 2)
            make.top.equalTo(self)
            make.height.equalTo(RolodexsSegmentedView.segmentHeight)
        }
        segmentControl.setNeedsLayout()
    }
    
    class func heightForView() -> CGFloat {
        return segmentHeight
    }
}
