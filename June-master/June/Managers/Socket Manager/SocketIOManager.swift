//
//  SocketIOManager.swift
//  June
//
//  Created by Joshua Cleetus on 10/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SocketIO
import Feathers
import FeathersSwiftSocketIO
import KeychainSwift
import AlertBar

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

    let socket = FeathersManager.Providers.socket.defaultSocket

    private override init() {
//        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.off(clientEvent: .connect)
        socket.off(clientEvent: .error)
        socket.off(clientEvent: .disconnect)
        socket.off(clientEvent: .reconnect)
        socket.disconnect()
    }
    
    func refreshJWTToken() -> Void {
        guard let token = KeychainSwift().get(JuneConstants.Feathers.jwtToken) else {
            print("no jwt token found")
            let settingsVC = SettingsViewController()
            settingsVC.logOutUser()
            return
        }
        print(token)
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": "jwt",
            "accessToken": token
            ])
            .on(value: { response in
                print(response)
                
            })
            .startWithFailed { (error) in
                if error.error.localizedDescription.isEqualToString(find: "The operation couldn’t be completed. (Feathers.FeathersNetworkError error 2.)") {
                    AlertBar.show(.error, message: "The operation couldn’t be completed. Network is down")
                    let settingsVC = SettingsViewController()
                    settingsVC.logOutUser()
                }
        }

    }
    
    public func listenToClientEvents() -> Void {

        self.socket.on(clientEvent: .connect) { (dataArray, socketAck) in
            self.refreshJWTToken()
            //show alert if need
            //AlertBar.show(.notice, message: "Connected!")
            AlertBar.hide()
        }
        
        self.socket.on(clientEvent: .disconnect) { (dataArray, socketAck) in
            //show alert if need
            //AlertBar.show(.error, message: "Disconnected...")
        }
        
        self.socket.on(clientEvent: .reconnect) { (dataArray, socketAck) in
            //show alert if need
            //AlertBar.show(.warning, message: "Reconnecting...")
        }
        
        self.socket.on(clientEvent: .error) { (dataArray, socketAck) in
//            AlertBar.showNotHide(.error, message: "The operation couldn’t be completed. Network is down")
        }
    }

}
