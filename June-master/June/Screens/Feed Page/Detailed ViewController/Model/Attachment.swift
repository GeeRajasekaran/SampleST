//
//  Attachment.swift
//  June
//
//  Created by Ostap Holub on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class Attachment: Equatable {
    
    var url: String = ""
    var filename: String
    var contentId: String
    var contentType: String
    var id: String
    var size: Int32
    
    convenience init(from file: Messages_Files) {
        let name = file.file_name ?? ""
        let contId = file.content_id ?? ""
        let type = file.content_type ?? ""
        let fileId = file.id ?? ""
        self.init(name: name, contentId: contId, type: type, id: fileId, fileSize: Int32(file.size))
    }
    
    init(name: String, contentId: String, type: String, id: String, fileSize: Int32) {
        filename = name
        contentType = type
        size = fileSize
        self.contentId = contentId
        self.id = id
    }
    
    init(name: String, type: String, fileSize: Int32) {
        filename = name
        contentType = type
        size = fileSize
        contentId = ""
        id = ""
    }
    
    init(jsonObject: JSON) {
        filename = jsonObject["filename"].stringValue
        contentType = jsonObject["content_type"].stringValue
        size = jsonObject["size"].int32Value
        url = jsonObject["url"].stringValue
        contentId = ""
        id = jsonObject["id"].stringValue
    }
    
    static func ==(lhs: Attachment, rhs: Attachment) -> Bool {
        return lhs.id == rhs.id
    }
    
}
