//
//  NSMutableAttributedString+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    class func colorizeTextInString(mainString string: String, stringToColorize: String, color: UIColor) -> NSAttributedString {
        
        let range = (string as NSString).range(of: stringToColorize)
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        return attributedString
    }
    
    class func colorizeTextInString(mainString string: String, stringToColorize: String, color: UIColor, font: UIFont, attributes: [NSAttributedStringKey: Any]) -> NSMutableAttributedString {
        
        let range = (string as NSString).range(of: stringToColorize)
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        return attributedString
    }
    
    class func linkTextInString(mainString string: String, stringToLink: String, link: URL, attributes: [NSAttributedStringKey: Any]) -> NSMutableAttributedString {
        let range = (string as NSString).range(of: stringToLink)
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.addAttribute(NSAttributedStringKey.link, value: link, range: range)
        return attributedString
    }

    func linkTextInString(stringToLink string: String, link: URL) {
        let range = (self.string as NSString).range(of: string)
        self.addAttribute(NSAttributedStringKey.link, value: link, range: range)
    }
}
