//
//  StarredAPIBridge.swift
//  June
//
//  Created by Tatia Chachua on 06/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import Foundation
import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import KeychainSwift

class StarredAPIBridge: NSObject {
    
    var skip: Int = 1
    var dataArray: [[String: AnyObject]] = []
    var dataArrayb: [[String: AnyObject]] = []
    
    var accountsObject: NSArray = []
    var thread: Threads?
    var totalNewMessagesCount: Int32 = 0
    
    var dataArray2: [[String: AnyObject]] = []
    var dataArray2b: [[String: AnyObject]] = []
    var totalNewMessagesCount2: Int32 = 0
    
    func getStarredConversationsDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                _ = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    .eq(property: "starred", value: 1)
                                    .eq(property: "section", value: "convos")
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    //                                    .`in`(property: "account_id", values: [primary_account_id])
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(20)
                                
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        self.totalNewMessagesCount = Int32(totalString)!
                                    }
                                    self.dataArray = response.data.value as! [[String: AnyObject]]
                                    DispatchQueue.main.async {
                                        completion(.Success(self.dataArray))
                                    }
                                }).startWithFailed { (error) in
                                    return completion(.Error(error.localizedDescription))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getStarredConversationsDataWith(_withSkip skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                _ = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    .eq(property: "starred", value: 1)
                                    .eq(property: "section", value: "convos")
                                    
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    //                                    .`in`(property: "account_id", values: [primary_account_id])
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(20)
                                    .skip(skipValue)
                                
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        self.totalNewMessagesCount = Int32(totalString)!
                                    }
                                    self.dataArrayb = response.data.value as! [[String: AnyObject]]
                                    DispatchQueue.main.async {
                                        completion(.Success(self.dataArrayb))
                                    }
                                }).startWithFailed { (error) in
                                    return completion(.Error(error.localizedDescription))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getStarredFeedDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                _ = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    .eq(property: "starred", value: 1)
                                    .eq(property: "section", value: "feeds")
                                    
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    //                                    .`in`(property: "account_id", values: [primary_account_id])
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(20)
                                
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        self.totalNewMessagesCount2 = Int32(totalString)!
                                    }
                                    self.dataArray2 = response.data.value as! [[String: AnyObject]]
                                    DispatchQueue.main.async {
                                        completion(.Success(self.dataArray2))
                                    }
                                }).startWithFailed { (error) in
                                    return completion(.Error(error.localizedDescription))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func getStarredFeedDataWith(_withSkip skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                _ = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    
                                    .eq(property: "starred", value: 1)
                                    .eq(property: "section", value: "feeds")
                                    
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(20)
                                    .skip(skipValue)
                                
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        self.totalNewMessagesCount2 = Int32(totalString)!
                                    }
                                    self.dataArray2b = response.data.value as! [[String: AnyObject]]
                                    DispatchQueue.main.async {
                                        completion(.Success(self.dataArray2b))
                                    }
                                }).startWithFailed { (error) in
                                    return completion(.Error(error.localizedDescription))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // unstar message
    func markAsUnstarred(threadId: String, accountId: String, completion: @escaping (Result<[String: Any]>) -> Void) {
        
        let thread_id = threadId
        if thread_id.isEmpty {
            return
        }
        let account_id = accountId
        let params = ["starred": false, "account_id" : account_id as Any] as [String : Any]
        
        FeathersManager.Services.threads.request(.patch(id: thread_id, data: params, query: nil)).on(value: { response in
            let data = response.data.value as! [String: Any]
            DispatchQueue.main.async {
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
        
    }
    
    // unstar feed
    func markAsUnstarredFeed(threadId: String, accountId: String, completion: @escaping (Result<[String: Any]>) -> Void) {
        
        let thread_id = threadId
        if thread_id.isEmpty {
            return
        }
        let account_id = accountId
        let params = ["starred": false, "account_id" : account_id as Any] as [String : Any]
        
        FeathersManager.Services.threads.request(.patch(id: thread_id, data: params, query: nil)).on(value: { response in
            let data = response.data.value as! [String: Any]
            DispatchQueue.main.async {
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
        
    }
    
    func markThreadAsStarredOrUnstarred(threadId: String, accountId: String, starred: Bool, completion: @escaping (Result<[String: Any]>) -> Void) {
        let params = ["starred": starred, "account_id" : accountId as Any] as [String : Any]
        if threadId.isEmpty {
            return
        }
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil)).on(value: { response in
            let data = response.data.value as! [String: Any]
            completion(.Success(data))
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
}
