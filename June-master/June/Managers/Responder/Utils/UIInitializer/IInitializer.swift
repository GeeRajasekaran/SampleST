//
//  IInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IInitializer {
    
    var parentViewController: ResponderViewControllerOld { get set }
    
    init(parentVC: ResponderViewControllerOld)
    func initialize()
}
