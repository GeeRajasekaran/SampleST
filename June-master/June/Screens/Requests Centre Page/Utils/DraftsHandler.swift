//
//  DraftsHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class DraftsHandler {

    let proxy = DraftsProxy()
    let parser = DraftsParser()
    let filesParser = AttachmentsParser()
    let filesProxy = FilesProxy()
    
    func saveDraftIntoCoreData(withRepliedToMessageId messageId: String, and messageEntity: Messages, and text: String, attachments: [Attachment]? = nil) {
        var draftEntity: Drafts? = nil
        if let entity = proxy.fetchDraft(by: messageId) {
            draftEntity = entity
        } else {
            draftEntity = proxy.addNewEmptyDrafts()
        }
        
        if draftEntity != nil {
            parser.loadData(from: messageEntity, and: text, to: draftEntity!)
            let files = create(from: attachments)
            if files.count > 0 {
                parser.add(filesFrom: files, to: draftEntity!)
            }
            proxy.saveContext()
        }
    }
    
    func removeDraftFromCoreData(with info: DraftInfo) {
        if let id = info.replyToMessageId {
            proxy.removeDraft(with: id)
            proxy.saveContext()
            removeFilesFromCoreData(with: info)
        }
    }
    
    func removeFilesFromCoreData(with draftInfo: DraftInfo) {
        if let files = draftInfo.files {
            files.forEach { file in
                if let id = file.id {
                    filesProxy.removeFile(by: id)
                }
            }
            filesProxy.saveContext()
        }
    }
    
    private func create(from attachments: [Attachment]?) -> [Messages_Files] {
        var files: [Messages_Files] = []
        guard let unwrappedAttachments = attachments else { return files }
        unwrappedAttachments.forEach { attachment in
            if let file = filesProxy.fetchFile(by: attachment.id) {
                files.append(file)
            }
        }
        return files
    }
}
