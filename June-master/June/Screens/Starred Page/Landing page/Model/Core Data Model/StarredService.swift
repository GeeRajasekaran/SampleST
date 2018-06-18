//
//  ThreadsService.swift
//  June
//
//  Created by Tatia Chachua on 05/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import Foundation
import CoreData

class StarredService {
    
    unowned var parentVC: StarredViewController
    var threadsList = [Threads]()
    
    internal init(parentVC: StarredViewController) {
        self.parentVC = parentVC
    }
    
    // MARK: - CRUD
    func update(currentThreadStarredValue currentThread: Threads, withNewStarredValue newStarred: Bool) {
        currentThread.starred = newStarred
        save(currentThread)
    }
    
    func updateFeed(currentThreadStarredValue currentThread: Threads, withNewStarredValue newStarred: Bool) {
        currentThread.starred = newStarred
        save(currentThread)
    }
    
    func updateStarredValue(threadId: String, starredValue: Bool) {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", threadId)
        do {
            let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                if let thread = result.first {
                    thread.starred = starredValue
                    self.save(thread)
                }
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
    }
    
    // DELETE
    func deleteThread(threadToDelete thread: Threads) {
        CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(thread)
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch let error as NSError {
            print("Delete item failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private
    private func save(_ thread: Threads) {
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
            
        }
        catch let error as NSError {
            print("Add item to thread failed: \(error.localizedDescription)")
        }
    }
    
    // Starred
    func getAllStarreddConversations(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Threads> {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        let sort = NSSortDescriptor(key: "last_message_timestamp", ascending: ascending)
        sortDescriptors.append(sort)
        
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = 20
        
        let predicate1 = NSPredicate(format: "starred = \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "section == %@", "convos")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.parentVC.fetchedResultController = fetchedResultsController
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }
    
    // Starred feed
    func getStarredFeedConversations(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Threads> {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        let sort = NSSortDescriptor(key: "last_message_timestamp", ascending: ascending)
        sortDescriptors.append(sort)
        
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = 20
        
        let predicate1 = NSPredicate(format: "starred = \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "section == %@", "feeds")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,  managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.parentVC.fetchedResultController2 = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }
    
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createThreadsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadData()
    }
    
    func saveInCoreDataWith2(array: [[String: AnyObject]]) {
        _ = array.map{self.createThreadsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadData2()
        self.parentVC.feedTable?.reloadData()
    }
    
    func saveInCoreDataWithRealtimeEvents(array: [[String: AnyObject]]) {
        _ = array.map{self.createThreadsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        })
    }

    
    func createThreadsEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let conversation_id = dictionary["id"] as! String
        request.predicate = NSPredicate(format: "id = %@", conversation_id)
        do {
            let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                if let threadsEntity = result.first {
                    if let conversation_id = dictionary["id"] as? String {
                        threadsEntity.id = conversation_id
                    }
                    
                    if let object = dictionary["object"] as? String {
                        threadsEntity.object = object
                    }
                    
                    if let account_id = dictionary["account_id"] as? String {
                        threadsEntity.account_id = account_id
                    }
                    
                    if let last_message_timestamp = dictionary["last_message_timestamp"] as? Int32 {
                        threadsEntity.last_message_timestamp  = last_message_timestamp
                    }
                    
                    if let last_message_received_timestamp = dictionary["last_message_received_timestamp"] as? Int32 {
                        threadsEntity.last_message_received_timestamp  = last_message_received_timestamp
                    }
                    
                    if let has_attachments = dictionary["has_attachments"] as? Bool {
                        print("has_attachments ", has_attachments)
                        threadsEntity.has_attachments = has_attachments
                    }
                    
                    if let first_message_timestamp = dictionary["first_message_timestamp"] as? Int32 {
                        threadsEntity.first_message_timestamp = first_message_timestamp
                    }
                    
                    if let subject = dictionary["subject"] as? String {
                        threadsEntity.subject = subject
                    }
                    
                    if let last_message_received_timestamp = dictionary["last_message_received_timestamp"] as? Int32 {
                        threadsEntity.last_message_received_timestamp = last_message_received_timestamp
                    }
                    
                    if let last_message_sent_timestamp = dictionary["last_message_sent_timestamp"] as? Int32 {
                        threadsEntity.last_message_sent_timestamp = last_message_sent_timestamp
                    }
                    
                    if let summary = dictionary["summary"] as? String {
                        threadsEntity.summary = summary
                    } else {
                        threadsEntity.summary = ""
                    }
                    
                    if let snippet = dictionary["snippet"] as? String {
                        
                        threadsEntity.snippet = snippet
                    } else {
                        threadsEntity.snippet = ""
                    }
                    
                    // Participants
                    if let participants = dictionary["participants"] {
                        let participantsData = threadsEntity.participants?.mutableCopy() as! NSMutableSet
                        for participant in participants as! NSArray {
                            let participantData = participant as! [String: AnyObject]
                            
                            let participants = Participants(context: context)
                            if let participantName = participantData["name"] as? String {
                                participants.name = participantName
                            }
                            if let participantEmail = participantData["email"] as? String {
                                participants.email = participantEmail
                            }
                            
                            participantsData.add(participants)
                            threadsEntity.addToParticipants((participantsData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let message_ids = dictionary["message_ids"] as? NSArray {
                        threadsEntity.message_ids = message_ids
                    }
                    
                    if let starred = dictionary["starred"] as? Bool {
                        threadsEntity.starred = starred
                    }
                    
                    if let unread = dictionary["unread"] as? Bool {
                        print("unread =", unread)
                        threadsEntity.unread = unread
                    }
                    
                    if let section = dictionary["section"] as? String {
                        threadsEntity.section = section
                    }
                    
                    if let category = dictionary["category"] as? String {
                        threadsEntity.category = category
                    }
                    
                    if let cards = dictionary["cards"] as? [String: AnyObject] {
                        let vendorInfo = Vendor(context: context)
                        if let vendorDict = cards["vendor"] as? [String: AnyObject] {
                            if let vendorName = vendorDict["name"] as? String {
                                vendorInfo.name = vendorName
                            }
                            if let vendorIcon = vendorDict["icon"] as? String {
                                vendorInfo.name = vendorIcon
                            }
                        }
                        
                        let cardInfo = Cards(context: context)
                        cardInfo.vendor = vendorInfo
                        
                        if let object = cards["object"] as? String {
                            cardInfo.object = object
                        }
                        
                        if let thread_id = cards["thread_id"] as? String {
                            cardInfo.thread_id = thread_id
                        }
                        
                        if let message_id = cards["message_id"] as? String {
                            cardInfo.message_id = message_id
                        }
                        
                        if let template = cards["template"] as? String {
                            cardInfo.template = template
                        }
                        
                        if let bill_number = cards["bill_number"] as? String {
                            cardInfo.bill_number = bill_number
                        }
                        
                        if let bill_total = cards["bill_total"] as? String {
                            cardInfo.bill_total = bill_total
                        }
                        
                        if let bill_due_date = cards["bill_due_date"] as? Int32 {
                            cardInfo.bill_due_date = bill_due_date
                        }
                        
                        if let order_number = cards["order_number"] as? String {
                            cardInfo.order_number = order_number
                        }
                        
                        if let order_total = cards["order_total"] as? String {
                            cardInfo.order_total = order_total
                        }
                        
                        if let refund_total = cards["refund_total"] as? String {
                            cardInfo.refund_total = refund_total
                        }
                        
                        if let tracking_numbers = cards["tracking_numbers"] as? NSArray {
                            cardInfo.tracking_numbers = tracking_numbers
                        }
                        
                        if let items = cards["items"] as? NSArray {
                            cardInfo.items = items
                        }
                        
                        if let from = cards["from"] as? String {
                            cardInfo.from = from
                        }
                        
                        if let to = cards["to"] as? String {
                            cardInfo.to = to
                        }
                        
                        if let payment_id = cards["payment_id"] as? String {
                            cardInfo.payment_id = payment_id
                        }
                        
                        if let transaction_date = cards["transaction_date"] as? Int32 {
                            cardInfo.transaction_date = transaction_date
                        }
                        
                        if let transaction_amount = cards["transaction_amount"] as? Int32 {
                            cardInfo.transaction_amount = transaction_amount
                        }
                        
                        if let email_image = cards["email_image"] as? String {
                            cardInfo.email_image = email_image
                        }
                        
                        if let qwant_image = cards["qwant_image"] as? String {
                            cardInfo.qwant_image = qwant_image
                        }
                        
                        threadsEntity.cards = cardInfo
                    }
                    
                    if let approved = dictionary["approved"] as? Bool {
                        print("approved = ", approved)
                        threadsEntity.approved = approved
                    }
                    
                    if let spam = dictionary["spam"] as? Bool {
                        print("spam = ", spam)
                        threadsEntity.spam = spam
                    }
                    
                    if let trash = dictionary["trash"] as? Bool {
                        print("trash = ", trash)
                        threadsEntity.trash = trash
                    }
                    
                    if let sent = dictionary["sent"] as? Bool {
                        threadsEntity.sent = sent
                    }
                    
                    if let inbox = dictionary["inbox"] as? Bool {
                        threadsEntity.inbox = inbox
                    }
                    
                    if let important = dictionary["important"] as? Bool {
                        threadsEntity.important = important
                    }
                    
                    if let archived = dictionary["archived"] as? Bool {
                        threadsEntity.archived = archived
                    }
                    
                    if let all = dictionary["all"] as? Bool {
                        print("All = ", all)
                        threadsEntity.all = all
                    }
                    print("all = ", dictionary["all"] as Any)
                    
                    if let broadcasted_at = dictionary["broadcasted_at"] as? Int32 {
                        threadsEntity.broadcasted_at = broadcasted_at
                    }
                    
                    if let block_id = dictionary["block_id"] as? String {
                        threadsEntity.block_id = block_id
                    }
                    
                    // Last Message From
                    if let last_message_from = dictionary["last_message_from"] as? NSArray {
                        if last_message_from.count > 0 {
                            let lastMessageFrom = LastMessageFrom(context: context)
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
                            threadsEntity.last_message_from = lastMessageFrom
                        }
                    }
                    
                    return threadsEntity
                    
                }
                
            } else {
                
                if let threadsEntity = NSEntityDescription.insertNewObject(forEntityName: "Threads", into: context) as? Threads {
                    
                    if let conversation_id = dictionary["id"] as? String {
                        threadsEntity.id = conversation_id
                    }
                    
                    if let object = dictionary["object"] as? String {
                        threadsEntity.object = object
                    }
                    
                    if let account_id = dictionary["account_id"] as? String {
                        threadsEntity.account_id = account_id
                    }
                    
                    if let last_message_timestamp = dictionary["last_message_timestamp"] as? Int32 {
                        threadsEntity.last_message_timestamp  = last_message_timestamp
                    }
                    
                    if let last_message_received_timestamp = dictionary["last_message_received_timestamp"] as? Int32 {
                        threadsEntity.last_message_received_timestamp  = last_message_received_timestamp
                    }
                    
                    if let has_attachments = dictionary["has_attachments"] as? Bool {
                        print("has_attachments ", has_attachments)
                        threadsEntity.has_attachments = has_attachments
                    }
                    
                    if let first_message_timestamp = dictionary["first_message_timestamp"] as? Int32 {
                        threadsEntity.first_message_timestamp = first_message_timestamp
                    }
                    
                    if let subject = dictionary["subject"] as? String {
                        threadsEntity.subject = subject
                    }
                    
                    if let last_message_received_timestamp = dictionary["last_message_received_timestamp"] as? Int32 {
                        threadsEntity.last_message_received_timestamp = last_message_received_timestamp
                    }
                    
                    if let last_message_sent_timestamp = dictionary["last_message_sent_timestamp"] as? Int32 {
                        threadsEntity.last_message_sent_timestamp = last_message_sent_timestamp
                    }
                    
                    if let summary = dictionary["summary"] as? String {
                        threadsEntity.summary = summary
                    } else {
                        threadsEntity.summary = ""
                    }
                    
                    if let snippet = dictionary["snippet"] as? String {
                        
                        threadsEntity.snippet = snippet
                    } else {
                        threadsEntity.snippet = ""
                    }
                    
                    // Participants
                    if let participants = dictionary["participants"] {
                        let participantsData = threadsEntity.participants?.mutableCopy() as! NSMutableSet
                        for participant in participants as! NSArray {
                            let participantData = participant as! [String: AnyObject]
                            
                            let participants = Participants(context: context)
                            if let participantName = participantData["name"] as? String {
                                participants.name = participantName
                            }
                            if let participantEmail = participantData["email"] as? String {
                                participants.email = participantEmail
                            }
                            
                            participantsData.add(participants)
                            threadsEntity.addToParticipants((participantsData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let message_ids = dictionary["message_ids"] as? NSArray {
                        threadsEntity.message_ids = message_ids
                    }
                    
                    if let starred = dictionary["starred"] as? Bool {
                        threadsEntity.starred = starred
                    }
                    
                    if let unread = dictionary["unread"] as? Bool {
                        print("unread =", unread)
                        threadsEntity.unread = unread
                    }
                    
                    if let section = dictionary["section"] as? String {
                        threadsEntity.section = section
                    }
                    
                    if let category = dictionary["category"] as? String {
                        threadsEntity.category = category
                    }
                    
                    if let cards = dictionary["cards"] as? [String: AnyObject] {
                        let vendorInfo = Vendor(context: context)
                        if let vendorDict = cards["vendor"] as? [String: AnyObject] {
                            if let vendorName = vendorDict["name"] as? String {
                                vendorInfo.name = vendorName
                            }
                            if let vendorIcon = vendorDict["icon"] as? String {
                                vendorInfo.name = vendorIcon
                            }
                        }
                        
                        let cardInfo = Cards(context: context)
                        cardInfo.vendor = vendorInfo
                        
                        if let object = cards["object"] as? String {
                            cardInfo.object = object
                        }
                        
                        if let thread_id = cards["thread_id"] as? String {
                            cardInfo.thread_id = thread_id
                        }
                        
                        if let message_id = cards["message_id"] as? String {
                            cardInfo.message_id = message_id
                        }
                        
                        if let template = cards["template"] as? String {
                            cardInfo.template = template
                        }
                        
                        if let bill_number = cards["bill_number"] as? String {
                            cardInfo.bill_number = bill_number
                        }
                        
                        if let bill_total = cards["bill_total"] as? String {
                            cardInfo.bill_total = bill_total
                        }
                        
                        if let bill_due_date = cards["bill_due_date"] as? Int32 {
                            cardInfo.bill_due_date = bill_due_date
                        }
                        
                        if let order_number = cards["order_number"] as? String {
                            cardInfo.order_number = order_number
                        }
                        
                        if let order_total = cards["order_total"] as? String {
                            cardInfo.order_total = order_total
                        }
                        
                        if let refund_total = cards["refund_total"] as? String {
                            cardInfo.refund_total = refund_total
                        }
                        
                        if let tracking_numbers = cards["tracking_numbers"] as? NSArray {
                            cardInfo.tracking_numbers = tracking_numbers
                        }
                        
                        if let items = cards["items"] as? NSArray {
                            cardInfo.items = items
                        }
                        
                        if let from = cards["from"] as? String {
                            cardInfo.from = from
                        }
                        
                        if let to = cards["to"] as? String {
                            cardInfo.to = to
                        }
                        
                        if let payment_id = cards["payment_id"] as? String {
                            cardInfo.payment_id = payment_id
                        }
                        
                        if let transaction_date = cards["transaction_date"] as? Int32 {
                            cardInfo.transaction_date = transaction_date
                        }
                        
                        if let transaction_amount = cards["transaction_amount"] as? Int32 {
                            cardInfo.transaction_amount = transaction_amount
                        }
                        
                        if let email_image = cards["email_image"] as? String {
                            cardInfo.email_image = email_image
                        }
                        
                        if let qwant_image = cards["qwant_image"] as? String {
                            cardInfo.qwant_image = qwant_image
                        }
                        
                        threadsEntity.cards = cardInfo
                    }
                    
                    if let approved = dictionary["approved"] as? Bool {
                        print("approved = ", approved)
                        threadsEntity.approved = approved
                    }
                    
                    if let spam = dictionary["spam"] as? Bool {
                        print("spam = ", spam)
                        threadsEntity.spam = spam
                    }
                    
                    if let trash = dictionary["trash"] as? Bool {
                        print("trash = ", trash)
                        threadsEntity.trash = trash
                    }
                    
                    if let sent = dictionary["sent"] as? Bool {
                        threadsEntity.sent = sent
                    }
                    
                    if let inbox = dictionary["inbox"] as? Bool {
                        threadsEntity.inbox = inbox
                    }
                    
                    if let important = dictionary["important"] as? Bool {
                        threadsEntity.important = important
                    }
                    
                    if let archived = dictionary["archived"] as? Bool {
                        threadsEntity.archived = archived
                    }
                    
                    if let all = dictionary["all"] as? Bool {
                        print("All = ", all)
                        threadsEntity.all = all
                    }
                    print("all = ", dictionary["all"] as Any)
                    
                    if let broadcasted_at = dictionary["broadcasted_at"] as? Int32 {
                        threadsEntity.broadcasted_at = broadcasted_at
                    }
                    
                    if let block_id = dictionary["block_id"] as? String {
                        threadsEntity.block_id = block_id
                    }
                    
                    // Last Message From
                    if let last_message_from = dictionary["last_message_from"] as? NSArray {
                        if last_message_from.count > 0 {
                            let lastMessageFrom = LastMessageFrom(context: context)
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
                            threadsEntity.last_message_from = lastMessageFrom
                        }
                    }
                    
                    return threadsEntity
                }
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func threadExists(_ objectId: String) -> Threads? {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", objectId)
        do {
            let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                return result.first
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveMessagesInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createMessagesEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        })
    }
    
    func createMessagesEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        let conversation_id = dictionary["_id"] as! String
        request.predicate = NSPredicate(format: "messages_id = %@", conversation_id)
        do {
            let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                if let threadsEntity = result.first {
                    
                    if let conversation_id = dictionary["id"] as? String {
                        threadsEntity.id = conversation_id
                    }
                    
                    if let messages_id = dictionary["_id"] as? String {
                        threadsEntity.messages_id = messages_id
                    }
                    
                    if let rolodex_id = dictionary["rolodex_id"] as? String {
                        threadsEntity.rolodex_id = rolodex_id
                    }
                    
                    if let thread_id = dictionary["thread_id"] as? String {
                        threadsEntity.thread_id  = thread_id
                    }
                    
                    if let obm_id = dictionary["obm_id"] as? String {
                        threadsEntity.obm_id  = obm_id
                    }
                    
                    if let subject = dictionary["subject"] as? String {
                        threadsEntity.subject = subject
                    }
                    
                    threadsEntity.messages_from = nil
                    
                    if let messages_from = dictionary["from"] as? NSArray {
                        let fromData = threadsEntity.messages_from?.mutableCopy() as! NSMutableSet
                        for from in messages_from {
                            let messagesFromData = from  as! [String: AnyObject]
                            let messagesFrom = Messages_From(context: context)
                            if let messagesFromName = messagesFromData["name"] as? String {
                                messagesFrom.name = messagesFromName
                            }
                            if let messagesFromEmail = messagesFromData["email"] as? String {
                                messagesFrom.email = messagesFromEmail
                            }
                            if let messagesFromProfilePic = messagesFromData["profile_pic"] as? String {
                                messagesFrom.profile_pic = messagesFromProfilePic
                            }
                            fromData.add(messagesFrom)
                            threadsEntity.addToMessages_from((fromData.copy() as? NSSet)!)
                        }
                    }
                    
                    threadsEntity.messages_to = nil
                    
                    if let messages_to = dictionary["to"] as? NSArray {
                        let toData = threadsEntity.messages_to?.mutableCopy() as! NSMutableSet
                        for to in messages_to {
                            let messagesToData = to as! [String: AnyObject]
                            let messagesTo = Messages_To(context: context)
                            if let messagesToName = messagesToData["name"] as? String {
                                messagesTo.name = messagesToName
                            }
                            if let messagesToEmail = messagesToData["email"] as? String {
                                messagesTo.email = messagesToEmail
                            }
                            if let messagesToProfilePic = messagesToData["profile_pic"] as? String {
                                messagesTo.profile_pic = messagesToProfilePic
                            }
                            toData.add(messagesTo)
                            threadsEntity.addToMessages_to((toData.copy() as? NSSet)!)
                        }
                    }
                    
                    threadsEntity.messages_cc = nil
                    
                    if let messages_cc = dictionary["cc"] as? NSArray {
                        let toData = threadsEntity.messages_cc?.mutableCopy() as! NSMutableSet
                        for to in messages_cc {
                            let messagesCcData = to as! [String: AnyObject]
                            let messagesCc = Messages_Cc(context: context)
                            if let messagesCcName = messagesCcData["name"] as? String {
                                messagesCc.name = messagesCcName
                            }
                            if let messagesCcEmail = messagesCcData["email"] as? String {
                                messagesCc.email = messagesCcEmail
                            }
                            if let messagesCcProfilePic = messagesCcData["profile_pic"] as? String {
                                messagesCc.profile_pic = messagesCcProfilePic
                            }
                            toData.add(messagesCc)
                            threadsEntity.addToMessages_cc((toData.copy() as? NSSet)!)
                        }
                    }
                    
                    threadsEntity.messages_bcc = nil
                    
                    if let messages_bcc = dictionary["bcc"] as? NSArray {
                        let toData = threadsEntity.messages_bcc?.mutableCopy() as! NSMutableSet
                        for to in messages_bcc {
                            let messagesBccData = to as! [String: AnyObject]
                            let messagesBcc = Messages_Bcc(context: context)
                            if let messagesBccName = messagesBccData["name"] as? String {
                                messagesBcc.name = messagesBccName
                            }
                            if let messagesBccEmail = messagesBccData["email"] as? String {
                                messagesBcc.email = messagesBccEmail
                            }
                            if let messagesBccProfilePic = messagesBccData["profile_pic"] as? String {
                                messagesBcc.profile_pic = messagesBccProfilePic
                            }
                            toData.add(messagesBcc)
                            threadsEntity.addToMessages_bcc((toData.copy() as? NSSet)!)
                        }
                    }
                    
                    threadsEntity.messages_files = nil
                    if let messages_files = dictionary["files"] as? NSArray {
                        let filesData = threadsEntity.messages_files?.mutableCopy() as! NSMutableSet
                        for file in messages_files {
                            let messagesFileData = file  as! [String: AnyObject]
                            let messagesFile = Messages_Files(context: context)
                            if let name = messagesFileData["filename"] as? String {
                                messagesFile.file_name = name
                            }
                            if let contentType = messagesFileData["content_type"] as? String {
                                messagesFile.content_type = contentType
                            }
                            if let id = messagesFileData["id"] as? String {
                                messagesFile.id = id
                            }
                            if let size = messagesFileData["size"] as? Int32 {
                                messagesFile.size = size
                            }
                            filesData.add(messagesFile)
                            threadsEntity.addToMessages_files((filesData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let snippet = dictionary["snippet"] as? String {
                        threadsEntity.snippet = snippet
                    }
                    
                    if let last_message_from_contact_id = dictionary["last_message_from_contact_id"] as? String {
                        threadsEntity.last_message_from_contact_id = last_message_from_contact_id
                    }
                    
                    if let body = dictionary["body"] as? String {
                        threadsEntity.body = body
                    }
                    
                    if let account_id = dictionary["account_id"] as? String {
                        threadsEntity.account_id = account_id
                    }
                    
                    if let object = dictionary["object"] as? String {
                        threadsEntity.object = object
                    }
                    
                    if let date = dictionary["date"] as? Int32 {
                        threadsEntity.date = date
                    }
                    
                    if let data_sha256 = dictionary["data_sha256"] as? String {
                        threadsEntity.data_sha256 = data_sha256
                    }
                    
                    if let spool_id = dictionary["spool_id"] as? String {
                        threadsEntity.spool_id = spool_id
                    }
                    
                    if let starred = dictionary["starred"] as? Bool {
                        threadsEntity.starred = starred
                    }
                    
                    if let unread = dictionary["unread"] as? Bool {
                        threadsEntity.unread = unread
                    }
                    
                    if let character_count = dictionary["character_count"] as? Int32 {
                        threadsEntity.character_count = character_count
                    }
                    
                    if let emotion_score = dictionary["emotion_score"] as? Double {
                        threadsEntity.emotion_score = emotion_score
                    }
                    
                    if let word_count = dictionary["word_count"] as? Int32 {
                        threadsEntity.word_count = word_count
                    }
                    
                    threadsEntity.messages_segmented_html = nil
                    
                    if let segmented_html = dictionary["segmented_html"] as? NSArray {
                        let toData = threadsEntity.messages_segmented_html?.mutableCopy() as! NSMutableSet
                        for to in segmented_html {
                            let segmentedHtmlData = to as! [String: AnyObject]
                            let segmentedHtml = Messages_Segmented_Html(context: context)
                            if let segmentedHtmlType = segmentedHtmlData["type"] as? String {
                                segmentedHtml.type = segmentedHtmlType
                            }
                            if let segmentedHtmlOrder = segmentedHtmlData["order"] as? Int16 {
                                segmentedHtml.order = segmentedHtmlOrder
                            }
                            if let segmentedHtmlString = segmentedHtmlData["html"] as? String {
                                segmentedHtml.html = segmentedHtmlString
                            }
                            if let htmlMarkDownString = segmentedHtmlData["html_markdown"] as? String {
                                segmentedHtml.html_markdown = htmlMarkDownString
                                
                            }
                            toData.add(segmentedHtml)
                            threadsEntity.addToMessages_segmented_html((toData.copy() as? NSSet)!)
                        }
                        
                        for to in segmented_html {
                            let segmentedHtmlData = to as! [String: AnyObject]
                            if let forwarded_from = segmentedHtmlData["from"] as? NSArray {
                                let forwardedFromData = threadsEntity.messages_forwarded_from?.mutableCopy() as! NSMutableSet
                                for from in forwarded_from {
                                    let messagesForwardedFromData = from  as! [String: AnyObject]
                                    let messagesForwardedFrom = Messages_Forwarded_From(context: context)
                                    if let messagesForwardedFromName = messagesForwardedFromData["name"] as? String {
                                        messagesForwardedFrom.name = messagesForwardedFromName
                                    }
                                    if let messagesFromEmail = messagesForwardedFromData["email"] as? String {
                                        messagesForwardedFrom.email = messagesFromEmail
                                    }
                                    if let messagesFromProfilePic = messagesForwardedFromData["profile_pic"] as? String {
                                        messagesForwardedFrom.profile_pic = messagesFromProfilePic
                                    }
                                    forwardedFromData.add(messagesForwardedFrom)
                                    threadsEntity.addToMessages_forwarded_from((forwardedFromData.copy() as? NSSet)!)
                                }
                            }
                        }
                    }
                    
                    if let summary = dictionary["summary"] as? String {
                        threadsEntity.summary = summary
                    }
                    
                    if let category_ids = dictionary["category_ids"] as? NSArray {
                        threadsEntity.category_ids = category_ids
                    }
                    
                    if let section = dictionary["section"] as? String {
                        threadsEntity.section = section
                    }
                    
                    if let all = dictionary["all"] as? Bool {
                        threadsEntity.all = all
                    }
                    
                    if let inbox = dictionary["inbox"] as? Bool {
                        threadsEntity.inbox = inbox
                    }
                    
                    if let archived = dictionary["archived"] as? Bool {
                        threadsEntity.archived = archived
                    }
                    
                    if let drafts = dictionary["drafts"] as? Bool {
                        threadsEntity.drafts = drafts
                    }
                    
                    if let spam = dictionary["spam"] as? Bool {
                        threadsEntity.spam = spam
                    }
                    
                    if let trash = dictionary["trash"] as? Bool {
                        threadsEntity.trash = trash
                    }
                    
                    if let sent = dictionary["sent"] as? Bool {
                        threadsEntity.sent = sent
                    }
                    
                    if let important = dictionary["important"] as? Bool {
                        threadsEntity.important = important
                    }
                    
                    return threadsEntity
                    
                }
                
            } else {
                
                if let threadsEntity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: context) as? Messages {
                    
                    if let conversation_id = dictionary["id"] as? String {
                        threadsEntity.id = conversation_id
                    }
                    
                    if let messages_id = dictionary["_id"] as? String {
                        threadsEntity.messages_id = messages_id
                    }
                    
                    if let rolodex_id = dictionary["rolodex_id"] as? String {
                        threadsEntity.rolodex_id = rolodex_id
                    }
                    
                    if let thread_id = dictionary["thread_id"] as? String {
                        threadsEntity.thread_id  = thread_id
                    }
                    
                    if let obm_id = dictionary["obm_id"] as? String {
                        threadsEntity.obm_id  = obm_id
                    }
                    
                    if let subject = dictionary["subject"] as? String {
                        threadsEntity.subject = subject
                    }
                    
                    if let messages_from = dictionary["from"] as? NSArray {
                        let fromData = threadsEntity.messages_from?.mutableCopy() as! NSMutableSet
                        for from in messages_from {
                            let messagesFromData = from  as! [String: AnyObject]
                            let messagesFrom = Messages_From(context: context)
                            if let messagesFromName = messagesFromData["name"] as? String {
                                messagesFrom.name = messagesFromName
                            }
                            if let messagesFromEmail = messagesFromData["email"] as? String {
                                messagesFrom.email = messagesFromEmail
                            }
                            if let messagesFromProfilePic = messagesFromData["profile_pic"] as? String {
                                messagesFrom.profile_pic = messagesFromProfilePic
                            }
                            fromData.add(messagesFrom)
                            threadsEntity.addToMessages_from((fromData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let messages_to = dictionary["to"] as? NSArray {
                        let toData = threadsEntity.messages_to?.mutableCopy() as! NSMutableSet
                        for to in messages_to {
                            let messagesToData = to as! [String: AnyObject]
                            let messagesTo = Messages_To(context: context)
                            if let messagesToName = messagesToData["name"] as? String {
                                messagesTo.name = messagesToName
                            }
                            if let messagesToEmail = messagesToData["email"] as? String {
                                messagesTo.email = messagesToEmail
                            }
                            if let messagesToProfilePic = messagesToData["profile_pic"] as? String {
                                messagesTo.profile_pic = messagesToProfilePic
                            }
                            toData.add(messagesTo)
                            threadsEntity.addToMessages_to((toData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let messages_cc = dictionary["cc"] as? NSArray {
                        let toData = threadsEntity.messages_cc?.mutableCopy() as! NSMutableSet
                        for to in messages_cc {
                            let messagesCcData = to as! [String: AnyObject]
                            let messagesCc = Messages_Cc(context: context)
                            if let messagesCcName = messagesCcData["name"] as? String {
                                messagesCc.name = messagesCcName
                            }
                            if let messagesCcEmail = messagesCcData["email"] as? String {
                                messagesCc.email = messagesCcEmail
                            }
                            if let messagesCcProfilePic = messagesCcData["profile_pic"] as? String {
                                messagesCc.profile_pic = messagesCcProfilePic
                            }
                            toData.add(messagesCc)
                            threadsEntity.addToMessages_cc((toData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let messages_bcc = dictionary["bcc"] as? NSArray {
                        let toData = threadsEntity.messages_bcc?.mutableCopy() as! NSMutableSet
                        for to in messages_bcc {
                            let messagesBccData = to as! [String: AnyObject]
                            let messagesBcc = Messages_Bcc(context: context)
                            if let messagesBccName = messagesBccData["name"] as? String {
                                messagesBcc.name = messagesBccName
                            }
                            if let messagesBccEmail = messagesBccData["email"] as? String {
                                messagesBcc.email = messagesBccEmail
                            }
                            if let messagesBccProfilePic = messagesBccData["profile_pic"] as? String {
                                messagesBcc.profile_pic = messagesBccProfilePic
                            }
                            toData.add(messagesBcc)
                            threadsEntity.addToMessages_bcc((toData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let messages_files = dictionary["files"] as? NSArray {
                        let filesData = threadsEntity.messages_files?.mutableCopy() as! NSMutableSet
                        for file in messages_files {
                            let messagesFileData = file  as! [String: AnyObject]
                            let messagesFile = Messages_Files(context: context)
                            if let name = messagesFileData["filename"] as? String {
                                messagesFile.file_name = name
                            }
                            if let contentType = messagesFileData["content_type"] as? String {
                                messagesFile.content_type = contentType
                            }
                            if let id = messagesFileData["id"] as? String {
                                messagesFile.id = id
                            }
                            if let size = messagesFileData["size"] as? Int32 {
                                messagesFile.size = size
                            }
                            filesData.add(messagesFile)
                            threadsEntity.addToMessages_files((filesData.copy() as? NSSet)!)
                        }
                    }
                    
                    if let snippet = dictionary["snippet"] as? String {
                        threadsEntity.snippet = snippet
                    }
                    
                    if let last_message_from_contact_id = dictionary["last_message_from_contact_id"] as? String {
                        threadsEntity.last_message_from_contact_id = last_message_from_contact_id
                    }
                    
                    if let body = dictionary["body"] as? String {
                        threadsEntity.body = body
                    }
                    
                    if let account_id = dictionary["account_id"] as? String {
                        threadsEntity.account_id = account_id
                    }
                    
                    if let object = dictionary["object"] as? String {
                        threadsEntity.object = object
                    }
                    
                    if let date = dictionary["date"] as? Int32 {
                        threadsEntity.date = date
                    }
                    
                    if let data_sha256 = dictionary["data_sha256"] as? String {
                        threadsEntity.data_sha256 = data_sha256
                    }
                    
                    if let spool_id = dictionary["spool_id"] as? String {
                        threadsEntity.spool_id = spool_id
                    }
                    
                    if let starred = dictionary["starred"] as? Bool {
                        threadsEntity.starred = starred
                    }
                    
                    if let unread = dictionary["unread"] as? Bool {
                        threadsEntity.unread = unread
                    }
                    
                    if let character_count = dictionary["character_count"] as? Int32 {
                        threadsEntity.character_count = character_count
                    }
                    
                    if let emotion_score = dictionary["emotion_score"] as? Double {
                        threadsEntity.emotion_score = emotion_score
                    }
                    
                    if let word_count = dictionary["word_count"] as? Int32 {
                        threadsEntity.word_count = word_count
                    }
                    
                    if let segmented_html = dictionary["segmented_html"] as? NSArray {
                        let toData = threadsEntity.messages_segmented_html?.mutableCopy() as! NSMutableSet
                        for to in segmented_html {
                            let segmentedHtmlData = to as! [String: AnyObject]
                            let segmentedHtml = Messages_Segmented_Html(context: context)
                            if let segmentedHtmlType = segmentedHtmlData["type"] as? String {
                                segmentedHtml.type = segmentedHtmlType
                            }
                            if let segmentedHtmlOrder = segmentedHtmlData["order"] as? Int16 {
                                segmentedHtml.order = segmentedHtmlOrder
                            }
                            if let segmentedHtmlString = segmentedHtmlData["html"] as? String {
                                segmentedHtml.html = segmentedHtmlString
                            }
                            if let htmlMarkDownString = segmentedHtmlData["html_markdown"] as? String {
                                segmentedHtml.html_markdown = htmlMarkDownString
                                
                            }
                            toData.add(segmentedHtml)
                            threadsEntity.addToMessages_segmented_html((toData.copy() as? NSSet)!)
                        }
                        
                        for to in segmented_html {
                            let segmentedHtmlData = to as! [String: AnyObject]
                            if let forwarded_from = segmentedHtmlData["from"] as? NSArray {
                                let forwardedFromData = threadsEntity.messages_forwarded_from?.mutableCopy() as! NSMutableSet
                                for from in forwarded_from {
                                    let messagesForwardedFromData = from  as! [String: AnyObject]
                                    let messagesForwardedFrom = Messages_Forwarded_From(context: context)
                                    if let messagesForwardedFromName = messagesForwardedFromData["name"] as? String {
                                        messagesForwardedFrom.name = messagesForwardedFromName
                                    }
                                    if let messagesFromEmail = messagesForwardedFromData["email"] as? String {
                                        messagesForwardedFrom.email = messagesFromEmail
                                    }
                                    if let messagesFromProfilePic = messagesForwardedFromData["profile_pic"] as? String {
                                        messagesForwardedFrom.profile_pic = messagesFromProfilePic
                                    }
                                    forwardedFromData.add(messagesForwardedFrom)
                                    threadsEntity.addToMessages_forwarded_from((forwardedFromData.copy() as? NSSet)!)
                                }
                            }
                        }
                        
                        for to in segmented_html {
                            let segmentedHtmlData = to as! [String: AnyObject]
                            if let forwarded_to = segmentedHtmlData["to"] as? NSArray {
                                let forwardedToData = threadsEntity.messages_forwarded_to?.mutableCopy() as! NSMutableSet
                                for to in forwarded_to {
                                    let messagesForwardedToData = to  as! [String: AnyObject]
                                    let messagesForwardedTo = Messages_Forwarded_To(context: context)
                                    if let messagesForwardedToName = messagesForwardedToData["name"] as? String {
                                        messagesForwardedTo.name = messagesForwardedToName
                                    }
                                    if let messagesToEmail = messagesForwardedToData["email"] as? String {
                                        messagesForwardedTo.email = messagesToEmail
                                    }
                                    if let messagesToProfilePic = messagesForwardedToData["profile_pic"] as? String {
                                        messagesForwardedTo.profile_pic = messagesToProfilePic
                                    }
                                    forwardedToData.add(messagesForwardedTo)
                                    threadsEntity.addToMessages_forwarded_to((forwardedToData.copy() as? NSSet)!)
                                }
                            }
                        }
                        
                    }
                    
                    if let summary = dictionary["summary"] as? String {
                        threadsEntity.summary = summary
                    }
                    
                    if let category_ids = dictionary["category_ids"] as? NSArray {
                        threadsEntity.category_ids = category_ids
                    }
                    
                    if let section = dictionary["section"] as? String {
                        threadsEntity.section = section
                    }
                    
                    if let all = dictionary["all"] as? Bool {
                        threadsEntity.all = all
                    }
                    
                    if let inbox = dictionary["inbox"] as? Bool {
                        threadsEntity.inbox = inbox
                    }
                    
                    if let archived = dictionary["archived"] as? Bool {
                        threadsEntity.archived = archived
                    }
                    
                    if let drafts = dictionary["drafts"] as? Bool {
                        threadsEntity.drafts = drafts
                    }
                    
                    if let spam = dictionary["spam"] as? Bool {
                        threadsEntity.spam = spam
                    }
                    
                    if let trash = dictionary["trash"] as? Bool {
                        threadsEntity.trash = trash
                    }
                    
                    if let sent = dictionary["sent"] as? Bool {
                        threadsEntity.sent = sent
                    }
                    
                    if let important = dictionary["important"] as? Bool {
                        threadsEntity.important = important
                    }
                    
                    return threadsEntity
                    
                }
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
        return nil
    }
    
}
