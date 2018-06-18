//
//  SingleCategoryViewDataSource.swift
//  June
//
//  Created by Ostap Holub on 8/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SingleCategoryViewDataSource: NSObject {
    
    // MARK: - Variables & Constants
    private weak var singleCategoryDataRepository: SingleCategoryDataRepository?
    let swipyCellHandler = SwipyCellHandler()
    private weak var currentCategory: FeedCategory?
    
    var onMoreOptionsAction: ((FeedItem) -> Void)?
    var onStar: ((FeedItem) -> Void)?
    var onRecategorize: ((FeedItem) -> Void)?
    var onShare: ((FeedItem, IndexPath) -> Void)?
    
    init(storage: SingleCategoryDataRepository?, category: FeedCategory?) {
        singleCategoryDataRepository = storage
        currentCategory = category
        super.init()
    }
    
    private func item(at viewIndex: IndexPath) -> FeedItem? {
        return singleCategoryDataRepository?.item(in: viewIndex.section, at: viewIndex.row)
    }
    
    private lazy var onTapRemoveBookmark: (IndexPath) -> Void = { [weak self] index in
        guard let singleItem = self?.item(at: index) else { return }
        self?.onStar?(singleItem)
    }
    
    private lazy var onStarActionTriggered: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        guard let singleItem = self?.item(at: viewIndex) else { return }
        DispatchQueue.main.async {
            cell.swipeToOrigin {
                self?.onStar?(singleItem)
            }
        }
    }
    
    private lazy var onRecategorizeAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        guard let singleItem = self?.item(at: viewIndex) else { return }
        DispatchQueue.main.async {
            cell.swipeToOrigin {
                self?.onRecategorize?(singleItem)
            }
        }
    }
    
    private lazy var onShareAction: (IndexPath, FeedSwipyCell) -> Void = { [weak self] viewIndex, cell in
        guard let singleItem = self?.item(at: viewIndex) else { return }
        DispatchQueue.main.async {
            cell.swipeToOrigin {
                self?.onShare?(singleItem, viewIndex)
            }
        }
    }
}

extension SingleCategoryViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = singleCategoryDataRepository?.sectionsCount {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = singleCategoryDataRepository?.countOfRows(in: section) {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = singleCategoryDataRepository?.item(in: indexPath.section, at: indexPath.row) else {
            print("\(#file) at line \(#line): Failed to fetch item for index \(indexPath.row) in category \(currentCategory?.title ?? "")")
            return UITableViewCell()
        }
        
        let dataModel = item.type == .news ? FeedNewsItemInfo(thread: item.threadEntity) : FeedGenericItemInfo(thread: item.threadEntity)
        let cell = FeedCellsFactory.cell(for: item, at: indexPath, for: tableView)
        var cardView = FeedCardViewBuilder.cardView(for: item.type, at: cell.frame, at: indexPath)
        cardView.itemInfo = dataModel
        cardView.onRemoveBookmarkAction = onTapRemoveBookmark
        cell.set(feedView: cardView)
        
        swipyCellHandler.configure(feedCell: cell, at: indexPath, with: [onStarActionTriggered], rightActions: [onRecategorizeAction, onShareAction], item: dataModel)
        
        return cell
    }
}
