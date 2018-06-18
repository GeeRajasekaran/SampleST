//
//  RecipientViewBuilder.swift
//  June
//
//  Created by Ostap Holub on 2/23/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RecipientViewBuilder {
    
    class func view(for recipient: EmailReceiver, with rect: CGRect) -> RecipientItemView {
        if recipient.destination == .display {
            return self.displayRecipientView(with: recipient, in: rect)
        } else {
            return self.inputRecipientView(with: recipient, in: rect)
        }
    }
    
    private class func displayRecipientView(with recipient: EmailReceiver, in rect: CGRect) -> DisplayRecipientItemView {
        let view = DisplayRecipientItemView()
        view.frame = rect
        view.frame.size.width = self.dispalyWidth(of: recipient)
        view.setupViews(for: recipient)
        return view
    }
    
    private class func inputRecipientView(with recipient: EmailReceiver, in rect: CGRect) -> InputRecipientItemView {
        let view = InputRecipientItemView()
        view.frame = rect
        view.frame.size.width = self.inputWidth()
        view.setupViews(for: recipient)
        return view
    }
    
    // MARK: - Recipient view calculation
    
    private class func dispalyWidth(of recipient: EmailReceiver) -> CGFloat {
        var title = ""
        if recipient.name != "" {
            title = recipient.name ?? ""
        } else {
            title = recipient.email ?? ""
        }
        
        var titleWidth: CGFloat = 0
        if let font = UIFont(name: LocalizedFontNameKey.ResponderHelper.ReceiverTitleFont, size: 11) {
            titleWidth = title.width(usingFont: font) + 5
        }
        let totalWidth = 16 + titleWidth + 2 * 16
        return totalWidth
    }
    
    private class func inputWidth() -> CGFloat {
        return 0.4 * UIScreen.main.bounds.width
    }
}
