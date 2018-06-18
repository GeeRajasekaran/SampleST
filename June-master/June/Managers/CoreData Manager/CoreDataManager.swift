//
//  CoreDataManager.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    private override init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "June")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
                print("error \(error) \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            
        }
    }
    
    func deleteRecords() {
        let moc = persistentContainer.viewContext
        let threadRequest: NSFetchRequest<Threads> = Threads.fetchRequest()
        let threadsNamedParticipantsRequest: NSFetchRequest<Threads_Named_Participants> = Threads_Named_Participants.fetchRequest()
        let vendorRequest: NSFetchRequest<Vendor> = Vendor.fetchRequest()
        let participantsRequest: NSFetchRequest<Participants> = Participants.fetchRequest()
        let lastMessageFromRequest: NSFetchRequest<LastMessageFrom> = LastMessageFrom.fetchRequest()
        let cardsRequest: NSFetchRequest<Cards> = Cards.fetchRequest()
        let messagesRequest: NSFetchRequest<Messages> = Messages.fetchRequest()
        let messagesBccRequest: NSFetchRequest<Messages_Bcc> = Messages_Bcc.fetchRequest()
        let messagesCcRequest: NSFetchRequest<Messages_Cc> = Messages_Cc.fetchRequest()
        let messagesEventsRequest: NSFetchRequest<Messages_Events> = Messages_Events.fetchRequest()
        let messagesEventsParticipantsRequest: NSFetchRequest<Messages_Events_Participants> = Messages_Events_Participants.fetchRequest()
        let messagesEventsWhenRequest: NSFetchRequest<Messages_Events_When> = Messages_Events_When.fetchRequest()
        let messagesFilesRequest: NSFetchRequest<Messages_Files> = Messages_Files.fetchRequest()
        let messagesFromRequest: NSFetchRequest<Messages_From> = Messages_From.fetchRequest()
        let messagesReplyToRequest: NSFetchRequest<Messages_Reply_To> = Messages_Reply_To.fetchRequest()
        let messagesSegmentedHtmlRequest: NSFetchRequest<Messages_Segmented_Html> = Messages_Segmented_Html.fetchRequest()
        let messagesSegmentedProRequest: NSFetchRequest<Messages_Segmented_Pro> = Messages_Segmented_Pro.fetchRequest()
        let messagesToRequest: NSFetchRequest<Messages_To> = Messages_To.fetchRequest()
        let messagesUnsubscribeLinksRequest: NSFetchRequest<Messages_Unsubscribe_Links> = Messages_Unsubscribe_Links.fetchRequest()
        let messagesRecipients: NSFetchRequest<Messages_Recipients> = Messages_Recipients.fetchRequest()
        let contactRequest: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        let draftsRequest: NSFetchRequest<Drafts> = Drafts.fetchRequest()
        let rolodexsRequest: NSFetchRequest<Rolodexs> = Rolodexs.fetchRequest()
        let rolodexsLabelsRequest: NSFetchRequest<Rolodexs_Labels> = Rolodexs_Labels.fetchRequest()
        let rolodexsLastMessageEvents: NSFetchRequest<Rolodexs_Last_Message_Events> = Rolodexs_Last_Message_Events.fetchRequest()
        let rolodexsLastMessageFrom: NSFetchRequest<Rolodexs_Last_Message_From> = Rolodexs_Last_Message_From.fetchRequest()
        let rolodexsParticipants: NSFetchRequest<Rolodexs_Participants> = Rolodexs_Participants.fetchRequest()
        let rolodexsNamedParticipants: NSFetchRequest<Rolodexs_Named_Participants> = Rolodexs_Named_Participants.fetchRequest()

        var deleteRequest: NSBatchDeleteRequest
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: threadRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: threadsNamedParticipantsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: vendorRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: participantsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: lastMessageFromRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: cardsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesBccRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesCcRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesEventsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesEventsParticipantsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesEventsWhenRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesFilesRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesFromRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesReplyToRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesSegmentedHtmlRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesSegmentedProRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesToRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesUnsubscribeLinksRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: messagesRecipients as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: contactRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: draftsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: rolodexsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: rolodexsLabelsRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: rolodexsLastMessageFrom as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: rolodexsLastMessageEvents as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: rolodexsParticipants as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: rolodexsNamedParticipants as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
        }
        catch {
            print("Failed removing existing records")
        }
    }

}

extension CoreDataManager {
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
