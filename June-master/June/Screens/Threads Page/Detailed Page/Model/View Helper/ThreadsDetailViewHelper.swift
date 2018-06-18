//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

struct ThreadsDetailViewHelper {
    
    let tableViewCellHeight : CGFloat = 75
    let tableViewNumberOfSections : Int = 1
    let tableViewHeaderHeight : CGFloat = 66
    
    func heightForLabel(_ text: String, font: UIFont, width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        if lineSpacing > 0.0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = .center
            label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.paragraphStyle: style])
        } else {
            label.text = text
        }
        label.sizeToFit()
        return label.frame.height
    }
    
}
