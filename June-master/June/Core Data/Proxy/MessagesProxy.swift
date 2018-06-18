//
//  MessagesProxy.swift
//  June
//
//  Created by Ostap Holub on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class MessagesProxy: BaseCoreDataProxy {
    
    private var frc: NSFetchedResultsController<Messages>?
    
    // MARK: - General
    
    func addNewMessage() -> Messages {
        let messageItem = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: CoreDataManager.sharedInstance.persistentContainer.viewContext) as! Messages
        return messageItem
    }
    
    // MARK: - Carbon copies
    
    func addNewMessagesBcc() -> Messages_Bcc {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_Bcc", into: managedContext) as! Messages_Bcc
    }
    
    func addNewMessagesCc() -> Messages_Cc {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_Cc", into: managedContext) as! Messages_Cc
    }
    
    // MARK: - Source / destination
    
    func addNewMessageFrom() -> Messages_From {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_From", into: managedContext) as! Messages_From
    }
    
    func addNewMessagesReplyTo() -> Messages_Reply_To {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_Reply_To", into: managedContext) as! Messages_Reply_To
    }
    
    func addNewMessagesTo() -> Messages_To {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_To", into: managedContext) as! Messages_To
    }
    
    // MARK: - Events
    
    // MARK: - Files
    
    func addNewMessagesFiles() -> Messages_Files {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_Files", into: managedContext) as! Messages_Files
    }
    
    // MARK: - Segmented
    
    func addNewMessagesSegmentedHtml() -> Messages_Segmented_Html {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_Segmented_Html", into: managedContext) as! Messages_Segmented_Html
    }
    
    func addNewMessagesSegmentedPro() -> Messages_Segmented_Pro {
        return NSEntityDescription.insertNewObject(forEntityName: "Messages_Segmented_Pro", into: managedContext) as! Messages_Segmented_Pro
    }
    
    func fetchLastSpoolMessage(for id: String) -> Messages? {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "spool_id == %@", id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            return frc?.fetchedObjects?.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchTempMessage(for threadId: String) -> Messages? {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(thread_id == %@) AND (id == %@)", threadId, "tempId")
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
            if let message = frc?.fetchedObjects?.first {
                return message
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchMessagesEntities(forThread id: String) -> [Messages] {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "thread_id == %@", id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            if let messages = frc?.fetchedObjects {
                return messages
            } else {
                return []
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchMessages(for threadId: String) -> [Message] {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "thread_id == %@", threadId)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            var modelMessages = [Message]()
            if let messages = frc?.fetchedObjects {
                for messageEntity in messages {
                    modelMessages.append(Message(with: messageEntity))
                }
                return modelMessages
            } else {
                return []
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchMessages(forMessageId messageId: String) -> [Message] {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", messageId)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            var modelMessages = [Message]()
            if let messages = frc?.fetchedObjects {
                for messageEntity in messages {
                    modelMessages.append(Message(with: messageEntity))
                }
                return modelMessages
            } else {
                return []
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchMessage(by id: String) -> Messages? {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
            if let message = frc?.fetchedObjects?.first {
                return message
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchMessage(byObm obmId: String) -> Messages? {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "obm_id == %@", obmId)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
            if let message = frc?.fetchedObjects?.first {
                return message
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Deletion
    
    func removeTempMessage(for threadId: String) {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(id == %@) AND (thread_id == %@)", "tempId", threadId)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
        frc?.delegate = self
        do {
            try frc?.performFetch()
            if let message = frc?.fetchedObjects?.first {
                CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(message)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeMessage(with id: String) {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages>
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
    
    // MARK: - Private part
    
    private func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return fetchRequest
    }
}

extension MessagesProxy: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //print("OKSANA TEST >> Oksana message \(type)")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("OKSANA TEST >> Oksana message controllerDidChangeContent")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // print("OKSANA TEST >> Oksana message controllerWillChangeContent")
    }
}
