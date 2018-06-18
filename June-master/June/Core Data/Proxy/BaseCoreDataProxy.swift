//
//  BaseCoreDataProxy.swift
//  June
//
//  Created by Ostap Holub on 8/21/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import Foundation
import CoreData

class BaseCoreDataProxy: NSObject {
    
    var managedContext: NSManagedObjectContext

    override init() {
        managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        super.init()
    }
    
    func saveContext() {
        CoreDataManager.sharedInstance.saveContext()
    }
}
