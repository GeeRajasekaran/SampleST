//
//  ThreadsInfoLoader.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/21/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ThreadsInfoLoader: NSObject {

    static private var sortOrderPredicate: (Threads_Named_Participants, Threads_Named_Participants) -> Bool = { f, s in
        return f.order < s.order
    }
    
    //MARK: - get recepients from entity
    static func getRecipients(from threadEntity: Threads?) -> String {
        guard let toArray = threadEntity?.threads_named_participants?.allObjects as? [Threads_Named_Participants] else { return "" }
        let recepientsInOrder: [Threads_Named_Participants] = toArray.sorted(by: sortOrderPredicate)
        var nameArray: [String] = []
        var nameConcatenatedString = ""
        if recepientsInOrder.count == 1 {
            if let toObject: Threads_Named_Participants = recepientsInOrder.first {
                guard let name = toObject.name else { return "" }
                nameConcatenatedString = name
            }
        } else if recepientsInOrder.count > 1 {
            for toData in recepientsInOrder {
                let toObject: Threads_Named_Participants = toData
                if toObject.first_name?.count == 0 {
                    guard let name = toObject.name else { return "" }
                    nameArray.append(name)
                } else {
                    guard let first_name = toObject.first_name else { return "" }
                    nameArray.append(first_name)
                }
            }
            nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: Localized.string(forKey: LocalizedString.ConvosSeparatorTitle))
        }
        return nameConcatenatedString
    }
}
