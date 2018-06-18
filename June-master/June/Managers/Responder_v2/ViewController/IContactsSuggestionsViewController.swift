//
//  IContactsSuggestionsViewController.swift
//  June
//
//  Created by Ostap Holub on 2/21/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IContactsSuggestionsViewController: class {
    
    var searchEngine: SearchEngine { get set }
    var metadata: ResponderMetadata? { get set }
    func search(by query: String)
    func clear()
}
