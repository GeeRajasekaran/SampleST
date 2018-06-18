//
//  BlockedRequestsViewController.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class BlockedRequestsViewController: UIViewController {
    
    var requestsTableView: UITableView = UITableView()
    var topView: RequestsTopView = RequestsTopView()
    weak var statusWorker: StatusWorker?
    
    private lazy var dataRepository: RequestsDataRepository = { [unowned self] in
        let repo = RequestsDataRepository(onRecentItemsLoaded: self.onRecentItemsLoaded)
        repo.onUpdateMessageCallback = onMessagesUpdate
        repo.onRealTimeCallback = onRealTimeCallback
        repo.screenType = .blockedPeople
        return repo
    }()
    
    private lazy var uiInitializer: BlockedRequestsUIInititalizer = { [unowned self] in
        let initializer = BlockedRequestsUIInititalizer(with: self)
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
        dataSource.onUnblockedCell = statusButtonsHandler.onUnblockedTapped
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
        handler.onError = onError
        return handler
    }()
    
    //MARK: - attachment handler
    lazy private var attachmentHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: self)
        return handler
    }()
    
    //MARK: - loader
    lazy var loaderHandler: RequestsLoaderHandler = { [unowned self] in
        let loader = RequestsLoaderHandler(with: view)
        return loader
    }()
    
    //MARK: - screen Type
    var screenType: RequestsScreenType {
        get {
            if let segment = screenBuilder.loadSegment() as? RequestsScreenType {
                return segment
            }
            return RequestsScreenType.blockedPeople
        }
        set {
            screenBuilder.switchSegment(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
        screenType = .blockedPeople
        loaderHandler.startLoader()
        dataRepository.loadBlockedRequests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataRepository.subscribeForRealTimeEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        actionButtonsHandler.hideResponder()
        statusButtonsHandler.notificationViewPresenter.hide()
    }
    
    deinit {
        dataRepository.unsubscribe()
    }
    
    //MARK: - lazy loading actions
    //MARK: - change cell height
    lazy var onViewChanged: (Int, CGFloat) -> Void = { [weak self] index, height in
        if let strongSelf = self {
            strongSelf.screenBuilder.put(height, at: index)
            strongSelf.requestsTableView.beginUpdates()
            strongSelf.requestsTableView.endUpdates()
        }
    }
    
    //MARK: - update message
    lazy var onMessagesUpdate: (Int) -> Void = { [weak self] index in
        if let strongSelf = self {
            let indexPath = IndexPath(row: index, section: RequestsSectionType.section.rawValue)
            strongSelf.requestsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private lazy var onRecentItemsLoaded: () -> Void = { [weak self] in
        DispatchQueue.main.async { [weak self] in
            self?.loaderHandler.stopLoader()
            self?.requestsTableView.reloadData()
        }
    }
    
    //MARK: - top view buttons clicked
    lazy var onPeopleTableLoaded: () -> Void = { [weak self] in
        self?.changeRequestsWith(screenType: .blockedPeople)
    }
    
    lazy var onSubscriptionTableLoaded: () -> Void = { [weak self] in
        self?.changeRequestsWith(screenType: .blockedSubscriptions)
        
    }
    
    private func changeRequestsWith(screenType type: RequestsScreenType) {
        loaderHandler.startLoader()
        screenType = type
        screenBuilder.cleatHeights()
        actionButtonsHandler.hideResponder()
        dataRepository.loadRequestsFromCoreData(with: type)
    }
    
    //MARK: - error when approve/ignore
    private lazy var onError: (String) -> Void = { [weak self] text in
        //When error comes update requests page from core data
        guard let sSelf = self else { return }
        sSelf.changeRequestsWith(screenType: sSelf.screenType)
        self?.topView.requestTotalCategories()
    }
    
    //MARK: - back action
    lazy var onBackButtonAction: () -> Void = { [weak self] in
        self?.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - on real time update contact
    private lazy var onRealTimeCallback: (RequestItem) -> Void = { [weak self] item in
        guard let sSelf = self else { return }
        sSelf.screenBuilder.realTime(with: item, and: sSelf.requestsTableView)
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
            sSelf.requestsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //MARK: - update cell action
    private lazy var onUpdate: (RequestItem) -> Void = { [weak self] requestItem in
        guard let sSelf = self else { return }
        if let index = sSelf.dataRepository.index(of: requestItem) {
            let indexPath = IndexPath(row: index, section: RequestsSectionType.section.rawValue)
            sSelf.requestsTableView.reloadRows(at: [indexPath], with: .none)
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
