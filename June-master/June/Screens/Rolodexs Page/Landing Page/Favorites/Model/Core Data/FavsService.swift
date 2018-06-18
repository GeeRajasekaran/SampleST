//
//  FavsService.swift
//  June
//
//  Created by Joshua Cleetus on 3/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class FavsService {
    unowned var parentVC: RolodexsViewController
    var favsList = [Favorites]()
    
    internal init(parentVC: RolodexsViewController) {
        self.parentVC = parentVC
    }
    
    struct FavsKeys {
        static let id = "id"
        static let _id = "_id"
        static let participants = "participants"
        static let rolodex_ids = "rolodex_ids"
        static let name = "name"
        static let user_id = "user_id"
        static let created_at = "created_at"
        static let updated_at = "updated_at"
        static let unread_message_count = "unread_message_count"
        static let starred_message_count = "starred_message_count"
        static let unread_spool_count = "unread_spool_count"
        static let starred_spool_count = "starred_spool_count"
        static let unread = "unread"
        static let starred = "starred"
    }
    
    func getFavs(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Favorites> {
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        let sort = NSSortDescriptor(key: "name", ascending: ascending)
        sortDescriptors.append(sort)
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = JuneConstants.Rolodexs.emailsLimit
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        print(fetchedResultsController.fetchedObjects as Any)
        return fetchedResultsController
    }
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createFavsEntityFrom(dictionary: $0)}
        CoreDataManager.sharedInstance.persistentContainer.viewContext.perform({
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
                print("saved rolodex")
            } catch let error {
                print(error)
            }
        })
        self.parentVC.loadFavsData()
    }
    
    func createFavsEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        if let conversation_id = dictionary[FavsKeys.id] as? String {
            request.predicate = NSPredicate(format: "favorites_id = %@", conversation_id)
            do {
                let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
                if result.count > 0 {
                    if let favsEntity = result.first {
                        return self.loadFavsEntity(dictionary: dictionary, context: context, favsEntity: favsEntity)
                    }
                } else {
                    if let favsEntity = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as? Favorites {
                        return self.loadFavsEntity(dictionary: dictionary, context: context, favsEntity: favsEntity)
                    }
                }
            }
            catch let error as NSError {
                print("Error checking store existence: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func loadFavsEntity(dictionary: [String: AnyObject], context: NSManagedObjectContext, favsEntity: Favorites) -> NSManagedObject {
        if let favorites_id = dictionary[FavsKeys.id] as? String {
            favsEntity.favorites_id = favorites_id
        }
        if let favorites_underscore_id = dictionary[FavsKeys._id] as? String {
            favsEntity.favorites_underscore_id = favorites_underscore_id
        }
        
        if let name = dictionary[FavsKeys.name] as? String {
            favsEntity.name = name
        }

        if let user_id = dictionary[FavsKeys.user_id] as? String {
            favsEntity.user_id = user_id
        }
        
        if let created_at = dictionary[FavsKeys.created_at] as? Int32 {
            favsEntity.created_at = created_at
        }
        
        if let updated_at = dictionary[FavsKeys.updated_at] as? Int32 {
            favsEntity.updated_at = updated_at
        }
        
        if let rolodex_ids = dictionary[FavsKeys.rolodex_ids] as? NSArray {
            favsEntity.rolodex_ids = rolodex_ids
        }
        
        if let unread_message_count = dictionary[FavsKeys.unread_message_count] as? Int16 {
            favsEntity.unread_message_count = unread_message_count
        }
        
        if let starred_message_count = dictionary[FavsKeys.starred_message_count] as? Int16 {
            favsEntity.starred_message_count = starred_message_count
        }
        
        if let unread_spool_count = dictionary[FavsKeys.unread_spool_count] as? Int16 {
            favsEntity.unread_spool_count = unread_spool_count
        }
        
        if let starred_spool_count = dictionary[FavsKeys.starred_spool_count] as? Int16 {
            favsEntity.starred_spool_count = starred_spool_count
        }
        
        if let unread = dictionary[FavsKeys.unread] as? Bool {
            favsEntity.unread = unread
        }
        
        if let starred = dictionary[FavsKeys.starred] as? Bool {
            favsEntity.starred = starred
        }
        
        // Participants
        favsEntity.favorites_participants = nil
        if let participants = dictionary[FavsKeys.participants] {
            let participantsData = favsEntity.favorites_participants?.mutableCopy() as! NSMutableSet
            for participant in participants as! NSArray {
                let participantData = participant as! [String: AnyObject]
                let participants = Favorites_Participants(context: context)
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
                favsEntity.addToFavorites_participants((participantsData.copy() as? NSSet)!)
            }
        }

        return favsEntity
    }
    
}
