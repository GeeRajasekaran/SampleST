//
//  EmailLinker.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

struct EmailLinkerJsonKeys {
    static let email = "email"
    static let authorizationUrl = "authorization_url"
    static let provider = "provider"
    static let providerType = "provider_type"
    static let reauth = "reauth"
}

class EmailLinker {
    var email: String = ""
    var authorizationUrl: String = ""
    var provider: String = ""
    var providerType: String = ""
    var reauth: Bool = false
    
    init(with jsonObject: JSON) {
        email = jsonObject[EmailLinkerJsonKeys.email].stringValue
        authorizationUrl = jsonObject[EmailLinkerJsonKeys.authorizationUrl].stringValue
        provider = jsonObject[EmailLinkerJsonKeys.provider].stringValue
        providerType = jsonObject[EmailLinkerJsonKeys.providerType].stringValue
        reauth = jsonObject[EmailLinkerJsonKeys.reauth].boolValue
    }
    
    func isGeneric() -> Bool {
        if authorizationUrl == "" {
            return true
        }
        return false
    }
}
