//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 10/24/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import KeychainSwift
import SocketIO
import FeathersSwiftSocketIO

class FeathersErrorFix: NSObject {
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL.init(string: JuneConstants.Feathers.baseURL)!, config:[])
    
    func RefreshJWTToken() -> Void {
        let token = KeychainSwift().get(JuneConstants.Feathers.jwtToken)!
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": "jwt",
            "accessToken": token
            ])
            .on(value: { response in
                print(response)
                
            })
            .startWithFailed { (error) in
                print(error)
        }
    }
    
    public func listenToReconnectDisconnect() -> Void {
        
        FeathersManager.Providers.socket.on(clientEvent: .connect) { (dataArray, socketAck) in
            self.RefreshJWTToken()
        }

        FeathersManager.Providers.socket.on(clientEvent: .disconnect) { (dataArray, socketAck) in
//            print("Josh Socket IO Testing .disconnect", dataArray)
//            print("Josh Socket IO Testing .disconnect", socketAck)
        }

        FeathersManager.Providers.socket.on(clientEvent: .reconnect) { (dataArray, socketAck) in
//            print("Josh Socket IO Testing .reconnect", dataArray)
//            print("Josh Socket IO Testing .reconnect", socketAck)
        }

        FeathersManager.Providers.socket.on(clientEvent: .error) { (dataArray, socketAck) in
//            print("Josh Socket IO Testing .error", dataArray)
//            print("Josh Socket IO Testing .error", socketAck)
//            print("Error! Cannot establish Connection.")
        }

    }
    
}
