//
//  CannedResponse.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/11/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyAction: NSObject {
    
    var title: String
    var message: String?
    var imageName: String?
    
    init(title: String, message: String? = nil, imageName: String? = nil) {
        self.title = title
        self.message = message
        self.imageName = imageName
    }
}
