//
//  ResponderRecipientsController.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderRecipientsController: IRecipientsController {
    
    weak var metadata: ResponderMetadata?
    var dataSource: IResponderRecipientsDataSource
    var delegate: IResponderRecipientsDelegate
    var dataRepository: IResponderRecipientsDataRepository
    
    required init(metadata: ResponderMetadata?, onRemove: ((EmailReceiver) -> Void)?) {
        self.metadata = metadata
        dataRepository = ResponderRecipientsDataRepository(metadata: metadata)
        dataSource = ResponderRecipientsDataSource(storage: dataRepository, onRemove: onRemove)
        delegate = ResponderRecipientsDelegate(storage: dataRepository)
    }
}
