//
//  CalendarInviteFeedItem.swift
//  June
//
//  Created by Ostap Holub on 11/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class CalendarInviteFeedItem: FeedItem {

    weak var eventEntity: ThreadsEvents?
    
    override var title: String? {
        get {
            if let title = eventEntity?.title {
                return title
            } else {
                return threadEntity?.subject
            }
        }
    }
    
    var owner: String? {
        get {
            guard let ownerString = eventEntity?.owner else { return nil }
            if let endIndex = ownerString.index(of: "<") {
                let startIndex = ownerString.startIndex
                return ownerString[startIndex..<endIndex].trimmingCharacters(in: .whitespaces)
            }
            return nil
        }
    }
    
    var ownerProfilePicURL: URL? {
        get {
            guard let participant = eventEntity?.threadsEventsParticipants?.sorted(by: { (first, _) -> Bool in
                if let firstPart = first as? ThreadsEventsParticipants {
                    return firstPart.name == owner
                }
                return false
            }).first as? ThreadsEventsParticipants else { return nil }
            if let urlString = participant.profilePicture {
                return URL(string: urlString)
            }
            return nil
        }
    }
    
    var when: String? {
        get {
            let converter = CalendarInviteDateConveter()
            return converter.eventTime(from: eventEntity?.when)
        }
    }
    
    override init(with entity: Threads, category: FeedCategory?) {
        super.init(with: entity, category: category)
        eventEntity = entity.threadsEvents?.anyObject() as? ThreadsEvents
    }
}
