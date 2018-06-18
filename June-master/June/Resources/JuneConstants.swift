//
//  JuneConstants.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

// MARK: Constants Helper Functions

func ifDebug(execute: () -> Void) {
    #if DEBUG
        execute()
    #endif
}

struct JuneConstants {
    
    struct LogKey {
        static let rErrorLog = "[June] Error"
        static let rDebugLog = "[June] Debug"
        static let rVerboseLog = "[June] Verbose"
        static let rAPILog = "[June] API"
        static let rLog = "[June]"
    }
    
    struct Feathers {
        static let strategy = "local"
        static let baseURL = "https://peregrine.hellolucy.io/"
//        static let baseURL = "http://10.0.1.16:3030"
//        static let baseURL = "https://a91e4d69.ngrok.io/"
        static let jwtToken = "feathers-jwt"
    }
    
    struct KeychainKey {
        static let username = "June username"
        static let userObject = "June userObject"
        static let accountID = "June accountID"
        static let userID = "June userID"
    }
    
    struct APITokens {
        static let apiKey = ""
        static let encryptionKey = ""
    }
    
    struct Convos {
        static let emailsLimit = 20
    }
    
    struct Rolodexs {
        static let emailsLimit = 50
    }
    
}
