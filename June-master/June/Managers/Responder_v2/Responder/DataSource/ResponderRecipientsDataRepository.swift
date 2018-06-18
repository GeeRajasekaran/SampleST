//
//  ResponderRecipientsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderRecipientsDataRepository: IResponderRecipientsDataRepository {
    
    var recipients: [EmailReceiver]
    
    weak var metadata: ResponderMetadata?
    private var config: ResponderConfig?
    
    required init(metadata: ResponderMetadata?) {
        self.metadata = metadata
        recipients = []
        if let unwrappedRecipients = metadata?.recipients {
            recipients = unwrappedRecipients
        }
    }
    
    func count() -> Int {
        return recipients.count
    }
    
    func recipient(at index: Int) -> EmailReceiver? {
        if 0..<recipients.count ~= index {
            return recipients[index]
        }
        return nil
    }
    
    func append(_ recipient: EmailReceiver) {
        let index = recipients.count - 1
        if index < recipients.count {
            recipients.insert(recipient, at: index)
        }
    }
    
    func contains(_ recipient: EmailReceiver) -> Bool {
        return recipients.contains(recipient)
    }
    
    func index(of recipient: EmailReceiver) -> Int? {
        return recipients.index(of: recipient)
    }
    
    func remove(at index: Int) {
        recipients.remove(at: index)
    }
    
    func containsEmail(_ email: String) -> Bool {
        for recipient in recipients {
            if recipient.email == email { return true }
        }
        return false
    }
    
    func clear() {
        recipients = []
    }
}
