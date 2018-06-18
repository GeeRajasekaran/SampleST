//
//  KeyChainManager.swift
//  June
//
//  Created by Joshua Cleetus on 7/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import KeychainSwift

class KeyChainManager {
    
    class func clear() {
        KeychainSwift().delete(JuneConstants.Feathers.jwtToken)
        
        if let usernameData = KeyChainManager.load(key: JuneConstants.KeychainKey.username) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.username, data: usernameData)
        }
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
        }
        if let userAccountData = KeyChainManager.load(key: JuneConstants.KeychainKey.accountID) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.accountID, data: userAccountData)
        }
        if let userIDData = KeyChainManager.load(key: JuneConstants.KeychainKey.userID) {
            _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userID, data: userIDData)
        }
    }
    
    class func save(key: String, data: NSData) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
        
    }
    
    class func load(key: String) -> NSData? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef:AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return (dataTypeRef! as! NSData)
        } else {
            return nil
        }
        
        
    }
    
    class func delete(key: String, data: NSData) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status
    }
    
    class func dictionaryToNSDATA(dictionary : Dictionary<String, Any>)->NSData
    {
        let _Data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        return _Data as NSData
        
    }
    
    class func NSDATAtoDictionary(data : NSData)->Dictionary<String, Any>
    {
        let returned_dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String : Any]
        return returned_dictionary!
        
    }
    
    class func stringToNSDATA(string : String)->NSData
    {
        let _Data = (string as NSString).data(using: String.Encoding.utf8.rawValue)
        return _Data! as NSData
        
    }
    
    
    class func NSDATAtoString(data: NSData)->String
    {
        let returned_string : String = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return returned_string
    }
    
    class func intToNSDATA(r_Integer : Int)->NSData
    {
        
        var SavedInt: Int = r_Integer
        let _Data = NSData(bytes: &SavedInt, length: MemoryLayout<Int>.size)
        return _Data
        
    }
    
    class func NSDATAtoInteger(_Data : NSData) -> Int
    {
        var RecievedValue : Int = 0
        _Data.getBytes(&RecievedValue, length: MemoryLayout<Int>.size)
        return RecievedValue
        
    }
    
    class func CreateUniqueID() -> String
    {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr:CFString = CFUUIDCreateString(nil, uuid)
        
        let nsTypeString = cfStr as NSString
        let swiftString:String = nsTypeString as String
        return swiftString
    }
    
}
