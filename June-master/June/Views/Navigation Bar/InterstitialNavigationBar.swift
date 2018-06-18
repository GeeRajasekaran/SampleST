//
//  InterstitialNavigationBar.swift
//  Romio
//
//  Created by Arjun Busani on 11/7/17.
//  Copyright © 2017 HomePeople Corporation. All rights reserved.
//

import UIKit

class InterstitialNavigationBar: UIView {
    
    private var buttons: [UIButton] = []
    private static let BUTTON_HT: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        backgroundColor = .white
    }

    @discardableResult
    func addInterstitialBarButton(ofType type: NavigationButtonType, position: NavigationElementPosition, target: AnyObject?, action: Selector, color: UIColor = .black, shouldTint: Bool = true) -> UIButton {
        let button: UIButton = UIButton()
        switch type.style {
        case .icon:
            var buttonImage = UIImage(named: type.typeValue)
            if shouldTint {
                buttonImage = buttonImage?.withRenderingMode(.alwaysTemplate)
                button.imageView?.tintColor = color
            }
            button.setImage(buttonImage, for: UIControlState())
            button.sizeToFit()
            button.addTarget(target, action: action, for: .touchUpInside)
            break
            
        case .title:
            let fontInfo = UIFont.sfTextOfStyleAndSize(style: .semiBold, size: .largeMedium)
            button.setTitle(type.typeValue, for: .normal)
            button.sizeToFit()
            button.titleLabel?.font = fontInfo
            break
        }
        addSubview(button)
        
        button.snp.remakeConstraints { (make) in
            make.width.equalTo(button)
            make.height.equalTo(button)
            make.centerY.equalTo(self)
            switch position {
            case .left:
                make.left.equalTo(self).offset(UIView.midMargin)
                
            case .right:
                make.right.equalTo(self).offset(UIView.midMargin.inverse)
                
            case .center:
                make.centerX.equalTo(self)
            }
        }
        
        buttons.append(button)
        return button
    }
    
    func clearButtons() {
        buttons.forEach { (button) in
            button.removeFromSuperview()
        }
    }
    
    static func viewHeight() -> CGFloat {
        var ht: CGFloat = UIView.narrowMargin
        ht += BUTTON_HT
        ht += UIView.narrowMargin
        return ht
    }
}
