//
//  ConvosLoading.swift
//  June
//
//  Created by Joshua Cleetus on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

class ConvosLoading: NSObject {
    
    unowned var parentVC: ConvosViewController
    init(parentVC: ConvosViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
    // Show loading gif image
    func showLoadingGif() {
        guard let tableView = self.parentVC.tableView else {
            return
        }
        self.parentVC.loadingImageView.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 5)
        self.parentVC.loadingImageView.backgroundColor = UIColor.white
        self.parentVC.loadingImageView.contentMode = .scaleAspectFill
        self.parentVC.loadingImageView.tag = 555
        let joshGif = UIImage.gifImageWithName("gif_loader_iphoneX")
        self.parentVC.loadingImageView.image = joshGif
        self.parentVC.view.addSubview(self.parentVC.loadingImageView)
    }
    
    // Remove loading gif image
    func removeLoadingGif() {
        self.parentVC.loadingImageView.removeFromSuperview()
    }

    // New Convos
    func checkDataStoreForNewConvos() {
        self.parentVC.showLoadingGif()
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "unread == \(NSNumber(value:true))")
        let predicate1a = NSPredicate(format: "seen == \(NSNumber(value:false))")
        let predicate2 = NSPredicate(format: "category == %@", "conversations")
        let predicate3 = NSPredicate(format: "inbox == \(NSNumber(value:true))")
        let predicate4 = NSPredicate(format: "section == %@", "convos")
        let predicate5 = NSPredicate(format: "approved == %@", NSNumber(value:true))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate1a, predicate2, predicate3, predicate4, predicate5])
        
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            print(threadsCount as Any)
            if threadsCount == 0 {
                self.getNewConvosFromBackend()
            } else {
                self.parentVC.loadNewConvosData()
            }
        }
        catch {
            print("Error in counting")
            self.parentVC.removeLoadingGif()
        }
    }
    
    func getNewConvosFromBackend() {
        let service = ConvosAPIBridge()
        service.getNewConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                let threadsService = ConvosService(parentVC: self.parentVC)
                threadsService.saveInCoreDataWith(array: data)
                self.parentVC.maxNewItemsCount = service.totalNewMessagesCount
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadNewConvosData() {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllNewConversations(withAscendingOrder: self.parentVC.sortAscending)
        self.parentVC.newItemsThreadInfo = fetchedResultController.fetchedObjects
        let newItemsCount = self.parentVC.newItemsThreadInfo?.count
        if newItemsCount == self.parentVC.maxNewItemsCount {
            self.parentVC.maxNewItemsReached = true
        } else {
            self.parentVC.maxNewItemsReached = false
        }
        self.parentVC.removeLoadingGif()
    }
    
    func fetchMoreNewConvos(_withSkip skip:Int) {
        let service = ConvosAPIBridge()
        service.getNewConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: skip) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    let threadsService = ConvosService(parentVC: self.parentVC)
                    threadsService.saveInCoreDataWith(array: data)
                    self.parentVC.maxNewItemsCount = service.totalNewMessagesCount
                } else {
                    self.parentVC.isLoading = false
                }
                self.parentVC.maxNewItemsCount = service.totalNewMessagesCount
                if self.parentVC.newItemsThreadInfo?.count == service.totalNewMessagesCount {
                    self.parentVC.maxNewItemsReached = true
                    self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
                    self.parentVC.tableView?.reloadData()
                }
                
            case .Error(let message):
                print(message)
                self.parentVC.isLoading = false
            }
        }
    }
    
    func fetchNewMessagesData() {
        let service = ConvosAPIBridge()
        service.getNewConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: 0) { (result) in
                switch result {
                case .Success(let data):
                    if data.count > 0 {
                        let threadsService = ConvosService(parentVC: self.parentVC)
                        threadsService.saveInCoreDataWithRealtimeEvents(array: data)
                        self.parentVC.maxNewItemsCount = service.totalNewMessagesCount
                        guard let dicObject = data.first as [String: AnyObject]? else {
                            return
                        }
                        guard let threadObject = threadsService.createThreadsEntityFrom(dictionary: dicObject) as? Threads else {
                            return
                        }
                        self.parentVC.loadNewConvosWithRealtimeUpdates(thread: threadObject)
                    }
                case .Error(let message):
                    print(message)
                }
        }
    }
    
    // Seen Convos
    func checkDataStoreForSeenConvos() {
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1 = NSPredicate(format: "unread == \(NSNumber(value:true))")
        let predicate1a = NSPredicate(format: "seen == \(NSNumber(value:true))")
        let predicate1b = NSPredicate(format: "inbox == \(NSNumber(value:true))")
        let predicate2 = NSPredicate(format: "spam == \(NSNumber(value:false))")
        let predicate3 = NSPredicate(format: "trash == \(NSNumber(value:false))")
        let predicate4 = NSPredicate(format: "category == %@", "conversations")
        let predicate5 = NSPredicate(format: "section == %@", "convos")
        let predicate7 = NSPredicate(format: "approved == %@", NSNumber(value:true))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate1a, predicate1b, predicate2, predicate3, predicate4, predicate5, predicate7])
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getSeenConvosFromBackend()
            } else {
                self.parentVC.loadSeenConvosData()
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getSeenConvosFromBackend() {
        let service = ConvosAPIBridge()
        service.getSeenConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                let threadsService = ConvosService(parentVC: self.parentVC)
                threadsService.saveSeenConvosInCoreData(array: data)
                self.parentVC.maxSeenItemsCount = service.totalSeenMessagesCount
            case .Error(let message):
                print(message)
                self.parentVC.tableView?.reloadData()
                self.parentVC.removeLoadingGif()
            }
        }
    }
    
    func loadSeenConvosData() {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllSeenConversations(withAscendingOrder: self.parentVC.sortAscending)
        self.parentVC.seenItemsThreadInfo = fetchedResultController.fetchedObjects
        let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count
        if seenItemsCount == self.parentVC.maxSeenItemsCount {
            self.parentVC.maxSeenItemsReached = true
        } else {
            self.parentVC.maxSeenItemsReached = false
        }        
    }
    
    func loadSeenConvosDataWithoutTableReload() {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllSeenConversations(withAscendingOrder: self.parentVC.sortAscending)
        self.parentVC.seenItemsThreadInfo = fetchedResultController.fetchedObjects
        let seenItemsCount = self.parentVC.seenItemsThreadInfo?.count
        if seenItemsCount == self.parentVC.maxSeenItemsCount {
            self.parentVC.maxSeenItemsReached = true
        } else {
            self.parentVC.maxSeenItemsReached = false
        }
    }
    
    func fetchMoreSeenConvos(_withSkip skip:Int) {
        let service = ConvosAPIBridge()
        service.getSeenConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: skip) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    let threadsService = ConvosService(parentVC: self.parentVC)
                    threadsService.saveSeenConvosInCoreData(array: data)
                    self.parentVC.maxSeenItemsCount = service.totalSeenMessagesCount
                    if data.count < JuneConstants.Convos.emailsLimit {
                        self.parentVC.maxSeenItemsReached = true
                        
                    } else
                        if self.parentVC.seenItemsThreadInfo?.count == service.totalSeenMessagesCount {
                            self.parentVC.maxSeenItemsReached = true
                    }
                } else {
                    self.parentVC.isLoading = false
                }
                
            case .Error(let message):
                print(message)
                self.parentVC.isLoading = false
            }
        }
    }
    
    func fetchSeenMessagesData() {
        let service = ConvosAPIBridge()
        service.getSeenConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    if data.count < JuneConstants.Convos.emailsLimit {
                        self.parentVC.maxSeenItemsReached = true
                    }
                    let threadsService = ConvosService(parentVC: self.parentVC)
                    threadsService.saveInCoreDataWithRealtimeEvents(array: data)
                    self.parentVC.maxSeenItemsCount = service.totalSeenMessagesCount
                    if self.parentVC.seenItemsThreadInfo?.count == self.parentVC.maxSeenItemsCount {
                        self.parentVC.maxSeenItemsReached = true
                    }
                    guard let dicObject = data.first as [String: AnyObject]? else {
                        return
                    }
                    guard let threadObject = threadsService.createThreadsEntityFrom(dictionary: dicObject) as? Threads else {
                        return
                    }
                    self.parentVC.loadSeenConvosWithRealtimeUpdates(thread: threadObject)
                }
                
            case .Error(let message):
                print(message)
            }
        }
    }
    
    // Cleared Convos
    func checkDataStoreForClearedConvos() {
        self.showLoadingGif()
        let request: NSFetchRequest<Threads> = Threads.fetchRequest()
        let predicate1a = NSPredicate(format: "inbox == \(NSNumber(value:false))")
        let predicate1b = NSPredicate(format: "inbox == \(NSNumber(value:true))")
        let predicate1c = NSPredicate(format: "unread == \(NSNumber(value:false))")
        let predicate1d = NSCompoundPredicate(type: .and, subpredicates: [predicate1b, predicate1c])
        let predicate1 = NSCompoundPredicate(type: .or, subpredicates: [predicate1a, predicate1d])
        let predicate2 = NSPredicate(format: "spam == \(NSNumber(value:false))")
        let predicate3 = NSPredicate(format: "trash == \(NSNumber(value:false))")
        let predicate4 = NSPredicate(format: "category == %@", "conversations")
        let predicate5 = NSPredicate(format: "section == %@", "convos")
        let predicate7 = NSPredicate(format: "approved == %@", NSNumber(value:true))
        request.predicate = NSCompoundPredicate(type: .and, subpredicates:[predicate1, predicate2, predicate3, predicate4, predicate5, predicate7])
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            if threadsCount == 0 {
                self.getClearedConvosFromBackend()
            } else {
                self.parentVC.loadClearedConvosData()
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getClearedConvosFromBackend() {
        let service = ConvosAPIBridge()
        service.getClearedConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                let threadsService = ConvosService(parentVC: self.parentVC)
                threadsService.saveClearedConvosInCoreData(array: data)
                self.parentVC.maxClearedItemsCount = service.totalClearedMessagesCount
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadClearedConvosData() {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllClearedConversations(withAscendingOrder: self.parentVC.sortAscending)
        self.parentVC.clearedItemsThreadInfo = fetchedResultController.fetchedObjects
        let clearedItemsCount = self.parentVC.clearedItemsThreadInfo?.count
        if clearedItemsCount == self.parentVC.maxClearedItemsCount {
            self.parentVC.maxClearedItemsReached = true
        } else {
            self.parentVC.maxClearedItemsReached = false
        }
    }
    
    func loadClearedConvosDataWithoutTableReload() {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllClearedConversations(withAscendingOrder: self.parentVC.sortAscending)
        self.parentVC.clearedItemsThreadInfo = fetchedResultController.fetchedObjects
        let clearedItemsCount = self.parentVC.clearedItemsThreadInfo?.count
        if clearedItemsCount == self.parentVC.maxClearedItemsCount {
            self.parentVC.maxClearedItemsReached = true
        } else {
            self.parentVC.maxClearedItemsReached = false
        }
        self.parentVC.removeLoadingGif()
    }
    
    func fetchMoreClearedConvos(_withSkip skip:Int) {
        let service = ConvosAPIBridge()
        service.getClearedConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: skip) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    let threadsService = ConvosService(parentVC: self.parentVC)
                    threadsService.saveClearedConvosInCoreData(array: data)
                    self.parentVC.maxClearedItemsCount = service.totalClearedMessagesCount
                    if data.count < JuneConstants.Convos.emailsLimit {
                        self.parentVC.maxClearedItemsReached = true
                        self.parentVC.sections = self.parentVC.screenBuilder.loadSections() as! [ConvosSectionType]
                        self.parentVC.tableView?.reloadData()
                    }
                } else {
                    self.parentVC.isLoading = false
                }
            case .Error(let message):
                print(message)
                self.parentVC.isLoading = false
            }
        }
    }
    
    func fetchClearedMessagesData() {
        let service = ConvosAPIBridge()
        service.getClearedConvosDataWith(_withLimit: JuneConstants.Convos.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    if data.count < JuneConstants.Convos.emailsLimit {
                        self.parentVC.maxClearedItemsReached = true
                    }
                    let threadsService = ConvosService(parentVC: self.parentVC)
                    threadsService.saveInCoreDataWithRealtimeEvents(array: data)
                    self.parentVC.maxClearedItemsCount = service.totalClearedMessagesCount
                    guard let dicObject = data.first as [String: AnyObject]? else {
                        return
                    }
                    guard let threadObject = threadsService.createThreadsEntityFrom(dictionary: dicObject) as? Threads else {
                        return
                    }
                    self.parentVC.loadClearedConvosWithRealtimeUpdates(thread: threadObject)
                }

            case .Error(let message):
                print(message)
            }
        }
    }
    
    // Realtime Loading
    func listenToRealTimeEvents() {
        self.parentVC.convosRealTime.getRealTimeDataWith(completion: ) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 { 
                    let threadsService = ConvosService(parentVC: self.parentVC)
                    threadsService.saveInCoreDataWithRealtimeEvents(array: data as [[String : AnyObject]])
                    guard let dicObject = data.first as [String: AnyObject]? else {
                        return
                    }
                    guard let threadObject = threadsService.createThreadsEntityFrom(dictionary: dicObject) as? Threads else {
                        return
                    }
                    let workItem = DispatchWorkItem {
                        if let approved = data.first?["approved"] as? Int, let unread = data.first?["unread"] as? Bool, let starred = data.first?["starred"] as? Bool, let spam = data.first?["spam"] as? Bool, let trash = data.first?["trash"] as? Bool, approved == 1, unread == false, !starred, spam == false, trash == false {
                            self.loadClearedConvosWithRealtimeUpdates(thread: threadObject)
                        } else if let inbox = data.first?["inbox"] as? Bool, let unread = data.first?["unread"] as? Bool, let seen = data.first?["seen"] as? Bool, inbox == true, unread == true, seen == false {
                            self.loadNewConvosWithRealtimeUpdates(thread: threadObject)
                        } else if let approved = data.first?["approved"] as? Int, let unread = data.first?["unread"] as? Bool, let starred = data.first?["starred"] as? Bool, let seen = data.first?["seen"] as? Bool, approved == 1, unread == true, starred == true, seen == true {
                            self.loadSeenConvosWithRealtimeUpdates(thread: threadObject)
                        }
                    }
                    self.parentVC.realtimeRequestWorkItem = workItem
                    if !self.parentVC.isLoadingRealtime {
                        self.parentVC.isLoadingRealtime = true
                        let when = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: when, execute: workItem)
                    } else {
                        let when = DispatchTime.now() + 5
                        DispatchQueue.main.asyncAfter(deadline: when, execute: workItem)
                    }
                    
                }
            case .Error(let message):
                print(message)
            }
        }
    }

    func loadNewConvosWithRealtimeUpdates(thread: Threads) {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllNewConversations(withAscendingOrder: self.parentVC.sortAscending)
        let currentScreentType = self.parentVC.screenType
        if currentScreentType == ConvosScreenType.combined {
            if let newItemsArray = fetchedResultController.fetchedObjects, let previousNewItemsArray = self.parentVC.newItemsThreadInfo {
                if newItemsArray != previousNewItemsArray {
                    self.parentVC.newItemsThreadInfo = newItemsArray
                    self.parentVC.loadNewNewConvosData()
                }
            }
        } else if currentScreentType == ConvosScreenType.cleared {
            if let newItemsArray = fetchedResultController.fetchedObjects, let previousNewItemsArray = self.parentVC.newItemsThreadInfo {
                if newItemsArray != previousNewItemsArray {
                    self.parentVC.newItemsThreadInfo = newItemsArray
                    self.parentVC.loadNewNewConvosData()
                }
            }
        }
    }

    func loadSeenConvosWithRealtimeUpdates(thread: Threads) {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllSeenConversations(withAscendingOrder: self.parentVC.sortAscending)
        let currentScreentType = self.parentVC.screenType
        if currentScreentType == ConvosScreenType.combined {
            if let newSeenItemsArray = fetchedResultController.fetchedObjects, let previousSeenItemsArray = self.parentVC.seenItemsThreadInfo {
                if newSeenItemsArray != previousSeenItemsArray {
                    self.parentVC.seenItemsThreadInfo = newSeenItemsArray
                    self.parentVC.loadNewSeenData()
                }
            }
        } else if currentScreentType == ConvosScreenType.cleared {
            if let newSeenItemsArray = fetchedResultController.fetchedObjects, let previousSeenItemsArray = self.parentVC.seenItemsThreadInfo {
                if newSeenItemsArray != previousSeenItemsArray {
                    self.parentVC.seenItemsThreadInfo = newSeenItemsArray
                    self.parentVC.loadNewSeenData()
                }
            }
        }
    }

    func loadClearedConvosWithRealtimeUpdates(thread: Threads) {
        let threadsService = ConvosService(parentVC: self.parentVC)
        let fetchedResultController = threadsService.getAllClearedConversations(withAscendingOrder: self.parentVC.sortAscending)
        let currentScreentType = self.parentVC.screenType
        if currentScreentType == ConvosScreenType.cleared {
            if let newClearedItemsArray = fetchedResultController.fetchedObjects, let previousClearedItemsArray = self.parentVC.clearedItemsThreadInfo {
                if newClearedItemsArray.count > 0, newClearedItemsArray != previousClearedItemsArray {
                    self.parentVC.clearedItemsThreadInfo = newClearedItemsArray
                    self.parentVC.loadNewClearedData()
                }
            }
        } else if currentScreentType == ConvosScreenType.combined {
            if let newClearedItemsArray = fetchedResultController.fetchedObjects, let previousClearedItemsArray = self.parentVC.clearedItemsThreadInfo {
                if newClearedItemsArray != previousClearedItemsArray {
                    self.parentVC.clearedItemsThreadInfo = newClearedItemsArray
                    self.parentVC.loadNewClearedData()
                }
            }
        }
    }
    
    //Delete Threads
    func deleteThreads() {
        let moc = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let threadRequest: NSFetchRequest<Threads> = Threads.fetchRequest()
        var deleteRequest: NSBatchDeleteRequest
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: threadRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc.execute(deleteRequest)
            self.checkDataStoreForNewConvos()
        }
        catch {
            print("Failed deleting the threads")
        }
    }

}
