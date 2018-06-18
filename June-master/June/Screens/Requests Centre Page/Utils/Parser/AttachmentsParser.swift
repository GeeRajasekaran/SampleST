//
//  AttachmentsParser.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

class AttachmentsParser {
    
    func loadData(from json: JSON, to entity: Messages_Files) {
        entity.id = json["id"].string
        entity.size = json["size"].int32Value
        entity.content_type = json["content_type"].string
        entity.file_name = json["filename"].string
    }
    
    func loadData(from attachment: Attachment, to entity: Messages_Files) {
        entity.id = attachment.id
        entity.size = attachment.size
        entity.content_type = attachment.contentType
        entity.file_name = attachment.id
    }
}
