//
//  AttachmentLoader.swift
//  June
//
//  Created by Ostap Holub on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Alamofire

class AttachmentLoader {
    
    // MARK: - Request keys struct
    
    private struct RequestKeys {
        static let id = "id"
        static let contentType = "content_type"
        static let size = "size"
        static let filename = "filename"
        static let accountId = "account_id"
        static let downloadType = "download_type"
    }
    
    private var baseUrl = "https://peregrine.hellolucy.io/download"
    
    // MARK: - API call implementation
    
    func download(_ attachment: Attachment, completion: @escaping (Result<String>) -> Void) {
        guard let token = FeathersManager.Providers.feathersApp.authenticationStorage.accessToken else {
            completion(.Error("Failed to fetch auth token"))
            return
        }
        let headers = ["Authorization":"Bearer " + token]
        guard let params = buildRequestParams(for: attachment) else {
            completion(.Error("Failed to build request params"))
            return
        }
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        Alamofire.download(baseUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers, to: destination).response(completionHandler: { response in
            if let url = response.destinationURL {
                completion(.Success(url.absoluteString))
            }
        })
    }
    
    // MARK: - Reqeust building logic
    
    private func buildRequestParams(for attachment: Attachment) -> [String: Any]? {
        guard let accountId = fetchAccountId() else { return nil }
        var params = [String: Any]()
        
        params[RequestKeys.id] = attachment.id
        params[RequestKeys.contentType] = attachment.contentType
        params[RequestKeys.size] = attachment.size
        params[RequestKeys.filename] = attachment.filename
        params[RequestKeys.accountId] = accountId
        params[RequestKeys.downloadType] = "attachment"
        return params
    }
    
    private func fetchAccountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        return serializedUserObject["primary_account_id"] as? String
    }
}
