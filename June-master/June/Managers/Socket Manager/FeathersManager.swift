//
//  FeathersManager.swift
//  June
//
//  Created by Joshua Cleetus on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Feathers
import FeathersSwiftSocketIO
import SocketIO

struct FeathersManager {
    
    struct Providers {
        static let socket = SocketManager(socketURL: URL.init(string: JuneConstants.Feathers.baseURL)!, config: [.reconnects(true), .forceWebsockets(true), .compress, .log(false)])
        static let feathersApp = Feathers(provider: SocketProvider(manager: socket, timeout: 15))
    }
    
    struct Services {
        static let beforeHooks = Service.Hooks(all: [RequestLoggerHook()])
        static let errorHooks = Service.Hooks(all: [RequestLoggerHook()])
        static let users = Providers.feathersApp.service(path: "users")
        static let threads = Providers.feathersApp.service(path: "threads")
        static let rolodexs = Providers.feathersApp.service(path: "rolodexs")
        static let favorites = Providers.feathersApp.service(path: "favorites")
        static let accounts = Providers.feathersApp.service(path: "accounts")
        static let uploadImage = Providers.feathersApp.service(path: "upload/profile-image")
        static let categories = Providers.feathersApp.service(path: "categories")
        static let message = Providers.feathersApp.service(path: "messages")
        static let contacts = Providers.feathersApp.service(path: "contacts")
        static let elasticSearchContacts = Providers.feathersApp.service(path: "escontacts")
        static let suggestions = Providers.feathersApp.service(path: "suggestions")
        static let tokens = Providers.feathersApp.service(path: "tokens")
        static let download = Providers.feathersApp.service(path: "download")
        static let share = Providers.feathersApp.service(path: "share")
        static let template = Providers.feathersApp.service(path: "templates")
        static let spools = Providers.feathersApp.service(path: "spools")
    }

}
