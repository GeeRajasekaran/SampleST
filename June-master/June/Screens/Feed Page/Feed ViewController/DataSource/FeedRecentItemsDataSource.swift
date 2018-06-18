//
//  FeedRecentItemsDataSource.swift
//  June
//
//  Created by Ostap Holub on 11/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedRecentItemsDataSource: NSObject {
    
    // MARK: - Variables & constants
    
    private weak var dataRepository: FeedDataRepository?
    var onMoreOptions: ((FeedItem) -> Void)?
    var onRecategorize: ((FeedItem) -> Void)?
    var rightSwipeViews = [FeedRightSwipeView]()
    var leftSwipeViews = [FeedLeftSwipeView]()
    let swipyCellHandler = SwipyCellHandler()
    private var onStar: ((FeedItem) -> Void)?
    
    // MARK: - Initialization
    
    init(storage: FeedDataRepository?, onStarAction: ((FeedItem) -> Void)?) {
        dataRepository = storage
        onStar = onStarAction
        super.init()
    }
    
    private lazy var onStarActionTriggered: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        if let item = self?.dataRepository?.item(at: viewIndex) {
            DispatchQueue.main.async {
                cell.swipeToOrigin {
                    self?.onStar?(item)
                }
            }
        }
    }
    
    private lazy var onRecategorizeAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        if let item = self?.dataRepository?.item(at: viewIndex) {
            cell.swipeToOrigin {
                self?.onRecategorize?(item)
            }
        }
    }
    
    private lazy var onShareAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        cell.swipeToOrigin {
            print("Call share action here")
        }
    }
}
    // MARK: - UITableViewDataSource

extension FeedRecentItemsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let count = self.dataRepository?.mostRecentItemsCount {
                return count
            }
        } else if section == 1 {
            if let count = self.dataRepository?.recentItemsCount {
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var item: FeedItem?
        if indexPath.section == 0 {
            item = dataRepository?.todayItem(at: indexPath.row)
        } else if indexPath.section == 1 {
            item = dataRepository?.item(at: indexPath)
        }
        
        guard let unwrappedItem = item else {
            print("\(#file) at line \(#line): Failed to fetch item for index \(indexPath.row)")
            return UITableViewCell()
        }
        let cell = FeedCellsFactory.cell(for: unwrappedItem, at: indexPath, for: tableView)
//        if  let action = onMoreOptions {
//            var cardView = FeedCardViewBuilder.cardView(for: unwrappedItem, at: cell.frame)
//            cardView.item = unwrappedItem
//            cardView.onMoreOptionsAction = action
//            cell.set(feedView: cardView)
//            swipyCellHandler.configure(feedCell: cell, at: indexPath, with: [onRecategorizeAction, onShareAction], rightActions: [onStarActionTriggered], item: unwrappedItem)
//        }
        return cell
    }
}
