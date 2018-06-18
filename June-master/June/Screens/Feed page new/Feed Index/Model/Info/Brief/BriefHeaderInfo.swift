//
//  BriefHeaderInfo.swift
//  June
//
//  Created by Ostap Holub on 1/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefHeaderInfo: BaseTableModel {
    
    // MARK: - Variables
    
    var title: String = ""
    var subtitle: String = ""
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        title = createTitle()
        subtitle = createSubtitle()
    }
    
    // MARK: - Private title building
    
    private func createTitle() -> String {
        let firstPart: String = "Good Morning"
        let name: String = username() ?? ""
        return "\(firstPart) \(name)!"
    }
    
    // MARK: - Private subtitle building
    
    private func createSubtitle() -> String {
        let dayName = Date().dayName
        return "\(dayName)'s Daily Brief"
    }
    
    private func username() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let username = serializedUserObject["name"] as? String {
            let components = username.components(separatedBy: " ")
            return components.first
        }
        return nil
    }
}
