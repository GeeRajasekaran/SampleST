//
//  FeedDetailedViewController.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import AlertBar

class FeedDetailedViewController: UIViewController {
    
    // MARK: - Variables & Constants
    
    var bottomConstraint: NSLayoutConstraint?
    
    var currentCard: FeedItem?
    var cardView: IFeedCardView?
    var contentTableView: UITableView?
    var toolView: ToolPanelView?
    
    private var readStateHandler = ReadStateHandler()
    private var bookmarksHandler = BookmarkHandler()
    weak var threadsDataProvider: ThreadsDataProvider?
    var categories: [FeedCategory] = [FeedCategory]()
    weak var pendingCategory: FeedCategory?
    var isFromSearch = false
    private var shareManager = ShareManager()
    
    var previousResponderFrame: CGRect?

    private var responder: Responder?
    private var responderOld: ResponderOld?
    private let contactsDataProvider = ContactsDataProvider()
    private let statusWorker = StatusWorker()
    private var savedContact: Contacts?
    
    private let categoriesDataProvider = CategoriesDataProvider()
    
    private var pendingResponderMetadata: ResponderMetadata?
    
    lazy fileprivate var actionSheetHadler: ShareActionSheetHandler = { [unowned self] in
        let handler = ShareActionSheetHandler(with: self)
        handler.inJuneAction = self.shareInJune
        handler.iniOSAction = self.shareIniOS
        return handler
    }()
    
    private lazy var uiInitializer: FeedDetailedUIInitializer = { [unowned self] in
        let initializer = FeedDetailedUIInitializer(vc: self)
        return initializer
    }()
    
    private lazy var dataRepository: MessagesDataRepository = { [weak self] in
        let repo = MessagesDataRepository(with: currentCard?.id)
        repo.onUpdateCallback = self?.onDataUpdate
        return repo
    }()
    
    private lazy var screenBuilder: FeedDetailedScreenBuilder = { [weak self] in
        let builder = FeedDetailedScreenBuilder(model: nil, storage: self?.dataRepository, thread: self?.currentCard?.threadEntity)
        return builder
    }()
    
    lazy var dataSource: FeedDetailedDataSource = { [weak self] in
        let source = FeedDetailedDataSource(builder: self?.screenBuilder)
        source.onWebViewLoadedAction = self?.onWebViewLoaded
        return source
    }()
    
    lazy var delegate: FeedDetailedTableDelegate = { [weak self] in
        let delegate = FeedDetailedTableDelegate(builder: self?.screenBuilder)
        return delegate
    }()
    
    lazy fileprivate var moreOptionsHandler: MoreOptionsActionSheetHandler = { [unowned self] in
        let handler = MoreOptionsActionSheetHandler(with: self)
        handler.recategorizeAction = self.onRecategorize
        handler.replyAction = self.onReply
        handler.unsubscribeAction = self.onUnsubscribe
        return handler
    }()
    
    lazy private var recategorizeHandler: RecategorizeHandler = { [unowned self] in
        let handler = RecategorizeHandler(rootVC: self, categories: self.categories)
        handler.onRecategorizeFailed = self.onRecategorizeFailed
        handler.onRecategorizeStarted = self.onRecategorizeStarted
        handler.onRecategorizeCanceled = self.onRecategorizeCanceled
        return handler
    }()
    
    lazy var notificationViewPresenter: NotificationViewPresenter = {
        let presenter = NotificationViewPresenter()
        presenter.delegate = self
        return presenter
    }()
    
