//
//  BriefReqeustsInfo.swift
//  June
//
//  Created by Ostap Holub on 1/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefReqeustsInfo: BaseTableModel {
    
    // MARK: - Variables
    
    private var names: [String]
    var buttonTitle: String
    
    var message: NSAttributedString {
        get { return attributedMessage() }
    }
    
    // MARK: - Initialization
    
    init(names: [String]) {
        self.names = names
        self.buttonTitle = LocalizedStringKey.FeedBriefHelper.ViewButtonTitle
    }
    
    // MARK: - Attributed string building logic
    
    private func attributedMessage() -> NSAttributedString {
        let reqeusts = names.count == 1 ? LocalizedStringKey.FeedBriefHelper.PendingRequestsSingle : LocalizedStringKey.FeedBriefHelper.PendingRequestsPlural
        let initialString = NSString(string: "\(names.count) \(reqeusts) \(names.joined(separator: ", "))")
        let finalString = NSMutableAttributedString(string: initialString as String)
        
        let range = initialString.range(of: "\(names.count) \(reqeusts)")
        finalString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        finalString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .bold, size: .midSmall), range: range)
        
        names.forEach { name in
            let range = initialString.range(of: name)
            finalString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
            finalString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .black, size: .midSmall), range: range)
        }
        
        let fullRange = NSRange(location: 0, length: initialString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.7
        paragraphStyle.lineBreakMode = .byTruncatingTail
        finalString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        return finalString
    }
}
