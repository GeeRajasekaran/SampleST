//
//  UserInfoLoader.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class UserInfoLoader: NSObject {

    static var profileImageURL: URL? {
        get { return loadUsertImageURL() }
    }
    
    static var userName: String? {
        get { return loadUsertName() }
    }
    
    static var userPrimaryEmail: String? {
        get { return loadUsertPrimaryEmail() }
    }
    
    static var userEmails: [String]? {
        get { return loadUserEmails() }
    }
    
    static var accountId: String? {
        get { return loadAccountId() }
    }
    
    //MARK: - private part
    static private func loadUsertImageString() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let profile_image = serializedUserObject["profile_image"] {
            return profile_image as? String
        }
        return nil
    }
    
    static private func loadUsertImageURL() -> URL? {
        if let urlString = loadUsertImageString() {
            return URL(string: urlString)
        }
        return nil
    }
    
    static private func loadUsertName() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]], let firstAccount = accounts.first {
            if let name = firstAccount["name"] as? String {
                return name
            }
        }
        return nil
    }
    
    static private func loadUsertPrimaryEmail() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let primary_email = serializedUserObject["primary_email"] {
            return primary_email as? String
        }
        return nil
    }
    
    static private func loadUserEmails() -> [String]? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil}
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        var emails: [String] = []
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]] {
            accounts.forEach({ accountDictionary in
                if let email = accountDictionary["email_address"] as? String {
                    emails.append(email)
                }
            })
        }
        return emails
    }
    
    static private func loadAccountId() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        return serializedUserObject["primary_account_id"] as? String
    }
}
