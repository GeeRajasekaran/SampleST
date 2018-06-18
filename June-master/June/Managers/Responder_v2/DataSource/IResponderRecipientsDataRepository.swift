//
//  IResponderRecipientsDataRepository.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderRecipientsDataRepository: class {
    
    var recipients: [EmailReceiver] { get set }
    var metadata: ResponderMetadata? { get set }
    
    init(metadata: ResponderMetadata?)
    
    func count() -> Int
    func recipient(at index: Int) -> EmailReceiver?
    func append(_ recipient: EmailReceiver)
    func contains(_ recipient: EmailReceiver) -> Bool
    func index(of recipient: EmailReceiver) -> Int?
    func remove(at index: Int)
    func containsEmail(_ email: String) -> Bool
    func clear()
}
