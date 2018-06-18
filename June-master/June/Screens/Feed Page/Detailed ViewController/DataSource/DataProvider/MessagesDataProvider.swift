//
//  MessagesDataProvider.swift
//  June
//
//  Created by Ostap Holub on 9/4/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

protocol MessagesProviderDelegate: class {
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessageFor threadId: String, total: Int)
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessagesFor spoolId: String)
}

extension MessagesProviderDelegate {
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessagesFor spoolId: String) {}
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessageFor threadId: String, total: Int) {}
}

protocol MessagesProviderRealTimeEventDelegate: class {
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessageInRealTimeWith messageId: String, for threadId: String)
}

class MessagesDataProvider {
    
    // MARK: - Variables
    private var realTimeListener: MessagesRealTimeListener?
    private weak var delegate: MessagesProviderDelegate?
    private weak var realTimeDelegate: MessagesProviderRealTimeEventDelegate?
    private var messagesProxy: MessagesProxy
    private var parser: MessagesParser
    
    init(with callbackResponder: MessagesProviderDelegate?) {
        delegate = callbackResponder
        messagesProxy = MessagesProxy()
        parser = MessagesParser()
    }
    
    init(with callbackResponder: MessagesProviderDelegate?, and realTimeCallbackResponder: MessagesProviderRealTimeEventDelegate?) {
        delegate = callbackResponder
        realTimeDelegate = realTimeCallbackResponder
        messagesProxy = MessagesProxy()
        parser = MessagesParser()
    }
    
    //MARK: - real time
    lazy var onPatch: ([String: Any]) -> Void = { [weak self] j in
        let json = JSON(j)
        print(json)
        self?.saveMessage(json)
        let messageId = json["id"].stringValue
        let threadId = json["thread_id"].stringValue
        self?.realTimeDelegate?.provider(self!, didReceiveMessageInRealTimeWith: messageId, for: threadId)
    }
    
    // MARK: - Request part
    
    func requestLastMessage(for spoolId: String) {
        let query: Query = Query().eq(property: "spool_id", value: spoolId)
                                .sort(property: "date", ordering: .orderedDescending)
        
        FeathersManager.Services.message.request(.find(query: query))
            .on(value: { [weak self] response in
                if let strongSelf = self, let messagesJSON = JSON(response.data.value).array {
                    strongSelf.process(messagesJSON)
                    strongSelf.delegate?.provider(strongSelf, didReceiveMessagesFor: spoolId)
                }
            }).startWithFailed({ error in
                print(error.localizedDescription)
            })
    }
    
    func requestNextMessagesPage(for spool: Spools?, skipCount: Int, limit: Int = 5, shouldSort: Bool = true) {
        guard let threadId = spool?.last_messages_thread_id else { return }
        requestMessages(for: threadId, limit: limit, shouldSort: shouldSort, skipCount: skipCount)
    }
    
    func requestMessages(for spool: Spools?, limit: Int = 5, shouldSort: Bool = true) {
        guard let threadId = spool?.last_messages_thread_id else { return }
        requestMessages(for: threadId, limit: 5, shouldSort: true)
    }
    
    func requestMessages(for threadId: String, limit: Int = 10, shouldSort: Bool = false, skipCount: Int = 0) {
        var query = Query()
            .eq(property: "thread_id", value: threadId)
            .skip(skipCount)
            .limit(limit)
        if shouldSort {
            query = query.sort(property: "date", ordering: ComparisonResult.orderedDescending)
        }
        
        FeathersManager.Services.message.request(.find(query: query))
            .on(value: { [weak self] response in
                if let strongSelf = self, let messagesJSON = JSON(response.data.value).array {
                    let total = response.description.getTotal()
                    strongSelf.process(messagesJSON)
                    strongSelf.delegate?.provider(strongSelf, didReceiveMessageFor: threadId, total: total)
                }
            }).startWithFailed({ error in
                print(error.localizedDescription)
            })
    }
    
    // MARK: - Real time
    func subscribeForRealTimeEvents() {
        realTimeListener = MessagesRealTimeListener()
        realTimeListener?.subscribeForPatch(event: onPatch)
    }
    
    func unsubscribe() {
        realTimeListener?.unsubscribe()
        realTimeListener = nil
    }
    
    // MARK: - Private part
    
    private func process(_ messages: [JSON]) {
        messages.forEach({ element -> Void in
            saveMessage(element)
        })
    }
    
    private func saveMessage(_ messageJson: JSON) {
        guard let messageId = messageJson["id"].string else { return }
        if let messageEntity = messagesProxy.fetchMessage(by: messageId) {
            parser.loadData(from: messageJson, into: messageEntity)
        } else {
            if let obmId = messageJson["obm_id"].string {
                if let messageEntityByObmId = messagesProxy.fetchMessage(byObm: obmId) {
                    parser.loadData(from: messageJson, into: messageEntityByObmId)
                } else {
                    let message = messagesProxy.addNewMessage()
                    parser.loadData(from: messageJson, into: message)
                }
            } else {
                let message = messagesProxy.addNewMessage()
                parser.loadData(from: messageJson, into: message)
            }
        }
        messagesProxy.saveContext()
    }
}
