//
//  StatusButtonHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/19/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlertBar

class StatusButtonsHandler {

    var tableView: UITableView?
    var onItemsCountChanged: ((Int) -> Void)?
    var onError: ((String) -> Void)?
    
    private weak var builder: RequestsScreenBuilder?
    private unowned var statusWorker: StatusWorker
    
    private var lastTappedRequestItem: RequestItem?
    private var lastTappedIndexPath: IndexPath?
    
    lazy var notificationViewPresenter: NotificationViewPresenter = { [unowned self] in
        let presenter = NotificationViewPresenter()
        presenter.delegate = self
        return presenter
    }()
    
    init(builder: RequestsScreenBuilder?, statusWorker: StatusWorker? = nil) {
        if let unwrappedWorker = statusWorker {
            self.statusWorker = unwrappedWorker
        } else {
            self.statusWorker = StatusWorker()
        }
        self.builder = builder
    }
    
    //MARK: - approve, ignore, block, deny actions
    lazy var onApprovedTapped: (UISelectableButton, UITableViewCell, RequestItem) -> Void = { [weak self] button, cell, item in
        self?.changeStatus(status: .approved, for: cell, with: item, notification: LocalizedStringKey.RequestsViewHelper.ApprovedTitile)
    }
    
    lazy var onIgnoredTapped: (UISelectableButton, UITableViewCell, RequestItem) -> Void = { [weak self] button, cell, item in
        self?.changeStatus(status: .ignored, for: cell, with: item, notification: LocalizedStringKey.RequestsViewHelper.IgnoredTitile)
    }
    
    lazy var onBlockedTapped: (UISelectableButton, UITableViewCell, RequestItem) -> Void = { [weak self] button, cell, item in
        self?.changeStatus(status: .blocked, for: cell, with: item)
    }
    
    lazy var onDenyTapped: (UISelectableButton, UITableViewCell, RequestItem) -> Void = { [weak self] button, cell, item in
        self?.changeStatus(status: .denied, for: cell, with: item, notification: LocalizedStringKey.RequestsViewHelper.DeniedTitile)
    }
    
    lazy var onUnblockedTapped: (UISelectableButton, UITableViewCell, RequestItem) -> Void = { [weak self] button, cell, item in
        self?.changeStatus(status: .unblock, for: cell, with: item)
    }
    
    //MARK: - Approve, Ignore, Blocked logic
    //MARK: - change status with notification view
    func changeStatus(status: Status, for cell: UITableViewCell, with requestItem: RequestItem, notification text: String) {
        guard let contact = requestItem.contactEntity else { return }
        statusWorker.change(contact, with: status, and: 2.5) { [weak self] result in
            if result != "" {
                AlertBar.show(.error, message: result)
                self?.onError?(result)
            }
        }
        notificationViewPresenter.show(title: text)
        remove(contactCell: cell, with: requestItem)
    }
    
    //MARK: - change status without notification view
    func changeStatus(status: Status, for cell: UITableViewCell, with requestItem: RequestItem) {
        guard let contact = requestItem.contactEntity else { return }
        statusWorker.change(contact, with: status) { [weak self] result in
            if result != "" {
                AlertBar.show(.error, message: result)
                self?.onError?(result)
            }
        }
        remove(contactCell: cell, with: requestItem)
    }
    
    func remove(contactCell cell: UITableViewCell, with requestItem: RequestItem) {
        guard let index = builder?.dataRepository?.index(of: requestItem) else { return }
        let indexPath = IndexPath(row: index, section: RequestsSectionType.section.rawValue)
        lastTappedIndexPath = indexPath
        lastTappedRequestItem = requestItem
        builder?.dataRepository?.remove(requestItem)
        onItemsCountChanged?(-1)
        tableView?.deleteRows(at: [indexPath], with: .top)
    }
    
    func removeAllPendingItems() {
        statusWorker.cancelAll()
    }

    func undoContact() {
        guard let indexPath = lastTappedIndexPath, let requestItem = lastTappedRequestItem else { return }
        builder?.dataRepository?.add(requestItem, at: indexPath.row)
        onItemsCountChanged?(1)
        tableView?.insertRows(at: [indexPath], with: .top)
    }
}

extension StatusButtonsHandler: NotificationViewPresenterDelegate {
    func didTapOnUndoButton(_ button: UIButton) {
        undoContact()
        statusWorker.cancelLast()
    }
    
    func didHideViewAfterDelay(_ view: NotificationView) {
        
    }
}
