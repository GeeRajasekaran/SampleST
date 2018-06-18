//
//  IResponderNavigationCoordinator.swift
//  June
//
//  Created by Ostap Holub on 2/21/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderNavigationCoordinator {
    
    func show(suggestions: IContactsSuggestionsViewController & UIViewController, for metadata: ResponderMetadata, at rootVC: UIViewController)
    func hideSuggestions()
}
