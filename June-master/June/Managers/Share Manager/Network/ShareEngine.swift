//
//  ShareEngine.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShareEngine {
    
    // MARK: - Request body keys
    private struct RequestKey {
        static let accountId = "account_id"
        static let messageId = "sharing_message_id"
        static let messageBody = "sharing_message"
        static let to = "to"
        static let from = "from"
        static let preview = "preview"
    }
    
    // MARK: - Public share part
    
    func share(with messageId: String, and body: String, for receivers: [EmailReceiver], completion: @escaping (Result<String>) -> Void) {
        let data = buildParams(with: messageId, and: body, for: receivers)
        FeathersManager.Services.share.request(.create(data: data, query: nil))
            .on(value: { response in
                let json = JSON(response.data.value)
                print(json)
                let error = json["error"]["description"].stringValue
                if error == "" {
                    completion(.Success(""))
                } else {
                    completion(.Error(error))
                }
                
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })
    }
    
    // MARK: - Private helper methods
    
    private func buildParams(with messageId: String, and body: String, for receivers: [EmailReceiver]) -> [String: Any] {
        var data = [String: Any]()
        
        data[RequestKey.accountId] = UserInfoLoader.accountId
        data[RequestKey.messageId] = messageId
        data[RequestKey.messageBody] = body
        data[RequestKey.to] = buildContactDict(from: receivers)
        data[RequestKey.from] = buildFromDict()
        data[RequestKey.preview] = true
        return data
    }
    
    private func buildContactDict(from array: [EmailReceiver]) -> [[String: String]] {
        var dictsArray = [[String: String]]()
        array.forEach { element -> Void in
            if element.destination == .input { return }
            if let email = element.email, let name = element.name {
                if name != "" || email != "" {
                    dictsArray.append(["name": name, "email": email])
                }
            }
        }
        return dictsArray
    }
    
    private func buildFromDict() -> [[String: String]] {
        var dictsArray = [[String: String]]()
        if let userName = UserInfoLoader.userName, let userEmail = UserInfoLoader.userPrimaryEmail {
            dictsArray.append(["name": userName, "email": userEmail])
        }
        return dictsArray
    }
}
