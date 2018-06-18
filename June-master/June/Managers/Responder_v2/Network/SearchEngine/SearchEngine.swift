//
//  SearchEngine.swift
//  June
//
//  Created by Ostap Holub on 9/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import Alamofire
import SwiftyJSON

class SearchEngine {
    
    private var skip: Int = 0
    var previousQuery = ""
    private var threadsProxy = ThreadsProxy()
    private var parser = ThreadsParser()
    
    func search(by text: String, completion: @escaping ([EmailReceiver], Bool) -> Void) {
        guard let token = FeathersManager.Providers.feathersApp.authenticationStorage.accessToken else { return }
        
        let headers = ["Authorization":"Bearer " + token]
        var urlParams = ["$search": text]
        
        if text == previousQuery {
            urlParams["$skip"] = String(skip)
        } else {
            skip = 0
        }
        
        Alamofire.request("https://peregrine.hellolucy.io/escontacts", method: .get, parameters: urlParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            
            if let jsonData = response.data {
                do {
                    let json = try JSON(data: jsonData)
                    if let contacts = json["data"].array {
                        self.skip += contacts.count
                        var receivers = [EmailReceiver]()
                        contacts.forEach({ contact in
                            let receiverName = contact["name"].string
                            let receiverEmail = contact["email"].string
                            let receiverImage = contact["profile_pic"].string
                            
                            let receiver = EmailReceiver(name: receiverName, email: receiverEmail, image: receiverImage, destination: .display)
                            receivers.append(receiver)
                        })
                        if text == self.previousQuery {
                            completion(receivers, true)
                        } else {
                            self.previousQuery = text
                            completion(receivers, false)
                        }
                    }
                }
                catch let error as NSError {
                    print("Load json failed: \(error.localizedDescription)")
                }
                
            }
        })
    }
    
    func searchContacts(by text: String, completion: @escaping ([ContactReceiver], Bool) -> Void) {
        guard let token = FeathersManager.Providers.feathersApp.authenticationStorage.accessToken else { return }
        
        let headers = ["Authorization":"Bearer " + token]
        //TODO: - remove parameters $skip and $limit after search will work
        var urlParams = ["$search": text, "$select[0]": "id", "$select[1]": "name", "$select[2]" : "email", "$limit" : "25"]
        
        if text == previousQuery {
            urlParams["$skip"] = String(skip)
        } else {
            skip = 0
        }
        
        Alamofire.request("https://peregrine.hellolucy.io/escontacts", method: .get, parameters: urlParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            
            if let jsonData = response.data {
                do {
                    let json = try JSON(data: jsonData)
                    if let contacts = json["data"].array {
                        self.skip += contacts.count
                        var receivers = [ContactReceiver]()
                        contacts.forEach({ contact in
                            let receiver = ContactReceiver(with: contact)
                            receivers.append(receiver)
                        })
                        if text == self.previousQuery {
                            completion(receivers, true)
                        } else {
                            self.previousQuery = text
                            completion(receivers, false)
                        }
                    }
                }
                catch let error as NSError {
                    print("Load json failed: \(error.localizedDescription)")
                }
                
            }
        })
    }
    
    func searchThreads(by text: String, completion: @escaping ([ThreadsReceiver], Bool) -> Void) {
        guard let token = FeathersManager.Providers.feathersApp.authenticationStorage.accessToken else { return }
        
        let headers = ["Authorization":"Bearer " + token]
        var urlParams = ["$search": text]
        
        if text == previousQuery {
            urlParams["$skip"] = String(skip)
        } else {
            skip = 0
        }
        
        Alamofire.request("https://peregrine.hellolucy.io/threads", method: .get, parameters: urlParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            
            if let jsonData = response.data {
                do {
                    let json = try JSON(data: jsonData)
                    if let threads = json["data"].array {
                        self.skip += threads.count
                        self.saveThreads(threads)
            
                        var receivers = [ThreadsReceiver]()
                        threads.forEach({ thread in
                            let receiver = ThreadsReceiver(with: thread)
                            receivers.append(receiver)
                        })
                        if text == self.previousQuery {
                            completion(receivers, true)
                        } else {
                            self.previousQuery = text
                            completion(receivers, false)
                        }
                    } else {
                        let message = json["message"].stringValue
                        print("Search failed: \(message)")
                    }
                }
                catch let error as NSError {
                    print("Load json failed: \(error.localizedDescription)")
                }
            }
        })
    }
    
    // MARK: - Process section
    
    private func saveThreads(_ threadsJson: [JSON]) {
        threadsJson.forEach({ element -> Void in
            saveThread(element)
        })
    }
    
    private func saveThread(_ threadJson: JSON) {
        guard let threadId = threadJson["id"].string else { return }
        if let threadEntity = threadsProxy.fetchThread(by: threadId) {
            parser.loadData(from: threadJson, to: threadEntity)
        } else {
            let thread = threadsProxy.addNewEmptyThread()
            parser.loadData(from: threadJson, to: thread)
        }
        threadsProxy.saveContext()
    }
}
