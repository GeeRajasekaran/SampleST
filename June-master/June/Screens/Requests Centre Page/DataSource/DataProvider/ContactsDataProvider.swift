//
//  ContactsDataProvider.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON
import Feathers

struct ContactsDataProviderPropertyKeys {
    static let inbox = "inbox"
    static let accountId = "account_id"
    static let status = "status"
    static let listName = "list_name"
    static let lastMessageDate = "last_message_date"
    static let accounts = "accounts"
    static let createdAt = "created_at"
}

struct ContactsNameValue {
    static let people = "people"
    static let susbcriptions = "subscriptions"
}

protocol ContactsDataProviderDelegate: class {
    func provider(_ contactsProvider: ContactsDataProvider, didUpdate contactId: String)
    func provider(_ contactsProvider: ContactsDataProvider, didReceive error: String)
    func provider(_ contactsProvider: ContactsDataProvider, didReceiveContactsWithType type: RequestsScreenType)
}

class ContactsDataProvider {
    
    let accountKey = "primary_account_id"
    var realTimeListener: ContactRealTimeListener?
    var shouldLoadMore = true
    private let defaultLimit = 10
    weak var delegate: ContactsDataProviderDelegate?
    
    private var contactsProxy = ContactsProxy()
    private var contactsParser = ContactsParser()
    
    //MARK: - real time
    lazy var onPatch: ([String: Any]) -> Void = { [weak self] j in
        guard let sSelf = self else { return }
        let json = JSON(j)
        let contactId  = json["id"].stringValue
        sSelf.saveContact(json)
        sSelf.delegate?.provider(sSelf, didUpdate: contactId)
    }
    
