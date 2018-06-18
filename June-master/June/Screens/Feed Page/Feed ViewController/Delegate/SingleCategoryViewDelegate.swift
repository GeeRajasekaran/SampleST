//
//  SingleCategoryViewDelegate.swift
//  June
//
//  Created by Ostap Holub on 8/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol SingleCategorySelectionDelegate: class {
    func delegate(_ selectionDelegate: SingleCategoryViewDelegate, didSelect card: FeedItem, with cardView: IFeedCardView?)
    func delegateDidRecategorize(card: FeedItem)
}

class SingleCategoryViewDelegate: NSObject {
    
    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    weak var category: FeedCategory?
    weak var delegate: SingleCategorySelectionDelegate?
    private weak var dataProvider: ThreadsDataProvider?
    private weak var singleCategoryDataRepository: SingleCategoryDataRepository?
    weak var swipyCellHandler: SwipyCellHandler?
    
    init(storage: SingleCategoryDataRepository?, category: FeedCategory?, provider: ThreadsDataProvider?) {
        singleCategoryDataRepository = storage
        dataProvider = provider
        self.category = category
        super.init()
    }
    
    func buildCardView(_ tableView: UITableView, forRowAt indexPath: IndexPath, and item: FeedItem) -> IFeedCardView? {
        if let cell = tableView.cellForRow(at: indexPath) as? FeedItemCell {
            let model = item.type == .news ? FeedNewsItemInfo(thread: item.threadEntity) : FeedGenericItemInfo(thread: item.threadEntity)
            var cardView = FeedCardViewBuilder.cardView(for: item.type, at: cell.frame, at: indexPath)
            cardView.itemInfo = model
            cardView.setupSubviews()
            cardView.loadItemData()
            return cardView
        }
        return nil
    }
}

extension SingleCategoryViewDelegate: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        swipyCellHandler?.cancelSwipeForPendigCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let unwrappedCategory = category {
            if let section = singleCategoryDataRepository?.sectionsCount, let rows = singleCategoryDataRepository?.countOfRows(in: section - 1) {
                if indexPath.section == section - 1 && indexPath.row == rows - 1 && unwrappedCategory.shouldLoad {
                    dataProvider?.requestThreads(for: unwrappedCategory, shouldSkip: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = singleCategoryDataRepository?.item(in: indexPath.section, at: indexPath.row) {
            return FeedCardViewBuilder.height(for: item)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = singleCategoryDataRepository?.item(in: indexPath.section, at: indexPath.row) {
            delegate?.delegate(self, didSelect: item, with: buildCardView(tableView, forRowAt: indexPath, and: item))
        }
    }
    
    // MARK: - Headers related logic
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.09 * screenWidth : 0.07 * screenWidth
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let timestamp = singleCategoryDataRepository?.item(in: section, at: 0)?.date else { return nil }
        let view = SingleCategoryHeaderView()
        view.setupSubviews(with: timestamp)
        return view
    }
}
