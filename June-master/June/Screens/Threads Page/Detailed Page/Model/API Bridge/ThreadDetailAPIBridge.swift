//
//  ThreadDetailAPIBridge.swift
//  June
//
//  Created by Joshua Cleetus on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import KeychainSwift

class ThreadsDetailAPIBridge: NSObject {

    var skip: Int = 1
    var dataArray: [[String: AnyObject]] = []
    var totalNewMessagesCount: Int = 0
    var message: Messages?
    var totalUnreadMessagesCount: Int = 0

    // Get messages for a thread
    
    func getMessagesDataWith(_withThreadId threadId: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let query = Query()
            .eq(property: "thread_id", value: threadId)
            .sort(property: "date", ordering: ComparisonResult.orderedDescending)
            .limit(5)
        FeathersManager.Services.message.request(.find(query: query)).on(value: { [weak self] response in
            if let strongSelf = self {
                let responseString : String = response.description
                let responseStringArray : Array = responseString.split{$0 == "\n"}.map(String.init)
                if responseStringArray.count > 0 {
                    let totalStringArray : Array = responseStringArray[0].split{$0 == " "}.map(String.init)
                    let totalString : String = totalStringArray[1]
                    if let converterdString = Int(totalString) {
                        strongSelf.totalNewMessagesCount = converterdString
                    } else {
                        strongSelf.totalNewMessagesCount = 0
                    }
                }
                if let value = response.data.value as? [[String: AnyObject]] {
                    strongSelf.dataArray = value
                    DispatchQueue.main.async {
                        completion(.Success(strongSelf.dataArray))
                    }
                }
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    // Get Messages for a thread with a skip value
    
    func getMoreMessagesDataWith(_withSkip skipValue: Int, threadId: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let query = Query()
            .eq(property: "thread_id", value: threadId)
            .sort(property: "date", ordering: ComparisonResult.orderedDescending)
            .limit(5)
            .skip(skipValue)
        FeathersManager.Services.message.request(.find(query: query)).on(value: { [weak self] response in
            if let strongSelf = self {
                let responseString = response.description
                let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                if responseStringArray.count > 0 {
                    let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                    let totalString = totalStringArray[1]
                    if let converterdString = Int(totalString) {
                        strongSelf.totalNewMessagesCount = converterdString
                    } else {
                        strongSelf.totalNewMessagesCount = 0
                    }
                }
                if let value = response.data.value as? [[String: AnyObject]] {
                    strongSelf.dataArray = value
                    DispatchQueue.main.async {
                        completion(.Success(strongSelf.dataArray))
                    }
                }
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    // Mark thread as starred or unstarred
    
    func markThreadAsStarredOnUnstarred(threadId: String, accountId: String, starred: Bool, completion: @escaping (Result<[String: Any]>) -> Void) {
        let params = ["starred": starred, "unread" : false, "account_id" : accountId as Any] as [String : Any]
        if threadId.isEmpty {
            return
        }
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil)).on(value: { response in
            if let data = response.data.value as? [String: Any] {
                completion(.Success(data))
            }
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
    
    // Get the unread messages from a thread
    // if there are no results, there are no unread messages in the thread
    //    query = {
    //    thread_id: THREAD_ID,
    //    unread: true,
    //    $limit: 1,
    //    $sort: { date: -1 }
    //    }
    
    func getUnreadMessagesForTheThread(threadId: String, completion: @escaping (Result<[[String: Any]]>) -> Void) {
        let query = Query()
            .eq(property: "thread_id", value: threadId)
            .eq(property: "unread", value: "true")
            .limit(1)
            .sort(property: "date", ordering: ComparisonResult.orderedAscending)
        FeathersManager.Services.message.request(.find(query: query))
            .on(value: { [weak self] response in
                if let strongSelf = self {
                    let responseString = response.description
                    let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
                    if responseStringArray.count > 0 {
                        let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                        let totalString = totalStringArray[1]
                        if let count = Int(totalString) {
                            strongSelf.totalUnreadMessagesCount = count
                        } else {
                            strongSelf.totalUnreadMessagesCount = 0
                        }
                    }
                    if let data = response.data.value as? [[String: Any]] {
                        completion(.Success(data))
                    }
                }
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })

    }
    
}
