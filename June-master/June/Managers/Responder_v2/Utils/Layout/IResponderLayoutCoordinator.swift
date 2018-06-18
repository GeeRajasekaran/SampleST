//
//  IResponderLayoutCoordinator.swift
//  June
//
//  Created by Ostap Holub on 2/13/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderLayoutCoordinator {
    
    var responder: IResponder? { get set }
    
    init(responder: IResponder?)
    func subscribe()
    func unsubscribe()
}
