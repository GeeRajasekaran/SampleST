//
//  FeedViewHelper.swift
//  June
//
//  Created by Ostap Holub on 1/15/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedViewHelper {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var swipyCellHandler: SwipyCellHandler = SwipyCellHandler()
    private weak var dataRepository: FeedDataRepository?
    
    var onStar: ((IndexPath) -> Void)?
    var onRecategorize: ((IndexPath) -> Void)?
    var onShare: ((IndexPath) -> Void)?
    
    // MARK: - Initialization
    
    init(storage: FeedDataRepository?) {
        dataRepository = storage
    }
    
    // MARK: - Height calculations logic
    
    func height(for rowType: FeedRowType, at tableView: UITableView) -> CGFloat {
        var cardHeight: CGFloat = 0
        if rowType == .news {
            cardHeight = 0.37 * screenWidth
        } else if rowType == .briefHeader {
            return 0.253 * screenWidth
        } else if rowType == .briefCategory {
            return 0.173 * screenWidth
        } else if rowType == .briefRequests {
            return 0.178 * screenWidth
        } else if rowType == .briefCategoryControl {
            return 0.16 * screenWidth
        } else if rowType == .briefGenericItem {
            cardHeight = 0.2 * screenWidth
        } else if rowType == .briefWideItem {
            cardHeight = 0.306 * screenWidth
        } else if rowType == .emptyToday {
            return 0.6 * screenWidth
        } else if rowType == .emptyBookmarks {
            let tableViewHeight: CGFloat = tableView.frame.height
            return tableViewHeight - 0.197 * screenWidth - 0.173 * screenWidth
        } else if rowType == .pendingSubscriptions {
            return PendingRequestTableViewCell.fixedHeight()
        } else {
            cardHeight = 0.224 * screenWidth
        }
        return FeedGenericCardLayoutConstants.topInset + cardHeight + FeedGenericCardLayoutConstants.bottomInset
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        if section == 0 {
            return 0.197 * screenWidth
        } else if section == 2 {
            return 0.106 * screenWidth
        }
        return 0
    }
    
    // MARK: - Feed cell swipes configuration
    
    private lazy var onBookmarkAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        DispatchQueue.main.async {
            cell.swipeToOrigin {
                self?.onStar?(viewIndex)
            }
        }
    }
    
    private lazy var onRecategorizeAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        cell.swipeToOrigin {
            self?.onRecategorize?(viewIndex)
        }
    }
    
    private lazy var onShareAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        cell.swipeToOrigin {
            self?.onShare?(viewIndex)
        }
    }
    
    func configureSwipe(for cell: FeedItemCell, at indexPath: IndexPath, with model: BaseTableModel?) {
        guard let feedInfo = model as? FeedGenericItemInfo else { return }
        swipyCellHandler.configure(feedCell: cell, at: indexPath, with: [onBookmarkAction], rightActions: [onRecategorizeAction, onShareAction], item: feedInfo)
    }
    
    func updateSwipeView(at indexPath: IndexPath, with item: FeedItem) {
        if let view = swipyCellHandler.leftViewsMap[indexPath.section]?[indexPath.row] {
            view.updateIcon(item.starred)
        }
    }
    
    func cancelSwipeForPendigCell() {
        swipyCellHandler.cancelSwipeForPendigCell()
    }
}
