//
//  StatusHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/18/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlertBar

class StatusHandler {
    
    // MARK: - Variables
    
    private var parser = ContactsParser()
    private let proxy = ContactsProxy()
    
    func changeStatusAndSave(_ contact: Contacts, with status: Status, completion: @escaping (String) -> Void) {
        
        guard let validatedContactId = ContactsValidator.validate(contactId: contact.id) else {
            return
        }
        
        if let params = parameters(for: contact, with: status) {
            FeathersManager.Services.contacts.request(.patch(id: validatedContactId, data: params, query: nil))
                .on(value: { [weak self] response in
                    if let strongSelf = self {
                        let contactJson = JSON(response.data.value)
                        strongSelf.updateContactsJsonInCoreData(contactJson, completion: completion)
                    }
                }).startWithFailed({ error in
                    completion(error.localizedDescription)
                })
        }
    }
    
    // MARK: - Parameters building
    
    private func parameters(for contact: Contacts, with status: Status) -> [String: Any]? {
        return ["status": status.value] as [String : Any]
    }
    
    private func updateContactsJsonInCoreData(_ jsonObject: JSON, completion: @escaping (String) -> Void) {
        if !jsonObject.isEmpty {
            if let contactId = jsonObject["id"].string {
                if let contactEntity = proxy.fetchContact(by: contactId) {
                    parser.loadData(from: jsonObject, to: contactEntity)
                    proxy.saveContext()
                    completion("")
                }
            } else {
                completion("Can't change status")
            }
        }
    }
}