    lazy var shareViewPresenter: ShareViewPresenter = { [unowned self] in
        let presenter = ShareViewPresenter(with: self)
        return presenter
    }()
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
        uiInitializer.setStar(action: #selector(onStar), for: self)
        uiInitializer.setShare(action: #selector(onShare), for: self)
        uiInitializer.setMoreOptions(action: #selector(onMoreOptions), for: self)
        dataRepository.requestMessages()
        if let message = dataRepository.firstMessage() {
            shareManager.generateLink(for: message.entity)
        }
        loadCategoriesIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        threadsDataProvider?.subscribeForRealTimeEvents()
        toolView?.starIfNeeded(for: currentCard?.threadEntity)
        if currentCard?.unread == true {
            readStateHandler.markAsReadThread(with: currentCard?.id)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toolView?.removeFromSuperview()
        threadsDataProvider?.unsubscribe()
    }
    
    func loadCategoriesIfNeeded() {
        if categories.count == 0 {
            requestCategories()
        }
    }
    
    private func requestCategories() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.categoriesDataProvider.requestCategories(completion: { result in
                switch result {
                case .Success(let categories):
                    self?.categories = categories
                case .Error(let error):
                    AlertBar.show(.error, message: error)
                }
            })
        }
    }
    
    // MARK: - Data update logic
    
    lazy var onDataUpdate: () -> Void = { [weak self] in
        self?.contentTableView?.reloadData()
    }
    
    lazy var onWebViewLoaded: (Int, CGFloat) -> Void = { [weak self] index, height in
        self?.screenBuilder.save(cellHeigh: height, at: index)
        self?.contentTableView?.beginUpdates()
        self?.contentTableView?.endUpdates()
    }
    
    // MARK: - Tool panel actions
    
    @objc func onBack() {
        navigationController?.popViewController(animated: true)
        responderOld?.hide()
        responder?.hide()
    }
    
    @objc func onMoreOptions() {
        moreOptionsHandler.show()
    }
    
    @objc func onStar() {
        guard let unwrappedThread = currentCard?.threadEntity else { return }
        toolView?.bookmarkButton.changeState()
        bookmarksHandler.changeState(of: unwrappedThread) { result in
            if result != "" {
                AlertBar.show(.error, message: result)
            }
        }
    }
    
    @objc func onShare() {
        shareViewPresenter.show(cardView)
    }
    
    // MARK: - More options actions
    
    lazy var onRecategorize: () -> Void = { [weak self] in
        guard let item = self?.currentCard else { return }
        self?.recategorizeHandler.startRecategorize(for: item)
    }
    
    lazy var onReply: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        guard let unwrappedThread = sSelf.currentCard?.threadEntity, let message = sSelf.dataRepository.firstMessage()?.entity else { return }
        let config = ResponderConfig(with: .reply, thread: unwrappedThread, message: message, minimized: false)
        config.shouldClearOnSend = false
        config.shouldAutoExpand = true
//        if sSelf.responderOld != nil {
//            sSelf.responderOld?.hide()
//        }
        
        if sSelf.responder != nil {
            sSelf.responder?.hide()
        }
        
//        sSelf.responderOld = ResponderOld(with: sSelf, and: config)
//        sSelf.responderOld?.onSuccessResponse = sSelf.onSuccessReplyResponse
//        sSelf.responderOld?.start()
        sSelf.responder = Responder(rootVC: sSelf, config: config)
        sSelf.responder?.actionsListener = sSelf
        sSelf.responder?.show()
        sSelf.responder?.responderViewController.responderAccessoryView?.becomeFirstResponderIfNeeded()
    }
    
