//
//  FavsAPIBridge.swift
//  June
//
//  Created by Joshua Cleetus on 3/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import KeychainSwift

class FavsAPIBridge: NSObject {

    func getFavsDataWith(_withLimit limit:Int, skipValue: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let query = Query()
            // cut off clause
            // new messages can only be after you signed up for June
            .sort(property: "name", ordering: .orderedAscending)
            .limit(limit)
            .skip(skipValue)
        FeathersManager.Services.favorites.request(.find(query: query)).on(value: { response in
            let responseString = response.description
            let responseStringArray = responseString.split{$0 == "\n"}.map(String.init)
            if responseStringArray.count > 0 {
                let totalStringArray = responseStringArray[0].split{$0 == " "}.map(String.init)
                let totalString = totalStringArray[1]
                if Int(totalString) != nil {
                    print(totalString as Any)
                }
            }
            if let dataArray = response.data.value as? [[String: AnyObject]] {
                print(dataArray as Any)
                DispatchQueue.main.async {
                    completion(.Success(dataArray))
                }
            } else {
                completion(.Error("No data found"))
            }
            
        }).startWithFailed { (error) in
            return completion(.Error(error.localizedDescription))
        }
    }
}
