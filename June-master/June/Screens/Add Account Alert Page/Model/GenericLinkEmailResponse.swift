//
//  GenericLinkEmailResponse.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

struct EmailResponseJsonKeys {
    static let success = "success"
    static let emailAddress = "email_address"
    static let accountId = "account_id"
}

class GenericLinkEmailResponse {
    var isSuccess: Bool = false
    var emailAddress: String = ""
    var accountId: String = ""
    
    init(with jsonObject: JSON) {
        isSuccess = jsonObject[EmailResponseJsonKeys.success].boolValue
        emailAddress = jsonObject[EmailResponseJsonKeys.emailAddress].stringValue
        accountId = jsonObject[EmailResponseJsonKeys.accountId].stringValue
    }
}
