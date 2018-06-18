//
//  SwipeActionButtonBuilder.swift
//  June
//
//  Created by Ostap Holub on 11/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SwipeActionButtonBuilder {
    
    class func buildAttributedButton(with frame: CGRect) -> UIButton {
        
        let actionButton = UIButton(frame: frame)
        actionButton.backgroundColor = .white
        actionButton.layer.cornerRadius = frame.height / 2
        
        actionButton.layer.masksToBounds = false
        actionButton.layer.shadowRadius = 5.0
        actionButton.layer.shadowOpacity = 1.0
        actionButton.layer.shadowOffset = .zero
        actionButton.layer.shadowColor = UIColor.feedSwipeButtonShadowColor.cgColor
        
        return actionButton
    }
    
    class func buildTitle(for button: UIButton?, with size: CGSize) -> UILabel {
        guard let buttonFrame = button?.frame else { return UILabel() }
        let screenWidth = UIScreen.main.bounds.width
        let origin = CGPoint(x: buttonFrame.origin.x + buttonFrame.width / 2 - size.width / 2, y: buttonFrame.origin.y + buttonFrame.height + 0.018 * screenWidth)
        let labelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        
        let label = UILabel(frame: CGRect(origin: origin, size: size))
        label.textAlignment = .center
        label.textColor = UIColor.feedStarSwipeTitleColor
        label.font = labelFont
        
        return label
    }
    
}
