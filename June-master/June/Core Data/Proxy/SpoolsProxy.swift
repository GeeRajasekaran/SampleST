//
//  SpoolsProxy.swift
//  June
//
//  Created by Ostap Holub on 4/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class SpoolsProxy: BaseCoreDataProxy {
    
    var frc: NSFetchedResultsController<Spools>?
    
    func addNewSpool() -> Spools {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Spools", into: CoreDataManager.sharedInstance.persistentContainer.viewContext) as! Spools
        return newItem
    }
    
    func addNewSpoolNamedPartcipant(into context: NSManagedObjectContext) -> Spools_Named_Participants {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Spools_Named_Participants", into: context) as! Spools_Named_Participants
        return newItem
    }
    
    func addNewsSpoolParticipant(into context: NSManagedObjectContext) -> Spools_Participants {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Spools_Participants", into: context) as! Spools_Participants
        return newItem
    }
    
    func fetchSpool(by id: String) -> Spools? {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "spools_id == %@", id)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Spools>
//        frc?.delegate = self
        
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
    
    func spools(by relodexId: String) -> [Spools] {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "last_messages_rolodex_id == %@", relodexId)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Spools>
        
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

    private func createRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spools")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "last_message_date", ascending: false)]
        return fetchRequest
    }
}
