//
//  AttachmentsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 10/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class AttachmentsDataRepository {
    
    // MARK: - Variables & Constants
    
    private var attachments = [Attachment]()
    private var filesProxy: FilesProxy = FilesProxy()
    
    // MARK: - Initialization
    
    init(message: Messages?) {
        message?.messages_files?.forEach({ element in
            if let file = element as? Messages_Files {
                attachments.append(Attachment(from: file))
            }
        })
    }
    
    // MARK: - Accessing methods
    
    var count: Int {
        return attachments.count
    }
    
    func setAttachments(_ attachments: [Attachment]) {
        self.attachments = attachments
    }
    
    func getAttachments() -> [Attachment] {
        return attachments
    }
    
    func append(_ attachment: Attachment) {
        attachments.append(attachment)
    }
    
    func append(_ attachments: [Attachment]) {
        self.attachments.append(contentsOf: attachments)
    }
    
    func remove(at index: Int) {
        attachments.remove(at: index)
    }
    
    func attachment(at index: Int) -> Attachment? {
        if index >= 0 && index < attachments.count {
            return attachments[index]
        }
        return nil
    }
    
    func index(of attachment: Attachment) -> Int? {
        return attachments.index(of: attachment)
    }
    
    func clear() {
        attachments.removeAll()
    }
    
    func removeAttachemntFromeCoreData(at index: Int) {
        if let attachment = attachment(at: index) {
            filesProxy.removeFile(by: attachment.id)
        }
    }
}
