//
//  RolodexsViewController + Extension.swift
//  June
//
//  Created by Joshua Cleetus on 3/18/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData

extension RolodexsViewController {
    
    // New Rolodexs
    func checkDataStoreForNewRolodexs() {
        let request: NSFetchRequest<Rolodexs> = Rolodexs.fetchRequest()
        let predicate1 = NSPredicate(format: "category == %@", "conversations")
        let predicate2 = NSPredicate(format: "spam == \(NSNumber(value:false))")
        let predicate3 = NSPredicate(format: "trash == \(NSNumber(value:false))")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            print(threadsCount as Any)
            if threadsCount == 0 {
                self.getNewRolodexsFromBackend()
            } else {
                self.loadRolodexsData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.checkNewRolodexsInBackground()
                }
            }
        }
        catch {
            print("Error in counting")
        }
    }

    func getNewRolodexsFromBackend() {
        let service = RolodexsAPIBridge()
        service.getRolodexsDataWith(_withLimit: JuneConstants.Rolodexs.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count>0 {
                    let rolodexsService = RolodexsService(parentVC: self)
                    rolodexsService.saveInCoreDataWith(array: data)
                }

            case .Error(let message):
                print(message)
            }
        }
    }
    
    func checkNewRolodexsInBackground() {
        let service = RolodexsAPIBridge()
        service.getRolodexsDataWith(_withLimit: JuneConstants.Rolodexs.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count>0 {
                    let rolodexsService = RolodexsService(parentVC: self)
                    rolodexsService.saveInCoreDataWith(array: data)
                }
                
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func loadRolodexOnlyIfThereIsNewObjects() {
        let rolodexsService = RolodexsService(parentVC: self)
        self.fetchedResultController = rolodexsService.getNewRolodexs(withAscendingOrder: self.sortAscending)
        self.rolodexsItemsInfo = self.fetchedResultController?.fetchedObjects
    }
    
    func loadRolodexsData() {
        let rolodexsService = RolodexsService(parentVC: self)
        self.fetchedResultController = rolodexsService.getNewRolodexs(withAscendingOrder: self.sortAscending)
        self.rolodexsItemsInfo = self.fetchedResultController?.fetchedObjects
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        if indexPathIsValid(indexPath: indexPath) == true {
            self.rolodexTableView?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        if let tableView = self.rolodexTableView {
            return indexPath.section < tableView.numberOfSections && indexPath.row < tableView.numberOfRows(inSection: indexPath.section)
        } else {
            return false
        }
    }
    
    func getRecipients(from rolodexs: Rolodexs) -> String {
        guard let toArray = rolodexs.rolodexs_named_participants?.allObjects as? [Rolodexs_Named_Participants] else { return "" }
        var nameArray: [String] = []
        var nameConcatenatedString = ""
        if toArray.count == 1 {
            if let toObject: Rolodexs_Named_Participants = toArray.first {
                if toObject.name?.count == 0 {
                    guard let name = toObject.first_name else { return "" }
                    nameConcatenatedString = name
                } else {
                    guard let first_name = toObject.name else { return "" }
                    nameConcatenatedString = first_name
                }

            }
        } else if toArray.count > 1 {
            for toData in toArray {
                let toObject: Rolodexs_Named_Participants = toData
                if toObject.first_name?.count == 0 {
                    guard let name = toObject.name else { return "" }
                    nameArray.append(name)
                } else {
                    guard let first_name = toObject.first_name else { return "" }
                    nameArray.append(first_name)
                }
            }
            nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: Localized.string(forKey: LocalizedString.RolodexsSeparatorTitle))
        }
        return nameConcatenatedString
    }

    func fetchMoreRolodexsConvos(_withSkip skip:Int) {
        let service = RolodexsAPIBridge()
        service.getRolodexsDataWith(_withLimit: JuneConstants.Rolodexs.emailsLimit, skipValue: skip) { (result) in
            switch result {
            case .Success(let data):
                if data.count > 0 {
                    let rolodexsService = RolodexsService(parentVC: self)
                    rolodexsService.saveInCoreDataWith(array: data)
                }
            case .Error(let message):
                print(message)
            }
        }
    }
    
    // Real time updates
    func listenToRealTimeEvents() {
        let rolodexsLoading = RolodexsLoading(parentVC: self)
        rolodexsLoading.listenToRealTimeEvents()
    }
    
    // Show loading gif image
    func showLoadingGif() {
        self.loadingImageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 5)
        self.loadingImageView.backgroundColor = UIColor.white
        self.loadingImageView.contentMode = .scaleAspectFill
        self.loadingImageView.tag = 555
        let joshGif = UIImage.gifImageWithName("gif_loader_iphoneX")
        self.loadingImageView.image = joshGif
        self.view.addSubview(self.loadingImageView)
    }
    
    // Remove loading gif image
    func removeLoadingGif() {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){ [weak self] in
            if let viewsArray = self?.view.subviews, let imgView = self?.loadingImageView {
                if viewsArray.contains(imgView) {
                    self?.loadingImageView.removeFromSuperview()
                }
            }
        }
    }

    // Segment Value Handler
    @objc func didChangeSegment(_ sender: UISegmentedControl) {
        segment = RolodexsScreenType(rawValue: sender.selectedSegmentIndex)!
    }
    
    // Favorites
    func getNewFavoritesFromBackend() {
        let service = FavsAPIBridge()
        service.getFavsDataWith(_withLimit: JuneConstants.Rolodexs.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count>0 {
                    let favsService = FavsService(parentVC: self)
                    favsService.saveInCoreDataWith(array: data)
                }
            case .Error(let message):
                print(message)
            }
            self.dismissSpinner()
        }
    }
    
    func loadFavsData() {
        let favsService = FavsService(parentVC: self)
        self.favsFetchedResultController = favsService.getFavs(withAscendingOrder: true)
        self.favsItemsInfo = self.favsFetchedResultController?.fetchedObjects
    }
    
    func getRecipients(from favorites: Favorites) -> String {
        guard let toArray = favorites.favorites_participants?.allObjects as? [Favorites_Participants] else { return "" }
        var nameArray: [String] = []
        var nameConcatenatedString = ""
        if toArray.count == 1 {
            if let toObject: Favorites_Participants = toArray.first {
                guard let first_name = toObject.name else { return "" }
                nameConcatenatedString = first_name
            }
        } else if toArray.count > 1 {
            for toData in toArray {
                let toObject: Favorites_Participants = toData
                guard let name = toObject.name else { return "" }
                nameArray.append(name)
            }
            nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: Localized.string(forKey: LocalizedString.RolodexsSeparatorTitle))
        }
        return nameConcatenatedString
    }
    
    func selectedRecent() {
        segment = RolodexsScreenType.recent
        self.loadRolodexsData()
    }
    
    // Filter
    @objc internal func didTapFilter(sender: UITapGestureRecognizer) {
        print("did tap filter")
        self.filterImageView.isHidden = false
        self.segmentView.filter.image = #imageLiteral(resourceName: "rolodex-filter-selected")
    }
    
    @objc internal func removeFilterImageView() {
        self.filterImageView.isHidden = true
        self.segmentView.filter.image = #imageLiteral(resourceName: "rolodex-filter")
        self.segmentView.unread.isHidden = true
        self.segmentView.pinned.isHidden = true
    }
    
    @objc internal func didTapClearFilterBg(sender: UITapGestureRecognizer) {
        print("did tap clear filter background")
        self.filterImageView.isHidden = true
        if segment == .recent {
            self.segmentView.filter.isHidden = false
            self.segmentView.filter.image = #imageLiteral(resourceName: "rolodex-filter")
        } else if segment == .unread {
            self.segmentView.unread.isHidden = false
        } else if segment == .pinned {
            self.segmentView.pinned.isHidden = false
        }
    }

    // Unread
    @objc internal func didTapUnreadFilter(sender: UITapGestureRecognizer) {
        print("did tap unread filter")
        self.filterImageView.isHidden = true
        self.segmentView.filter.isHidden = true
        self.segmentView.unread.isHidden = false
        self.segmentView.pinned.isHidden = true
        self.selectedUnread()
    }
    
    @objc internal func didTapUnreadClose(sender: UITapGestureRecognizer) {
        self.segmentView.unread.isHidden = true
        self.segmentView.filter.isHidden = false
        self.segmentView.filter.image = #imageLiteral(resourceName: "rolodex-filter")
        self.filterImageView.isHidden = true
        self.selectedRecent()
    }

    func selectedUnread() {
        segment = RolodexsScreenType.unread
    }
    
    func getNewUnreadFromBackend() {
        let service = RolodexsAPIBridge()
        service.getUnreadRolodexsDataWith(_withLimit: JuneConstants.Rolodexs.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count>0 {
                    let unreadsService = RolodexsService(parentVC: self)
                    unreadsService.saveUnreadsInCoreDataWith(array: data)
                }
            case .Error(let message):
                print(message)
            }
            self.dismissSpinner()
        }
    }
    
    func loadUnreadsData() {
        let unreadsService = RolodexsService(parentVC: self)
        self.unreadsFetchedResultController = unreadsService.getNewUnreads(withAscendingOrder: true)
        self.unreadsItemsInfo = self.unreadsFetchedResultController?.fetchedObjects
    }
    
    // Pinned
    @objc internal func didTapPinnedFilter(sender: UITapGestureRecognizer) {
        print("did tap pinned filter")
        self.filterImageView.isHidden = true
        self.segmentView.filter.isHidden = true
        self.segmentView.unread.isHidden = true
        self.segmentView.pinned.isHidden = false
        self.selectedPinned()
    }
    
    @objc internal func didTapPinnedClose(sender: UITapGestureRecognizer) {
        self.segmentView.pinned.isHidden = true
        self.segmentView.filter.isHidden = false
        self.segmentView.filter.image = #imageLiteral(resourceName: "rolodex-filter")
        self.filterImageView.isHidden = true
        self.selectedRecent()
    }
    
    func selectedPinned() {
        segment = RolodexsScreenType.pinned
    }
    
    func getNewPinsFromBackend() {
        let service = RolodexsAPIBridge()
        service.getPinnedRolodexsDataWith(_withLimit: JuneConstants.Rolodexs.emailsLimit, skipValue: 0) { (result) in
            switch result {
            case .Success(let data):
                if data.count>0 {
                    let unreadsService = RolodexsService(parentVC: self)
                    unreadsService.savePinsInCoreDataWith(array: data)
                }
            case .Error(let message):
                print(message)
            }
            self.dismissSpinner()
        }
    }
    
    func loadPinsData() {
        let pinsService = RolodexsService(parentVC: self)
        self.pinnedFetchedResultController = pinsService.getNewPins(withAscendingOrder: true)
        self.pinnedItemsInfo = self.pinnedFetchedResultController?.fetchedObjects
    }
}
