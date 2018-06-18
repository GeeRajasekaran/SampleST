//
//  DraftsProxy.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/1/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData

class DraftsProxy: BaseCoreDataProxy {
    
    var frc: NSFetchedResultsController<Drafts>?
    private let entityName = "Drafts"
    
    //MARK: - create drafts
    func addNewEmptyDrafts() -> Drafts {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataManager.sharedInstance.persistentContainer.viewContext) as! Drafts
        return newItem
    }
    
    //MARK: - fetch draft
    func fetchDraft(by messageId: String) -> Drafts? {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "message_id == %@", messageId)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Drafts>
        do {
            try frc?.performFetch()
            if let draft = frc?.fetchedObjects?.first {
                return draft
            }
            return nil
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Deletion
    
    func removeDraft(with messageId: String) {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "message_id == %@", messageId)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Drafts>
       
        do {
            try frc?.performFetch()
            if let draft = frc?.fetchedObjects?.first {
                CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(draft)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeDraft(threadId: String?) {
        guard let unwrappedThreadId = threadId else { return }
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "thread_id == %@", unwrappedThreadId)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Drafts>
        
        do {
            try frc?.performFetch()
            frc?.fetchedObjects?.forEach { draft in
                CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(draft)
            }
        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    //MARK: - private part
    private func createRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "message_id", ascending: false)]
        return fetchRequest
    }
}

    // MARK: - Drafts for Responder

extension DraftsProxy {
    
    func saveDraft(with metadata: ResponderMetadata) {
        guard metadata.message.isEmpty == false else { return }
        guard let draft = fetchDraft(byThreadId: metadata.config.thread.id) else {
            newDraft(with: metadata)
            return
        }
        update(draft, with: metadata)
    }
    
    func fetchDraft(byThreadId: String?) -> Drafts? {
        guard let unwrappedThreadId = byThreadId else { return nil }
        let request = createRequest()
        request.predicate = NSPredicate(format: "(thread_id == %@) ", unwrappedThreadId)
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Drafts>
        do {
            try frc?.performFetch()
            if let draft = frc?.fetchedObjects?.first {
                return draft
            }
            return nil
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func update(_ draft: Drafts, with metadata: ResponderMetadata) {
        load(metadata: metadata, into: draft)
        saveContext()
    }
    
    private func newDraft(with metadata: ResponderMetadata) {
        let draft = addNewEmptyDrafts()
        load(metadata: metadata, into: draft)
        saveContext()
    }
    
    private func load(metadata: ResponderMetadata, into entity: Drafts) {
        // save properties here
        entity.body = metadata.message
        entity.thread_id = metadata.config.thread.id
        entity.subject = metadata.config.thread.subject
        entity.message_id = metadata.config.message.id
        
        //save relationships here
        entity.messages_cc = metadata.config.message.messages_cc
        entity.messages_bcc = metadata.config.message.messages_bcc
        entity.messages_to = NSSet()
        
        metadata.recipients.forEach { r in
            if r.destination == .input { return }
            let messagesTo = Messages_To(context: entity.managedObjectContext!)
            messagesTo.email = r.email
            messagesTo.name = r.name
            messagesTo.profile_pic = r.profileImage
            entity.addToMessages_to(messagesTo)
        }
        
        entity.messages_from = metadata.config.message.messages_from
        entity.messages_files = metadata.config.message.messages_files
        entity.messages_files = NSSet()
        
        metadata.attachments.forEach { a in
            let messageFile = Messages_Files(context: entity.managedObjectContext!)
            messageFile.file_name = a.filename
            messageFile.content_id = a.contentId
            messageFile.content_type = a.contentType
            messageFile.size = a.size
            messageFile.id = a.id
            entity.addToMessages_files(messageFile)
        }
    }
}
