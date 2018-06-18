//
//  IResponderRecipientsDelegate.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderRecipientsDelegate: class, UICollectionViewDelegate {
    
    var dataRepository: IResponderRecipientsDataRepository { get set }
    init(storage: IResponderRecipientsDataRepository)
    
}
