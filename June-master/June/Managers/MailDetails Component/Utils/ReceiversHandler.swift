//
//  ReceiversHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/8/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReceiversHandler {

    private var searchState: SearchState = .finished
    
    var removeReceiver: ((IndexPath) -> Void)?
    var insertReceiver: ((IndexPath) -> Void)?
    var updatePlaceholder: ((Int) -> Void)?
    
    //MARK: - data repository
    var receiversDataRepository = EmailReceiversDataRepository()
    
    lazy private var navigationHandler: MailDetailsNavigationHandler = {
        let handler = MailDetailsNavigationHandler(rootVC: parentViewController)
        return handler
    }()
    
    //MARK: - data source
    lazy var receiversDataSource: ComposeEmailReceiversDataSource = { [unowned self] in
        let source = ComposeEmailReceiversDataSource(storage: receiversDataRepository)
        source.onRemoveReceiver = onRemoveReceiverAction
        source.onReturnAction = onReturnAction
        return source
    }()
    
    //MARK: - delegate
    lazy var receiversDelegate: ComposeEmailReceiversDelegate = { [unowned self] in
        let delegate = ComposeEmailReceiversDelegate(storage: self.receiversDataRepository)
        return delegate
    }()
    
    //MARK: - suggestions controller
    lazy var suggestionViewController: ComposeSuggestionsViewController = { [unowned self] in
        let controller = ComposeSuggestionsViewController()
        controller.onSelectAction = onSelectAction
        return controller
    }()
    
    private unowned var parentViewController: BaseMailDetailsViewController
    
    // MARK: - Initialization
    
    init(parentVC: BaseMailDetailsViewController) {
        parentViewController = parentVC
    }
    
    //MARK: - private part
    //MARK: - actions
    private lazy var onSelectAction: (EmailReceiver) -> Void = { [weak self] receiver in
        guard let sSelf = self else { return }
        sSelf.searchState = .finished
        sSelf.navigationHandler.hideSuggestions(sSelf.suggestionViewController)
        sSelf.receiversDataRepository.append(receiver)
        if let index = sSelf.receiversDataRepository.index(of: receiver) {
            let indexPath = IndexPath(item: index, section: 0)
            sSelf.insertReceiver?(indexPath)
        }
        NotificationCenter.default.post(name: .onClearTextInput, object: nil)
    }
    
    private lazy var onRemoveReceiverAction: (Int) -> Void = { [weak self] index in
        guard let sSelf = self else { return }
        sSelf.receiversDataRepository.remove(at: index)
        let indexPath = IndexPath(item: index, section: 0)
        sSelf.removeReceiver?(indexPath)
        if sSelf.receiversDataRepository.receivers.count == 1 {
            let lastIndex = sSelf.receiversDataRepository.receivers.count - 1
            sSelf.updatePlaceholder?(lastIndex)
        }
    }
    
    private lazy var onReturnAction: (String) -> Void = { [weak self] text in
        guard let sSelf = self else { return }
        if !text.isValidEmail() { return }
        sSelf.searchState = .finished
        sSelf.navigationHandler.hideSuggestions(sSelf.suggestionViewController)
        let receiver = EmailReceiver(name: "", email: text, destination: .display)
        sSelf.receiversDataRepository.append(receiver)
        if let index = sSelf.receiversDataRepository.index(of: receiver) {
            let indexPath = IndexPath(item: index, section: 0)
            sSelf.insertReceiver?(indexPath)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ResponderOld.SearchNotificationName.clearText), object: nil)
    }
    
    // MARK: - ToField Notifications
    func subscribeForToFieldNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidBeginSearch(_:)), name: .onSearchStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidEndSearch(_:)), name: .onSearchFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateData(_:)), name: .onQueryChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleResignNotification(_:)), name: Notification.Name(rawValue: ResponderOld.SearchNotificationName.resign), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRemoveLastRecipient) , name: .onRemoveRecipientByBackspace, object: nil)
    }
    
    func unsubscribeForToFieldNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleRemoveLastRecipient(_ notification: Notification) {
        guard receiversDataRepository.receivers.count > 1 else { return }
        let lastIndex = receiversDataRepository.receivers.count - 2
        onRemoveReceiverAction(lastIndex)
    }
    
    @objc private func handleResignNotification(_ notification: Notification) {
        if searchState == .started {
            searchState = .finished
            navigationHandler.hideSuggestions(suggestionViewController)
        }
    }
    
    //MARK: - notification actions
    @objc private func onDidBeginSearch(_ notification: Notification) {
        if searchState == .finished {
            searchState = .started
        }
    }
    
    @objc private func onDidEndSearch(_ notification: Notification) {
        if searchState == .started {
            searchState = .finished
            navigationHandler.hideSuggestions(suggestionViewController)
        }
    }
    
    @objc private func onUpdateData(_ notification: Notification) {
        if searchState == .started {
            guard let query = notification.userInfo?["query"] as? String else { return }
            navigationHandler.showSuggestions(suggestionViewController)
            suggestionViewController.search(by: query)
        }
    }
    
}