    lazy var onUnsubscribe: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        guard let email = sSelf.dataRepository.firstMessage()?.senderName else { return }
        sSelf.notificationViewPresenter.show(animated: true, title: LocalizedStringKey.DetailedViewHelper.BlockSenderTitle + " \(email).")
        sSelf.contactsDataProvider.getContactBy(email: email, completion: { [weak self] result in
            switch result {
            case .Success(let contact):
                sSelf.savedContact = contact
                sSelf.blockContact()
            case .Error(let error):
                AlertBar.show(.error, message: error)
            }
        })
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
        if sSelf.responderOld != nil {
            sSelf.responderOld?.hide()
        }
        sSelf.responderOld = ResponderOld(with: sSelf, and: config)
        sSelf.responderOld?.onSuccessResponse = sSelf.onSuccessReplyResponse
        sSelf.responderOld?.start()
    }
    
    private lazy var onSuccessReplyResponse: ([String: AnyObject], String) -> Void = { [weak self] attributes, string in
//        self?.responderOld?.hide()
        self?.responder?.hide()
    }
    
    private lazy var shareIniOS: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        if let shareURL = sSelf.shareManager.shareURL, let title = sSelf.currentCard?.title {
            let finalStringToShare = title + "\n" + shareURL
            let controller = UIActivityViewController(activityItems: [finalStringToShare], applicationActivities: nil)
            controller.completionWithItemsHandler = sSelf.onCompleteShare
            if let presentedVC = sSelf.presentedViewController {
                presentedVC.present(controller, animated: true, completion: nil)
            } else {
                sSelf.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    private lazy var onCompleteShare: (UIActivityType?, Bool, [Any]?, Error?) -> Void = { [weak self] type, completed, returnedItems, error in
        if !completed {
            if let errorMessage = error?.localizedDescription {
                AlertBar.show(.error, message: errorMessage)
            }
        }
    }
    
    // MARK: - Block contact methods
    
    private func blockContact() {
        changeContact(with: .blocked)
    }
    
    private func undoContactIfNeeded() {
        guard let unwrappedContact = savedContact else { return }
        let blocked: Status = .blocked
        if unwrappedContact.status == blocked.value {
            changeContact(with: .unblock)
        }
    }
    
    private func changeContact(with status: Status) {
        guard let unwrappedContact = savedContact else { return }
        statusWorker.change(unwrappedContact, with: status) { result in
            if result != "" {
                AlertBar.show(.error, message: result)
            }
        }
    }
    
    private var resignTap: UITapGestureRecognizer?
    
    private func addResignTap() {
        guard resignTap == nil else { return }
        guard responder?.metadata.state != .minimized else { return }
        
        resignTap = UITapGestureRecognizer(target: self, action: #selector(handleHideResponderOnTap(_:)))
        resignTap?.delegate = self
        if resignTap != nil {
            contentTableView?.addGestureRecognizer(resignTap!)
        }
    }
    
    private func removeResignTap() {
        guard resignTap != nil else { return }
        contentTableView?.removeGestureRecognizer(resignTap!)
        resignTap = nil
    }
    
    @objc private func handleHideResponderOnTap(_ gesture: UIGestureRecognizer) {
        if responder?.metadata.state == .regular {
            responder?.hide()
            responder = nil
            removeResignTap()
        }
    }
}

extension FeedDetailedViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !String(describing: touch.view).isEqualToString(find: "UITableViewCellContentView")
    }
}

extension FeedDetailedViewController: NotificationViewPresenterDelegate {
    func didTapOnUndoButton(_ button: UIButton) {
        undoContactIfNeeded()
    }
    
    func didHideViewAfterDelay(_ view: NotificationView) {
        blockContact()
    }
}

extension FeedDetailedViewController: IResponderActionsListener {
    
    func onChangeFrame(_ responderFrame: CGRect) {
        guard let unwrappedFrame = previousResponderFrame else {
            bottomConstraint?.constant = -responderFrame.height
            previousResponderFrame = responderFrame
            return
        }
        if unwrappedFrame.origin.y != responderFrame.origin.y {
            let constant = view.frame.height - responderFrame.origin.y
            bottomConstraint?.constant = -constant
            previousResponderFrame = responderFrame
            addResignTap()
        }
    }
    
    func onHideAction(_ metadata: ResponderMetadata, shouldSaveDraft: Bool) {
        bottomConstraint?.constant = 0.0
    }
    
    func onSendAction(_ metadata: ResponderMetadata) {
        responder?.disableSendButton()
    }
    
    func onSuccessAction(_ responseData: [String : AnyObject]) {
        removeResignTap()
        notificationViewPresenter.show(animated: true, title: "Message sent")
        responder?.hide()
        responder = nil
    }
    
    func onFailAction(_ error: String) {
        notificationViewPresenter.show(animated: true, title: error)
        responder?.enableSendButton()
    }
}
