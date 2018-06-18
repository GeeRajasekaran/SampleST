//
//  UIColor+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

typealias GradientType = (x: CGPoint, y: CGPoint)

enum GradientPoint {
    case leftRight
    case rightLeft
    case topBottom(offset: CGFloat)
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
    var draw: GradientType {
        switch self {
        case .leftRight:
            return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
        case .topBottom(let offset):
            let xOffset = offset
            return (x: CGPoint(x: xOffset, y: 0), y: CGPoint(x: xOffset, y: 1))
        case .bottomTop:
            return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
        }
    }
}

extension UIColor {
    
    // --- Black ---
    
    open class var todayFeedHeaderBlack: UIColor {
        return UIColor(red: 44/255.0, green: 44/255.0, blue: 44/255.0, alpha: 1.0)
    }
    
    open class var yesterdayFeedHeaderColor: UIColor {
        //#82848E
        return UIColor(red: 45/255.0, green: 56/255.0, blue: 85/255.0, alpha: 1.0)
    }
    
    open class var categoriesCollectionBackgroundColor: UIColor {
        return UIColor(hexString: "FCFDFD")
    }
    
    open class var categoriesCollectionShadowColor: UIColor {
        return UIColor(hexString: "EEEEEE")
    }
    
    open class var tableViewBackgroundStartColor: UIColor {
        return UIColor(hexString: "E0E0E0").withAlphaComponent(0.7)
    }
    
    open class var tableViewBackgroundEndColor: UIColor {
        return UIColor(hexString: "FCFDFD")
    }
    
    // --- Red ---
    
    open class var bookmarkedSwitchRed: UIColor {
        return UIColor(red: 28/255.0, green: 102/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    open class var attachmentRed: UIColor {
        //hex #FF8181
        return UIColor(red: 255/255.0, green: 129/255.0, blue: 129/255.0, alpha: 1.0)
    }
    
    open class var amazonCardActionColor: UIColor {
        //hex #FF9900
        return UIColor(red: 255/255.0, green: 155/255.0, blue: 0/255.0, alpha: 1.0)
    }

    open class var notificationRed: UIColor {
        //hex #ed4e3e
        return UIColor(red: 237/255.0, green: 78/255.0, blue: 62/255.0, alpha: 1.0)
    }
    
    open class var unreadCountRed: UIColor {
        //hex #F45B9C
        return UIColor(red: 244/255.0, green: 91/255.0, blue: 156/255.0, alpha: 1.0)
    }
    
    open class var blockedTextRed: UIColor {
        //hex #FF6C7E
        return UIColor(red: 255/255.0, green: 108/255.0, blue: 126/255.0, alpha: 1.0)
    }
    
    open class var blockedBackgroundRed: UIColor {
        //hex #FF9CBE
        return UIColor(red: 255/255.0, green: 156/255.0, blue: 190/255.0, alpha: 1.0)
    }
    
    open class var actionButtonTitleColor: UIColor {
        return UIColor(red: 111/255.0, green: 111/255.0, blue: 251/255.0, alpha: 1.0)
    }
    
    // --- Gray ---
    
    open class var recategorizeTitleDarkGray: UIColor {
        return UIColor(red: 57/255.0, green: 59/255.0, blue: 68/255.0, alpha: 1.0)
    }
    
    open class var recategorizeTitleLightGray: UIColor {
        return UIColor(red: 143/255.0, green: 143/255.0, blue: 143/255.0, alpha: 1.0)
    }
    
    open class var swipeBackgroundColor: UIColor {
        return UIColor(red: 178/255.0, green: 181/255.0, blue: 204/255.0, alpha: 0.13)
    }
    
    open class var eventTimeLabelColor: UIColor {
        //hex 4A4A4A
        return UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
    }
    
    open class var estimatedToArriveColor: UIColor {
        //hex 868686
        return UIColor(red: 134/255.0, green: 134/255.0, blue: 134/255.0, alpha: 1.0)
    }
    
    open class var whiteShadowColor: UIColor {
        return UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.05)
    }
    
