//
//  FeedPageDataSource.swift
//  June
//
//  Created by Ostap Holub on 1/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedPageDataSource: NSObject, UITableViewDataSource {
    
    private weak var builder: FeedScreenBuilder?
    var onBookmarkedSwitchAction: ((Bool) -> Void)?
    var onCollapseBriefCategory: (() -> Void)?
    var onViewMoreAction: (() -> Void)?
    var onRequestItemClicked: (() -> Void)?
    
    var onRequestNotificationClosed: (() -> Void)?
    
    init(builder: FeedScreenBuilder?) {
        self.builder = builder
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = builder?.loadSections().count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionType = builder?.loadSections()[section] {
            return builder?.loadRows(withSection: sectionType).count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionType = builder?.loadSections()[indexPath.section] as? FeedSectionType,
            let rowType = builder?.loadRows(withSection: sectionType)[indexPath.row] as? FeedRowType else { return UITableViewCell() }
        
        let dataModel = builder?.loadModel(for: sectionType, rowType: rowType, forPath: indexPath)

        switch rowType {
        case .todayHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedMostRecentHeaderCell.reuseIdentifier(), for: indexPath) as! FeedMostRecentHeaderCell
            cell.setupSubviews(for: dataModel!)
            cell.onSwitchValueChanged = onBookmarkedSwitchAction
            return cell
        case .generic, .news:
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedGenericCardTableViewCell.reuseIdentifier(), for: indexPath) as! FeedItemCell
            builder?.bind(model: dataModel, to: cell, at: indexPath, with: rowType)
            return cell
        case .earlierHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedEarlierHeaderCell.reuseIdentifier(), for: indexPath) as! FeedEarlierHeaderCell
            cell.setupSubviews(for: dataModel!)
            return cell
        case .briefHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefHeaderCell.reuseIdentifier(), for: indexPath) as! BriefHeaderCell
            cell.setupSubviews()
            cell.load(model: dataModel)
            return cell
        case .briefCategory:
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCategoryCell.reuseIdentifier(), for: indexPath) as! BriefCategoryCell
            cell.setupSubviews()
            cell.load(model: dataModel)
            return cell
        case .briefRequests:
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefRequestsCell.reuseIdentifier(), for: indexPath) as! BriefRequestsCell
            cell.setupSubviews()
            cell.onRequestItemClicked = onRequestItemClicked
            cell.load(model: dataModel)
            return cell
        case .briefGenericItem, .briefWideItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefItemCell.reuseIdentifier(), for: indexPath) as! BriefItemCell
            cell.setupSubviews()
            cell.cardView = FeedCardViewBuilder.cardView(for: rowType, at: cell.frame, at: indexPath)
            guard let feedInfo = dataModel as? FeedGenericItemInfo else { return cell }
            cell.cardView?.itemInfo = feedInfo
            cell.cardView?.loadItemData()
            return cell
        case .briefCategoryControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCategoryControlCell.reuseIdentifier(), for: indexPath) as! BriefCategoryControlCell
            cell.setupSubviews()
            cell.onCollapseBriefCategory = onCollapseBriefCategory
            cell.onViewMoreAction = onViewMoreAction
            cell.load(model: dataModel)
            return cell
        case .emptyToday:
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedEmptyTodayTableViewCell.reuseIdentifier(), for: indexPath) as! FeedEmptyTodayTableViewCell
            cell.setupSubviews()
            return cell
        case .emptyBookmarks:
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedEmptyBookmarksTableViewCell.reuseIdentifier(), for: indexPath) as! FeedEmptyBookmarksTableViewCell
            cell.setupSubviews()
            return cell
        case .pendingSubscriptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: PendingRequestTableViewCell.reuseIdentifier(), for: indexPath) as! PendingRequestTableViewCell
            cell.setupSubviews()
            cell.onClose = onRequestNotificationClosed
            if let pendingModel = dataModel as? PendingRequestItemInfo {
                cell.loadModel(pendingModel)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
