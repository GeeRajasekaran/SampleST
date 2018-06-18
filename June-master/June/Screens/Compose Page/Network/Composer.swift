//
//  Composer.swift
//  June
//
//  Created by Ostap Holub on 10/4/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class Composer {
    
    // MARK: - Request body keys
    
    private let htmlTemplate = "<div dir=\"ltr\">#placeholder#</div><br>"
    private let placeholderString = "#placeholder#"
    
    private struct RequestKey {
        static let accountId = "account_id"
        static let subject = "subject"
        static let body = "body"
        static let bodyTxt = "body_txt"
        static let to = "to"
        static let bcc = "bcc"
        static let cc = "cc"
        static let attachments = "file_ids"
    }
    
    // MARK: - Public compose part
    
    func compose(with subject: String, and body: String, for receivers: [EmailReceiver], with attachments: [Attachment], completion: @escaping (Result<String>) -> Void) {
        let data = buildParams(with: subject, and: body, for: receivers, with: attachments)
        
        FeathersManager.Services.message.request(.create(data: data, query: nil))
            .on(value: { response in
                completion(.Success(""))
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })
    }
    
    // MARK: - Private helper methods
    
    private func buildParams(with subject: String, and body: String, for receivers: [EmailReceiver], with attachments: [Attachment]) -> [String: Any] {
        var data = [String: Any]()
        
        data[RequestKey.accountId] = fetchAccountId()
        data[RequestKey.subject] = subject
        data[RequestKey.body] = buildHTMLBody(from: body)
        data[RequestKey.to] = buildContactDict(from: receivers)
        data[RequestKey.bodyTxt] = body
        data[RequestKey.cc] = []
        data[RequestKey.bcc] = []
        data[RequestKey.attachments] = attachments.map { attachment -> String in
            return attachment.id
        }
        return data
    }
    
    private func buildContactDict(from array: [EmailReceiver]) -> [[String: String]] {
        var dictsArray = [[String: String]]()
        array.forEach { element -> Void in
            if element.destination == .input { return }
            if let email = element.email, let name = element.name {
                dictsArray.append(["name": name, "email": email])
            }
        }
        return dictsArray
    }
    
    private func buildHTMLBody(from bodyString: String) -> String {
        let template = htmlTemplate.replacingOccurrences(of: placeholderString, with: bodyString)
        return template.replacingOccurrences(of: "\n", with: "<br>")
    }
    
    private func fetchAccountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        return serializedUserObject["primary_account_id"] as? String
    }
    
    private func buildAttachmentsDict(from array: [Attachment]) -> [[String: String]] {
        var dictsArray = [[String: String]]()
        array.forEach { element -> Void in
            let dict = ["url": element.url, "id": element.id, "filename": element.filename, "content_type": element.contentType, "size": String(element.size), "status": "done"]
            dictsArray.append(dict)
        }
        return dictsArray
    }
}
