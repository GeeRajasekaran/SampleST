//
//  UILabel+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension UILabel {

    func addIconToLabel(imageName: String, labelText: String, bounds_x: Double, bounds_y: Double, boundsWidth: Double, boundsHeight: Double) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: bounds_x, y: bounds_y, width: boundsWidth, height: boundsHeight)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: labelText)
        string.append(attachmentStr)
        self.attributedText = string
    }
    
    func addIconBeforeStringToLabel(imageName: String, labelText: String, bounds_x: Double, bounds_y: Double, boundsWidth: Double, boundsHeight: Double) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: bounds_x, y: bounds_y, width: boundsWidth, height: boundsHeight)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        let spaceString = NSAttributedString(string: " ", attributes: [.font: self.font])
        mutableAttributedString.append(spaceString)
        let textString = NSAttributedString(string: labelText, attributes: [.font: self.font])
        mutableAttributedString.append(textString)
        
        self.attributedText = mutableAttributedString
    }

    
    func makeLabelTextPosition (sampleLabel :UILabel?, positionIdentifier : String) -> UILabel
    {
        let rect = sampleLabel!.textRect(forBounds: bounds, limitedToNumberOfLines: 0)
        
        switch positionIdentifier
        {
        case "VerticalAlignmentTop":
            sampleLabel?.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            break;
            
        case "VerticalAlignmentMiddle":
            sampleLabel?.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.width)
            break;
            
        case "VerticalAlignmentBottom":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height:  rect.size.height)
            break;
            
        default:
            sampleLabel!.frame = bounds;
            break;
        }
        return sampleLabel!
        
    }

}
