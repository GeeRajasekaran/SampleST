//
//  ResponderLayoutConstants.swift
//  June
//
//  Created by Ostap Holub on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

struct ResponderLayoutConstants {
    
    // MARK: - Initial heights for Responder
    
    struct Height {
        static let regularIntial: CGFloat = 146
        static let minimized: CGFloat = 102
        static let suggestions: CGFloat = 129
        static let attachments: CGFloat = 35
    }
    
    // MARK: - Height for state
    
    static func height(for state: ResponderState) -> CGFloat {
        if state == .regular {
            return Height.regularIntial
        } else if state == .minimized {
            return Height.minimized
        }
        return 0
    }
    
    // MARK: - Text input related constants
    
    struct TextInput {
        static let horizontalInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
    }
    
    // MARK: - Header view related constants
    
    struct Header {
        static let height: CGFloat = 44
        static let separatorInset: CGFloat = 14
        static let expandButtonWidth: CGFloat = 45
        
        static func height(for state: ResponderState) -> CGFloat {
            if state == .regular {
                return height
            } else if state == .minimized {
                return 1
            }
            return 0
        }
    }
    
    // MARK: - Action view with buttons
    
    struct ActionView {
        static let height: CGFloat = 48
        static let imageInsetTop: CGFloat = 10
        static let imageInsetRight: CGFloat = 1
        static let sendTrailing: CGFloat = -15
        static let sendDimension: CGFloat = 33
        static let thumbUpLeading: CGFloat = 10
        static let thumbUpWidth: CGFloat = 30
    }
    
    // MARK: - Minimized state constants
    
    struct Minimized {
        static let verticalInset: CGFloat = 10
        static let horizontalInset: CGFloat = 15
        static let cornerRadius: CGFloat = 15
        static let attachmentWitdth: CGFloat = 46
        static let thumbUpWidth: CGFloat = 43
        static let separatorVerticalInset: CGFloat = 2
        static let textLeading: CGFloat = 12
        static let textTrailing: CGFloat = -3
    }
}
