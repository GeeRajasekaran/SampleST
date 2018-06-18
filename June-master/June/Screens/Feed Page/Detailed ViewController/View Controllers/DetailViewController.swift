//
//  DetailViewController.swift
//  June
//
//  Created by Ostap Holub on 9/1/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class DetailViewController: UIViewController {
    
    // MARK: - Views
    
    var toolView: ToolPanelView?
    var navigationView: UIView?
    var subjectBar: UIView?
    var subjectLabel: UILabel?
    var vendorDetailsBar: UIView?
    var vendorDetailsView: VendorDetailsView?
    var bodyScrollView: UIScrollView?
    var contentWebView: UIWebView?
    var backButton: UIButton?
    var coloredLineView: UIImageView?
    
    var contentTableView: FeedTableView?
    var documentsController: UIDocumentInteractionController?
    
    // MARK: - Variables
    
    var categories: [FeedCategory] = [FeedCategory]()
    weak var pendingCategory: FeedCategory?
    weak var threadsDataProvider: ThreadsDataProvider?
    
    var isFromSearch: Bool = false
    var currentCard: FeedItem?
    private var starringHandler = BookmarkHandler()
    private var shareManager = ShareManager()
    private var readStateHandler = ReadStateHandler()

    private var responder: ResponderOld?
    private var savedContact: Contacts?
    
    lazy fileprivate var dataRepository: MessagesDataRepository = {
        let source = MessagesDataRepository(with: self.currentCard?.id)
        source.onUpdateCallback = self.onDataUpdate
        return source
    }()
    
    lazy var tableViewSource: MessagesDataSource = {
        let source = MessagesDataSource(with: self.dataRepository)
        source.onWebViewLoadedAction = self.onWebViewLoaded
        source.onOpenAttachment = self.onOpenAttachment
        source.onWebViewClicked = self.onWebViewClicked
        return source
    }()
    
    lazy var tableViewDelegate: MessagesTableViewDelegate = {
        let delegate = MessagesTableViewDelegate(with: self.dataRepository)
        delegate.onHideResponder = self.onResignResponder
        return delegate
    }()
    
    lazy fileprivate var uiInitializer: DetailViewInitializer = {
        let initializer = DetailViewInitializer(with: self)
        return initializer
    }()
    
    lazy fileprivate var actionSheetHadler: ShareActionSheetHandler = {
        let handler = ShareActionSheetHandler(with: self)
        handler.inJuneAction = self.shareInJune
        handler.iniOSAction = self.shareIniOS
        return handler
    }()
    
    lazy fileprivate var moreOptionsHandler: MoreOptionsActionSheetHandler = {
        let handler = MoreOptionsActionSheetHandler(with: self)
        handler.recategorizeAction = self.onRecategorize
        handler.replyAction = self.onReply
        handler.unsubscribeAction = self.onUnsubscribe
        return handler
    }()
    
    lazy var notificationViewPresenter: NotificationViewPresenter = {
        let presenter = NotificationViewPresenter()
        presenter.delegate = self
        return presenter
    }()
    
    lazy private var attachmentHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: self)
        return handler
    }()
    
    lazy private var recategorizeHandler: RecategorizeHandler = { [unowned self] in
        let handler = RecategorizeHandler(rootVC: self, categories: self.categories)
        handler.onRecategorizeFailed = self.onRecategorizeFailed
        handler.onRecategorizeStarted = self.onRecategorizeStarted
        handler.onRecategorizeCanceled = self.onRecategorizeCanceled
        return handler
    }()
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
        dataRepository.requestMessages()
        if let message = dataRepository.firstMessage() {
            shareManager.generateLink(for: message.entity)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiInitializer.addNavigationView()
        uiInitializer.addColoredHeaderLine()
        uiInitializer.setShare(action: #selector(onShare), for: self)
        uiInitializer.setStar(action: #selector(onStar), for: self)
        uiInitializer.setRecategorize(action: #selector(onRemind), for: self)
        uiInitializer.setMoreOptions(action: #selector(onMoreOptions), for: self)
        
        if let card = currentCard {
            toolView?.starIfNeeded(for: card.threadEntity)
        }
        threadsDataProvider?.subscribeForRealTimeEvents()
        if currentCard?.unread == true {
            readStateHandler.markAsReadThread(with: currentCard?.id)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //responder?.hide()
        backButton?.removeFromSuperview()
        toolView?.removeFromSuperview()
        coloredLineView?.removeFromSuperview()
        threadsDataProvider?.unsubscribe()
    }
    
    // MARK: - Data logic
    
    private func updateHeader() {
        if let subject = dataRepository.firstMessage()?.subject {
            subjectLabel?.text = subject
        }
    }
    
    lazy var onWebViewLoaded: (Int, CGFloat) -> Void = { [weak self] index, height in
        if let strongSelf = self {
            strongSelf.tableViewDelegate.put(height, at: index)
            strongSelf.contentTableView?.beginUpdates()
            strongSelf.contentTableView?.endUpdates()
        }
    }
    
    lazy var onDataUpdate: () -> Void = { [weak self] in
        self?.updateHeader()
        self?.contentTableView?.reloadData()
    }
    
    // MARK: - Attachments action sheet
    
    lazy var onOpenAttachment: (Attachment) -> Void = { [weak self] attachment in
        self?.attachmentHandler.present(attachment)
    }
    
    // MARK: - Buttons Actions
    
    @objc func onBack() {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        responder?.hide()
    }
    
    //MARK: - on webViewClicked
    lazy var onWebViewClicked: () -> Void = { [weak self] in
        self?.responder?.hide()
    }
    
    @objc func onMoreOptions() {
        moreOptionsHandler.show()
    }
    
    @objc func onStar() {
        guard let unwrappedThread = currentCard?.threadEntity else { return }
        toolView?.bookmarkButton.changeState()
        starringHandler.changeState(of: unwrappedThread) { result in
            if result != "" {
                AlertBar.show(.error, message: result)
            }
        }
    }
    
    @objc func onRemind() {
        print("Remind button clicked")
    }
    
    @objc func onShare() {
        actionSheetHadler.show()
    }
    
    lazy var onHideResponder: () -> Void = { [weak self] in
      //  self?.responder = nil
    }
    
    lazy var onSuccessReplyResponse: ([String: AnyObject], String) -> Void = { [weak self] attributes, string in
        self?.responder?.hide()
    }
    
    lazy var onResignResponder: () -> Void = { [weak self] in
        self?.responder?.hide()
    }
    
    // MARK: - More options Actions
    
    lazy var onRecategorize: () -> Void = { [weak self] in
        guard let item = self?.currentCard else { return }
        self?.recategorizeHandler.startRecategorize(for: item)
    }
    
    lazy var onReply: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        guard let unwrappedThread = sSelf.currentCard?.threadEntity, let message = sSelf.dataRepository.firstMessage()?.entity else { return }
        let config = ResponderConfig(with: .reply, thread: unwrappedThread, message: message, minimized: false)
        if sSelf.responder != nil {
            sSelf.responder?.hide()
        }
        sSelf.responder = ResponderOld(with: sSelf, and: config)
        sSelf.responder?.onHideAction = sSelf.onHideResponder
        sSelf.responder?.onSuccessResponse = sSelf.onSuccessReplyResponse
        sSelf.responder?.start()
    }
    
    lazy var onUnsubscribe: () -> Void = { [weak self] in
//        guard let sSelf = self else { return }
//        let contactsDataProvider = ContactsDataProvider()
//        guard let email = sSelf.dataRepository.firstMessage()?.senderName else { return }
//        sSelf.notificationViewPresenter.show(animated: true, title: LocalizedStringKey.DetailedViewHelper.BlockSenderTitle + " \(email).")
//        contactsDataProvider.getContactBy(email: email, completion: { result in
//            switch result {
//            case .Success(let contact):
//                sSelf.savedContact = contact
//            case .Error(let error):
//                AlertBar.show(.error, message: error)
//            }
//        })
    }
    
    // MARK: - Recategorization actions
    
    lazy var onRecategorizeStarted: (FeedItem, FeedCategory, FeedCategory) -> Void = { [weak self] item, currentCategory, destinationCategory in
        self?.pendingCategory = currentCategory
        self?.currentCard?.feedCategory = destinationCategory
    }
    
    lazy var onRecategorizeFailed: (FeedItem, String) -> Void = { [weak self] item, error in
        self?.currentCard?.feedCategory = self?.pendingCategory
        AlertBar.show(.error, message: error)
    }
    
    lazy var onRecategorizeCanceled: (FeedItem) -> Void = { [weak self] item in
        self?.currentCard?.feedCategory = self?.pendingCategory
    }
    
    // MARK: - Action Sheet Actions
    
    lazy var shareInJune: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        guard let unwrappedThread = sSelf.currentCard?.threadEntity, let message = sSelf.dataRepository.firstMessage()?.entity else { return }
        let config = ResponderConfig(with: .forward, thread: unwrappedThread, message: message, minimized: false)
        if sSelf.responder != nil {
            sSelf.responder?.hide()
        }
        sSelf.responder = ResponderOld(with: sSelf, and: config)
        sSelf.responder?.onHideAction = sSelf.onHideResponder
        sSelf.responder?.onSuccessResponse = sSelf.onSuccessReplyResponse
        sSelf.responder?.start()
    }
    
    lazy var shareIniOS: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        if let shareURL = sSelf.shareManager.shareURL, let title = sSelf.currentCard?.title {
            let finalStringToShare = title + "\n" + shareURL
            let controller = UIActivityViewController(activityItems: [finalStringToShare], applicationActivities: nil)
            controller.completionWithItemsHandler = sSelf.onCompleteShare
            sSelf.present(controller, animated: true, completion: nil)
        }
    }
    
    lazy var onCompleteShare: (UIActivityType?, Bool, [Any]?, Error?) -> Void = { [weak self] type, completed, returnedItems, error in
        if !completed {
            if let errorMessage = error?.localizedDescription {
                AlertBar.show(.error, message: errorMessage)
            }
        }
    }
    
    //MARK: - Unsubscribe
    private func changeContact(with status: Status) {
        //TODO: - chnage status with new core dat object
//        guard let unwrappedContact = savedContact else { return }
//        let statusHandler = StatusHandler()
//        statusHandler.changeStatusAndSave(unwrappedContact, with: status, completion: { result in
//            switch result {
//            case .Success( _):
//                break
//            case .Error(let error):
//                AlertBar.show(.error, message: error)
//            }
//        })
    }
    
    private func blockContact() {
        changeContact(with: .blocked)
    }
    
    private func undoContactIfNeeded() {
        //TODO: check if works
        //Remove when old feed classes will be removed
//        guard let unwrappedContact = savedContact else { return }
//        let blocked: Status = .blocked
//        if unwrappedContact.status == blocked.value {
//            changeContact(with: .unblock)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if responder != nil {
            responder?.hide()
        }
    }
}

extension DetailViewController: NotificationViewPresenterDelegate {
    func didTapOnUndoButton(_ button: UIButton) {
        undoContactIfNeeded()
    }
    
    func didHideViewAfterDelay(_ view: NotificationView) {
       blockContact()
    }
}

extension DetailViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
