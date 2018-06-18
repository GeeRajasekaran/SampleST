//
//  SpoolItemStyleBuilder.swift
//  June
//
//  Created by Ostap Holub on 4/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolItemStyleBuilder {
    
    class func style(for spoolItem: SpoolItemInfo) -> SpoolItemStyle {
        return spoolItem.unread ? unreadStyle() : readStyle()
    }

    class func readStyle() -> SpoolItemStyle {
        let subjectFont = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
        let senderFont = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        return SpoolItemStyle(subjectFont: subjectFont, senderFont: senderFont, backgroundColor: UIColor(hexString: "F8F9F9"))
    }
    
    class func unreadStyle() -> SpoolItemStyle {
        let subjectFont = UIFont.latoStyleAndSize(style: .black, size: .mediumLarge)
        let senderFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        return SpoolItemStyle(subjectFont: subjectFont, senderFont: senderFont, backgroundColor: .white)
    }
}
