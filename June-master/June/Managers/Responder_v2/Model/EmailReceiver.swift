//
//  Person.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class EmailReceiver: Equatable {
    
    // MARK: - Variables
    
    enum Destination: String {
        case display
        case input
    }
    
    var name: String?
    var email: String?
    var profileImage: String?
    var destination: Destination
    
    // MARK: - Initialization
    
    init(name: String?, email: String?, image: String? = nil, destination: Destination) {
        self.name = name
        self.email = email
        self.profileImage = image
        self.destination = destination
    }
    
    static func == (lhs: EmailReceiver, rhs: EmailReceiver) -> Bool {
        return lhs.email == rhs.email
    }
}
