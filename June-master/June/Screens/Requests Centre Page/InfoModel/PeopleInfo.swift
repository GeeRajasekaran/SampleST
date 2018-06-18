//
//  PeopleInfo.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class PeopleInfo: BaseTableModel {
    
    private var contactEntity: Contacts?
    private var messagesCount: Int?

    var pictureURL: URL? {
        get { return loadContactURL() }
    }
    
    var name: String? {
        get { return contactEntity?.name }
    }
    
    var email: String? {
        get { return contactEntity?.email }
    }
    var lastMessageSubject: String? {
        get { return contactEntity?.last_message_subject }
    }
    
    var lastMessageSnippet: String? {
        get { return contactEntity?.last_message_snippet }
    }
    
    init(entity: Contacts?, messagesCount: Int?) {
        self.contactEntity = entity
        self.messagesCount = messagesCount
    }
    
    var totalMessagesCount: Int? {
        get { return messagesCount }
    }
    
    var shouldShowMoreLabel: Bool {
        get { return showMoreLabel() }
    }
    
    // MARK: - Private processing logic
    private func loadContactURL() -> URL? {
        if let urlString = contactEntity?.profile_pic {
            return URL(string: urlString)
        }
        return nil
    }
    
    private func showMoreLabel() -> Bool {
        guard let count = messagesCount else { return false }
        if count > 1 {
            return true
        }
        return false
    }
}
