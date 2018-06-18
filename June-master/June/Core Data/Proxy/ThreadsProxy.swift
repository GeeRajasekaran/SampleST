//
//  ThreadsProxy.swift
//  June
//
//  Created by Ostap Holub on 8/21/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import Foundation
import CoreData

class ThreadsProxy: BaseCoreDataProxy {
    
    var frc: NSFetchedResultsController<Threads>?
    // MARK: - Public part
    
    func addNewEmptyThread() -> Threads {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Threads", into: CoreDataManager.sharedInstance.persistentContainer.viewContext) as! Threads
        return newItem
    }
    
    func fetchAllFeedThreads() -> [Threads] {
        let fetchRequest = createFetchRequest()
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Threads>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            return (frc?.fetchedObjects)!
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchThread(by id: String) -> Threads? {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Threads>
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
            if let thread = frc?.fetchedObjects?.first {
                return thread
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchFeedThreads(for category: FeedCategory) -> [Threads] {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category.id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Threads>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            if let threads = frc?.fetchedObjects {
                return threads
            } else {
                return []
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func removeThread(with id: String) {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Threads>
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
            if let threads = frc?.fetchedObjects?.first {
                CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(threads)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchRecentThreads() -> [Threads] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Threads")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "last_message_timestamp", ascending: false)]        
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "category != %@", "conversations"), NSPredicate(format: "spam == %@", NSNumber(value: false)), NSPredicate(format: "trash == %@", NSNumber(value: false)), NSPredicate(format: "approved == %@", NSNumber(value: true))])
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Threads>
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
            if let threads = frc?.fetchedObjects {
                return threads
            } else {
                return []
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    // MARK: - Private part
    
    private func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Threads")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "last_message_timestamp", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "section == %@", "feeds")
        return fetchRequest
    }
    
    private func createRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Threads")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "last_message_timestamp", ascending: false)]
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
}

extension ThreadsProxy: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //print("OKSANA TEST >> Oksana thread \(type)")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("OKSANA TEST >> Oksana thread controllerDidChangeContent")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("OKSANA TEST >> Oksana thread controllerWillChangeContent")
    }
}
