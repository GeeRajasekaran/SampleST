//
//  ThreadsAPIBridge.swift
//  June
//
//  Created by Joshua Cleetus on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import KeychainSwift

class ThreadsAPIBridge: NSObject {
    
    var skip: Int = 1
    var dataArray: [[String: AnyObject]] = []
    var dataArrayb: [[String: AnyObject]] = []

    var accountsObject: NSArray = []
    var thread: Threads?
    var totalNewMessagesCount: Int32 = 0
    
    var dataArray2: [[String: AnyObject]] = []
    var dataArray2b: [[String: AnyObject]] = []
    var totalNewMessagesCount2: Int32 = 0
    
    var dataArray3: [[String: AnyObject]] = []
    var dataArray3b: [[String: AnyObject]] = []
    var totalNewMessagesCount3: Int32 = 0
    
    var dataArray4: [[String: AnyObject]] = []
    var dataArray4b: [[String: AnyObject]] = []
    var totalNewMessagesCount4: Int32 = 0
    
    func getUnreadConversationsDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                let cutOffDateTime = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "unread", value: "true")
                                    .eq(property: "inbox", value: "true")
                                    .eq(property: "spam", value: "false")
                                    .eq(property: "trash", value: "false")
                                    .eq(property: "category", value: "conversations")
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
//                                    .gt(property: "last_message_timestamp", value: cutOffDateTime!)
                                    .or(subqueries: ["approved": Query.PropertySubquery.eq(1), "first_message_timestamp": Query.PropertySubquery.gt(cutOffDateTime!)])
                                    .limit(50)
                                let userService = FeathersManager.Services.threads
                                userService.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray))
                                        }
                                    }
                                    
                                }).startWithFailed { (error) in
                                    print(error as Any)
                                    return completion(.Error(error.localizedDescription))
                                }
                            } else {
                                completion(.Error("Authentication Error 400"))
                            }
                        }
                    }
                } else {
                    completion(.Error("Authentication Error 400"))
                }
            } else {
                completion(.Error("Authentication Error 400"))
            }
        }
    }
    
    func getUnreadConversationsDataWith(_withSkip skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                let cutOffDateTime = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "unread", value: "true")
                                    .eq(property: "inbox", value: "true")
                                    .eq(property: "category", value: "conversations")
//                                    .gt(property: "last_message_timestamp", value: cutOffDateTime!)
                                    .or(subqueries: ["approved": Query.PropertySubquery.eq(1), "first_message_timestamp": Query.PropertySubquery.gt(cutOffDateTime!)])
                                    .eq(property: "account_id", value: primary_account_id)
                                    // base query
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(50)
                                    .skip(skipValue)
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArrayb = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArrayb))
                                        }
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
    
    func getReadConversationsDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                let cutOffDateTime = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "unread", value: "false")
                                    .eq(property: "spam", value: "false")
                                    .eq(property: "trash", value: "false")
                                    .eq(property: "category", value: "conversations")
//                                    .gt(property: "last_message_timestamp", value: cutOffDateTime!)
                                    .or(subqueries: ["approved": Query.PropertySubquery.eq(1), "first_message_timestamp": Query.PropertySubquery.gt(cutOffDateTime!)])
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    //                                    .`in`(property: "account_id", values: [primary_account_id])
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(50)
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount2 = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray2 = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray2))
                                        }
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
    
    func getReadConversationsDataWith(_withSkip skipValue:Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                let cutOffDateTime = accountsDict["created_at"] as? Int32
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "unread", value: "false")
                                    .eq(property: "spam", value: "false")
                                    .eq(property: "trash", value: "false")
                                    .eq(property: "category", value: "conversations")
//                                    .gt(property: "last_message_timestamp", value: cutOffDateTime!)
                                    .or(subqueries: ["approved": Query.PropertySubquery.eq(1), "first_message_timestamp": Query.PropertySubquery.gt(cutOffDateTime as Any)])
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    //.`in`(property: "account_id", values: [primary_account_id])
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(50)
                                    .skip(skipValue)
                                
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount2 = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray2b = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray2b))
                                        }
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
    
    func getTrashDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "trash", value: 1)
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
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount3 = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray3 = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray3))
                                        }
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
    
    func getTrashDataWith(_withSkip skipValue:Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "trash", value: 1)
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
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount3 = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray3b = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray3b))
                                        }
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
    
    func getSpamDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "spam", value: 1)
                                    // base query
                                    .eq(property: "account_id", value: primary_account_id)
                                    .sort(property: "last_message_timestamp", ordering: ComparisonResult.orderedDescending)
                                    .limit(20)
                                FeathersManager.Services.threads.request(.find(query: query)).on(value: { response in
                                    let responseString = response.description
                                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                                    if responseStringArray.count > 0 {
                                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                                        let totalString = totalStringArray[1]
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount4 = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray4 = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray4))
                                        }
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
    
    func getSpamDataWith(_withSkip skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if let accounts_object = userObject["accounts"] as? NSArray {
                if accounts_object.count > 0 {
                    if let accountsDict = accounts_object[0] as? [String : Any] {
                        if (accountsDict["created_at"] as? Int32) != nil {
                            if let primary_account_id = userObject["primary_account_id"] as? String {
                                
                                let query = Query()
                                    // cut off clause
                                    // new messages can only be after you signed up for June
                                    .eq(property: "spam", value: 1)
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
                                        if Int32(totalString) != nil {
                                            self.totalNewMessagesCount4 = Int32(totalString)!
                                        }
                                    }
                                    if response.data.value is Array<Any> {
                                        self.dataArray4b = response.data.value as! [[String: AnyObject]]
                                        DispatchQueue.main.async {
                                            completion(.Success(self.dataArray4b))
                                        }
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
    
    func markThreadAsRead(threadId: String, accountId: String, completion: @escaping (Result<[String: Any]>) -> Void) {

        let thread_id = threadId
        if thread_id.isEmpty {
            return
        }
        let account_id = accountId
        let params = ["unread" : false, "account_id" : account_id as Any] as [String : Any]
        
        FeathersManager.Services.threads.request(.patch(id: thread_id, data: params, query: nil)).on(value: { response in
            let data = response.data.value as! [String: Any]
            DispatchQueue.main.async {
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
        
    }
    
    func markThreadAsStarred(threadId: String, accountId: String, completion: @escaping (Result<[String: Any]>) -> Void) {
        
        let thread_id = threadId
        if thread_id.isEmpty {
            return
        }
        let account_id = accountId
        let params = ["starred": true, "unread" : false, "account_id" : account_id as Any] as [String : Any]
        
        FeathersManager.Services.threads.request(.patch(id: thread_id, data: params, query: nil)).on(value: { response in
            let data = response.data.value as! [String: Any]
            DispatchQueue.main.async {
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    func markThreadAsUnStarred(threadId: String, accountId: String, completion: @escaping (Result<[String: Any]>) -> Void) {
        
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
    
    func markThreadAsStarredOrUnstarred(threadId: String, accountId: String, starred: Bool, unread: Bool, completion: @escaping (Result<[String: Any]>) -> Void) {
        let params = ["starred": starred, "unread" : unread, "account_id" : accountId as Any] as [String : Any]
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

enum Result<T> {
    case Success(T)
    case Error(String)
}
