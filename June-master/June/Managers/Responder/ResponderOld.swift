//
//  ResponderOld.swift
//  June
//
//  Created by Ostap Holub on 9/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderOld: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Responder notifications names
    
    struct SearchNotificationName {
        static let start = "DidStartSearch"
        static let end = "DidEndSearch"
        static let update = "DidUpdateSearchResult"
        static let clearText = "InputShouldClearText"
        static let paging = "InputShouldRequestNext"
        static let resign = "InputShouldResign"
    }
    
    // MARK: - Nested responder goal enum
    
    enum ResponderGoal {
        case forward
        case reply
        case replyAll
    }
    
    // MARK: - Neseted resonder controller state enum
    
    enum ControllerState {
        case expanded
        case collapsed
        case minimized
    }
    
    // MARK: - Nested search state enum
    
    private enum SearchState {
        case started
        case finished
    }
    
    var state: ControllerState
    private var searchState: SearchState
    private var configuration: ResponderConfig
    var rootViewController: UIViewController
    private var responderViewController: ResponderViewControllerOld
    private var suggestionsViewController: ReceiversSuggestionViewController?
    private var responderNavigationHandler: INavigationHandler
    var shouldMinimize: Bool = true
    var onSendButtonPressed: ((Messages, String, [EmailReceiver], [Attachment]) -> Void)?
    var onSuccessResponse: (([String: AnyObject], String) -> Void)?
    var onErrorResponse: ((String) -> Void)?
    var onHideAction: (() -> Void)?
    
    var onResponderShown: ((CGFloat) -> Void)?
    var onResponderMinimized: ((CGFloat) -> Void)?
    var onResponderExpanded: ((CGFloat) -> Void)?
    
    var isFirstAttachmentAdded = true
    // this variable is used to store last text view content height
    // in collapsed mode. It is necessary to store, to know what height should
    // view have after moving from .expanded to .collapsed Responder state.
    var lastResponderHeight: CGFloat?
    
    // MARK: - Initialization
    
    init(with rootVC: UIViewController, and config: ResponderConfig) {
        configuration = config
        rootViewController = rootVC
        responderViewController = ResponderViewControllerOld()
        state = config.isMinimizationEnabled == true ? .minimized : .collapsed
        searchState = .finished
        responderNavigationHandler = NavigationHandlerFactory.handler(for: config.goal!, with: rootVC)
        super.init()
    }
    
    // MARK: - Body initialization
    
    func setBody(with string: String) {
        if string == "" {
            responderViewController.accessoryView?.disableSendButton()
        } else {
            responderViewController.accessoryView?.enableSendButton()
        }
        responderViewController.accessoryView?.textView?.text = string
    }
    
    func setMessage(_ message: Messages) {
        configuration.message = message
    }
    
    func setThread(_ thread: Threads) {
        configuration.thread = thread
    }
    
    func getMessageBody() -> String {
        if let text = responderViewController.accessoryView?.bodyText {
            return text
        }
        return ""
    }
    
    func getAttachments() -> [Attachment] {
        if let attachments = responderViewController.accessoryView?.attachmentsView?.getAttachments() {
            return attachments
        }
        return []
    }
    
    func add(attachments: [Attachment]) {
        responderViewController.addAttachments(attachments: attachments)
        changeSizeWithAttachments()
    }
    
    // MARK: - Showing / Hiding logic
    
    func start(with goal: ResponderGoal) {
        configuration.goal = goal
        responderViewController.responder = self
        responderViewController.config = configuration
        responderViewController.accessoryView?.setFirstResponder()
        responderViewController.updateReceivers()
    }
    
    func start() {
        responderViewController.responder = self
        responderViewController.config = configuration
        responderViewController.onExapandAction = onExpandAction
        responderViewController.onTextViewExpanded = onTextViewExpanded
        addDismissGesture(to: responderViewController.view)
        responderViewController.keyboardManager?.subscribeForKeyboardNotifications()
        subscribeForSearchNotifications()
        responderNavigationHandler.show(responderViewController)
    }
    
    func hide() {
        unsubscribeForSearchNotifications()
        responderViewController.keyboardManager?.unsubscribeForKeyboardNotifications()
        responderNavigationHandler.hide(responderViewController)
        onHideAction?()
    }
    
    func clean() {
        setBody(with: "")
    }
    
    func subscribe() {
        responderViewController.keyboardManager?.subscribeForKeyboardNotifications()
    }
    
    func unsusbscribe() {
        responderViewController.keyboardManager?.unsubscribeForKeyboardNotifications()
    }
    
    // MARK: - Dismiss tap
    
    private func addDismissGesture(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissTap))
        tapGesture.delegate = self
        
