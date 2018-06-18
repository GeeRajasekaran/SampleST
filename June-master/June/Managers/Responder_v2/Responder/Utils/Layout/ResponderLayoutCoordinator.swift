//
//  ResponderLayoutCoordinator.swift
//  June
//
//  Created by Ostap Holub on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderLayoutCoordinator: NSObject, IResponderLayoutCoordinator {
    
    // MARK: - Variables & Cosntants
    private var observingContext: String = "ResponderLayoutCoordinatorObservingContext"
    weak var responder: IResponder?
    private var uiWorker: ResponderLayoutWorker
    
    // MARK: - Initialization
    
    required init(responder: IResponder?) {
        self.responder = responder
        uiWorker = ResponderLayoutWorker(controller: (responder?.responderViewController)!, meta: responder?.metadata)
        super.init()
    }
    
    // MARK: - Subscribe logic
    
    func subscribe() {
        self.responder?.metadata.addObserver(self, forKeyPath: #keyPath(ResponderMetadata.rawState), options: .new, context: &observingContext)
        self.responder?.metadata.addObserver(self, forKeyPath: #keyPath(ResponderMetadata.message), options: .new, context: &observingContext)
        self.responder?.metadata.addObserver(self, forKeyPath: #keyPath(ResponderMetadata.attachmentsCount), options: .new, context: &observingContext)
    }
    
    func unsubscribe() {
        self.responder?.metadata.removeObserver(self, forKeyPath: #keyPath(ResponderMetadata.rawState), context: &observingContext)
        self.responder?.metadata.removeObserver(self, forKeyPath: #keyPath(ResponderMetadata.message), context: &observingContext)
        self.responder?.metadata.removeObserver(self, forKeyPath: #keyPath(ResponderMetadata.attachmentsCount), context: &observingContext)
    }
    
    // MARK: - Private processing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observingContext else { return }
        guard let unwrappedKeyPath = keyPath else { return }
        
        switch unwrappedKeyPath {
        case #keyPath(ResponderMetadata.rawState):
            if let rawState = change?[.newKey] as? String {
                handleStateChanges(rawState)
            }
        case #keyPath(ResponderMetadata.message):
            if let delta = responder?.metadata.heightDelta {
                handleMessageChanges(delta)
            }
        case #keyPath(ResponderMetadata.attachmentsCount):
            handleAttachmentCountChanges()
        default:
            print("Some other keypath changed, this should not happen")
        }
    }
    
    private func handleStateChanges(_ rawState: String) {
        guard let currentState = ResponderState(rawValue: rawState) else { return }
        switch currentState {
            case .expanded: uiWorker.makeExpanded()
            case .regular: uiWorker.makeRegular(responder?.metadata.lastContentHeight)
            case .minimized: uiWorker.makeMinimized()
        }
    }
    
    private func handleMessageChanges(_ heightDelta: CGFloat) {
        if responder?.metadata.state == .regular {
            uiWorker.handleNewMessage(heightDelta)
        }
    }
    
    private func handleAttachmentCountChanges() {
        guard let unwrappedMetadata = responder?.metadata else { return }
        let currentCount = unwrappedMetadata.attachmentsCount
        let previousCount = unwrappedMetadata.previousAttachmentsCount
        
        if previousCount == 0 && currentCount != 0 && unwrappedMetadata.state != .minimized {
            uiWorker.handleAttachmentsAppear()
        } else if previousCount != 0 && currentCount == 0 && unwrappedMetadata.state != .minimized {
            uiWorker.handleAttachmentsDisappear()
        }
        responder?.responderViewController.responderAccessoryView?.updateLayout(for: unwrappedMetadata)
    }
}
