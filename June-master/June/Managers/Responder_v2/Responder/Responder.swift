//
//  Responder.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class Responder: IResponder {
    
    // MARK: - Initialization
    
    required init(rootVC: UIViewController, config: ResponderConfig) {
        self.rootViewController = rootVC
        self.metadata = ResponderMetadata(config: config)
        keyboardController = ResponderKeyboardController()
        responderViewController = ResponderViewController()
        responderViewController.metadata = self.metadata
        navigationCoordinator = ResponderNavigationCoordinator()
    }
    
    // MARK: - Variables & Constants
    
    private var isShown: Bool = false
    
    var rootViewController: UIViewController
    var metadata: ResponderMetadata
    var actionsListener: IResponderActionsListener?
    var keyboardController: IKeyboardController
    var responderViewController: UIViewController & IResponderViewController
    var navigationCoordinator: IResponderNavigationCoordinator
    
    var apiEngine: ResponderAPIEngine?
    
    lazy var suggestionsViewController: IContactsSuggestionsViewController & UIViewController = {
        let controller = ReceiversSuggestionViewController()
        return controller
    }()
    
    var layoutCoordinator: IResponderLayoutCoordinator?
    
    var communicator: IResponderCommunicationNode? 
    
    lazy var attachmentsActionSheetHandler: AttachmentsSheetHandler = { [unowned self] in
        let handler = AttachmentsSheetHandler(with: self.rootViewController, andCallback: self)
        return handler
    }()
    
    lazy var attachmentsHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: self.rootViewController)
        return handler
    }()
    
    // MARK: - Send button availability
    
    func enableSendButton() {
        responderViewController.responderAccessoryView?.enableSendButton()
    }
    
    func disableSendButton() {
        responderViewController.responderAccessoryView?.disableSendButton()
    }
    
    // MARK: - Presentation logic
    
    func update(with config: ResponderConfig) {
        metadata.update(config)
        responderViewController.responderAccessoryView?.becomeFirstResponderIfNeeded()
    }
    
    func show() {
        guard isShown == false else { return }
        keyboardController.subscribe(self)
        communicator = ResponderCommunicationNode()
        communicator?.subscribe(for: self)
        
        layoutCoordinator = ResponderLayoutCoordinator(responder: self)
        layoutCoordinator?.subscribe()
        
        apiEngine = ResponderAPIEngine()
        
        var height: CGFloat = 0.0
        if metadata.state == .regular || metadata.state == .expanded {
            if metadata.frame.height == 0.0 {
                height = ResponderLayoutConstants.height(for: metadata.state)
            } else {
                height = metadata.frame.height
            }
        } else {
            height = ResponderLayoutConstants.height(for: metadata.state)
        }
        
        if metadata.attachments.count != 0 && metadata.state == .regular {
            height += ResponderLayoutConstants.Height.attachments
        }
        
        let bottomInset: CGFloat = bottomSafeAreaInset()
        let screenHeight = rootViewController.view.frame.height
        let frame = CGRect(x: 0, y: screenHeight - height - bottomInset, width: rootViewController.view.frame.width, height: height)
        responderViewController.view.frame = frame
        metadata.frame = frame
        rootViewController.view.addSubview(responderViewController.view)
        isShown = true
    }
    
    func hide() {
        guard isShown == true else { return }
        keyboardController.unsubscribe()
        
        communicator?.unsubscribe()
        communicator = nil
        
        layoutCoordinator?.unsubscribe()
        layoutCoordinator = nil
        
        apiEngine = nil
        
        responderViewController.view.removeFromSuperview()
        actionsListener?.onHideAction(metadata, shouldSaveDraft: true)
        isShown = false
    }
    
    // MARK: - Recipients managament logic
    
    func addRecipient(_ recipient: EmailReceiver) {
        responderViewController.responderAccessoryView?.addRecipient(recipient)
    }
    
    func removeRecipient(_ recipient: EmailReceiver) {
        if let index = metadata.recipients.index(of: recipient) {
            metadata.recipients.remove(at: index)
        }
    }
    
    // MARK: - Attachments managament logic
    
    func addAttachment(_ attachment: Attachment) {
        metadata.attachments.append(attachment)
    }
    
    func removeAttachment(_ attachmetn: Attachment) {
        if let index = metadata.attachments.index(of: attachmetn) {
            metadata.attachments.remove(at: index)
        }
    }
    
    // MARK: - Layout insets calculations
    
    private func bottomSafeAreaInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom ?? 0
                }
            }
        }
        return 0.0
    }
}

    // MARK: - Keyboard events handling

extension Responder: KeyboardControllerDelegate {
    func controller(_ controller: IKeyboardController, willShowKeyboardWith height: CGFloat) {
        let finalHeight: CGFloat = height - bottomSafeAreaInset()
        responderViewController.moveUp(finalHeight)
        metadata.frame = responderViewController.view.frame
    }
    
    func controller(_ controller: IKeyboardController, willHideKeyboardWith height: CGFloat) {
        let finalHeight: CGFloat = height - bottomSafeAreaInset()
        responderViewController.moveDown(finalHeight)
        metadata.frame = responderViewController.view.frame
    }
    
    func controller(_ controller: IKeyboardController, willIncreaseHeight delta: CGFloat) {
        if metadata.state != .expanded {
            responderViewController.moveUp(delta)
        } else {
            responderViewController.view.frame.size.height -= delta
        }
        metadata.frame = responderViewController.view.frame
    }
    
    func controller(_ controller: IKeyboardController, willDecreaseHeight delta: CGFloat) {
        if metadata.state != .expanded {
            responderViewController.moveDown(delta)
        } else {
            responderViewController.view.frame.size.height += delta
        }
        metadata.frame = responderViewController.view.frame
    }
}

    // MARK: - Attachments action sheet delegate

extension Responder: AttachmentsSheetHandlerDelegate {
    
    private func moveResponderToPreviousState() {
        responderViewController.view.isHidden = false
        if metadata.state == .regular {
            responderViewController.responderAccessoryView?.becomeFirstResponderIfNeeded()
        }
    }
    
    func handler(_ handler: AttachmentsSheetHandler, didFailWith error: String) {
        moveResponderToPreviousState()
        let alert = UIAlertController(title: LocalizedStringKey.ResponderHelper.UploadingErrorTitle, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizedStringKey.ResponderHelper.OkButtonTitle, style: .cancel, handler: nil)
        alert.addAction(okAction)
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    func handler(_ handler: AttachmentsSheetHandler, dismissWith attachment: Attachment) {
        moveResponderToPreviousState()
        addAttachment(attachment)
        if metadata.isSendButtonEnabled {
            responderViewController.responderAccessoryView?.enableSendButton()
        }
    }
    
    func handler(_ handler: AttachmentsSheetHandler, didPressCancel cancelButton: UIButton?) {
        moveResponderToPreviousState()
        if metadata.isSendButtonEnabled {
            responderViewController.responderAccessoryView?.enableSendButton()
        }
    }
    
    func handler(_ handler: AttachmentsSheetHandler, startUploadingImage isUploading: Bool) {
        moveResponderToPreviousState()
        responderViewController.responderAccessoryView?.disableSendButton()
    }
}
