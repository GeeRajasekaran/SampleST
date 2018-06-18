//
//  ContactsProxy.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/24/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class ContactsProxy: BaseCoreDataProxy {

    var frc: NSFetchedResultsController<Contacts>?
    private let entityName = "Contacts"
    
    //MARK: - create requests
    func addNewEmptyContact() -> Contacts {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataManager.sharedInstance.persistentContainer.viewContext) as! Contacts
        return newItem
    }
    
    //MARK: - fetch requests
    func fetchPeople() -> [Contacts] {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "(list_name == %@) AND (status == %@ OR status = nil) AND (inbox == %@)", "people", "", NSNumber(value: true))
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contacts>
        do {
            try frc?.performFetch()
            if let people = frc?.fetchedObjects {
                return people
            }
            return []
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchSubscriptions() -> [Contacts] {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "(list_name == %@) AND (status == %@ OR status = nil) AND (inbox == %@)", "subscriptions" ,"", NSNumber(value: true) )
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contacts>
        do {
            try frc?.performFetch()
            if let subscriprions = frc?.fetchedObjects {
                return subscriprions
            }
            return []
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchBlockedPeople() -> [Contacts] {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "(list_name == %@) AND (status == %@) AND (inbox == %@)", "people", "blocked", NSNumber(value: true))
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contacts>
        do {
            try frc?.performFetch()
            if let people = frc?.fetchedObjects {
                return people
            }
            return []
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchBlockedSubscriptions() -> [Contacts] {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "(list_name == %@) AND (status == %@) AND (inbox == %@)", "subscriptions", "blocked", NSNumber(value: true))
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contacts>
        do {
            try frc?.performFetch()
            if let subscriptions = frc?.fetchedObjects {
                return subscriptions
            }
            return []
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchContact(by id: String) -> Contacts? {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contacts>
        do {
            try frc?.performFetch()
            guard let contact = frc?.fetchedObjects?.first else { return nil }
            return contact
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchPeopleCount() -> Int {
        return fetchPeople().count
    }
    
    func fetchSubscriptionsCount() -> Int {
        return fetchSubscriptions().count
    }
    
    //MARK: - remove requests
    func removeContact(with id: String) {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contacts>
        
        do {
            try frc?.performFetch()
            if let contacts = frc?.fetchedObjects?.first {
                CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(contacts)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeContacts(with type: RequestsScreenType) {
        var contacts: [Contacts] = []
        switch type {
        case .people:
            contacts = fetchPeople()
        case .blockedPeople:
            contacts = fetchBlockedPeople()
        case .blockedSubscriptions:
            contacts = fetchBlockedSubscriptions()
        case .subscriptions:
            contacts = fetchSubscriptions()
        }
        
        contacts.forEach { contact in
            guard let contactId = contact.id else { return }
            removeContact(with: contactId)
        }
    }
    
    //MARK: - private part
    private func createRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "last_message_date", ascending: false)]
        return fetchRequest
    }
    
    private func accountCreatedAt() -> Int? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]] {
            if let firstAccount = accounts.first {
                return firstAccount["created_at"] as? Int
            }
        }
        return nil
    }
    
    private func accountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        guard let accountId = serializedUserObject["primary_account_id"] as? String else { return nil }
        return accountId
    }
}
