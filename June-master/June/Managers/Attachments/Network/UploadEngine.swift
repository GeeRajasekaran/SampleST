//
//  UploadEngine.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/31/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import Alamofire
import SwiftyJSON

class UploadEngine {
    
    
    func upload(imageData: Data?, with imageName: String?, and fileURL: URL?, mimeType: String, onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil) {
        guard let token = FeathersManager.Providers.feathersApp.authenticationStorage.accessToken else { return }
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accountId = serializedUserObject["primary_account_id"] as? String {
            
            let url = "https://peregrine.hellolucy.io/upload/attachments"
            let fileKey = "file"
            let headers: HTTPHeaders = [
                "Authorization":"Bearer " + token,
                "Content-type": "multipart/form-data"
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(accountId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "account_id")
                if let data = imageData, let name = imageName {
                    multipartFormData.append(data, withName: fileKey, fileName: name, mimeType: mimeType)
                }
                if let url = fileURL {
                    multipartFormData.append(url, withName: fileKey)
                }
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        guard let data = response.result.value else {
                            onCompletion?(nil)
                            return
                        }
                        onCompletion?(JSON(data))
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    onError?(error)
                }
            })
        }
    }
}
