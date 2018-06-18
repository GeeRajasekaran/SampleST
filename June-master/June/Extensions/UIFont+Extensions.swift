//
//  UIFont+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

enum LatoStyle: String {
    case regular = "Lato-Regular"
    case bold = "Lato-Bold"
    case LightItalic = "Lato-LightItalic"
    case boldItalic = "Lato-BoldItalic"
    case black = "Lato-Black"
    case semibold = "Lato-Semibold"
}

enum RobotoStyle: String {
    case boldItalic = "Roboto-BoldItalic"
    case lightItalic = "Roboto-LightItalic"
    case mediumItalic = "Roboto-MediumItalic"
    case regular = "Roboto-Regular"
}

enum ProximaNovaStyle: String {
    case black = "ProximaNova-Black"
    case bold = "ProximaNova-Bold"
    case Extrabld = "ProximaNova-Extrabld"
    case light = "ProximaNova-Light"
    case regular = "ProximaNova-Regular"
    case semibold = "ProximaNova-Semibold"
}

enum AvenirStyle: String {
    case heavy = "Avenir-Heavy"
    case medium = "Avenir-Medium"
    case book = "Avenir-Book"
}

enum OpenSansStyle: String {
    case boldItalic = "OpenSans-BoldItalic"
    case regular = "OpenSans-Regular"
}

enum SFDisplayStyle: String {
    case light = "SFUIDisplay-Light"
    case regular = "SFUIDisplay-Regular"
    case bold = "SFUIDisplay-Bold"
}

enum SFTextStyle: String {
    case semiBold = "SFUIText-Semibold"
    case regular = "SFUIText-Regular"
}

enum FontSize: CGFloat {
    case extremelySmall = 7
    case smallMedium = 10
    case small = 11
    case midSmall = 12
    case regular = 13
    case regMid = 14
    case medium = 15
    case largeMedium = 16
    case mediumLarge = 17
    case large = 18
    case midLarge = 19
    case extra = 20
    case extraMid = 22
    case extraMidLarge = 23
    case extraMaxLarge = 24
    case midExtraLarge = 25
    case extraLarge = 28
}

struct FontInfo {
    let fontSize: FontSize
    let fontColor: UIColor
    let fontStyle: String
}

enum FontType {
    case title1
    case title2
    case headline
    case body
    case footnote
    
    func getFontInfo() -> FontInfo {
        switch self {
        case .title1:
            return FontInfo(fontSize: .extraLarge, fontColor: .black, fontStyle: SFDisplayStyle.light.rawValue)
            
        case .title2:
            return FontInfo(fontSize: .large, fontColor: .black, fontStyle: SFDisplayStyle.regular.rawValue)
            
        case .headline:
            return FontInfo(fontSize: .medium, fontColor: .black, fontStyle: SFTextStyle.semiBold.rawValue)
            
        case .body:
            return FontInfo(fontSize: .regular, fontColor: .black, fontStyle: SFTextStyle.regular.rawValue)
            
        case .footnote:
            return FontInfo(fontSize: .small, fontColor: .textGray, fontStyle: SFTextStyle.regular.rawValue)
        }
    }
}

extension UIFont {
    
    class func latoStyleAndSize(style: LatoStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func robotoStyleAndSize(style: RobotoStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func proximaNovaStyleAndSize(style: ProximaNovaStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func avenirStyleAndSize(style: AvenirStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func openSansStyleAndSize(style: OpenSansStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func fontOfType(_ type: FontType) -> (font: UIFont, suggestedColor: UIColor) {
        let fontInfo = type.getFontInfo()
        return (font: UIFont(name: fontInfo.fontStyle, size: fontInfo.fontSize.rawValue)!, suggestedColor: fontInfo.fontColor)
    }
    
    class func sfDisplayOfStyleAndSize(style: SFDisplayStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func sfTextOfStyleAndSize(style: SFTextStyle, size: FontSize) -> UIFont {
        return fontWith(style: style.rawValue, size: size)
    }
    
    class func fontWith(style: String, size: FontSize) -> UIFont {
        return UIFont(name: style, size: size.rawValue)!
    }
}
