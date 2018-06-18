//
//  ResponderLayoutWorker.swift
//  June
//
//  Created by Ostap Holub on 2/15/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderLayoutWorker {
    
    // MARK: - Variable & Constants
    
    private unowned var viewController: UIViewController
    private var previousRegularHeight: CGFloat = 0.0
    private weak var metadata: ResponderMetadata?
    
    // MARK: - Initialization
    
    init(controller: UIViewController, meta: ResponderMetadata?) {
        viewController = controller
        metadata = meta
    }
    
    // MARK: - Public interface
    
    func makeExpanded() {
        let originY: CGFloat = 0//UIApplication.shared.statusBarFrame.height
        let currentY = viewController.view.frame.origin.y
        let delta = currentY - originY
        
        var newFrame = viewController.view.frame
        previousRegularHeight = viewController.view.frame.height
        newFrame.origin.y = originY
        newFrame.size.height += delta
        viewController.view.frame = newFrame
        metadata?.frame = newFrame
    }
    
    func makeRegular(_ lastHeight: CGFloat? = nil) {
        if let unwrappedHeight = lastHeight {
            previousRegularHeight = unwrappedHeight + ResponderLayoutConstants.Header.height + ResponderLayoutConstants.ActionView.height + ResponderLayoutConstants.TextInput.bottomInset + ResponderLayoutConstants.TextInput.topInset
        }
        var regularHeight = previousRegularHeight == 0.0 ? ResponderLayoutConstants.Height.regularIntial : previousRegularHeight
        
        if metadata?.attachments.count != 0 && regularHeight == ResponderLayoutConstants.Height.regularIntial {
            regularHeight += ResponderLayoutConstants.Height.attachments
        }
        
        var newFrame = viewController.view.frame
        let delta = newFrame.height - regularHeight
        newFrame.origin.y += delta
        newFrame.size.height -= delta
        viewController.view.frame = newFrame
        metadata?.frame = newFrame
        previousRegularHeight = 0.0
        
        if let rvc = viewController as? IResponderViewController, let meta = metadata {
            rvc.responderAccessoryView?.updateLayout(for: meta)
        }
    }
    
    func makeMinimized() {
        previousRegularHeight = viewController.view.frame.height
        
        let newHeight = ResponderLayoutConstants.Height.minimized
        let delta = viewController.view.frame.height - newHeight
        
        var newFrame = viewController.view.frame
        newFrame.size.height = newHeight
        newFrame.origin.y += delta
        
        viewController.view.frame = newFrame
        metadata?.frame = newFrame
        
        if let rvc = viewController as? IResponderViewController, let meta = metadata {
            rvc.responderAccessoryView?.updateLayout(for: meta)
            _ = rvc.responderAccessoryView?.resignFirstResponder()
        }
    }
    
    func handleNewMessage(_ delta: CGFloat) {
        var newFrame = viewController.view.frame
        newFrame.origin.y -= delta
        newFrame.size.height += delta
        
        if newFrame.size.height < ResponderLayoutConstants.Height.regularIntial {
            let localDelta = ResponderLayoutConstants.Height.regularIntial - newFrame.height
            newFrame.size.height = ResponderLayoutConstants.Height.regularIntial
            newFrame.origin.y -= localDelta
        }
        
        viewController.view.frame = newFrame
        metadata?.frame = newFrame
        previousRegularHeight = viewController.view.frame.height
    }
    
    func handleAttachmentsAppear() {
        let delta = ResponderLayoutConstants.Height.attachments
        
        var newFrame = viewController.view.frame
        newFrame.size.height += delta
        newFrame.origin.y -= delta
        
        viewController.view.frame = newFrame
        metadata?.frame = newFrame
        previousRegularHeight = viewController.view.frame.height
        print("Attachments debug: appering the collection")
    }
    
    func handleAttachmentsDisappear() {
        let delta = ResponderLayoutConstants.Height.attachments
        
        var newFrame = viewController.view.frame
        newFrame.size.height -= delta
        newFrame.origin.y += delta
        
        viewController.view.frame = newFrame
        metadata?.frame = newFrame
        previousRegularHeight = viewController.view.frame.height
        print("Attachments debug: disappering the collection")
    }
}