    // MARK: - Request people
    func requestPeople(with skipPeopleCount: Int = 0, shouldSkip: Bool = false) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        let skipCount = shouldSkip == true ? skipPeopleCount : 0
        if let accountId = serializedUserObject[accountKey] as? String {
            let query = Query()
                .eq(property: ContactsDataProviderPropertyKeys.inbox, value: true)
                .eq(property: ContactsDataProviderPropertyKeys.accountId, value: accountId)
                .nin(property: ContactsDataProviderPropertyKeys.status, values: [Status.approved.value, Status.blocked.value, Status.ignored.value])
                .eq(property: ContactsDataProviderPropertyKeys.listName, value: ContactsNameValue.people)
                .skip(prepareSkipCount(skipCount))
                .sort(property: ContactsDataProviderPropertyKeys.lastMessageDate, ordering: ComparisonResult.orderedDescending)
                .limit(20)
            request(with: query, and: .people, with: skipCount)
        }
    }
    
    // MARK: - Request blocked people
    func requestBlockedPeople(with skipPeopleCount: Int = 0, shouldSkip: Bool = false) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        let skipCount = shouldSkip == true ? skipPeopleCount : 0
        if let accountId = serializedUserObject[accountKey] as? String {
            let query = Query()
                .eq(property: ContactsDataProviderPropertyKeys.inbox, value: true)
                .eq(property: ContactsDataProviderPropertyKeys.accountId, value: accountId)
                .eq(property: ContactsDataProviderPropertyKeys.status, value: Status.blocked.value)
                .eq(property: ContactsDataProviderPropertyKeys.listName, value: ContactsNameValue.people)
                .skip(prepareSkipCount(skipCount))
                .sort(property: ContactsDataProviderPropertyKeys.lastMessageDate, ordering: ComparisonResult.orderedDescending)
                .limit(20)
            request(with: query, and: .blockedPeople, with: skipCount)
        }
    }
    
     // MARK: - Request companies
    func requestCompanies(with skipCompaniesCount: Int = 0, shouldSkip: Bool = false) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        let skipCount = shouldSkip == true ? skipCompaniesCount : 0
        if let accountId = serializedUserObject[accountKey] as? String {
            let query = Query()
                .eq(property: ContactsDataProviderPropertyKeys.inbox, value: true)
                .eq(property: ContactsDataProviderPropertyKeys.accountId, value: accountId)
                .nin(property: ContactsDataProviderPropertyKeys.status, values: [Status.approved.value, Status.blocked.value, Status.ignored.value])
                .eq(property: ContactsDataProviderPropertyKeys.listName, value: ContactsNameValue.susbcriptions)
                .skip(prepareSkipCount(skipCount))
                .sort(property: ContactsDataProviderPropertyKeys.lastMessageDate, ordering: ComparisonResult.orderedDescending)
                .limit(20)
            request(with: query, and: .subscriptions, with: skipCount)
        }
    }
    
    // MARK: - Request blocked companies
    func requestBlockedCompanies(with skipCompaniesCount: Int = 0, shouldSkip: Bool = false) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        let skipCount = shouldSkip == true ? skipCompaniesCount : 0
        if let accountId = serializedUserObject[accountKey] as? String {
            let query = Query()
                .eq(property: ContactsDataProviderPropertyKeys.inbox, value: true)
                .eq(property: ContactsDataProviderPropertyKeys.accountId, value: accountId)
                .eq(property: ContactsDataProviderPropertyKeys.status, value: Status.blocked.value)
                .eq(property: ContactsDataProviderPropertyKeys.listName, value: ContactsNameValue.susbcriptions)
                .skip(prepareSkipCount(skipCount))
                .sort(property: ContactsDataProviderPropertyKeys.lastMessageDate, ordering: ComparisonResult.orderedDescending)
                .limit(20)
            request(with: query, and: .blockedSubscriptions, with: skipCount)
        }
    }
    
    func requestTotalPendingPeople(completion: @escaping (Result<Int>) -> Void) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        //TODO: check if needed
        //guard let accounts = serializedUserObject[ContactsDataProviderPropertyKeys.accounts] as? NSArray else { return }
        //guard let account = accounts.firstObject as? [String: Any] else { return }
       // guard let createdDate = account[ContactsDataProviderPropertyKeys.createdAt] as? Int else { return }
        if let accountId = serializedUserObject[accountKey] as? String {
            let query = Query()
                .eq(property: ContactsDataProviderPropertyKeys.inbox, value: true)
                .eq(property: ContactsDataProviderPropertyKeys.accountId, value: accountId)
               // .gt(property: ContactsDataProviderPropertyKeys.lastMessageDate, value: createdDate)
                .nin(property: ContactsDataProviderPropertyKeys.status, values: [Status.approved.value, Status.blocked.value, Status.ignored.value])
            .eq(property: ContactsDataProviderPropertyKeys.listName, value: ContactsNameValue.people)

            sendRequest(with: query, completion: completion)
        }
    }
    
    func requestTotalPendingSubscriptions(completion: @escaping (Result<Int>) -> Void) {
        let query = Query()
            .eq(property: ContactsDataProviderPropertyKeys.inbox, value: true)
            .eq(property: ContactsDataProviderPropertyKeys.listName, value: ContactsNameValue.susbcriptions)
            .nin(property: ContactsDataProviderPropertyKeys.status, values: [Status.approved.value, Status.blocked.value, Status.ignored.value])
        sendRequest(with: query, completion: completion)
    }
    
    //MARK: - get person by email
    func getContactBy(email: String, completion: @escaping (Result<Contacts>) -> Void) {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accountId = serializedUserObject[accountKey] as? String {
            let query = Query()
                .eq(property: ContactsDataProviderPropertyKeys.accountId, value: accountId)
                .eq(property: "email", value: email)
            FeathersManager.Services.contacts.request(.find(query: query))
                .on(value: { [weak self] response in
                    guard let sSelf = self else { return }
                    if let json = JSON(response.data.value).array {
                        guard let firstJson = json.first else { return }
                        sSelf.saveContact(firstJson)
                        if let contactId = firstJson["id"].string {
                            if let contact = sSelf.contactsProxy.fetchContact(by: contactId) {
                                completion(.Success(contact))
                            }
                        }
                    }
                }).startWithFailed({ error in
                    completion(.Error(error.localizedDescription))
                })
        }
    }
    
    func requests(for category: RequestsScreenType) -> [RequestItem] {
        var contacts: [Contacts] = []
        switch category {
        case .people:
            contacts = contactsProxy.fetchPeople()
        case .subscriptions:
            contacts = contactsProxy.fetchSubscriptions()
        case .blockedPeople:
            contacts = contactsProxy.fetchBlockedPeople()
        case .blockedSubscriptions:
            contacts = contactsProxy.fetchBlockedSubscriptions()
        }
        return contacts.compactMap({ contact -> RequestItem in
            return RequestItem(contact: contact)
        })
    }
    
    private func request(with query: Query, and screenType: RequestsScreenType, with skipCount: Int) {
        if skipCount == 0 {
            sendRequest(with: query, and: screenType)
        } else {
            sendRequest(with: query, and: screenType, with: prepareSkipCount(skipCount))
        }
    }

    private func sendRequest(with query: Query, and screenType: RequestsScreenType, with skipCount: Int) {
        FeathersManager.Services.contacts.request(.find(query: query))
            .on(value: { [weak self] response in
                guard let sSelf = self else { return }
                if let array = JSON(response.data.value).array {
                    if array.count == 0 || array.count < sSelf.defaultLimit {
                        self?.shouldLoadMore = false
                    } else {
                        sSelf.shouldLoadMore = true
                        sSelf.saveContacts(array)
                        sSelf.delegate?.provider(sSelf, didReceiveContactsWithType: screenType)
                    }
                }
            }).startWithFailed({ [weak self] error in
                guard let sSelf = self else { return }
                sSelf.delegate?.provider(sSelf, didReceive: error.localizedDescription)
            })
    }
    
    private func sendRequest(with query: Query, and screenType: RequestsScreenType) {
        FeathersManager.Services.contacts.request(.find(query: query))
            .on(value: { [weak self] response in
                guard let sSelf = self else { return }
                if let array = JSON(response.data.value).array {
                    sSelf.clearContacts(with: screenType)
                    if array.count > 0 {
                        sSelf.saveContacts(array)
                        sSelf.delegate?.provider(sSelf, didReceiveContactsWithType: screenType)
                    }
                }
            }).startWithFailed({ [weak self] error in
                guard let sSelf = self else { return }
                sSelf.delegate?.provider(sSelf, didReceive: error.localizedDescription)
            })
    }
    
    private func sendRequest(with query: Query, completion: @escaping (Result<Int>) -> Void) {
        FeathersManager.Services.contacts.request(.find(query: query))
            .on(value: { response in
                let total = response.description.getTotal()
                completion(.Success(total))
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })
    }
    
    // MARK: - Real time
    func subscribeForRealTimeEvents() {
        realTimeListener = ContactRealTimeListener()
        realTimeListener?.subscribeForPatch(event: onPatch)
    }
    
    func unsubscribe() {
        realTimeListener?.unsubscribe()
        realTimeListener = nil
    }
    
    // MARK: - Process section - entity

    //Clear contacts from db when new items comes
    private func clearContacts(with screenType: RequestsScreenType) {
        contactsProxy.removeContacts(with: screenType)
        contactsProxy.saveContext()
    }
    
    private func saveContacts(_ contactsJson: [JSON]) {
        contactsJson.forEach({ element -> Void in
            saveContact(element)
        })
    }
    
    private func saveContact(_ contactJson: JSON) {
        guard let contactId = contactJson["id"].string else { return }
        if let contactEntity = contactsProxy.fetchContact(by: contactId) {
            contactsParser.loadData(from: contactJson, to: contactEntity)
        } else {
            let contact = contactsProxy.addNewEmptyContact()
            contactsParser.loadData(from: contactJson, to: contact)
        }
        contactsProxy.saveContext()
    }
    
    //MARK: - prepare skip count
    private func prepareSkipCount(_ skip: Int) -> Int {
        if skip % 10 != 0 {
            return skip - (skip % 10)
        }
        return skip
    }
}