    open class var minimizedPlaceholderGray: UIColor {
        return UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
    }
    
    open class var suggestionsBackgroundColor: UIColor {
        // hex FCFCFC
        return UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
    }
    
    open class var senderEmailsBackgroundGray: UIColor {
        // hex F6F6F7
        return UIColor(red: 246/255.0, green: 246/255.0, blue: 247/255.0, alpha: 1.0)
    }
    
    open class var composeTitleGray: UIColor {
        //hex #797A83
        return UIColor(red: 121/255.0, green: 122/255.0, blue: 131/255.0, alpha: 1.0)
    }
    
    open class var suggestedReceiverGrey: UIColor {
        return UIColor(red: 159/255.0, green: 159/255.0, blue: 159/255.0, alpha: 1.0)
    }
    
    open class var composeReceiverBorderColor: UIColor {
        //hex #d6d6d6
        return UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0)
    }
    
    open class var receiverTitleGrey: UIColor {
        //hex 404040
        return UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    }
    
    open class var receiverBorderGrey: UIColor {
        //hex c4c5c9
        return UIColor(red: 196/255.0, green: 197/255.0, blue: 201/255.0, alpha: 1.0)
    }
    
    open class var responderTextColor: UIColor {
        //hex 373737
        return UIColor(red: 37/255.0, green: 37/255.0, blue: 37/255.0, alpha: 1.0)
    }
    
    open class var textGray: UIColor {
        //hex #8c8c8c
        return UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
    }
    
    open class var backgroundLightGray: UIColor {
        //hex #f9f9f9
        return UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
    }
    
    open class var disabledTextGray: UIColor {
        //hex #c9cdd2
        return UIColor(red: 201/255.0, green: 205/255.0, blue: 210/255.0, alpha: 1.0)
    }

    open class var backgroundGray: UIColor {
        //hex #efeff4
        return UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
    }
    
    open class var romioLightGray: UIColor {
        //hex #eaeaeb
        return UIColor(red: 234/255.0, green: 234/255.0, blue: 235/255.0, alpha: 1.0)
    }
    
    open class var juneRolodexSeparatorGray: UIColor {
        //hex #eaeaeb
        return UIColor(red: 243/255.0, green: 244/255.0, blue: 245/255.0, alpha: 1.0)
    }
    
