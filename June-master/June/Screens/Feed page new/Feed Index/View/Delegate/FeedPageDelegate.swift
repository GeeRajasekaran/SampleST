//
//  FeedPageDelegate.swift
//  June
//
//  Created by Ostap Holub on 1/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedPageDelegate: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var builder: FeedScreenBuilder?
    weak var dataRepository: FeedDataRepository?
    var onSelectItem: ((IndexPath) -> Void)?
    var onBriefClicked: ((IndexPath) -> Void)?
    var onBirefItemSelected: ((Threads?) -> Void)?
    var onRequestItemClicked: (() -> Void)?
    
    var onPendingSubscriptionsClicked: (() -> Void)?
    
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var pendingThread: Threads?
    
    // MARK: - Initialization
    
    init(builder: FeedScreenBuilder?) {
        self.builder = builder
    }
}

extension FeedPageDelegate: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        builder?.cancelSwipeForPendigCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataRepository?.isBookmarksActive == true {
            handleBookmarksPagination(for: indexPath, in: tableView)
        } else if dataRepository?.isBookmarksActive == false {
            handleRegularPagination(for: indexPath, in: tableView)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let section = (builder?.loadSections() as? [FeedSectionType])?[indexPath.section],
                let row = (builder?.loadRows(withSection: section) as? [FeedRowType])?[indexPath.row] else { return }
            if row == .pendingSubscriptions {
                onPendingSubscriptionsClicked?()
            }
            if indexPath.row > 1 {
                if row == .briefCategory {
                    let index = IndexPath(row: indexPath.row - 2, section: indexPath.section)
                    onBriefClicked?(index)
                } else if row == .briefWideItem || row == .briefGenericItem {
                    guard let dataModel = builder?.loadModel(for: section, rowType: row, forPath: indexPath),
                         let info = dataModel as? FeedGenericItemInfo else { return }
                    pendingThread = info.thread
                    onBirefItemSelected?(info.thread)
                } else if row == .briefRequests {
                    onRequestItemClicked?()
                }
            }
        } else if indexPath.section == 1 {
            let index = IndexPath(row: indexPath.row, section: indexPath.section - 1)
            onSelectItem?(index)
        } else if indexPath.section == 2 {
            let index = IndexPath(row: indexPath.row - 1, section: indexPath.section - 1)
            onSelectItem?(index)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section != 1 {
            return builder?.headerHeight(for: indexPath.section) ?? 0
        }
        return builder?.height(for: indexPath, at: tableView) ?? 0
    }
    
    // MARK: - Private pagination logic
    
    private func handleRegularPagination(for indexPath: IndexPath, in tableView: UITableView) {
        let rowsCount = tableView.numberOfRows(inSection: 2)
        if indexPath.section == 2 && indexPath.row == rowsCount - 1 {
            guard let mostRecentCount = dataRepository?.mostRecentItemsCount,
                let recentCount = dataRepository?.recentItemsCount else { return }
            let totalCount = recentCount + mostRecentCount
            if totalCount != 0 {
                dataRepository?.threadsDataProvider.requestRecentThreads(skipCount: totalCount, bookmarkedOnly: false)
            }
        }
    }
    
    private func handleBookmarksPagination(for indexPath: IndexPath, in tableView: UITableView) {
        let rowsCount = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == rowsCount - 1 {
            guard let skipCount = dataRepository?.bookmarkedItems.count else { return }
            dataRepository?.threadsDataProvider.requestRecentThreads(skipCount: skipCount, bookmarkedOnly: true)
        }
    }
    
    // MARK: - Selection logic
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let section = (builder?.loadSections() as? [FeedSectionType])?[indexPath.section],
            let row = (builder?.loadRows(withSection: section) as? [FeedRowType])?[indexPath.row] else { return true }
        guard row != .pendingSubscriptions else { return true }
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedItemCell else { return false }
        cell.performScaleDown()
        return true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let section = (builder?.loadSections() as? [FeedSectionType])?[indexPath.section],
            let row = (builder?.loadRows(withSection: section) as? [FeedRowType])?[indexPath.row] else { return }
        guard row != .pendingSubscriptions else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedItemCell else { return }
        cell.performScaleUp()
    }
}
