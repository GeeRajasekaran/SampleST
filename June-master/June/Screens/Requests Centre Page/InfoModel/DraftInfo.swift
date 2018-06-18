//
//  DraftInfo.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class DraftInfo: BaseTableModel {
    private var draftEntity: Drafts?
    
    var text: String? {
        get { return draftEntity?.body }
    }
    
    var replyToMessageId: String? {
        get { return draftEntity?.message_id }
    }
    
    var attachments: [Attachment]? {
        get { return loadAttachments() }
    }
    
    var files: [Messages_Files]? {
        get { return loadFiles() }
    }
    
    init(entity: Drafts?) {
        self.draftEntity = entity
    }
    
    //MARK: - get attachments
    private func loadAttachments() -> [Attachment] {
        var attachmets: [Attachment] = []
        if let files = draftEntity?.messages_files?.allObjects as? [Messages_Files] {
            files.forEach({ file in
                let attachment = Attachment(from: file)
                attachmets.append(attachment)
            })
        }
        return attachmets
    }
    
    private func loadFiles() -> [Messages_Files] {
        if let files = draftEntity?.messages_files?.allObjects as? [Messages_Files] {
           return files
        }
        return []
    }
}
