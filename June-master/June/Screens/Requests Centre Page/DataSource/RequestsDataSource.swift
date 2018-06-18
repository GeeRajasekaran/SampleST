//
//  RequestsDataSource.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsDataSource: NSObject {
    
    private weak var builder: RequestsScreenBuilder?
    
    var onViewChangedAction: ((Int, CGFloat) -> Void)?
    var onReplyCell: ((RequestItem, RightImageButton) -> Void)?
    
    var onDiscardDraftAction: ((RequestItem, DraftInfo) -> Void)?
    var onEditDraftAction: ((RequestItem, DraftInfo) -> Void)?
    
    var onApprovedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onIgnoredCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onBlockedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onDeniedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    var onUnblockedCell: ((UISelectableButton, UITableViewCell, RequestItem) -> Void)?
    
    var onOpenAttachment: ((Attachment) -> Void)?
    
    lazy private var onViewChanged: (RequestItem, CGFloat) -> Void = { [weak self] i, h -> Void in
        if let strongSelf = self, let index = strongSelf.builder?.dataRepository?.index(of: i) {
            let currentHeight = strongSelf.builder?.height(for: IndexPath(row: index, section: 0))
            if currentHeight != h {
                strongSelf.onViewChangedAction?(index, h)
            }
        }
    }
    
    lazy private var onHeightChanged: (RequestItem, CGFloat) -> Void = { [weak self] i, h -> Void in
        if let strongSelf = self, let index = strongSelf.builder?.dataRepository?.index(of: i) {
            let currentHeight = strongSelf.builder?.height(for: IndexPath(row: index, section: 0))
            if currentHeight != h {
                strongSelf.onViewChangedAction?(index, h)
            }
        }
    }
    
    init(builder: RequestsScreenBuilder?) {
        self.builder = builder
    }
    
    //MARK: - cell configuration
    func cellForScreenType(_ screenType: RequestsScreenType, tableView: UITableView, withModel dataModel: BaseTableModel, indexPath: IndexPath) -> UITableViewCell {
        
        switch screenType {
        case .people:
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.reuseIdentifier(), for: indexPath) as! PeopleTableViewCell
            let buttonsView = PeopleButtonsView()
            buttonsView.setupSubviews()
            cell.onReplyCell = onReplyCell
            cell.onApprovedCell = onApprovedCell
            cell.onIgnoredCell = onIgnoredCell
            cell.onBlockedCell = onBlockedCell
            cell.onHeightChanged = onHeightChanged
            cell.onDiscardDraftAction = onDiscardDraftAction
            cell.onEditDraftAction = onEditDraftAction
            cell.onOpenAttachment = onOpenAttachment
            cell.setupUI(with: buttonsView)
            cell.loadData(dataModel as! RequestItem, completion: onViewChanged)
            return cell
        case .subscriptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionsTableViewCell.reuseIdentifier(), for: indexPath) as! SubscriptionsTableViewCell
            let buttonsView = SubscriptionsButtonsView()
            buttonsView.setupSubviews()
            cell.onApprovedCell = onApprovedCell
            cell.onDeniedCell = onDeniedCell
            cell.setupUI(with: buttonsView)
            cell.loadData(dataModel as! RequestItem, completion: onViewChanged)
            return cell
        case .blockedPeople:
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.reuseIdentifier(), for: indexPath) as! PeopleTableViewCell
            let buttonsView = BlockedRequestsButtonsView()
            buttonsView.setupSubviews()
            cell.onReplyCell = onReplyCell
            cell.onUnblockedCell = onUnblockedCell
            cell.onHeightChanged = onHeightChanged
            cell.onDiscardDraftAction = onDiscardDraftAction
            cell.onEditDraftAction = onEditDraftAction
            cell.onOpenAttachment = onOpenAttachment
            cell.setupUI(with: buttonsView)
            cell.loadData(dataModel as! RequestItem, completion: onViewChanged)
            return cell
        case .blockedSubscriptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionsTableViewCell.reuseIdentifier(), for: indexPath) as! SubscriptionsTableViewCell
            let buttonsView = BlockedRequestsButtonsView()
            buttonsView.setupSubviews()
            cell.onUnblockedCell = onUnblockedCell
            cell.setupUI(with: buttonsView)
            cell.loadData(dataModel as! RequestItem, completion: onViewChanged)
            return cell
        }
    }
}

extension RequestsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = builder?.loadSections().count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalCount = 0
        if let sectionType = builder?.loadSections()[section] {
            if let count = builder?.loadRows(withSection: sectionType).count {
                totalCount = count
            }
        }
        builder?.addNoResultsViewIfNeeded(count: totalCount, withTableView: tableView)
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = builder?.rowType(at: indexPath) else {
            print("\(#file) at line \(#line): Failed to fetch item for index \(indexPath.row) in Requests Page")
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
        guard let screenType = builder?.loadSegment() as? RequestsScreenType, let sectionType = builder?.loadSections()[indexPath.section] as? RequestsSectionType else { return UITableViewCell() }
        guard let dataModel = builder?.loadModel(for: sectionType, rowType: rowType, forPath: indexPath) else { return UITableViewCell() }
        return cellForScreenType(screenType, tableView: tableView, withModel: dataModel, indexPath: indexPath)
    }
}
