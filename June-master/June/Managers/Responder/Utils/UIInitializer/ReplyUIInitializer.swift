//
//  ReplyUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyUIInitializer: IInitializer {
    
    // MARK: - Variables
    
    unowned var parentViewController: ResponderViewControllerOld
    
    // MARK: - Initialization
    
    required init(parentVC: ResponderViewControllerOld) {
        parentViewController = parentVC
    }
    
    // MARK: - Public part
    
    func initialize() {
        parentViewController.view.backgroundColor = .clear
        addAccessoryView()
    }
    
    // MARK: - Accessory view
    
    private func addAccessoryView() {
        var height: CGFloat = 0
        if parentViewController.config?.isMinimizationEnabled == true {
            height = 0.144 * UIScreen.main.bounds.width
        } else {
            height = 0.336 * UIScreen.main.bounds.width
        }
    
        let frame = CGRect(x: 0, y: 0, width: parentViewController.view.frame.width, height: height)
        let accessoryView = ResponderAccessoryViewOld(frame: frame)
        accessoryView.backgroundColor = .white
        accessoryView.onExpandAction = parentViewController.onExapandAction
        accessoryView.onAttachementsAction = parentViewController.onAttachmentAction
        accessoryView.onSendAction = parentViewController.onSendAction
        accessoryView.onTextViewExpanded = parentViewController.onTextViewExpanded
        accessoryView.onOpenAttachment = parentViewController.onOpenAttachment
        accessoryView.onRemovedAttachment = parentViewController.onRemovedAttachment
        accessoryView.dataSource = parentViewController.dataSource
        accessoryView.delegate = parentViewController.delegate
        
        if let config = parentViewController.config, let unwrappedResponder = parentViewController.responder {
            accessoryView.setupSubviews(for: config, using: unwrappedResponder)
        }
        
        parentViewController.view.addSubview(accessoryView)
        parentViewController.accessoryView = accessoryView
    }
}

