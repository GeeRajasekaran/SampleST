//
//  FilesProxy.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData

class FilesProxy: BaseCoreDataProxy {
    
    var frc: NSFetchedResultsController<Messages_Files>?
    private let entityName = "Messages_Files"
    
    //MARK: - create messages files
    func addNewEmptyFiles() -> Messages_Files {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataManager.sharedInstance.persistentContainer.viewContext) as! Messages_Files
        return newItem
    }
    
    //MARK: - fetch file
    func fetchFile(by fileId: String) -> Messages_Files? {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", fileId)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages_Files>
        do {
            try frc?.performFetch()
            if let file = frc?.fetchedObjects?.first {
                return file
            }
            return nil
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Deletion
    
    func removeFile(by fileId: String) {
        let fetchRequest = createRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", fileId)
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Messages_Files>
        
        do {
            try frc?.performFetch()
            if let file = frc?.fetchedObjects?.first {
                CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(file)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - private part
    private func createRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        return fetchRequest
    }

}
