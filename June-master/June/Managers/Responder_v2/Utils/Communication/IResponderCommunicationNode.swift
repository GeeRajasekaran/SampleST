//
//  IResponderCommunicationNode.swift
//  June
//
//  Created by Ostap Holub on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderCommunicationNode {
    
    var responder: IResponder? { get set }
    
    func subscribe(for responder: IResponder)
    func unsubscribe()
}
