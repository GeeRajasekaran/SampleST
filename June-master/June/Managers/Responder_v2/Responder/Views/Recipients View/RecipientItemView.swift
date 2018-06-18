//
//  RecipientItemView.swift
//  June
//
//  Created by Ostap Holub on 2/22/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum RecipientItemViewType: String {
    case display
    case input
}

class RecipientItemView: UIView {
     
    // MARK: - Views

    weak var currentRecipient: EmailReceiver?
    var type: RecipientItemViewType?
    var removeAction: ((EmailReceiver) -> Void)?
    
    // MARK: - Public UI setup
    
    func setupViews(for recipient: EmailReceiver) {
        currentRecipient = recipient
        type = RecipientItemViewType(rawValue: recipient.destination.rawValue)
        backgroundColor = .white
    }
}
