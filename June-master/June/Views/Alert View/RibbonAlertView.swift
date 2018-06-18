//
//  RibbonAlertView.swift
//  Joshua
//
//  Created by Joshua Cleetus on 4/10/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import UIKit
import SnapKit

enum RibbonAlertType: String {
    case genericError = "genericError"
    case userActionAlert = "userActionAlert"
}

enum RibbonAlertPresentationType: Int {
    case withNavBar
    case withoutNavBar
}

class RibbonAlertView: UIView {

    var attributedText: NSAttributedString
    var alertType = RibbonAlertType.genericError
    
    let ribbonAlertViewLabel = UILabel()
    static let ribbonLabelCenterOffset: CGFloat = 10.0
    static let font = UIFont.sfDisplayOfStyleAndSize(style: SFDisplayStyle.regular, size: .medium)

    static let ribbonAlertHeightTopOffset : CGFloat = 20.0

    static func ribbonHeight(text: String) -> CGFloat {
        let textWidthPercent = UIScreen.size.width - (ribbonLabelCenterOffset*2)
        let computedHeight = text.height(withConstrainedWidth: textWidthPercent, font: font)
        let additionalOffset: CGFloat = UIScreen.isPhoneX ? RibbonAlertView.ribbonAlertHeightTopOffset : 0
        return computedHeight + (ribbonAlertHeightTopOffset*2) + additionalOffset
    }
    
    var leftPadding: CGFloat {
        get {
            return self.frame.width*0.07
        }
    }

    weak var delegate: RibbonAlertDelegate?

    init(frame: CGRect, alertType: RibbonAlertType, attributedText: NSAttributedString) {
        self.attributedText = attributedText
        super.init(frame: frame)
        self.frame = frame
        setup(alertType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ ribbonAlertType : RibbonAlertType) {
        ribbonAlertViewLabel.attributedText = attributedText
        ribbonAlertViewLabel.textAlignment = NSTextAlignment.center
        ribbonAlertViewLabel.textColor = .white
        ribbonAlertViewLabel.numberOfLines = 0
        ribbonAlertViewLabel.font = RibbonAlertView.font
        ribbonAlertViewLabel.adjustsFontSizeToFitWidth = true
        addSubview(ribbonAlertViewLabel)
        
        ribbonAlertViewLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-RibbonAlertView.ribbonLabelCenterOffset)
            make.leading.equalTo(self).offset(RibbonAlertView.ribbonLabelCenterOffset)
            make.trailing.equalTo(self).offset(-RibbonAlertView.ribbonLabelCenterOffset)
            make.height.equalTo(ribbonAlertViewLabel)
        }
        
        switch (ribbonAlertType) {
        case .genericError:
            backgroundColor = .notificationRed
            break
            
        case .userActionAlert:
            backgroundColor = .notificationRed
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(RibbonAlertView.didTap(_:)))
            tapRecognizer.cancelsTouchesInView = false
            addGestureRecognizer(tapRecognizer)
            break
        }
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.ribbonAlertDidTapView(sender: self)
        }
    }
}
