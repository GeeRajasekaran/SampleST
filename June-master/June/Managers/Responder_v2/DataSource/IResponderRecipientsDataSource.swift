//
//  IResponderRecipientsDataSource.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderRecipientsDataSource: class, UICollectionViewDataSource {
    
    var dataRepository: IResponderRecipientsDataRepository { get set }
    init(storage: IResponderRecipientsDataRepository, onRemove: ((EmailReceiver) -> Void)?)
    
    var onRemoveAction: ((EmailReceiver) -> Void)? { get set }
}
