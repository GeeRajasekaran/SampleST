//
//  SpoolResponderInfoLoader.swift
//  June
//
//  Created by Ostap Holub on 4/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolResponderInfoLoader {
    
    // MARK: - Variables & Constats
    
    private lazy  var messagesProvider: MessagesDataProvider = { [unowned self] in
        let provider = MessagesDataProvider(with: self)
        return provider
    }()
    
    private var threadsProvider: ThreadsDataProvider
    private var onFinish: ((Threads, Messages) -> Void)?
    
    var pendingMessage: Messages?
    var pendingThread: Threads?
    
    // MARK: - Initialization
    
    init() {
        threadsProvider = ThreadsDataProvider()
        threadsProvider.onSingleThreadLoaded = onThreadLoaded
    }
    
    private lazy var onThreadLoaded: (String) -> Void = { [weak self] id in
        let proxy: ThreadsProxy = ThreadsProxy()
        self?.pendingThread = proxy.fetchThread(by: id)
        guard let message = self?.pendingMessage, let thread = self?.pendingThread else { return }
        self?.onFinish?(thread, message)
    }
    
    // MARK: - Request part
    
    func requestInfo(for spoolId: String, completion: @escaping (Threads, Messages) -> Void) {
        onFinish = completion
        messagesProvider.requestLastMessage(for: spoolId)
    }
}

extension SpoolResponderInfoLoader: MessagesProviderDelegate {
    
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessagesFor spoolId: String) {
        let proxy: MessagesProxy = MessagesProxy()
        pendingMessage = proxy.fetchLastSpoolMessage(for: spoolId)
        if let threadId = pendingMessage?.thread_id {
            threadsProvider.requestThread(for: threadId)
        }
    }
}
