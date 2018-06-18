//
//  RequestsDataRepository.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import AlertBar

class RequestsDataRepository {
    
    var items = [RequestItem]()
    var screenType: RequestsScreenType = .people
    
    private var sortPredicate: (RequestItem, RequestItem) throws -> Bool = { first, second in
        if let firstName = first.peopleInfo?.name, let secondName = second.peopleInfo?.name {
            return firstName < secondName
        }
        return false
    }

    var threadsDataProvider: ThreadsDataProvider = ThreadsDataProvider()
    private var messagesProxy = MessagesProxy()
    private var contactsProxy = ContactsProxy()
    
    lazy var messagesProvider: MessagesDataProvider = { [unowned self] in
        let provider = MessagesDataProvider(with: self, and: self)
        return provider
    }()
    
    //Data provider
    lazy var contactsDataProvider: ContactsDataProvider = { [unowned self] in
        let provider = ContactsDataProvider()
        provider.delegate = self
        return provider
    }()
    
    // MARK: - Actions
    
    private var onRecentItemsLoaded: (() -> Void)
    
    var onRealTimeCallback: ((RequestItem) -> Void)?
    
    var onUpdateMessageCallback: ((Int) -> Void)?
    
    init(onRecentItemsLoaded: @escaping () -> Void) {
        self.onRecentItemsLoaded = onRecentItemsLoaded
    }
    
    // MARK: - Setting logic
    func update(_ item: RequestItem) {
        if let index = self.index(of: item) {
            if index < items.count {
                let isCollapsed = items[index].isCollapsed
                item.isCollapsed = isCollapsed
                items[index] = item
                self.requestMessage(for: item)
            }
        }
    }
    
    func append(messageInfo info: MessageInfo, to item: RequestItem) {
       item.messages?.insert(info, at: 0)
    }
    
    func remove(_ item: RequestItem) {
        if let index = self.index(of: item) {
            if index < items.count {
                items.remove(at: index)
            }
        }
    }
    
    func add(_ item: RequestItem, at index: Int) {
        items.insert(item, at: index)
    }
    
    func append( _ newItems: [RequestItem]) {
        _ = newItems.compactMap({ item -> Void in
            if !self.items.contains(where: {$0.contactId == item.contactId}) {
                self.items.append(item)
                self.requestMessage(for: item)
            }
        })
    }
    
    func subscribeForRealTimeEvents() {
        contactsDataProvider.subscribeForRealTimeEvents()
        messagesProvider.subscribeForRealTimeEvents()
    }
    
    func unsubscribe() {
        contactsDataProvider.unsubscribe()
        messagesProvider.unsubscribe()
    }
    
    // MARK: - Getting logic
    
    func contact(by index: Int) -> RequestItem? {
        if index < items.count {
            return items[index]
        }
        return nil
    }
    
    func getCount() -> Int? {
        return items.count
    }
    
    func index(of item: RequestItem) -> Int? {
        let contactId = item.contactId
        return items.index(where: {$0.contactId == contactId})
    }
    
    func getRequestItem(by lastThreadId: String) -> RequestItem? {
        var foundItem: RequestItem? = nil
        _ = self.items.compactMap({ item -> Void in
            if item.lastMessageThreadId == lastThreadId {
                foundItem = item
            }
        })
        return foundItem
    }
    
    //MARK: - Private part
    private func requestMessage(for item: RequestItem) {
        if requetsMessageFromCoreData(for: item) == nil {
            loadMessagesFromServer(for: item)
        }
    }
    
    
    private func requetsMessageFromCoreData(for item: RequestItem) -> Bool? {
        guard let lastThreadId = item.lastMessageThreadId else { return nil }
        let messages = messagesProxy.fetchMessages(for: lastThreadId)
        if messages.count == 0 { return nil }
        item.messages = create(from: messages)
        return true
    }
    
