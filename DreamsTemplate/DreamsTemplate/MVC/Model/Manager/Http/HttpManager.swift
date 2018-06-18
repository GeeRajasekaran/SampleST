//
//  HttpManager.swift
//  VRS
//
//  Created by admin on 27/05/2017.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit
import Alamofire

class HttpManager: NSObject {

    static let sharedInstance: HttpManager = {
       let instance = HttpManager()
        
        return instance
    }()

    func callGetApi(strUrl:String, sucessBlock: @escaping (Data)->(), failureBlock:@escaping (String) ->()) {
        
        
        let dict = [String : String] ()
        
        Alamofire.request(strUrl, method: .get, parameters: dict, encoding: Alamofire.URLEncoding.default, headers: nil).responseJSON
            {(response) in
                
                let responseData = response.data
                
                if response.result.isSuccess {
                    
                    sucessBlock(responseData!)
                }
                    
                else if response.result.isFailure {
                    
                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
                }
        }
    }
    
    func callPostApi(strUrl:String, dictParameters:[String : String], sucessBlock: @escaping (Data)->(), failureBlock:@escaping (String) ->()) {
        
        var headers:HTTPHeaders? = nil
       
        // let headers = ["Content-Type" : "application/json"]
        
        Alamofire.request(strUrl, method : .post, parameters : dictParameters, encoding : JSONEncoding.default , headers : headers).responseData {
            (dataResponse) in
            
            print(dataResponse.request as Any) // your request
            print(dataResponse.response as Any) // your response
            print(dataResponse.result.value as Any) // your response
            
            if dataResponse.result.isSuccess {
                
                var jsonResponse  = [String :Any]()
                
                if let encryptedData:NSData = dataResponse.result.value! as NSData {
                    
                    print(NSString(data: (encryptedData as Data) as Data, encoding: String.Encoding.utf8.rawValue)! as String)
                    
                    do {
                        jsonResponse = try JSONSerialization.jsonObject(with: encryptedData as Data, options: .mutableContainers) as! [String : Any]
                        print(jsonResponse as NSDictionary)
                    }
                        
                    catch let error
                    {
                        print(error)
                    }
                }
                
                sucessBlock(dataResponse.data!)
                
            }
                
            else if dataResponse.result.isFailure {
                
                failureBlock(ALERT_UNABLE_TO_REACH_DESC)
            }
        }
        
    }
   

}
