//
//  ResponderViewInitializer.swift
//  June
//
//  Created by Ostap Holub on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SnapKit

class ResponderViewInitializer {
    
    // MARK: - Variables & Constants
    
    private unowned var parentViewController: ResponderViewController
    
    // MARK: - Initialization
    
    init(viewController: ResponderViewController) {
        parentViewController = viewController
    }
    
    // MARK: - Public interface
    
    func initialize() {
        parentViewController.view.backgroundColor = .white
        addAccessoryView()
    }
    
    // MARK: - Private accessory view setup
    
    private func addAccessoryView() {
        guard let meta = parentViewController.metadata else { return }
        let accessoryView = ResponderAccessoryView()
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.setupSubviews(for: meta)
        
        parentViewController.view.addSubview(accessoryView)
        accessoryView.leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor).isActive = true
        accessoryView.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor).isActive = true
        accessoryView.topAnchor.constraint(equalTo: parentViewController.view.topAnchor).isActive = true
        accessoryView.bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor).isActive = true
        
        parentViewController.responderAccessoryView = accessoryView
    }
}
