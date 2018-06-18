//
//  ShareManager.swift
//  June
//
//  Created by Ostap Holub on 10/11/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

class ShareManager {
    
    // MARK: - Variables & Constants
    
    private let kMessageId = "message_id"
    private let kShareToken = "share_token"
    
    private let shareLinkPlaceholder = "https://elly.hellolucy.io/#/shared/{message_id}/{shared_token}"
    private let messageIdPlaceholder = "{message_id}"
    private let shareTokenPlaceholder = "{shared_token}"
    
    private var messageId: String?
    private var shareToken: String?
    var shareURL: String?
    
    // MARK: - Share token generation
    
    func generateLink(for message: Messages) {
        guard let id = message.id else { return }
        messageId = id
        
        let data = [kMessageId: id]
        FeathersManager.Services.share.request(.create(data: data, query: nil))
            .on(value: { [weak self] response in
                let json = JSON(response.data.value)
                if !json.isEmpty {
                    guard let tokenKey = self?.kShareToken else { return }
                    self?.generateShareLink(from: json[tokenKey].string)
                }
            }).startWithFailed({ error in
                print(error.localizedDescription)
        })
    }
    
    // MARK: - Share link generation
    
    private func generateShareLink(from token: String?) {
        guard let unwrappedToken = token,
            let unwrappedMessageId = messageId else { return }
        shareToken = unwrappedToken
        
        //generate link
        let finalShareLink = shareLinkPlaceholder
        shareURL = finalShareLink.replacingOccurrences(of: messageIdPlaceholder, with: unwrappedMessageId).replacingOccurrences(of: shareTokenPlaceholder, with: unwrappedToken)
    }
}
