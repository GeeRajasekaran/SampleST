//
//  ComposeViewController.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class ComposeViewController: BaseMailDetailsViewController {
    
    // MARK: - Varibales & Constants
    private var composer = Composer()
    private var pendingWorkItem: DispatchWorkItem?
    
    lazy private var uiInitializer: ComposeUIInitializer = { [unowned self] in
        let initializer = ComposeUIInitializer(parentVC: self)
        return initializer
    }()
    
    lazy private var keyboardManager: ComposeKeyboardManager = { [unowned self] in
        let manager = ComposeKeyboardManager(callbackResponder: self, rootVC: self)
        return manager
    }()
    
    lazy fileprivate var actionSheetHadler: AttachmentsSheetHandler = { [unowned self] in
        let handler = AttachmentsSheetHandler(with: self, andCallback: self)
        return handler
    }()
    
    lazy private var attachmentHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: self)
        return handler
    }()
    
    var notificationPresenter: NotificationViewPresenter?
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.subscribeForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.unsubscribeForKeyboardNotifications()
    }
    
    func checkSendButtonAvailability() {
        guard let textView = textInputView else { return }
        textViewDidChange(textView)
    }
    
    func discardScheduledMessageSending() {
        pendingWorkItem?.cancel()
        pendingWorkItem = nil
    }
    
    func triggerScheduledMessageSending() {
        pendingWorkItem?.perform()
    }
    
    // MARK: - Expand action
    
    lazy var onExpandAction: (Bool) -> Void = { [weak self] shouldExpand in
        if shouldExpand {
            self?.uiInitializer.expand()
        } else {
            self?.uiInitializer.collapse()
        }
    }
    
    // MARK: - Action accessory view actions
    
    override lazy var onSendAction: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        sSelf.actionsView?.disableSendButton()
        if let subject = sSelf.mailDetailsView?.subject,
            let bodyText = sSelf.textInputView?.text {
            var attachments: [Attachment] = []
            if let unwrappedAttachments = sSelf.mailDetailsView?.getAttachments() {
                attachments = unwrappedAttachments
            }
            
            self?.notificationPresenter?.show(animated: true, title: "Sending…")
            self?.pendingWorkItem?.cancel()
            self?.pendingWorkItem = DispatchWorkItem(block: {
                sSelf.composer.compose(with: subject, and: bodyText, for: sSelf.receiversHandler.receiversDataRepository.receivers, with: attachments, completion: { result in
                    switch result {
                    case .Success (_):
                        sSelf.showSuccessAlertView()
                    case .Error (let error):
                        sSelf.showErrorAlertView()
                    }
                })
            })
            self?.textInputView?.resignFirstResponder()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    lazy var onAttachmentAction: () -> Void = { [weak self] in
        self?.actionSheetHadler.show()
    }
    
    // MARK: - Contacts search actions
    
    lazy var onToExpandAction: (CGFloat) -> Void = { [weak self] height in
        self?.uiInitializer.expandToField(to: height)
    }
    
    lazy var onToCollapseAction: () -> Void = { [weak self] in
        self?.uiInitializer.collapseToField()
    }
    
    lazy var onOpenAttachment: (Attachment) -> Void = { [weak self] attachment in
        self?.attachmentHandler.present(attachment)
    }
    
    lazy var onRemovedAttachment: () -> Void = { [weak self] in
        guard let isAttachmentsExist = self?.mailDetailsView?.isAttchmentsExist() else { return }
        if !isAttachmentsExist {
            self?.uiInitializer.removeAttachments()
        }
    }
    
    //MARK: - sucess and error alert bar
    func showSuccessAlertView() {

        let sentView = UIImageView()
        sentView.image = #imageLiteral(resourceName: "no_internet_alert")
        if UIScreen.isPhoneX {
            sentView.frame = CGRect.init(x: 110, y: 667, width: 140, height: 50)
        } else if UIScreen.is6Or6S() {
            sentView.frame = CGRect.init(x: 110, y: 475, width: 140, height: 50)
        } else if UIScreen.is6PlusOr6SPlus() {
            sentView.frame = CGRect.init(x: 110, y: 540, width: 140, height: 50)
        }
        self.view.addSubview(sentView)
        
        let title = UILabel()
        title.frame = CGRect(x: 25, y: 13, width: 90, height: 22)
        title.text = "Message Sent"
        title.textAlignment = .center
        title.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        title.textColor = UIColor(hexString: "#FFFFFF")
        title.backgroundColor = .clear
        sentView.addSubview(title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sentView.removeFromSuperview()
        }
    }
    
    func showErrorAlertView() {
        let alert = UIAlertController(title: LocalizedStringKey.ComposeHelper.ErrorTitle, message: LocalizedStringKey.ComposeHelper.ErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: LocalizedStringKey.ComposeHelper.OkTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            alert.dismiss(animated: true, completion: nil)
            self.actionsView?.enableSendButton()
        }
    }
}

    // MARK: - Compose Keyboard Manager Delegate

extension ComposeViewController: ComposeKeyboardManagerDelegate {
    
    func manager(_ keyboardManager: ComposeKeyboardManager, willShowKeyboardWith height: CGFloat) {
        uiInitializer.updateUIForShowedKeyboard(with: height)
    }
    
    func manager(_ keyboardManager: ComposeKeyboardManager, willHideKeyboardWith height: CGFloat) {
        uiInitializer.updatedUIForHidenKeyboard(with: height)
    }
    
    func manager(_ keyboardManager: ComposeKeyboardManager, willChangeSizeWith delta: CGFloat) {
        uiInitializer.updateUIForKeyboardHeightChanges(with: delta)
    }
}

extension ComposeViewController: AttachmentsSheetHandlerDelegate {
    
    func handler(_ handler: AttachmentsSheetHandler, didFailWith error: String) {
        
    }
    
    func handler(_ handler: AttachmentsSheetHandler, dismissWith attachment: Attachment) {
        guard let isAttachmentsExist = mailDetailsView?.isAttchmentsExist() else { return }
        if !isAttachmentsExist {
            uiInitializer.expandWithAttachments()
        }
        if attachment.filename != "" {
            mailDetailsView?.append(attachment)
        }
    }
    
    func handler(_ handler: AttachmentsSheetHandler, didPressCancel cancelButton: UIButton?) {
        //MAKE some changes if press cancel
    }
    
    func handler(_ handler: AttachmentsSheetHandler, startUploadingImage isUploading: Bool) {
        //MAKE some changes if image started uploading
    }
}

extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            actionsView?.disableSendButton()
        } else {
            actionsView?.enableSendButton()
        }
    }
}