    @nonobjc class var romioBattleshipGreyText: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 118.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
    }

    open class var romioCoolGreyTwo: UIColor {
        return UIColor(red: 169.0 / 255.0, green: 191.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
    }
    
    open class var participantsLabelGray: UIColor {
        //hex #A8A9AE
        return UIColor(red: 168/255.0, green: 169/255.0, blue: 174/255.0, alpha: 1.0)
    }
    
    open class var composeReceiverLabelGray: UIColor {
        //hex #2F373B
        return UIColor(red: 47/255.0, green: 55/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    open class var romioGray: UIColor {
        //hex #959595
        return UIColor(red: 149/255.0, green: 149/255.0, blue: 149/255.0, alpha: 1.0)
    }
    
    open class var shadowGray: UIColor {
        //hex #DBDBE1
        return UIColor(red: 219/255.0, green: 219/255.0, blue: 225/255.0, alpha: 0.85)
    }
    
    open class var categoryTitleGray: UIColor {
        //hex # 9B9B9B
        return UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
    }
    
    open class var categoryGray: UIColor {
        //hex #89889F
        return UIColor(red: 137/255.0, green: 136/255.0, blue: 159/255.0, alpha: 1.0)
    }
    
    open class var tableHeaderTitleGray: UIColor {
        //hex #404040
        return UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    }
    
    open class var feedCardCategoryIconColor: UIColor {
        return UIColor(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0)
    }
    
    open class var newsCardBorderGray: UIColor {
        //hex #e2e2e6
        return UIColor(red: 226/255.0, green: 226/255.0, blue: 230/255.0, alpha: 1.0)
    }
    
    open class var newsCardSeparatorGray: UIColor {
        //hex #eeeeee
        return UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    }
    
    open class var bottomShadowColor: UIColor {
        //hex #e1e1e1
        return UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 0.6)
    }
    
    open class var vendorImageViewBorderColor: UIColor {
        //hex #DEDEE3
        return UIColor(red: 222/255.0, green: 222/255.0, blue: 227/255.0, alpha: 1.0)
    }
    
    open class var composeToFieldTextColor: UIColor {
        //hex #2F373B
        return UIColor(red: 47/255.0, green: 55/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    open class var unselectedTitleColor: UIColor {
        //hex #797A83
        return UIColor(red: 121/255.0, green: 122/255.0, blue: 131/255.0, alpha: 1.0)
    }
    
    open class var verticalLineColor: UIColor {
        //hex #797A83
        return UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
    }
    
    open class var separatorGrayColor: UIColor {
        //hex #F2F0FA
        return UIColor(red: 242/255.0, green: 240/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
    open class var borderGrayColor: UIColor {
        //hex #C4C5C9
        return UIColor(red: 196/255.0, green: 197/255.0, blue: 201/255.0, alpha: 1.0)
    }
    
    open class var ignoredBackgroundGray: UIColor {
        //hex #F2F0FA
        return UIColor(red: 242/255.0, green: 240/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
    open class var ignoredTextGray: UIColor {
        //hex #797A83
        return UIColor(red: 121/255.0, green: 122/255.0, blue: 131/255.0, alpha: 1.0)
    }
    
    open class var lineGray: UIColor {
        //hex #979797
        return UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
    }
    
    open class var notificationTitleGray: UIColor {
        //hex #454545
        return UIColor(red: 69/255.0, green: 69/255.0, blue: 69/255.0, alpha: 1.0)
    }
    
    open class var messageLineGray: UIColor {
        //hex #F1F1F1
        return UIColor(red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1.0)
    }
    
    open class var messageTextGray: UIColor {
        //hex #373737
        return UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
    }
    
    open class var caretGray: UIColor {
        return UIColor(red: 219/255.0, green: 219/255.0, blue: 221/255.0, alpha: 1.0)
    }
    
    open class var attachmentBorderColor: UIColor {
        //hex #F1F1F1
        return UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
    }
    
    open class var recentTableViewBackgroundColor: UIColor {
        //hex #F7F8FB
        return UIColor(red: 236/255.0, green: 236/255.0, blue: 242/255.0, alpha: 1.0)
    }
    
    open class var selectedCellBackgroundColor: UIColor {
        return UIColor(red: 231/255.0, green: 231/255.0, blue: 236/255.0, alpha: 1.0)
    }
    
    //  -- Blues ---
    
    open class var feedStarSwipeTitleColor: UIColor {
        //hex 757c92
        return UIColor(red: 142/255.0, green: 145/255.0, blue: 152/255.0, alpha: 1.0)
    }
    
    open class var feedSwipeButtonShadowColor: UIColor {
        return UIColor(red: 161/255.0, green: 166/255.0, blue: 190/255.0, alpha: 0.66)
    }
    
    open class var selectionCellColor: UIColor {
        //hex #AFBCFF
        return UIColor(red: 175/255.0, green: 188/255.0, blue: 255/255.0, alpha: 0.2)
    }
    
    open class var selectedReceiverColor: UIColor {
        //hex #6F6FFB
        return UIColor(red: 111/255.0, green: 111/255.0, blue: 251/255.0, alpha: 1.0)
    }
    
    open class var fbBlue: UIColor {
        //hex #526aa8
        return UIColor(red: 82/255.0, green: 106/255.0, blue: 168/255.0, alpha: 1.0)
    }
    
    open class var linkedInBlue: UIColor {
        //hex #3c7eb5
        return UIColor(red: 60/255.0, green: 126/255.0, blue: 181/255.0, alpha: 1.0)
    }
    
    open class var selectedCategoryBlue: UIColor {
        //hex #6069F2
        return UIColor(red: 96/255.0, green: 105/255.0, blue: 242/255.0, alpha: 1.0)
    }
    
    open class var approvedBackgroundBlue: UIColor {
        //hex #9A98FF
        return UIColor(red: 154/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    open class var undoBlue: UIColor {
        //hex #758BF6
        return UIColor(red: 117/255.0, green: 139/255.0, blue: 246/255.0, alpha: 1.0)
    }
    
    // -- Green ---
    
    open class var romioGreen: UIColor {
        //hex #54b59a
        return UIColor(red: 84/255.0, green: 181/255.0, blue: 154/255.0, alpha: 1.0)
    }
    
    open class var romioLightGreen: UIColor {
        //hex #7cbbae
        return UIColor(red: 124/255.0, green: 187/255.0, blue: 174/255.0, alpha: 1.0)
    }
    
    open class var romioLightBorderGreen: UIColor {
        //hex #9bcbc2
        return UIColor(red: 155/255.0, green: 203/255.0, blue: 194/255.0, alpha: 1.0)
    }
    
    open class var juneGreen: UIColor {
        //hex #42E6DA
        return UIColor(red: 66/255.0, green: 230/255.0, blue: 218/255.0, alpha: 1.0)
    }

    //  -- Pinks ---
    open class var blockStartPink: UIColor {
        //hex #c472d0
        return UIColor(red: 196/255.0, green: 114/255.0, blue: 208/255.0, alpha: 1.0)
    }
    
    open class var blockEndPink: UIColor {
        //hex #9bcbc2
        return UIColor(red: 249/255.0, green: 89/255.0, blue: 150/255.0, alpha: 1.0)
    }
    
    // -- Tab bar colors --
    open class var tabBarBackgroundColor: UIColor {
        //hex #2D3855
        return UIColor(red: 45/255.0, green: 56/255.0, blue: 85/255.0, alpha: 1.0)
    }
    
    open class var tabBarDarkBackgroundColor: UIColor {
        return UIColor(red: 30/255.0, green: 38/255.0, blue: 63/255.0, alpha: 1.0)

    }
    
    // -- Search bar colors --
    open class var searchBarTintColor: UIColor {
        //hex 256CFF
        return UIColor(red: 37/255.0, green: 108/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    open class var searchBarPlaceholderColor: UIColor {
        //hex 939393
        return UIColor(red: 171/255.0, green: 172/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    open class var searchBarBackgroundColor: UIColor {
        //hex EBEBED
        return UIColor(red: 235/255.0, green: 235/255.0, blue: 237/255.0, alpha: 1.0)
    }
    
    open class var searchBarTextColor: UIColor {
        //hex 2B3348
        return UIColor(red: 43/255.0, green: 51/255.0, blue: 72/255.0, alpha: 1.0)
    }
    
    open class var searchResultBackgroundColor: UIColor {
        //hex F8FAFA
        return UIColor(red: 248/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
    open class var searchResultBorderColor: UIColor {
        //hex EEEEEE
        return UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    }
    
    open class var searchResultReceiverColor: UIColor {
        //hex 28282C
        return UIColor(hexString: "28282C")
    }
    
    open class var searchResultTextColor: UIColor {
        //hex 2A334A
        return UIColor(red: 42/255.0, green: 51/255.0, blue: 74/255.0, alpha: 1.0)
    }
    
    open class var searchResultTimestemptColor: UIColor {
        //hex #9A9CA2
        return UIColor(hexString: "9A9CA2")
    }
    
    open class var searchResultBodyColor: UIColor {
        //hex #5E5E5E
        return UIColor(hexString: "5E5E5E")
    }
    
    // -- Requests colors --
    open class var requestsNameColor: UIColor {
        //hex 2D3855
        return UIColor(red: 45/255.0, green: 56/255.0, blue: 85/255.0, alpha: 1.0)
    }
    
    open class var requestsEmailColor: UIColor {
        //hex 939393
        return UIColor(red: 147/255.0, green: 147/255.0, blue: 147/255.0, alpha: 1.0)
    }
    
    open class var requestsDotColor: UIColor {
        //hex 19DFEC
        return UIColor(red: 25/255.0, green: 223/255.0, blue: 236/255.0, alpha: 1.0)
    }
    
    open class var requestsSubjectColor: UIColor {
        //hex 404040
        return UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    }
    
    open class var requestsApproveColor: UIColor {
        //hex 118BFD
        return UIColor(red: 17/255.0, green: 139/255.0, blue: 253/255.0, alpha: 1.0)
    }
    
    open class var requestsIgnoreColor: UIColor {
        //hex C4C5C9
        return UIColor(red: 196/255.0, green: 197/255.0, blue: 201/255.0, alpha: 1.0)
    }
    
    open class var requestsIgnoreTitleColor: UIColor {
        //hex 939393
        return UIColor(red: 147/255.0, green: 147/255.0, blue: 147/255.0, alpha: 1.0)
    }
    
    open class var requestsBlockColor: UIColor {
        //hex FF7272
        return UIColor(red: 255/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1.0)
    }
    
    open class var requestsSelectedTitleColor: UIColor {
        //hex 2D3855
        return UIColor(red: 45/255.0, green: 56/255.0, blue: 85/255.0, alpha: 1.0)
    }
    
    open class var requestsUnSelectedTitleColor: UIColor {
        //hex 85868C
        return UIColor(red: 133/255.0, green: 134/255.0, blue: 140/255.0, alpha: 1.0)
    }
    
    open class var requestsLeftGradienColor: UIColor {
        //hex 005FFF
        return UIColor(red: 0/255.0, green: 95/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    open class var requestsRightGradienColor: UIColor {
        //hex 34E0F9
        return UIColor(red: 52/255.0, green: 224/255.0, blue: 249/255.0, alpha: 1.0)
    }
    
    open class var requestsDateColor: UIColor {
        //hex #9A9CA2
        return UIColor(red: 154/255.0, green: 156/255.0, blue: 162/255.0, alpha: 1.0)
    }
    
    open class var requestsSelectedImageColor: UIColor {
        //hex #FF5168
        return UIColor(red: 255/255.0, green: 81/255.0, blue: 104/255.0, alpha: 1.0)
    }
    
    open class var requestsActionButtonColor: UIColor {
        //hex #8E9198
        return UIColor(red: 142/255.0, green: 145/255.0, blue: 152/255.0, alpha: 1.0)
    }
    
    open class var requestsNoResultColor: UIColor {
        //hex #110C3B
        return UIColor(red: 17/255.0, green: 12/255.0, blue: 59/255.0, alpha: 0.7)
    }
    
    open class var requestsMoreLabelColor: UIColor {
        //hex #2548FF
        return UIColor(red: 37/255.0, green: 72/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    open class var requestsSnippetColor: UIColor {
        //hex #5E5E5E
        return UIColor(red: 94/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1.0)
    }
    
    open class var requestsBorderColor: UIColor {
        //hex #F3F3F3
        return UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
    }
    
    open class var cannedResponseLineColor: UIColor {
        //hex #A19FAB
        return UIColor(red: 161/255.0, green: 159/255.0, blue: 171/255.0, alpha: 1.0)
    }
    
    open class var cannedResponseShadowColor: UIColor {
        //hex #A19FAB
        return UIColor(red: 38/255.0, green: 49/255.0, blue: 77/255.0, alpha: 0.7)
    }
    
    open class var cannedResponseHeaderColor: UIColor {
        //hex #BBBED0
        return UIColor(red: 187/255.0, green: 190/255.0, blue: 208/255.0, alpha: 0.7)
    }
    
    open class var notificationViewBackgroundColor: UIColor {
        //hex #2D3855
        return UIColor(red: 45/255.0, green: 56/255.0, blue: 85/255.0, alpha: 1.0)
    }
    
    open class var notificationViewShadowColor: UIColor {
        //hex #121036
        return UIColor(red: 18/255.0, green: 16/255.0, blue: 54/255.0, alpha: 0.33)
    }
    
    open class var undoBackgroundColor: UIColor {
        //hex #515D7D
        return UIColor(red: 81/255.0, green: 93/255.0, blue: 125/255.0, alpha: 1.0)
    }
    
    open class var discardButtonBorderColor: UIColor {
        //hex #CBCECE
        return UIColor(red: 203/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1.0)
    }
    
    open class var discardButtonMessageColor: UIColor {
        //hex 2B3348
        return UIColor(red: 43/255.0, green: 51/255.0, blue: 72/255.0, alpha: 1.0)
    }
    
    open class var discardButtonColor: UIColor {
        //hex #404040
        return UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    }
    

    // MARK: - Feed brief colors
    
    open class var briefLineViewColor: UIColor {
        return UIColor(hexString: "18DBFD")
    }
    
    open class var briefCellSeparatorColor: UIColor {
        return UIColor(hexString: "C9C9C9").withAlphaComponent(0.37)
    }
    
    open class var briefCellBorderColor: UIColor {
        return UIColor(hexString: "EBEBEB")
    }
    
    open class var briefHeaderTextColor: UIColor {
        return UIColor(hexString: "19191B")
    }
    
    open class var briefSutitleTextColor: UIColor {
        return UIColor(hexString: "2D3855")
    }
    
    open class var briefDodgerBlueColor: UIColor {
        return UIColor(hexString: "0B96FF")
    }
    
    open class var briefCollapseTitleColor: UIColor {
        return UIColor(hexString: "7F7F7F")
    }
    
    open class var briefCollapseBorderColor: UIColor {
        return UIColor(hexString: "E6E6E6")
    }
    
    open class var briefViewAllTitleColor: UIColor {
        return UIColor(hexString: "256CFF")
    }
    
    open class var categoryIconBackground: UIColor {
        return UIColor(hexString: "EFEFEF")
    }
    
    open class var promosBackgroundColor: UIColor {
        return UIColor(hexString: "F1F7FB")
    }

    //MARK: - sharing
    open class var shareBackgroundColor: UIColor {
        return UIColor(hexString: "343B4E")
    }
    
    open class var shareCardViewBackgroundColor: UIColor {
        return UIColor(hexString: "#FCFDFD")
    }
    
    open class var emptyStateTitleColor: UIColor {
        return UIColor(hexString: "110C3B")
    }
    
    // MARK: - Responder colors
    
    open class var topShadowColor: UIColor {
        return UIColor(hexString: "979797").withAlphaComponent(0.6)
    }
    
    open class var bottomSeparatorColor: UIColor {
        return UIColor(hexString: "979797").withAlphaComponent(0.16)
    }
    
    open class var responderPlaceholderTextColor: UIColor {
        return UIColor(hexString: "8E9198")
    }
    
    open class var responderRegularTextColor: UIColor {
        return UIColor(hexString: "373737")
    }
    
    open class var draftBlueColor: UIColor {
        return UIColor(hexString: "256CFF")
    }
    
    open class var noBookmarksTitleColor: UIColor {
        return UIColor(hexString: "110C3B")
    }
    
    // MARK: - Spool index header color
    
    open class var spoolNameHeaderColor: UIColor {
        return UIColor(hexString: "0E0E0E")
    }
    
    open class var spoolViewInfoHeaderColor: UIColor {
        return UIColor(hexString: "B9C1CC")
    }
    
    open class var spoolViewOlderMessagesColor: UIColor {
        return UIColor(hexString: "EEF1F3")
    }
    
    public convenience init?(_ hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let hexColor = hexString.subString(1)
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func highlighted() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.4, 0.0), green: max(g - 0.4, 0.0), blue: max(b - 0.4, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
}
