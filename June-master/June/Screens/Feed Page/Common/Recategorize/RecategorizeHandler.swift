//
//  RecategorizeHandler.swift
//  June
//
//  Created by Ostap Holub on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class RecategorizeHandler {
    
    // MARK: - Variables & Constants
    private unowned var rootViewController: UIViewController
    private var actionSheetHandler: RecategorizeActionSheetHandler
    private var apiService: RecategorizeAPIService
    private var pendingItem: FeedItem?
    private var workItem: DispatchWorkItem?
    
    private let convoCategory = FeedCategory(id: "conversations", title: LocalizedStringKey.RecategorizeHelper.conversationTitle)
    
    private lazy var notificationViewPresenter: NotificationViewPresenter = {
        let presenter = NotificationViewPresenter()
        presenter.delegate = self
        return presenter
    }()
    
    var onRecategorizeStarted: ((FeedItem, FeedCategory, FeedCategory) -> Void)?
    var onRecategorizeFailed: ((FeedItem, String) -> Void)?
    var onRecategorizeCanceled: ((FeedItem) -> Void)?
    
    // MARK: - Initialization
    
    init(rootVC: UIViewController, categories: [FeedCategory]) {
        rootViewController = rootVC
        apiService = RecategorizeAPIService()
        actionSheetHandler = RecategorizeActionSheetHandler(presentingVC: rootVC, categories: categories)
    }
    
    // MARK: - Handle recategorize flow
    
    func recategorize(_ thread: Threads) {
        pendingItem = FeedItem(with: thread, category: convoCategory)
        if let unwrappedItem = pendingItem {
            startRecategorize(for: unwrappedItem)
        }
    }
    
    func startRecategorize(for item: FeedItem) {
        pendingItem = item
        apiService.onErrorResponse = onRecategorizeFailed
        actionSheetHandler.onSelectCategory = onCategorySelected
        actionSheetHandler.show(for: item)
    }
    
    // MARK: - On new category selescted action handling
    
    private lazy var onCategorySelected: (FeedCategory) -> Void = { [weak self] category in
        if let item = self?.pendingItem {
            self?.notificationViewPresenter.show(animated: true, title: "Moved to '\(category.title)'")
            if let currentCategory = item.feedCategory {
                self?.onRecategorizeStarted?(item, currentCategory, category)
            }
            self?.createWorkItem(item, categoryId: category.id)
        }
    }
    
    // MARK: - Build work item logic
    
    private func createWorkItem(_ item: FeedItem, categoryId: String) {
        workItem = nil
        workItem = DispatchWorkItem(block: { [weak self] in
            self?.apiService.changeCategory(of: item, toCategoryWith: categoryId)
        })
    }
}

    // MARK: - NotificationViewPresenterDelegate

extension RecategorizeHandler: NotificationViewPresenterDelegate {
    
    func didTapOnUndoButton(_ button: UIButton) {
        workItem = nil
        if let item = pendingItem {
            onRecategorizeCanceled?(item)
        }
    }
    
    func didHideViewAfterDelay(_ view: NotificationView) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.workItem?.perform()
        }
    }
}

