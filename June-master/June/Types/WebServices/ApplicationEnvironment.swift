//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 12/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

enum ApplicationEnvironment : String {
    case mockLocal = "http://localhost:7878/"
    case mock = "https://a91e4d69.ngrok.io/"
    case development = "https://peregrine.hellolucy.io/"
    //TBD
    case QA = "https://peregrine.hellolucy.io/qa"
    //TBD
    case production = "https://peregrine.hellolucy.io/prod"
    
    static func allEnvironments() -> [ApplicationEnvironment] {
        return [mockLocal, mock, development, QA, production]
    }
    
    var description : String {
        switch(self) {
        case .mockLocal:
            return "Mock Local"
            
        case .mock:
            return "Mock"
            
        case .development:
            return "Development"
            
        case .QA:
            return "QA"
            
        case .production:
            return "Production"
        }
    }
    
    var savedMessage : String {
        return "Application Environment Saved: " + description
    }
}

enum EndPointVerion: String {
    case v1 = "v1/"
}

