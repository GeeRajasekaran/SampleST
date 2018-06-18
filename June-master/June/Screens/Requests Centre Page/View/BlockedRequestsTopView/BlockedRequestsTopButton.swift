//
//  BlockedRequestsTopButton.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class BlockedRequestsTopButton: UIButton {

    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    
    private var titleFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    
    private var selectedImageColor = UIColor.requestsSelectedImageColor
    private var unSelectedImageColor = UIColor.requestsUnSelectedTitleColor
    private var selectedTextColor = UIColor.requestsSelectedTitleColor
    private var unselectedTextColor = UIColor.requestsUnSelectedTitleColor
    
    private var bottomViewOffset = 0.059 * UIScreen.main.bounds.width
    
    // MARK: - Views
    private var nameLabel: UILabel?
    private var itemImageView: UIImageView?
    private var bottomView: UIView?

    private var title: String
    var isTapped: Bool = true {
        didSet {
            nameLabel?.textColor = isTapped ? selectedTextColor : unselectedTextColor
            itemImageView?.tintColor = isTapped ? selectedImageColor : unSelectedImageColor
            bottomView?.isHidden = isTapped ? false : true
        }
    }
    
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        title = ""
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        title = ""
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        self.title = title
        setupView()
        updateFrame()
    }
    
    // MARK: - UI setup
    func setupView() {
        // any UI setup goes here
        addItemImage()
        addTitleLabel()
        addBottomView()
    }
    
    //MARK: - private part
    private func addTitleLabel() {
        if nameLabel != nil { return }
        let labelHeight = 0.045 * screenWidth
        let labelWidth = title.width(usingFont: titleFont)
        nameLabel = UILabel(frame: CGRect(x: 0.072 * screenWidth, y: frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight))
        nameLabel?.font = titleFont
        nameLabel?.textColor = selectedTextColor
        nameLabel?.text = title
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
    
    private func addItemImage() {
        if itemImageView != nil { return }
        let imageWidth = 0.043 * screenWidth
        let imageHeight = imageWidth
        itemImageView = UIImageView(frame: CGRect(x: 0.012 * screenWidth, y: frame.height/2 - imageHeight/2, width: imageWidth, height: imageHeight))
        itemImageView?.image = UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BlockIcon)
        itemImageView?.tintColor = UIColor.requestsSelectedImageColor
        if itemImageView != nil {
            addSubview(itemImageView!)
        }
    }
    
    private func addBottomView() {
        if bottomView != nil { return }
        let viewHeight = 0.008 * screenWidth
        bottomView = UIView(frame: CGRect(x: 0, y: frame.height - viewHeight, width: frame.width, height: viewHeight))
        bottomView?.backgroundColor = selectedImageColor
        if bottomView != nil {
            addSubview(bottomView!)
        }
        addBottomViewConstraint()
    }
    
    private func updateFrame() {
        let startedWidth = 0.112 * screenWidth
        if nameLabel != nil {
            frame.size.width = startedWidth + (nameLabel?.frame.width)!
        }
    }
    
    //MARK: - constraints
    private func addBottomViewConstraint() {
        bottomView?.translatesAutoresizingMaskIntoConstraints = false
        bottomView?.heightAnchor.constraint(equalToConstant: 0.008 * screenWidth).isActive = true
        bottomView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
