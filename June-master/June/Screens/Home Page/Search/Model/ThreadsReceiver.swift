//
//  ThreadsReceiver.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SectionType {
    case convos
    case feeds
}

class ThreadsReceiver: Equatable {

    var threadEntity: Threads?
    
    var profilePicture: URL? {
        get { return loadVendorImageURL() }
    }

    var name: String? {
        get {
            let recepientName = ThreadsInfoLoader.getRecipients(from: threadEntity)
            if recepientName.isEmpty {
                return loadVendorName()
            }
            return recepientName
        }
    }
    
    var subject: String? {
        get { return threadEntity?.subject }
    }
    
    var body: String? {
        get { return loadBody() }
    }

    var lastMessageTimestamp: Int32? {
        get { return threadEntity?.last_message_timestamp }
    }
    
    var hasAttachments: Bool? {
        get { return threadEntity?.has_attachments }
    }
    
    var starred: Bool? {
        get { return threadEntity?.starred }
    }
    
    var id: String? {
        get { return threadEntity?.id }
    }
    
    var accountId: String? {
        get { return threadEntity?.account_id }
    }
    
    var unread: Bool? {
        get { return threadEntity?.unread }
    }
    
    var seen: Bool? {
        get { return threadEntity?.seen }
    }
    
    var sectionType: SectionType? {
        get { return loadSectionType() }
    }
    
    var isCleared: Bool? {
        get { return loadCleared() }
    }
    
    var isSeen: Bool? {
        get { return loadSeen() }
    }
    
    var isNew: Bool? {
        get { return loadNew() }
    }
    
    private var parser = ThreadsParser()
    private var proxy = ThreadsProxy()
    
    init(with jsonObject: JSON) {
        threadEntity = proxy.fetchThread(by: jsonObject["id"].stringValue)
    }
    
    // MARK: - Private processing logic
    
    private func loadVendorName() -> String? {
        var displayName = threadEntity?.last_message_from?.name
        if displayName == "" {
            displayName = threadEntity?.last_message_from?.email
        }
        return displayName
    }
    
    private func loadVendorImageURL() -> URL? {
        if let urlString = threadEntity?.last_message_from?.profile_pic {
            return URL(string: urlString)
        }
        return nil
    }
    
    private func loadSectionType() -> SectionType? {
        if let section = threadEntity?.section {
            if section == "feeds" {
                return .feeds
            }
            return .convos
        }
        return .convos
    }
    
    private func loadCleared() -> Bool? {
        //inbox = false or (inbox=true && unread = false)
        guard let inbox = threadEntity?.inbox, let unread = threadEntity?.unread, let section = sectionType else { return nil }
        if inbox == false || (inbox == true && unread == false)  && section == .convos {
            return true
        }
        return false
    }
    
    private func loadSeen() -> Bool? {
        //unread = true, seen = true, inbox = true
        guard let unread = threadEntity?.unread, let inbox = threadEntity?.inbox, let seen = threadEntity?.seen else { return nil }
        if unread == true && inbox == true &&  seen == true {
            return true
        }
        return false
    }
    
    private func loadNew() -> Bool? {
        //unread = true, seen = false, inbox = true
        guard let unread = threadEntity?.unread, let inbox = threadEntity?.inbox, let seen = threadEntity?.seen else { return nil }
        if unread == true && inbox == true && seen == false {
            return true
        }
        return false
    }

    private func loadBody() -> String? {
        if let summary = threadEntity?.summary {
            return summary
        }
        return threadEntity?.snippet
    }
    
    static func == (lhs: ThreadsReceiver, rhs: ThreadsReceiver) -> Bool {
        return lhs.id == rhs.id
    }
}
