//
//  RolodexsService.swift
//  June
//
//  Created by Joshua Cleetus on 3/18/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class RolodexsService {
    unowned var parentVC: RolodexsViewController
    var rolodexsList = [Rolodexs]()
    
    internal init(parentVC: RolodexsViewController) {
        self.parentVC = parentVC
    }
    
    struct RolodexsKeys {
        static let id = "id"
        static let all = "all"
        static let rolodex_subject_id = "rolodex_subject_id"
        static let inbox = "inbox"
        static let last_messages_thread_id = "last_messages_thread_id"
        static let last_message_from = "last_message_from"
        static let last_message_id = "last_message_id"
        static let archived = "archived"
        static let last_message_data_sha = "last_message_data_sha"
        static let drafts = "drafts"
        static let spam = "spam"
        static let last_messages_spool_id = "last_messages_spool_id"
        static let participants = "participants"
        static let last_message_unread = "last_message_unread"
        static let last_message_snippet = "last_message_snippet"
        static let last_message_obm_id = "last_message_obm_id"
        static let last_message_account_id = "last_message_account_id"
        static let trash = "trash"
        static let rolodex_subject_snippet_id = "rolodex_subject_snippet_id"
        static let object = "object"
        static let important = "important"
        static let last_message_subject = "last_message_subject"
        static let sent = "sent"
        static let last_message_date = "last_message_date"
        static let last_message_starred = "last_message_starred"
        static let participants_id = "participants_id"
        static let category = "category"
        static let section = "section"
        static let approved = "approved"
        static let summary = "summary"
        static let named_participants = "named_participants"
        static let unread_spool_count = "unread_spool_count"
        static let starred_spool_count = "starred_spool_count"
        static let unread = "unread"
        static let starred = "starred"
    }
    
    func getNewRolodexs(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Rolodexs> {
        let request: NSFetchRequest<Rolodexs> = Rolodexs.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        let sort = NSSortDescriptor(key: "last_message_date", ascending: ascending)
        sortDescriptors.append(sort)
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = JuneConstants.Rolodexs.emailsLimit
        let predicate1 = NSPredicate(format: "category == %@", "conversations")
        let predicate2 = NSPredicate(format: "spam == \(NSNumber(value:false))")
        let predicate3 = NSPredicate(format: "trash == \(NSNumber(value:false))")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createRolodexsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                print("saved rolodex")
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadRolodexsData()
    }
    
    func saveInCoreDataWithBackgroundFetch(array: [[String: AnyObject]]) {
        _ = array.map{self.createRolodexsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                print("saved rolodex")
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadRolodexOnlyIfThereIsNewObjects()
    }
    
    func getNewUnreads(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Rolodexs> {
        let request: NSFetchRequest<Rolodexs> = Rolodexs.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        let sort = NSSortDescriptor(key: "last_message_date", ascending: ascending)
        sortDescriptors.append(sort)
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = JuneConstants.Rolodexs.emailsLimit
        let predicate1 = NSPredicate(format: "category == %@", "conversations")
        let predicate2 = NSPredicate(format: "spam == \(NSNumber(value:false))")
        let predicate3 = NSPredicate(format: "trash == \(NSNumber(value:false))")
        let predicate4 = NSPredicate(format: "unread == \(NSNumber(value:true))")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }
    
    func saveUnreadsInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createRolodexsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                print("saved rolodex")
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadUnreadsData()
    }
    
    func getNewPins(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Rolodexs> {
        let request: NSFetchRequest<Rolodexs> = Rolodexs.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        let sort = NSSortDescriptor(key: "last_message_date", ascending: ascending)
        sortDescriptors.append(sort)
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = JuneConstants.Rolodexs.emailsLimit
        let predicate1 = NSPredicate(format: "category == %@", "conversations")
        let predicate2 = NSPredicate(format: "spam == \(NSNumber(value:false))")
        let predicate3 = NSPredicate(format: "trash == \(NSNumber(value:false))")
        let predicate4 = NSPredicate(format: "starred == \(NSNumber(value:true))")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }
    
    func savePinsInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createRolodexsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                print("saved rolodex")
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadPinsData()
    }

    
    func createRolodexsEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<Rolodexs> = Rolodexs.fetchRequest()
        if let conversation_id = dictionary[RolodexsKeys.id] as? String {
            request.predicate = NSPredicate(format: "rolodexs_id = %@", conversation_id)
            do {
                let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
                if result.count > 0 {
                    if let rolodexsEntity = result.first {
                        return self.loadRolodexsEntity(dictionary: dictionary, context: context, rolodexsEntity: rolodexsEntity)
                    }
                } else {
                    if let rolodexsEntity = NSEntityDescription.insertNewObject(forEntityName: "Rolodexs", into: context) as? Rolodexs {
                        return self.loadRolodexsEntity(dictionary: dictionary, context: context, rolodexsEntity: rolodexsEntity)
                    }
                }
            }
            catch let error as NSError {
                print("Error checking store existence: \(error.localizedDescription)")
            }
        }
        return nil
    }

    func loadRolodexsEntity(dictionary: [String: AnyObject], context: NSManagedObjectContext, rolodexsEntity: Rolodexs) -> NSManagedObject {
        if let rolodexs_id = dictionary[RolodexsKeys.id] as? String {
            rolodexsEntity.rolodexs_id = rolodexs_id
        }
        if let all = dictionary[RolodexsKeys.all] as? Bool {
            rolodexsEntity.all = all
        }
        if let rolodex_subject_id = dictionary[RolodexsKeys.rolodex_subject_id] as? String {
            rolodexsEntity.rolodex_subject_id = rolodex_subject_id
        }
        if let inbox = dictionary[RolodexsKeys.inbox] as? Bool {
            rolodexsEntity.inbox = inbox
        }
        if let last_messages_thread_id = dictionary[RolodexsKeys.last_messages_thread_id] as? String {
            rolodexsEntity.last_messages_thread_id = last_messages_thread_id
        }
        if let last_message_id = dictionary[RolodexsKeys.last_message_id] as? String {
            rolodexsEntity.last_message_id = last_message_id
        }
        if let archived = dictionary[RolodexsKeys.archived] as? Bool {
            rolodexsEntity.archived = archived
        }
        if let last_message_data_sha = dictionary[RolodexsKeys.last_message_data_sha] as? String {
            rolodexsEntity.last_message_data_sha = last_message_data_sha
        }
        if let drafts = dictionary[RolodexsKeys.drafts] as? Bool {
            rolodexsEntity.drafts = drafts
        }
        if let spam = dictionary[RolodexsKeys.spam] as? Bool {
            rolodexsEntity.spam = spam
        }
        if let last_messages_spool_id = dictionary[RolodexsKeys.last_messages_spool_id] as? String {
            rolodexsEntity.last_messages_spool_id = last_messages_spool_id
        }
        if let last_message_unread = dictionary[RolodexsKeys.last_message_unread] as? Bool {
            rolodexsEntity.last_message_unread = last_message_unread
        }
        if let last_message_snippet = dictionary[RolodexsKeys.last_message_snippet] as? String {
            rolodexsEntity.last_message_snippet = last_message_snippet
        }
        if let last_message_obm_id = dictionary[RolodexsKeys.last_message_obm_id] as? String {
            rolodexsEntity.last_message_obm_id = last_message_obm_id
        }
        if let last_message_account_id = dictionary[RolodexsKeys.last_message_account_id] as? String {
            rolodexsEntity.last_message_account_id = last_message_account_id
        }
        if let trash = dictionary[RolodexsKeys.trash] as? Bool {
            rolodexsEntity.trash = trash
        }
        if let rolodex_subject_snippet_id = dictionary[RolodexsKeys.rolodex_subject_snippet_id] as? String {
            rolodexsEntity.rolodex_subject_snippet_id = rolodex_subject_snippet_id
        }
        if let object = dictionary[RolodexsKeys.object] as? String {
            rolodexsEntity.object = object
        }
        if let important = dictionary[RolodexsKeys.important] as? Bool {
            rolodexsEntity.important = important
        }
        if let last_message_subject = dictionary[RolodexsKeys.last_message_subject] as? String {
            rolodexsEntity.last_message_subject = last_message_subject
        }
        if let sent = dictionary[RolodexsKeys.sent] as? Bool {
            rolodexsEntity.sent = sent
        }
        if let last_message_date = dictionary[RolodexsKeys.last_message_date] as? Int64 {
            rolodexsEntity.last_message_date = last_message_date
        }
        if let last_message_starred = dictionary[RolodexsKeys.last_message_starred] as? Bool {
            rolodexsEntity.last_message_starred = last_message_starred
        }
        if let participants_id = dictionary[RolodexsKeys.participants_id] as? String {
            rolodexsEntity.participants_id = participants_id
        }
        if let category = dictionary[RolodexsKeys.category] as? String {
            rolodexsEntity.category = category
        }
        if let section = dictionary[RolodexsKeys.section] as? String {
            rolodexsEntity.section = section
        }
        if let approved = dictionary[RolodexsKeys.approved] as? Bool {
            rolodexsEntity.approved = approved
        }
        if let summary = dictionary[RolodexsKeys.summary] as? String {
            rolodexsEntity.summary = summary
        }
        if let starred_spool_count = dictionary[RolodexsKeys.starred_spool_count] as? Int16 {
            rolodexsEntity.starred_spool_count = starred_spool_count
        }
        if let unread_spool_count = dictionary[RolodexsKeys.unread_spool_count] as? Int16 {
            rolodexsEntity.unread_spool_count = unread_spool_count
        }
        if let unread = dictionary[RolodexsKeys.unread] as? Bool {
            rolodexsEntity.unread = unread
        }
        if let starred = dictionary[RolodexsKeys.starred] as? Bool {
            rolodexsEntity.starred = starred
        }
        // Last Message From
        rolodexsEntity.rolodexs_last_message_from = nil
        if let last_message_from = dictionary[RolodexsKeys.last_message_from] as? NSArray {
            if last_message_from.count > 0 {
                let lastMessageFrom = Rolodexs_Last_Message_From(context: context)
                let lastMessageFromDict = last_message_from[0] as! [String: Any]
                if let lastMessageFromName = lastMessageFromDict["name"] {
                    lastMessageFrom.name = lastMessageFromName as? String
                }
                if let lastMessageFromEmail = lastMessageFromDict["email"] {
                    lastMessageFrom.email = lastMessageFromEmail as? String
                }
                if let lastMessageFromProfilePic = lastMessageFromDict["profile_pic"] {
                    lastMessageFrom.profile_pic = lastMessageFromProfilePic as? String
                }
                rolodexsEntity.rolodexs_last_message_from = lastMessageFrom
            }
        }
        // Participants
        rolodexsEntity.rolodexs_participants = nil
        if let participants = dictionary[RolodexsKeys.participants] {
            let participantsData = rolodexsEntity.rolodexs_participants?.mutableCopy() as! NSMutableSet
            for participant in participants as! NSArray {
                let participantData = participant as! [String: AnyObject]
                let participants = Rolodexs_Participants(context: context)
                if let participantName = participantData["name"] as? String {
                    participants.name = participantName
                }
                if let participantEmail = participantData["email"] as? String {
                    participants.email = participantEmail
                }
                if let participantProfilePic = participantData["profile_pic"] as? String {
                    participants.profile_pic = participantProfilePic
                }
                participantsData.add(participants)
                rolodexsEntity.addToRolodexs_participants((participantsData.copy() as? NSSet)!)
            }
        }
        // Named Participants
        rolodexsEntity.rolodexs_named_participants = nil
        if let participants = dictionary[RolodexsKeys.named_participants] {
            let participantsData = rolodexsEntity.rolodexs_named_participants?.mutableCopy() as! NSMutableSet
            for participant in participants as! NSArray {
                let participantData = participant as! [String: AnyObject]
                let participants = Rolodexs_Named_Participants(context: context)
                if let participantFirstName = participantData["first_name"] as? String {
                    participants.first_name = participantFirstName
                }
                if let participantLastName = participantData["last_name"] as? String {
                    participants.last_name = participantLastName
                }
                if let participantName = participantData["name"] as? String {
                    participants.name = participantName
                }
                if let participantEmail = participantData["email"] as? String {
                    participants.email = participantEmail
                }
                if let participantProfilePic = participantData["profile_pic"] as? String {
                    participants.profile_pic = participantProfilePic
                }
                participantsData.add(participants)
                rolodexsEntity.addToRolodexs_named_participants((participantsData.copy() as? NSSet)!)
            }
        }
        return rolodexsEntity
    }
    
}
