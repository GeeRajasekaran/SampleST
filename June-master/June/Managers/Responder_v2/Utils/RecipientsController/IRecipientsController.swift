//
//  IRecipientsController.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IRecipientsController {
    
    var metadata: ResponderMetadata? { get set }
    
    var dataSource: IResponderRecipientsDataSource { get set }
    var delegate: IResponderRecipientsDelegate { get set }
    var dataRepository: IResponderRecipientsDataRepository { get set }
    
    init(metadata: ResponderMetadata?, onRemove: ((EmailReceiver) -> Void)?)
}
