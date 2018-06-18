//
//  FeedRecentItemsDelegate.swift
//  June
//
//  Created by Ostap Holub on 11/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedRecentItemsDelegate: NSObject {
    
    // MARK: - Variables & constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private weak var dataRepository: FeedDataRepository?
    weak var swipyCellHandler: SwipyCellHandler?
    
    private var mostRecentSectionHeader: TodaySectionHeaderView?
    private var earlierSectionHeader: YesterdaySectionHeaderView?
    private var dateConverter: FeedDateConverter = FeedDateConverter()
    
    var onSelectItem: ((FeedItem) -> Void)?
    var onBookmarkSwitchChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    
    init(storage: FeedDataRepository?) {
        dataRepository = storage
        super.init()
    }
}

    // MARK: - UITableViewDataSource

extension FeedRecentItemsDelegate: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        swipyCellHandler?.cancelSwipeForPendigCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 1 { return }
        guard let itemsCount = dataRepository?.recentItemsCount else { return }
        if indexPath.row == itemsCount - 1 && dataRepository?.threadsDataProvider.shouldLoadMoreRecentThreads == true {
            addSpinner(to: tableView)
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.dataRepository?.threadsDataProvider.requestRecentThreads(skipCount: itemsCount)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataRepository?.item(at: indexPath) {
            onSelectItem?(item)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var item: FeedItem?
        if indexPath.section == 0 {
            item = dataRepository?.todayItem(at: indexPath.row)
        } else if indexPath.section == 1 {
            item = dataRepository?.item(at: indexPath)
        }
        
        if let unwrappedItem = item {
            return FeedCardViewBuilder.height(for: unwrappedItem)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return buildTodayHeader()
        } else if section == 1 {
            return buildYesterdayHeader()
        }
        return nil
    }
    
    // MARK: - Private logic
    
    private func buildTodayHeader() -> UIView {
        if let date = dataRepository?.mostRecentTimestamp() {
            guard let isBookmarksActive = self.dataRepository?.isBookmarksActive else { return UIView() }
            let title = dateConverter.isToday(date) ? LocalizedStringKey.FeedViewHelper.Today : dateConverter.timeAgoInWords(from: date)
            if mostRecentSectionHeader == nil {
                let headerView = TodaySectionHeaderView()
                headerView.setupSubviews(with: title, isSwitchOn: isBookmarksActive)
                headerView.onSwitchValueChanged = onBookmarkSwitchChanged
                mostRecentSectionHeader = headerView
                return headerView
            } else {
                mostRecentSectionHeader?.setupSubviews(with: title, isSwitchOn: isBookmarksActive)
                return mostRecentSectionHeader!
            }
        }
        return UIView()
    }
    
    private func buildYesterdayHeader() -> UIView {
        if let mostRecentDate = dataRepository?.mostRecentTimestamp() {
            let title = dateConverter.isToday(mostRecentDate) ? LocalizedStringKey.FeedViewHelper.YesterdayHeaderTitle : LocalizedStringKey.FeedViewHelper.EarlierHeaderTitle
            if earlierSectionHeader == nil {
                let headerView = YesterdaySectionHeaderView()
                headerView.setupSubviews(isExpanded: false, title: title)
                earlierSectionHeader = headerView
                return headerView
            } else {
                earlierSectionHeader?.setupSubviews(isExpanded: false, title: title)
                return earlierSectionHeader!
            }
        }
        return UIView()
    }
    
    private func headerHeight(for section: Int) -> CGFloat {
        if section == 0 {
            return 0.197 * screenWidth
        } else if section == 1 {
            return 0.106 * screenWidth
        }
        return 0
    }
    
    func addSpinner(to tableView: UITableView) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
}
