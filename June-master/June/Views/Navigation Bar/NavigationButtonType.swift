//
//  NavigationButtonType.swift
//  June
//
//  Created by Joshua Cleetus on 12/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

enum NavigationButtonStyle {
    case icon
    case title
}

enum NavigationElementPosition {
    case left
    case right
    case center
}

enum NavigationBarTitleType {
    case search
    case title
    case logo
    case custom
}

enum NavigationButtonType: String {
    case close
    case xIcon
    case cancel
    case back
    case delete
    case reply
    case more
    case add
    case done
    case claim
    case send
    case save
    case edit
    case next
    case load
    case skip
    case plus
    case askQuestion
    case ask
    case customButton
    case circleX
    case settings
    
    var style: NavigationButtonStyle {
        get {
            switch self {
            case .back, .reply, .more, .xIcon, .circleX:
                return .icon
                
            default:
                return .title
                
            }
        }
    }
    
    var typeValue: String {
        get {
            switch self {
            case .close:
                return Localized.string(forKey: .NavBarClose)
                
            case .xIcon:
                return "close-icon"
                
            case .cancel:
                return Localized.string(forKey: .NavBarCancel)
                
            case .back:
                return "back-icon"
                
            case .delete:
                return Localized.string(forKey: .NavBarDelete)
                
            case .reply:
                return "reply-icon"
                
            case .more:
                return "more-icon"
                
            case .add:
                return Localized.string(forKey: .NavBarAdd)
                
            case .done:
                return Localized.string(forKey: .NavBarDone)
                
            case .claim:
                return Localized.string(forKey: .NavBarClaim)
                
            case .send:
                return Localized.string(forKey: .NavBarSend)
                
            case .save:
                return Localized.string(forKey: .NavBarSave)
                
            case .edit:
                return Localized.string(forKey: .NavBarEdit)
                
            case .next:
                return Localized.string(forKey: .NavBarNext)
                
            case .load:
                return Localized.string(forKey: .NavBarLoad)
                
            case .skip:
                return "Skip"
                
            case .plus:
                return "+"
                
            case .askQuestion:
                return "Ask a Question"
                
            case .ask:
                return "+ Ask"
            case .customButton:
                return ""
                
            case .circleX:
                return "Clear"
                
            case .settings:
                return "Settings"
                
            }
        }
    }
}

