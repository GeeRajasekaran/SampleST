//
//  RequestsCentreViewController.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsCentreViewController: UIViewController {

    var requestsTableView: UITableView?
    var topView: RequestsTopView = RequestsTopView()
    
    private lazy var dataRepository: RequestsDataRepository = { [unowned self] in
        let repo = RequestsDataRepository(onRecentItemsLoaded: self.onRecentItemsLoaded)
        repo.onUpdateMessageCallback = onMessagesUpdate
        repo.onRealTimeCallback = onRealTimeCallback
        return repo
    }()
    
    private lazy var uiInitializer: RequestsCentreUIInitializer = { [unowned self] in
        let initializer = RequestsCentreUIInitializer(with: self)
        return initializer
    }()
    
    lazy var delegate: RequestsDelegate = { [unowned self] in
        let delegate = RequestsDelegate(builder: screenBuilder)
        delegate.tableViewStartScrolling = tableViewScrollAction
        return delegate
    }()
    
    lazy var dataSource: RequestsDataSource = { [unowned self] in
        let dataSource = RequestsDataSource(builder: screenBuilder)
        dataSource.onViewChangedAction = onViewChanged
        dataSource.onReplyCell = actionButtonsHandler.onReplyCell
        dataSource.onApprovedCell = statusButtonsHandler.onApprovedTapped
        dataSource.onIgnoredCell = statusButtonsHandler.onIgnoredTapped
        dataSource.onBlockedCell = statusButtonsHandler.onBlockedTapped
        dataSource.onDeniedCell = statusButtonsHandler.onDenyTapped
        dataSource.onDiscardDraftAction = actionButtonsHandler.onDiscardDraftAction
        dataSource.onEditDraftAction = actionButtonsHandler.onEditDraftAction
        dataSource.onOpenAttachment = onOpenAttachment
        return dataSource
    }()
    
    lazy var screenBuilder: RequestsScreenBuilder = { [weak self] in
        let builder = RequestsScreenBuilder(model: nil, storage: self?.dataRepository)
        return builder
    }()
    
    lazy var actionButtonsHandler: ActionButtonsHandler = { [unowned self] in
        let handler = ActionButtonsHandler(with: self)
        handler.onReplied = onRepliedTo
        handler.onUpdateItemAction = onUpdate
        return handler
    }()
    
    lazy var statusButtonsHandler: StatusButtonsHandler = { [unowned self] in
        let handler = StatusButtonsHandler(builder: screenBuilder, statusWorker: statusWorker)
        handler.onItemsCountChanged = onTopItemsCountChanged
        handler.onError = onError
        return handler
    }()
    
    //MARK: - loader
    lazy var loaderHandler: RequestsLoaderHandler = { [unowned self] in
        let loader = RequestsLoaderHandler(with: view)
        return loader
    }()
    
    var statusWorker = StatusWorker()
    
    //MARK: - attachment handler
    lazy private var attachmentHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: self)
        return handler
    }()
    
    //MARK: - screen Type
    var screenType: RequestsScreenType {
        get {
            if let segment = screenBuilder.loadSegment() as? RequestsScreenType {
                return segment
            }
            return RequestsScreenType.people
        }
        set {
            screenBuilder.switchSegment(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
        requestData()
        dataRepository.subscribeForRealTimeEvents()
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive(_:)), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive(_:)), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.title = LocalizedStringKey.RequestsViewHelper.RequestsTitle
        loaderHandler.startLoader()
        dataRepository.loadPendingFromCoreData()
        topView.requestTotalCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = LocalizedStringKey.RequestsViewHelper.RequestsTitle
    }
    
    func requestData() {
        dataRepository.loadPendingDataFromServer()
    }
    
    //MARK: - notifications
    @objc func appResignActive(_ notification: Notification) {
        dataRepository.unsubscribe()
        screenBuilder.cleatHeights()
    }
    
    @objc func appBecomeActive(_ notification: Notification) {
        loaderHandler.startLoader()
        requestData()
        dataRepository.subscribeForRealTimeEvents()
    }
    
    func selectPeopleButton() {
        topView.selectPeopleButton()
    }
    
    func selectSubscriptionsButton() {
        topView.selectSubscriptionsButton()
    }
    
    //MARK: - lazy loading actions
    //MARK: - change cell height
    lazy var onViewChanged: (Int, CGFloat) -> Void = { [weak self] index, height in
        if let strongSelf = self {
            strongSelf.screenBuilder.put(height, at: index)
            strongSelf.requestsTableView?.beginUpdates()
            strongSelf.requestsTableView?.endUpdates()
        }
    }
    
    //MARK: - update message
    lazy var onMessagesUpdate: (Int) -> Void = { [weak self] index in
        if let strongSelf = self {
            let indexPath = IndexPath(row: index, section: RequestsSectionType.section.rawValue)
            strongSelf.reloadRow(at: indexPath)
        }
    }
    
    private lazy var onRecentItemsLoaded: () -> Void = { [weak self] in
        DispatchQueue.main.async { [weak self] in
            self?.topView.requestTotalCategories()
            self?.loaderHandler.stopLoader()
            self?.requestsTableView?.reloadData()
        }
    }
    
    //MARK: - top view buttons clicked
    lazy var onPeopleTableLoaded: () -> Void = { [weak self] in
        self?.changeRequestsWith(screenType: .people)
    }
    
    lazy var onSubscriptionTableLoaded: () -> Void = { [weak self] in
        self?.changeRequestsWith(screenType: .subscriptions)
    }
    
    func changeRequestsWith(screenType type: RequestsScreenType) {
        loaderHandler.startLoader()
        screenType = type
        screenBuilder.cleatHeights()
        actionButtonsHandler.hideResponder()
        dataRepository.loadRequestsFromCoreData(with: type)
    }
    
    lazy var onBlockedClicked: () -> Void = { [weak self] in
        //navigate to blocked section
        let vc = BlockedRequestsViewController()
        vc.statusWorker = self?.statusWorker
        self?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - update top view count
    lazy var onTopItemsCountChanged: (Int) -> Void = { [weak self] count in
       self?.updateTopView(count)
    }
    
    private func updateTopView(_ count: Int) {
        if screenType == .subscriptions {
            topView.updateSubscriptionCount(count: count)
        } else {
            topView.updatePeopleCount(count: count)
        }
    }
    
    //MARK: - reload row
    private func reloadRow(at indexPath: IndexPath) {
        guard (requestsTableView?.cellForRow(at: indexPath)) != nil else { return }
        requestsTableView?.reloadRows(at: [indexPath], with: .none)
    }
    
    //MARK: - error when approve/ignore
    
    private lazy var onError: (String) -> Void = { [weak self] text in
        //When error comes update requests page from core data
        guard let sSelf = self else { return }
        sSelf.changeRequestsWith(screenType: sSelf.screenType)
        self?.topView.requestTotalCategories()
    }
    
    //MARK: - on update contact
    private lazy var onRealTimeCallback: (RequestItem) -> Void = { [weak self] item in
        guard let sSelf = self else { return }
        guard let tableView = sSelf.requestsTableView else { return }
        sSelf.screenBuilder.realTime(with: item, and: tableView)
        sSelf.topView.requestTotalCategories()
    }
    
    //MARK: - table view scroll action
    private lazy var tableViewScrollAction: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        sSelf.actionButtonsHandler.hideResponder()
    }
    
    //MARK: - replied action
    private lazy var onRepliedTo: (RequestItem, MessageInfo) -> Void = { [weak self] requestItem, messageInfo in
        guard let sSelf = self else { return }
        if let index = sSelf.dataRepository.index(of: requestItem) {
            let indexPath = IndexPath(row: index, section: RequestsSectionType.section.rawValue)
            sSelf.dataRepository.append(messageInfo: messageInfo, to: requestItem)
            sSelf.reloadRow(at: indexPath)
        }
    }
    
    //MARK: - update cell action
    private lazy var onUpdate: (RequestItem) -> Void = { [weak self] requestItem in
        guard let sSelf = self else { return }
        if let index = sSelf.dataRepository.index(of: requestItem) {
            let indexPath = IndexPath(row: index, section: RequestsSectionType.section.rawValue)
            sSelf.reloadRow(at: indexPath)
        }
    }
    
    // MARK: - Attachments actions
    lazy var onOpenAttachment: (Attachment) -> Void = { [weak self] attachment in
        self?.attachmentHandler.present(attachment)
    }
    
    //MARK: - actions
    @objc func tapAction() {
        actionButtonsHandler.hideResponder()
    }
}

