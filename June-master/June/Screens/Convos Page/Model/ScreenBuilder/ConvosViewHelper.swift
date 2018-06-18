//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 12/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

struct ConvosViewHelper {
    
    // Screen
    var screenType: ConvosScreenType = ConvosScreenType.combined
    
    // New
    let newHeader = Localized.string(forKey: LocalizedString.ConvosNewHeader)
    let viewAll = Localized.string(forKey: LocalizedString.ConvosViewAllButtonTitle)
    let collapse = Localized.string(forKey: LocalizedString.ConvosCollapseButtonTitle)
    var newPreviewMails: [ConvosTableInfo] = []
    var newMails: [ConvosTableInfo] = []
    let newMockPreviewCount: Int = 3
    let newMockCount: Int = 9
    var newCollapsed: Bool = true
    var maxNewItemsReached: Bool = false
    
    // Seen
    let seenHeader = Localized.string(forKey: LocalizedString.ConvosSeenHeader)
    let mockSeenLoader: Int = 20
    var maxSeenItemsReached: Bool = false
    var seenMails: [ConvosTableInfo] = []
    
    // Cleared
    var maxClearedItemsReached: Bool = false
    var clearedMails: [ConvosTableInfo] = []
    
    // Spam
    var maxSpamItemsReached: Bool = false
    var spamMails: [ConvosTableInfo] = []

    // Loader
    let loader = Localized.string(forKey: LocalizedString.ConvosLoaderTitle)
    
    // No New Items
    var noNewItems: Bool = false
    let noNewItemsTitle = Localized.string(forKey: LocalizedString.ConvosNoNewItemsTitle)
    let noNewItemsImage = #imageLiteral(resourceName: "nothing-new")
    
    // No Seen Items
    var noSeenItems: Bool = false
    
    // No New or Seen Items
    let noNewOrSeenItemsTitle = Localized.string(forKey: LocalizedString.ConvosNoNewOrSeenItemsTitle)
    let noNewOrSeenItemsImage = #imageLiteral(resourceName: "no-new-seen-icon")

    mutating func update(seenData data: [Threads]?) {
        if let model = data {
            if model.count == 0 {
                self.noSeenItems = true
                self.maxSeenItemsReached = true
            }
            guard model.count != 0 else { return }
            var _seenMails: [ConvosTableInfo] = []
            for thread in model {
                let mail = ConvosTableInfo(thread: thread)
                mail.type = .seen
                _seenMails.append(mail)
            }
            seenMails = _seenMails
        }
    }
    
    mutating func update(clearedData data: [Threads]?) {
        if let model = data {
            guard model.count != 0 else { return }
            var _clearedMails: [ConvosTableInfo] = []
            for thread in model {
                let mail = ConvosTableInfo(thread: thread)
                mail.type = .cleared
                _clearedMails.append(mail)
            }
            clearedMails = _clearedMails
        }
    }
    
    mutating func update(spamData data: [Threads]?) {
        if let model = data {
            guard model.count != 0 else { return }
            var _spamMails: [ConvosTableInfo] = []
            for thread in model {
                let mail = ConvosTableInfo(thread: thread)
                mail.type = .spam
                _spamMails.append(mail)
            }
            spamMails = _spamMails
        }
    }
    
    mutating func update(newData data: [Threads]?) {
        if let model = data {
            if model.count == 0 {
                self.noNewItems = true
                self.maxNewItemsReached = true
            }
            guard model.count != 0 else { return }
            var _newMails: [ConvosTableInfo] = []
            for thread in model {
                let mail = ConvosTableInfo(thread: thread)
                mail.type = .new
                _newMails.append(mail)
            }
            newMails = _newMails
            
            var _newPreviewMails: [ConvosTableInfo] = []
            for (index,thread) in model.enumerated() {
                if index < newMockPreviewCount {
                    let mail = ConvosTableInfo(thread: thread)
                    mail.type = .new
                    _newPreviewMails.append(mail)
                }
            }
            newPreviewMails = _newPreviewMails
        }
    }

}
