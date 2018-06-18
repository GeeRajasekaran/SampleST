//
//  Status.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/19/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

enum Status {
    case approved, ignored, blocked, denied, unblock
    
    var bgColor: UIColor {
        switch self {
        case .approved:
            return UIColor.approvedBackgroundBlue
        case .ignored:
            return UIColor.ignoredBackgroundGray
        case .blocked:
            return UIColor.blockedBackgroundRed
        case .denied:
            return UIColor.ignoredBackgroundGray
        case .unblock:
            return UIColor.ignoredBackgroundGray
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .approved:
            return .white
        case .ignored:
            return UIColor.ignoredTextGray
        case .blocked:
            return .white
        case .denied:
            return UIColor.ignoredTextGray
        case .unblock:
            return UIColor.ignoredBackgroundGray
        }
    }
    
    var image: UIImage? {
        switch self {
        case .approved:
            return UIImage(named: LocalizedImageNameKey.RequestsViewHelper.ApproveIconName)
        case .ignored:
            return UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BlockIconName)
        case .blocked:
            return UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BlockWhiteIconName)
        case .denied:
            return UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BlockIconName)
        case .unblock:
            return UIImage(named: LocalizedImageNameKey.RequestsViewHelper.BlockIconName)
        }
    }
    
    var font: UIFont? {
        return UIFont(name: LocalizedFontNameKey.RequestsViewHelper.SwipeButtonFont, size: 12)
    }
    
    var title: String {
        switch self {
        case .approved:
            return LocalizedStringKey.RequestsViewHelper.ApprovedTitile
        case .ignored:
            return LocalizedStringKey.RequestsViewHelper.IgnoredTitile
        case .blocked:
            return LocalizedStringKey.RequestsViewHelper.BlockedTitile
        case .denied:
            return LocalizedStringKey.RequestsViewHelper.DeniedTitile
        case .unblock:
            return LocalizedStringKey.RequestsViewHelper.UnblockedTitile
        }
    }
    
    var value: String {
        switch self {
        case .approved:
            return "approved"
        case .ignored:
            return "ignored"
        case .blocked:
            return "blocked"
        case .denied:
            return "blocked"
        case .unblock:
            return ""
        }
    }
}