//        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleDismissTap() {
        hide()
    }
    
    // MARK: - Search expansion logic
    
    private func subscribeForSearchNotifications() {
        
        suggestionsViewController = ReceiversSuggestionViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(didStartSearch(_:)), name: Notification.Name(rawValue: SearchNotificationName.start), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEndSearch(_:)), name: Notification.Name(rawValue: SearchNotificationName.end), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: Notification.Name(rawValue: SearchNotificationName.update), object: nil)
    }
    
    private func unsubscribeForSearchNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didStartSearch(_ notification: Notification) {
        if state == .collapsed && searchState == .finished {
            //1. expand frame of controller
            searchState = .started
            suggestionsViewController?.dataStorage.clear()
            responderNavigationHandler.startSearch(responderViewController)
            //2. add controller with table view
            if let unwrappedVC = suggestionsViewController {
                responderNavigationHandler.showSuggestions(unwrappedVC, from: responderViewController)
            }
        } else if state == .expanded && searchState == .finished {
            //1. show table view at the bottom
            if let unwrappedVC = suggestionsViewController {
                searchState = .started
                responderNavigationHandler.showExpandedSuggesstions(unwrappedVC, from: responderViewController)
            }
        }
    }
    
    @objc private func didEndSearch(_ notification: Notification) {
        if searchState == .started {
            //1. remove table view at any case of state
            searchState = .finished
            if state == .collapsed {
                responderNavigationHandler.endSearch(responderViewController)
            }
            if let unwrappedVC = suggestionsViewController {
                responderNavigationHandler.hideSuggestions(unwrappedVC)
            }
        }
    }
    
    @objc private func didUpdate(_ notification: Notification) {
        if searchState == .started {
            if let receivers = notification.userInfo?["receivers"] as? [EmailReceiver],
                let shouldAppend = notification.userInfo?["shouldAppend"] as? Bool {
                suggestionsViewController?.updateData(with: receivers, append: shouldAppend)
            }
        }
    }
    
    func append(_ receiver: EmailReceiver) {
        responderViewController.append(receiver)
        hideSuggestions()
        NotificationCenter.default.post(name: Notification.Name(rawValue: SearchNotificationName.clearText), object: nil)
    }
    
    func requestMoreContacts() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SearchNotificationName.paging), object: nil)
    }
    
    func hideSuggestions() {
        if let unwrappedVC = suggestionsViewController {
            responderNavigationHandler.hideSuggestions(unwrappedVC)
            responderNavigationHandler.endSearch(responderViewController)
            searchState = .finished
        }
    }
    
    // MARK: - Expand action
    
    lazy var onExpandAction: () -> Void = { [weak self] in
        if let unwrappedVC = self?.suggestionsViewController, let responderVC = self?.responderViewController {
            if self?.searchState == .started {
                if self?.state == .collapsed {
                    self?.responderNavigationHandler.hideSuggestions(unwrappedVC)
                    self?.responderNavigationHandler.endSearch(responderVC)
                } else if self?.state == .expanded {
                    self?.responderNavigationHandler.hideSuggestions(unwrappedVC)
                }
                self?.searchState = .finished
            }
        }
        if let unwrappedController = self?.responderViewController {
            if self?.state == .collapsed {
                self?.state = .expanded
                self?.responderNavigationHandler.expand(unwrappedController)
            } else if self?.state == .expanded {
                self?.state = .collapsed
                self?.responderNavigationHandler.collapse(unwrappedController, to: self?.lastResponderHeight)
            }
        }
    }
    
    // MARK: - Contacts suggestions
    
    lazy fileprivate var onSelectAction: (EmailReceiver) -> Void = { [weak self] receiver in
        self?.append(receiver)
    }
    
    lazy fileprivate var onMoreContacts: () -> Void = { [weak self] in
        self?.requestMoreContacts()
    }
    
    // MARK: - Minimization
    
    lazy var onTextViewExpanded: (CGFloat) -> Void = { delta in
        let finalHeight = self.responderViewController.view.frame.size.height - delta
        if finalHeight < self.responderNavigationHandler.defaultHeight {
            self.lastResponderHeight = nil
            self.responderNavigationHandler.collapse(self.responderViewController, to: self.lastResponderHeight)
            return
        }
        self.responderViewController.view.frame.size.height -= delta
        self.responderViewController.view.frame.origin.y += delta
        let newHeight = self.responderViewController.view.frame.height
        
        self.responderViewController.accessoryView?.frame.size.height = newHeight
        self.responderViewController.accessoryView?.updateLayout(for: newHeight)
        self.lastResponderHeight = self.responderViewController.view.frame.height
        self.onResponderExpanded?(delta)
    }
    
    func collapseWithoutAttachments() {
        //MARK: - change last responder height when attachments removed
        var delta: CGFloat = 0
        if self.responderViewController.config?.goal == ResponderGoal.forward {
            delta = 0.096
        }
        if self.lastResponderHeight != nil {
            self.lastResponderHeight! -= (0.15 + delta) * UIScreen.main.bounds.width
        }
        isFirstAttachmentAdded = true
        self.responderNavigationHandler.collapse(self.responderViewController, to: nil)
    }
    
    func changeSizeWithAttachments() {
        if state == .collapsed || state == .expanded {
            var totalHeight = 0.336 * UIScreen.main.bounds.width
            if (self.responderViewController.accessoryView?.isAttchmentsExist())! {
                var delta: CGFloat = 0
                if self.responderViewController.config?.goal == ResponderGoal.forward {
                    delta = 0.096
                }
                totalHeight = (0.336 + 0.15 + delta) * UIScreen.main.bounds.width
                ///MARK: - change last responder height when attachments added
                if isFirstAttachmentAdded {
                    if self.lastResponderHeight != nil {
                        self.lastResponderHeight! += (0.15 + delta) * UIScreen.main.bounds.width
                    }
                    isFirstAttachmentAdded = false
                }
            }
            let newHeight: CGFloat = self.lastResponderHeight == nil ? totalHeight : self.lastResponderHeight!
            let delta = newHeight - self.responderViewController.view.frame.height
            self.responderViewController.view.frame.origin.y -= delta
            self.responderViewController.view.frame.size.height = newHeight
            self.responderViewController.accessoryView?.frame.size.height = newHeight
            self.responderViewController.accessoryView?.updateLayout(for: newHeight)
        } else if state == .minimized {
            changeSize()
        }
    }
    
    func minimize() {
        if !shouldMinimize { return }
        if !configuration.isMinimizationEnabled {
            return
        }
        if state == .collapsed {
            state = .minimized
            responderViewController.accessoryView?.removeFirstResponder()
            self.responderViewController.accessoryView?.updateTextFieldForMinimizedState(with: self.configuration.message)
            UIView.animate(withDuration: 0.2, animations: {
                self.responderViewController.view.frame = self.responderNavigationHandler.initialResponderMinimizeFrame
                self.responderViewController.accessoryView?.minimize()
            }, completion: { _ in
                self.responderViewController.accessoryView?.center()
                let originY = self.responderViewController.view.frame.origin.y
                self.onResponderMinimized?(originY)
            })
        }
    }
    
    func collapseFrame() {
        UIView.animate(withDuration: 0.2, animations: {
            var totalHeight = 0.336 * UIScreen.main.bounds.width
            if (self.responderViewController.accessoryView?.isAttchmentsExist())! {
                var delta: CGFloat = 0
                if self.responderViewController.config?.goal == ResponderGoal.forward {
                    delta = 0.096
                }
                totalHeight = (0.336 + 0.15 + delta) * UIScreen.main.bounds.width
            }
            let newHeight: CGFloat = self.lastResponderHeight == nil ? totalHeight : self.lastResponderHeight!
            
            var offsetWithIphoneX: CGFloat = 0
            if #available(iOS 11.0, *) {
                offsetWithIphoneX = ((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!
            }
            
            let delta = newHeight - self.responderViewController.view.frame.size.height - offsetWithIphoneX
            self.responderViewController.view.frame.origin.y -= delta
            self.responderViewController.view.frame.size.height = newHeight
            self.responderViewController.accessoryView?.makeRegular()
            if self.lastResponderHeight != nil {
                self.responderViewController.accessoryView?.frame.size.height = newHeight
                self.responderViewController.accessoryView?.updateLayout(for: newHeight)
            }
        }, completion: { _ in
            self.responderViewController.accessoryView?.updateTextFieldForRegularState(with: self.configuration.message)
            let originY = self.responderViewController.view.frame.origin.y
            self.onResponderShown?(originY)
        })
    }
    
    func changeSize() {
        if state == .minimized {
            state = .collapsed
            collapseFrame()
        } else if state == .collapsed {
            self.minimize()
        }
    }
    
    func setPreviousState() {
        if state == .minimized {
            self.minimize()
        } else if state == .collapsed {
            collapseFrame()
        }
    }
}
