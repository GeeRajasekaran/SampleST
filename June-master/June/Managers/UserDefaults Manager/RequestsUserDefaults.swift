//
//  JuneUserDefaults.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/18/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsUserDefaults: JuneUserDefaults {
    
    let keyIsPeoplePillShow = "IsPeoplePillShow"
    let keyIsSubscriptionPillShow = "IsSubscriptionPillShow"
    
    var isPeoplePillShow: Bool {
        get {
            return (UserDefaults.standard.bool(forKey: keyIsPeoplePillShow))
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyIsPeoplePillShow)
            synchronize()
        }
    }
    
    var isSubscriptionPillShow: Bool {
        get {
            return (UserDefaults.standard.bool(forKey: keyIsSubscriptionPillShow))
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyIsSubscriptionPillShow)
            synchronize()
        }
    }

}
