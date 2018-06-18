//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RolodexsTableInfo: BaseTableModel {
    var rolodexs: Rolodexs?
    var from: String = ""
    var body: String = ""
    var subject: String = ""
    
    init(rolodexs: Rolodexs? = nil) {
        self.rolodexs = rolodexs
    }
}
