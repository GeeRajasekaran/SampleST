//
//  EmailLinkerDataProvider.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

class EmailLinkerDataProvider {
    
    func discoverEmail(with text: String, completion: @escaping (Result<EmailLinker>) -> Void) {
        FeathersManager.Services.accounts.request(.create(data: [
            "email": text
            ], query: nil))
            .on(value: { response in
                let emailLinkerJSON = JSON(response.data.value)
                let emailLinker = EmailLinker(with: emailLinkerJSON)
                completion(.Success(emailLinker))
            })
            .startWithFailed { error in
                completion(.Error(error.localizedDescription))
        }
    }
    
    func linkEmail(with text: String, dataOfLinkEmail emailLinker: EmailLinker, code oAuthCode: String?, and password: String?, completion: @escaping (Result<GenericLinkEmailResponse>) -> Void) {
        
        if let userData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userData)
            guard let userId = userObject["_id"] as? String else { return }

            var data: [String: Any] = ["email": text,
                        "provider": emailLinker.provider,
                        "provider_type": emailLinker.providerType,
                        "reauth": emailLinker.reauth,
                        "user_id": userId
            ]
            
            if let code = oAuthCode {
                data["code"] = code
            }
            
            if let unwrappedPassword = password {
                data["password"] = unwrappedPassword
            }
            
            FeathersManager.Services.accounts.request(.create(data: data, query: nil))
                .on(value: { response in
                    let jsonObject = JSON(response.data.value)
                    let response = GenericLinkEmailResponse(with: jsonObject)
                    completion(.Success(response))
                })
                .startWithFailed( { error in
                    completion(.Error(error.localizedDescription))
                })
        }
    }
    
    func reauthenticate(_ emailAddress: String, completion: @escaping (Result<EmailLinker>) -> Void) {
        let data: [String: Any] = ["email": emailAddress,
                                   "reauth": true]
        FeathersManager.Services.accounts.request(.create(data: data, query: nil))
            .on(value: { response in
                let jsonObject = JSON(response.data.value)
                let response = EmailLinker(with: jsonObject)
                response.reauth = true
                completion(.Success(response))
            })
            .startWithFailed( { error in
                completion(.Error(error.localizedDescription))
            })
    }
}
