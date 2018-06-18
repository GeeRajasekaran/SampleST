//
//  ConvosAPIBridge.swift
//  June
//
//  Created by Joshua Cleetus on 1/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import KeychainSwift

class ConvosAPIBridge: NSObject {
    var skip: Int = 1
    
    var accountsObject: NSArray = []
    var thread: Threads?
    
    var newDataArray: [[String: AnyObject]] = []
    var totalNewMessagesCount: Int = 0
    
    var seenDataArray: [[String: AnyObject]] = []
    var totalSeenMessagesCount: Int = 0
    
    var clearedDataArray: [[String: AnyObject]] = []
    var totalClearedMessagesCount: Int = 0
    
    var spamDataArray: [[String: AnyObject]] = []
    var totalspamMessagesCount: Int = 0
    
    //New
    func getNewConvosDataWith(_withLimit limit:Int, skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    var accountId:String
                    if let primary_account_id = userObject["primary_account_id"] as? String {
                        accountId = primary_account_id
                    } else {
                        guard let accountsDict = accounts_object[0] as? [String : Any] else {
                            return
                        }
                        guard let account_id = accountsDict["account_id"] as? String else {
                            return
                        }
                        accountId = account_id
                    }
                    let query = Query()
                        // cut off clause
                        // new messages can only be after you signed up for June
                        .eq(property: "unread", value: "true")
                        .eq(property: "seen", value: "false")
                        .eq(property: "inbox", value: "true")
                        .eq(property: "spam", value: "false")
                        .eq(property: "trash", value: "false")
                        .eq(property: "section", value: "convos")
                        .eq(property: "category", value: "conversations")
                        .eq(property: "approved", value: 1)
                        .eq(property: "account_id", value: accountId)
                        // base query
                        .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                        .limit(limit)
                        .skip(skipValue)
                    FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                        let responseString = response.description
                        let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                        if responseStringArray.count > 0 {
                            let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                            let totalString = totalStringArray[1]
                            if Int(totalString) != nil {
                                self.totalNewMessagesCount = Int(totalString)!
                            }
                        }
                        if response.data.value is Array<Any> {
                            self.newDataArray = response.data.value as! [[String: AnyObject]]
                            DispatchQueue.main.async {
                                completion(.Success(self.newDataArray))
                            }
                        } else {
                            completion(.Error("No data found"))
                        }
                        
                    }).startWithFailed { (error) in
                        return completion(.Error(error.localizedDescription))
                    }

                }
            }
        }
    }
    
    // MARK: - Seen
    func getSeenConvosDataWith(_withLimit limit:Int, skipValue:Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    var accountId:String
                    if let primary_account_id = userObject["primary_account_id"] as? String {
                        accountId = primary_account_id
                    } else {
                        guard let accountsDict = accounts_object[0] as? [String : Any] else {
                            return
                        }
                        guard let account_id = accountsDict["account_id"] as? String else {
                            return
                        }
                        accountId = account_id
                    }
                    let query = Query()
                        // cut off clause
                        // new messages can only be after you signed up for June
                        .eq(property: "unread", value: "true")
                        .eq(property: "seen", value: "true")
                        .eq(property: "spam", value: "false")
                        .eq(property: "trash", value: "false")
                        .eq(property: "section", value: "convos")
                        .eq(property: "category", value: "conversations")
                        .eq(property: "approved", value: 1)
                        // base query
                        .eq(property: "account_id", value: accountId)
                        .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                        .limit(limit)
                        .skip(skipValue)
                    FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                        let responseString = response.description
                        let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                        if responseStringArray.count > 0 {
                            let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                            let totalString = totalStringArray[1]
                            if Int(totalString) != nil {
                                self.totalSeenMessagesCount = Int(totalString)!
                            }
                        }
                        if response.data.value is Array<Any> {
                            self.seenDataArray = response.data.value as! [[String: AnyObject]]
                            DispatchQueue.main.async {
                                completion(.Success(self.seenDataArray))
                            }
                        } else {
                            completion(.Error("No data found"))
                        }
                    }).startWithFailed { (error) in
                        return completion(.Error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    // MARK: - Cleared
    func getClearedConvosDataWith(_withLimit limit:Int, skipValue:Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    var accountId:String
                    if let primary_account_id = userObject["primary_account_id"] as? String {
                        accountId = primary_account_id
                    } else {
                        guard let accountsDict = accounts_object[0] as? [String : Any] else {
                            return
                        }
                        guard let account_id = accountsDict["account_id"] as? String else {
                            return
                        }
                        accountId = account_id
                    }
                    let query = Query()
                        // cut off clause
                        // new messages can only be after you signed up for June
                        .eq(property: "spam", value: "false")
                        .eq(property: "trash", value: "false")
                        .eq(property: "section", value: "convos")
                        .eq(property: "category", value: "conversations")
                        .eq(property: "approved", value: 1)
                        // base query
                        .eq(property: "account_id", value: accountId)
                        .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                        .or(subqueries: ["inbox": Query.PropertySubquery.eq("false")])
                        .or(subqueries: ["inbox": Query.PropertySubquery.eq("true"), "unread": Query.PropertySubquery.eq("false")])
                        .limit(limit)
                        .skip(skipValue)
                    FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                        let responseString = response.description
                        let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                        if responseStringArray.count > 0 {
                            let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                            let totalString = totalStringArray[1]
                            if Int(totalString) != nil {
                                self.totalClearedMessagesCount = Int(totalString)!
                            }
                        }
                        if response.data.value is Array<Any> {
                            self.clearedDataArray = response.data.value as! [[String: AnyObject]]
                            DispatchQueue.main.async {
                                completion(.Success(self.clearedDataArray))
                            }
                        }
                    }).startWithFailed { (error) in
                        return completion(.Error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    func getClearedConvosDataForSecondQueryWith(_withLimit limit:Int, skipValue:Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    var accountId:String
                    if let primary_account_id = userObject["primary_account_id"] as? String {
                        accountId = primary_account_id
                    } else {
                        guard let accountsDict = accounts_object[0] as? [String : Any] else {
                            return
                        }
                        guard let account_id = accountsDict["account_id"] as? String else {
                            return
                        }
                        accountId = account_id
                    }
                    let query = Query()
                        // cut off clause
                        // new messages can only be after you signed up for June
                        .eq(property: "spam", value: "false")
                        .eq(property: "trash", value: "false")
                        .eq(property: "section", value: "convos")
                        .eq(property: "category", value: "conversations")
                        .eq(property: "approved", value: 1)
                        // base query
                        .eq(property: "account_id", value: accountId)
                        .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                        .or(subqueries: ["inbox": Query.PropertySubquery.eq("false")])
                        .or(subqueries: ["inbox": Query.PropertySubquery.eq("true"), "unread": Query.PropertySubquery.eq("false")])
                        .limit(limit)
                        .skip(skipValue)
                    FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                        let responseString = response.description
                        let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                        if responseStringArray.count > 0 {
                            let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                            let totalString = totalStringArray[1]
                            if Int(totalString) != nil {
                                self.totalClearedMessagesCount = Int(totalString)!
                            }
                        }
                        if response.data.value is Array<Any> {
                            self.clearedDataArray = response.data.value as! [[String: AnyObject]]
                            DispatchQueue.main.async {
                                completion(.Success(self.clearedDataArray))
                            }
                        }
                    }).startWithFailed { (error) in
                        return completion(.Error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    // MARK: - Spam
    func getSpamDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    var accountId:String
                    if let primary_account_id = userObject["primary_account_id"] as? String {
                        accountId = primary_account_id
                    } else {
                        guard let accountsDict = accounts_object[0] as? [String : Any] else {
                            return
                        }
                        guard let account_id = accountsDict["account_id"] as? String else {
                            return
                        }
                        accountId = account_id
                    }
                    let query = Query()
                        .eq(property: "spam", value: 1)
                        // base query
                        .eq(property: "account_id", value: accountId)
                        .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                        .limit(20)
                    FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                        let responseString = response.description
                        let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                        if responseStringArray.count > 0 {
                            let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                            let totalString = totalStringArray[1]
                            if Int32(totalString) != nil {
                                self.totalspamMessagesCount = Int(totalString)!
                            }
                        }
                        if response.data.value is Array<Any> {
                            self.spamDataArray = response.data.value as! [[String: AnyObject]]
                            DispatchQueue.main.async {
                                completion(.Success(self.spamDataArray))
                            }
                        }
                    }).startWithFailed { (error) in
                        return completion(.Error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    func getSpamDataWith(_withSkip skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    var accountId:String
                    if let primary_account_id = userObject["primary_account_id"] as? String {
                        accountId = primary_account_id
                    } else {
                        guard let accountsDict = accounts_object[0] as? [String : Any] else {
                            return
                        }
                        guard let account_id = accountsDict["account_id"] as? String else {
                            return
                        }
                        accountId = account_id
                    }
                    let query = Query()
                        .eq(property: "spam", value: 1)
                        .eq(property: "account_id", value: accountId)
                        .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                        .limit(20)
                        .skip(skipValue)
                    FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                        let responseString = response.description
                        let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                        if responseStringArray.count > 0 {
                            let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                            let totalString = totalStringArray[1]
                            if Int32(totalString) != nil {
                                self.totalspamMessagesCount = Int(totalString)!
                            }
                        }
                        if response.data.value is Array<Any> {
                            self.spamDataArray = response.data.value as! [[String: AnyObject]]
                            DispatchQueue.main.async {
                                completion(.Success(self.spamDataArray))
                            }
                        }
                    }).startWithFailed { (error) in
                        return completion(.Error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    // Mark as New
    func markThreadAsNew(threadId: String, accountId: String, thread:Threads, completion: @escaping (Result<[String: Any]>) -> Void) {
        let current_account = self.getUserAccount(accountId: accountId)
        let threadObject = self.getDictionaryFromThreads(thread: thread)
        let params = ["unread": true, "seen" : false, "account_id" : accountId as Any, "account": current_account, "thread": threadObject] as [String : Any]
        if threadId.isEmpty {
            return
        }
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil)).on(value: { response in
            if response.data.value is [String: Any] {
                let data = response.data.value as! [String: Any]
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    // Mark as Cleared
    func markThreadAsCleared(threadId: String, accountId: String, thread: Threads, completion: @escaping (Result<[String: Any]>) -> Void) {
        let current_account = self.getUserAccount(accountId: accountId)
        let threadObject = self.getDictionaryFromThreads(thread: thread)
        let params = ["unread" : false, "account_id" : accountId as Any, "account": current_account, "thread": threadObject] as [String : Any]
        if threadId.isEmpty {
            return
        }
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil)).on(value: { response in
            if response.data.value is [String: Any] {
                let data = response.data.value as! [String: Any]
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    // Mark as Seen
    func markThreadAsSeen(threadId: String, accountId: String, thread:Threads, completion: @escaping (Result<[String: Any]>) -> Void) {
        let current_account = self.getUserAccount(accountId: accountId)
        let threadObject = self.getDictionaryFromThreads(thread: thread)
        let params = ["unread": true, "seen" : true, "account_id" : accountId as Any, "account": current_account, "thread": threadObject] as [String : Any]
        if threadId.isEmpty {
            return
        }
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil)).on(value: { response in
            if response.data.value is [String: Any] {
                let data = response.data.value as! [String: Any]
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    // Mark change category
    func changeCategoryForSpam(threadId: String, category: String, completion: @escaping (Result<[String: Any]>) -> Void) {
        let params = ["category": category]
        if threadId.isEmpty {
            return
        }
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil)).on(value: { response in
            if response.data.value is [String: Any] {
                let data = response.data.value as! [String: Any]
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    func getUserAccount(accountId: String) -> [String: Any] {
        if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
            if userObject["accounts"] != nil {
                let accountsObject = userObject["accounts"] as! [[String: Any]]
                if accountsObject.count > 0 {
                    for dict in accountsObject {
                        if let account_id = dict["account_id"] as? String {
                            if account_id.isEqualToString(find: accountId) {
                                return dict
                            }
                        }
                    }
                }
            }
        }
        return [:]
    }
    
    func getDictionaryFromThreads(thread: Threads) -> [String: Any] {
        let keys = Array(thread.entity.attributesByName.keys)
        let dict:[String:Any] = thread.dictionaryWithValues(forKeys: keys)
        if dict.keys.count > 0 {
            return dict
        }
        return [:]
    }
}
