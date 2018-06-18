//
//  ResponderAPIEngine.swift
//  June
//
//  Created by Ostap Holub on 9/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import KeychainSwift
import SwiftyJSON

class ResponderAPIEngine {
    
    // MARK: - Request body keys 
    
    private let htmlTemplate = "<div dir=\"ltr\">#placeholder#</div><br>"
    private let placeholderString = "#placeholder#"
    private var text = ""
    private var responseData: [String: AnyObject] = [:]
    private let parser = MessagesParser()
    private let messagesProxy = MessagesProxy()

    private struct RequestKey {
        static let accountId = "account_id"
        static let subject = "subject"
        static let body = "body"
        static let bodyTxt = "body_txt"
        static let indent = "indent"
        static let to = "to"
        static let from = "from"
        static let replyToMessageId = "reply_to_message_id"
        static let attachments = "file_ids"
    }
    
    // MARK: - Reply / forward endpoint
    
    func sendMessage(with metadata: ResponderMetadata) {
        guard let accountId = fetchAccountId() else { return }
        text = metadata.message
        let data = buildParams(with: metadata.config.message, using: metadata.message, and: accountId, for: metadata.recipients, and: metadata.attachments)
        sendQuery(data)
    }
    
    func respond(to message: Messages, with body: String, to receivers: [EmailReceiver], with attachments: [Attachment], completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        guard let accountId = fetchAccountId() else { return }
        text = body
        let data = buildParams(with: message, using: body, and: accountId, for: receivers, and: attachments)
        sendQuery(data, completion: completion)
    }
    
    // MARK: - Private part
    
    private func sendQuery(_ data: [String: Any]) {
        FeathersManager.Services.message.request(.create(data: data, query: nil))
            .on(value: { [weak self] response in
                guard let sSelf = self else { return }
                if let data = response.data.value as? [String: AnyObject] {
                    sSelf.responseData = data
                    let userInfo: [AnyHashable: Any] = ["data": data]
                    NotificationCenter.default.post(name: .onSuccessResponse, object: nil, userInfo: userInfo)
                }
            }).startWithFailed({ error in
                let userInfo: [AnyHashable: Any] = ["error": error.localizedDescription]
                NotificationCenter.default.post(name: .onFailedResponse, object: nil, userInfo: userInfo)
            })
    }
    
    private func sendQuery(_ data: [String: Any], completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        
        FeathersManager.Services.message.request(.create(data: data, query: nil))
            .on(value: { [weak self] response in
                guard let sSelf = self else { return }
                //TODO: - need to refactor that lines of code
                sSelf.saveMessage(JSON(response.data.value))
                if let data = response.data.value as? [String: AnyObject] {
                    sSelf.responseData = data
                    completion(.Success(data))
                }
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })
    }
    
    //MARK: - save message into core data
    
    private func saveMessage(_ messageJson: JSON) {
        guard let messageId = messageJson["id"].string else { return }
        var messageEntity: Messages? = nil
        if let entity = messagesProxy.fetchMessage(by: messageId) {
            messageEntity = entity
        } else {
            messageEntity = messagesProxy.addNewMessage()
        }
        if messageEntity != nil {
            parser.loadData(from: messageJson, into: messageEntity!)
            saveHtmlEntity(into: messageEntity!)
            messagesProxy.saveContext()
        }
    }
    
    private func saveHtmlEntity(into messageEntity: Messages) {
        let html = buildHTMLBody(from: text)
        let htmlEntity = Messages_Segmented_Html(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
        htmlEntity.order = 1
        htmlEntity.type = "top_message"
        htmlEntity.html = html
        messageEntity.messages_segmented_html = NSSet(object: htmlEntity)
    }
    
    // MARK: - Query building
    
    private func buildParams(with message: Messages, using body: String, and id: String, for receivers: [EmailReceiver], and attachments: [Attachment]) -> [String: Any] {
        
        var dict = [String: Any]()
        
        dict[RequestKey.accountId] = id
        dict[RequestKey.subject] = message.subject
        dict[RequestKey.body] = buildHTMLBody(from: body)
        dict[RequestKey.indent] = message.body
        dict[RequestKey.bodyTxt] = body
        dict[RequestKey.to] = buildContactDict(from: receivers)
        dict[RequestKey.from] = senderDict()
        if attachments.count > 0 {
            dict[RequestKey.attachments] = attachments.map { attachment -> String in
                return attachment.id
            }
        }
        // don't set it for forward config
        if let unwrappedMessageId = message.id {
            dict[RequestKey.replyToMessageId] = unwrappedMessageId
        }
        
        return dict
    }
    
    private func buildHTMLBody(from bodyString: String) -> String {
        let template = htmlTemplate.replacingOccurrences(of: placeholderString, with: bodyString)
        return template.replacingOccurrences(of: "\n", with: "<br>")
    }
    
    private func senderDict() -> [[String: String]] {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return [[:]] }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        var sender = [String: String]()
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]], let firstAccount = accounts.first {
            if let name = firstAccount["name"] as? String, let email = firstAccount["email_address"] as? String {
                sender = ["name": name, "email": email]
            }
        }
        return [sender]
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
    
    private func buildAttachmentsDict(from array: [Attachment]) -> [[String: Any]] {
        var dictsArray = [[String: Any]]()
        array.forEach { element -> Void in
            let dict = ["url": element.url, "id": element.id, "filename": element.filename, "content_type": element.contentType, "size": element.size, "status": "done"] as [String: Any]
            dictsArray.append(dict)
        }
        return dictsArray
    }
    
    private func fetchAccountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        return serializedUserObject["primary_account_id"] as? String
    }
}