    private func loadMessagesFromServer(for item: RequestItem) {
        guard let lastThreadId = item.lastMessageThreadId else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.threadsDataProvider.requestThread(for: lastThreadId)
            self?.messagesProvider.requestMessages(for: lastThreadId, limit: 3, shouldSort: true)
        }
    }
    
    private func replace(_ threadId: String, with array: [Message]) -> Int? {
        guard let item = getRequestItem(by: threadId) else { return nil }
        item.messages = create(from: array)
        guard let index = index(of: item) else { return nil }
        return index
    }
    
    private func replace(_ newItems: [RequestItem]) {
        self.items = []
        append(newItems)
    }
    
    //MARK: - request requests
    
    func loadPendingDataFromServer() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let sSelf = self {
                sSelf.contactsDataProvider.requestPeople()
                sSelf.contactsDataProvider.requestCompanies()
            }
        }
    }
    
    func loadPendingFromCoreData() {
        loadRequestsFromCoreData(with: screenType)
    }
    
    func loadBlockedRequests() {
        loadRequestsFromCoreData(with: screenType)
        //request people and subscriptions update from backend
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let sSelf = self {
                sSelf.contactsDataProvider.requestBlockedPeople()
                sSelf.contactsDataProvider.requestBlockedCompanies()
            }
        }
    }
    
    func loadRequestsFromCoreData(with type: RequestsScreenType) {
        self.screenType = type
        let requestItems = contactsDataProvider.requests(for: screenType)
        replace(requestItems)
        contactsDataProvider.shouldLoadMore = true
        sortIfNeeded()
        onRecentItemsLoaded()
    }
    
    //MARK: - sort only for blocked people/subscriptions
    private func sortIfNeeded() {
        if screenType == .blockedPeople || screenType == .blockedSubscriptions {
            do {
                try items.sort(by: sortPredicate)
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - load next requests
    func loadNextPeople(with count: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let sSelf = self {
                sSelf.contactsDataProvider.requestPeople(with: count, shouldSkip: true)
            }
        }
    }
    
    func loadNextSubscriptions(with count: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let sSelf = self {
                sSelf.contactsDataProvider.requestCompanies(with: count, shouldSkip: true)
            }
        }
    }
    
    func loadNextBlockedPeople(with count: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let sSelf = self {
                sSelf.contactsDataProvider.requestBlockedPeople(with: count, shouldSkip: true)
            }
        }
    }
    
    func loadNextBlockedSubscriptions(with count: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let sSelf = self {
                sSelf.contactsDataProvider.requestBlockedCompanies(with: count, shouldSkip: true)
            }
        }
    }
    
    //MARk: - create item and message info models
    func create(from contacts: [Contacts]) -> [RequestItem] {
        var items: [RequestItem] = []
        _ = contacts.compactMap({ contact -> Void in
            let item = RequestItem(contact: contact)
            items.append(item)
        })
        return items
    }
    
    func create(from messages: [Message]) -> [MessageInfo] {
        var items: [MessageInfo] = []
        _ = messages.compactMap({ message -> Void in
            let info = MessageInfo(message: message)
            items.append(info)
        })
        return items
    }
}

extension RequestsDataRepository: MessagesProviderDelegate {
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessagesFor threadId: String) {
        guard let index = replace(threadId, with: messagesProxy.fetchMessages(for: threadId)) else { return }
        onUpdateMessageCallback?(index)
    }
}

extension RequestsDataRepository: MessagesProviderRealTimeEventDelegate {
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessageInRealTimeWith messageId: String, for threadId: String) {
        guard let index = replace(threadId, with: messagesProxy.fetchMessages(for: threadId)) else { return }
        onUpdateMessageCallback?(index)
    }
}

extension RequestsDataRepository: ContactsDataProviderDelegate {
    
    func provider(_ contactsProvider: ContactsDataProvider, didUpdate contactId: String) {
        guard let contactEntity = contactsProxy.fetchContact(by: contactId) else { return }
        if let requestItem = create(from: [contactEntity]).first {
            onRealTimeCallback?(requestItem)
        }
    }
    
    func provider(_ threadsProvider: ContactsDataProvider, didReceive error: String) {
        
    }
    
    func provider(_ contactsProvider: ContactsDataProvider, didReceiveContactsWithType type: RequestsScreenType) {
        if type == screenType {
            loadRequestsFromCoreData(with: type)
        }
    }
}
