//
//  IResponder.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

/// Nested responder goal enum
enum ResponderGoal {
    case reply
    case replyAll
}

/// Neseted resonder controller state enum

enum ResponderState: String {
    case expanded
    case regular
    case minimized
}

protocol IResponder: class {
    
    /// Constructor that should be used for concrete responder object building
    ///
    /// - Parameters:
    ///   - rootVC: UIViewController where Responder will be shown on
    ///   - config: Instance of ResponderConfig class, that contains all configurations
    init(rootVC: UIViewController, config: ResponderConfig)
    
    /// Root view controller of Responder
    var rootViewController: UIViewController { get }
    
    /// Current Responder metadata
    var metadata: ResponderMetadata { get }
    
    /// Class responsible for receiving action notifications
    var communicator: IResponderCommunicationNode? { get }
    
    /// Listener that will call appropriate methods in cases where environment
    /// should know what just was did inside the Responder
    var actionsListener: IResponderActionsListener? { get set }
    
    /// Controller that is resposible for managing keyboard events
    var keyboardController: IKeyboardController { get }
    
    /// View controller that will manage Responder view
    var responderViewController: IResponderViewController & UIViewController { get set }
    
    /// Coordinator that is resposinble for layout chages in Responder
    var layoutCoordinator: IResponderLayoutCoordinator? { get set }
    
    /// Coordinator responsible for presenting helper controllers
    var navigationCoordinator: IResponderNavigationCoordinator { get set }
    
    /// Controller responsible for searching contacts by some query and presenting it
    var suggestionsViewController: IContactsSuggestionsViewController & UIViewController { get set }
    
    /// Engine responsible for sending network calls to send message
    var apiEngine: ResponderAPIEngine? { get set }
    
    /// Handler responsible for showing the action sheet with options
    var attachmentsActionSheetHandler: AttachmentsSheetHandler { get set }
    
    /// Handler to organize attachments preview
    var attachmentsHandler: AttachmentHandler { get set }
    
    /// Method to update existing responder with config
    ///
    /// - Parameter config: data to update
    func update(with config: ResponderConfig)
    
    /// Shows Responder on rootViewController
    func show()
    
    /// Removes Responder from rootViewController
    func hide()
    
    /// Enable send button
    func enableSendButton()
    
    /// Disable send button
    func disableSendButton()
    
    /// Adds email recipient to Responder
    ///
    /// - Parameter recipient: recipient that will be added
    func addRecipient(_ recipient: EmailReceiver)
    
    /// Removes email recipient from Responder
    ///
    /// - Parameter recipient: recipient that will be removed
    func removeRecipient(_ recipient: EmailReceiver)
    
    /// Adds attachment to Responder
    ///
    /// - Parameter attachment: attachment that will be added
    func addAttachment(_ attachment: Attachment)
    
    /// Removes attachment from Responder
    ///
    /// - Parameter attachmetn: attachment that will be removed
    func removeAttachment(_ attachmetn: Attachment)
}
