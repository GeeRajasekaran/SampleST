//
//  RequestHeaderFieldType.swift
//  June
//
//  Created by Joshua Cleetus on 12/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

enum RequestHeaderFieldType: String {
    case authorization = "Authorization"
    case sessionID = "X-Session-Id"
    case disableEncryption = "postman-token"
    case encoded = "Content-Type"
}

struct RequestHeaderBuilder {
    
    static func load(forKey key: RequestHeaderFieldType, value: String? = nil) -> Dictionary<String, String> {
        switch key {
        case .authorization:
            var dic = Dictionary<String, String>()
            dic.updateValue(JuneConstants.APITokens.apiKey, forKey: key.rawValue)
            return dic
            
        case .sessionID:
            var dic = Dictionary<String, String>()
            if let session = value {
                dic.updateValue(session, forKey: key.rawValue)
            }
            return dic
            
        case .disableEncryption:
            var dic = Dictionary<String, String>()
            dic.updateValue(JuneConstants.APITokens.encryptionKey, forKey: key.rawValue)
            return dic
            
        case .encoded:
            var dic = Dictionary<String, String>()
            dic.updateValue("application/x-www-form-urlencoded", forKey: key.rawValue)
            return dic
            
        }
    }
}
