//
//  ScreenBuilderFactory.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ScreenBuilderAbstractFactory {
    func loadTableModelBuilder(_ screenType: TableScreenType, model: Any?) -> ScreenTableModelBuilder
}

class ScreenBuilderFactory: ScreenBuilderAbstractFactory {

    static let sharedInstance: ScreenBuilderFactory = {
        let instance = ScreenBuilderFactory()
        return instance
    }()

    func loadTableModelBuilder(_ screenType: TableScreenType, model: Any?) -> ScreenTableModelBuilder {
        switch screenType {
        case .convos:
            return ConvosScreenBuilder(model: model)
            
        case .rolodexs:
            return RolodexsScreenBuilder(model: model)
            
        default:
            return ConvosScreenBuilder(model: model)
        }
    }
    
}
