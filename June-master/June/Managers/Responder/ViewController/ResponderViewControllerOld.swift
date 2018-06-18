//
//  ResponderViewControllerOld.swift
//  June
//
//  Created by Ostap Holub on 9/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class ResponderViewControllerOld: UIViewController {
 
    // MARK: - Views
    
    var accessoryView: ResponderAccessoryViewOld?
    var headerView: UIView?
    
    // MARK: - Variables
    
    private var responderAPIEngine = ResponderAPIEngine()
    weak var responder: ResponderOld?
    weak var config: ResponderConfig?
    var searchEngine = SearchEngine()
    var onExapandAction: (() -> Void)?
    var onTextViewExpanded: ((CGFloat) -> Void)?
    
    lazy fileprivate var uiInitializer: IInitializer? = {
        guard let unwrappedGoal = self.config?.goal else { return nil }
        let initializer = UIInitializerFactory.initializer(for: unwrappedGoal, with: self)
        return initializer
    }()
    
    lazy var keyboardManager: IResponderKeyboardManager? = {
        guard let unwrappedGoal = self.config?.goal else { return nil }
        let manager = KeyboardManagerFactory.manager(for: unwrappedGoal, with: self)
        return manager
    }()
    
    lazy fileprivate var dataRepository: EmailReceiversDataRepository? = {
        guard let unwrappedConfig = self.config else { return nil }
        let repository = EmailReceiversDataRepository(with: unwrappedConfig)
        return repository
    }()
    
    lazy var dataSource: EmailReceiverDataSource = {
        let source = EmailReceiverDataSource(storage: self.dataRepository)
        source.onRemoveReceiver = self.onRemoveReceiverAction
        source.onReturnAction = self.onReturnAction
        source.goal = config?.goal
        return source
    }()
    
    lazy var delegate: EmailReceiverDelegate = {
        let delegate = EmailReceiverDelegate(storage: self.dataRepository)
        return delegate
    }()
    
    lazy fileprivate var actionSheetHadler: AttachmentsSheetHandler = {
        let handler = AttachmentsSheetHandler(with: (responder?.rootViewController)!, andCallback: self)
        return handler
    }()
    
    lazy private var attachmentHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: (responder?.rootViewController)!)
        return handler
        }()
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer?.initialize()
        dataRepository?.loadData()
        if config?.isMinimizationEnabled == false {
            accessoryView?.setFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager?.subscribeForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager?.unsubscribeForKeyboardNotifications()
    }
    
    // MARK: - Data Update logic
    
    func updateReceivers() {
        dataRepository?.clear()
        dataRepository?.loadData()
        accessoryView?.reloadReveivers()
    }
    
    // MARK: - Attachments actions
    
    lazy var onOpenAttachment: (Attachment) -> Void = { [weak self] attachment in
        self?.attachmentHandler.present(attachment)
    }
    
    lazy var onRemovedAttachment: () -> Void = { [weak self] in
        self?.removeAttachments()
    }
    
    lazy var onAttachmentAction: () -> Void = {
        self.responder?.shouldMinimize = false
        self.actionSheetHadler.show()
        self.responder?.shouldMinimize = true
    }
    
    func removeAttachments() {
       accessoryView?.removeAttachmentView()
    }
    
    func addAttachments(attachments: [Attachment]) {
        accessoryView?.add(attachments)
    }
    
    lazy var onSendAction: () -> Void = { [weak self] in

        if let unwrappedMessage = self?.config?.message,
            let unwrappedText = self?.accessoryView?.bodyText,
            let unwrappedCompletion = self?.onSendCompletedAction,
            let unwrappedReceivers = self?.dataRepository?.receivers {
            self?.accessoryView?.disableSendButton()
            var attachments: [Attachment] = []
            if let unwrappedAttachments = self?.accessoryView?.getAttachments() {
                attachments = unwrappedAttachments
            }
            print(unwrappedMessage as Any)
            print(unwrappedText as Any)
            //API call should be inside responderVC -> otherwise it won't working on different pages
            if InternetReachability.isConnectedToNetwork() {
                self?.responderAPIEngine.respond(to: unwrappedMessage, with: unwrappedText, to: unwrappedReceivers, with: attachments, completion: unwrappedCompletion)
            }
            
            
            self?.responder?.onSendButtonPressed?( unwrappedMessage, unwrappedText, unwrappedReceivers, attachments)

        }
    }
    
    lazy var onSendCompletedAction: (Result<[String: AnyObject]>) -> Void = { [weak self] result in
        switch result {
        case .Success (let data):
            self?.responder?.onSuccessResponse?(data, (self?.responder?.getMessageBody())!)
            self?.responder?.setBody(with: "")
            self?.accessoryView?.updatePlaceholderLabel(with: nil)
            self?.accessoryView?.attachmentsView?.clear()
            self?.removeAttachments()
        case .Error(let error):
            print(error as Any)
            self?.responder?.onErrorResponse?(error)
            self?.responder?.setBody(with: "")
            self?.accessoryView?.updatePlaceholderLabel(with: nil)
            self?.accessoryView?.attachmentsView?.clear()
            self?.removeAttachments()
            AlertBar.show(.error, message: error)
        }
    }
    
    // MARK: - Receiver remove button action
    
    lazy var onRemoveReceiverAction: (Int) -> Void = { [weak self] index in
        self?.dataRepository?.receivers.remove(at: index)
        let indexPath = IndexPath(item: index, section: 0)
        self?.accessoryView?.removeReceiver(at: indexPath)
    }
    
    func append(_ receiver: EmailReceiver) {
        if dataRepository?.contains(receiver) == true { return }
        dataRepository?.append(receiver)
        if let index = dataRepository?.index(of: receiver) {
            let indexPath = IndexPath(item: index, section: 0)
            self.accessoryView?.insertReceiver(at: indexPath)
        }
    }
    
    lazy var onReturnAction: (String) -> Void = { [weak self] text in
        guard let sSelf = self else { return }
        if !text.isValidEmail() { return }
        self?.responder?.hideSuggestions()
        let receiver = EmailReceiver(name: "", email: text, destination: .display)
        if self?.dataRepository?.contains(receiver) == true { return }
        self?.dataRepository?.append(receiver)
        if let index = self?.dataRepository?.index(of: receiver) {
            let indexPath = IndexPath(item: index, section: 0)
            self?.accessoryView?.insertReceiver(at: indexPath)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ResponderOld.SearchNotificationName.clearText), object: nil)
    }
}

extension ResponderViewControllerOld: AttachmentsSheetHandlerDelegate {
    
    func handler(_ handler: AttachmentsSheetHandler, didFailWith error: String) {
        
    }
    
    func handler(_ handler: AttachmentsSheetHandler, dismissWith attachment: Attachment) {
        if attachment.filename != "" {
            accessoryView?.append(attachment)
        }
        responder?.changeSizeWithAttachments()
        accessoryView?.setFirstResponder()
    }
    
    func handler(_ handler: AttachmentsSheetHandler, didPressCancel cancelButton: UIButton?) {
        responder?.setPreviousState()
        accessoryView?.setFirstResponder()
    }
    
    func handler(_ handler: AttachmentsSheetHandler, startUploadingImage isUploading: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.responder?.setPreviousState()
            self.accessoryView?.setFirstResponder()
        }
    }
}

