//
//  FeedPageScreenBuilder.swift
//  June
//
//  Created by Ostap Holub on 1/5/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedScreenBuilder: ScreenTableModelBuilder {
    
    // MARK: - Variables & Constants
        
    private weak var dataRepository: FeedDataRepository?
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let dateConverter: FeedDateConverter = FeedDateConverter()
    
    private let templatesReader: ITemplateReadable = TemplatesHandler()
    private let templates: [FeedCardTemplate]?
    
    var onBookmarkItem: ((FeedItem) -> Void)?
    var onRecategorizeItem: ((FeedItem) -> Void)?
    var onShareItem: ((FeedItem) -> Void)?
    
    private lazy var viewHelper: FeedViewHelper = { [weak self] in
        let helper = FeedViewHelper(storage: self?.dataRepository)
        helper.onStar = self?.onStarAction
        helper.onRecategorize = self?.onRecategorizeAction
        helper.onShare = self?.onShareAction
        return helper
    }()
    
    // MARK: - Initialization
    
    init(model: Any?, storage: FeedDataRepository?) {
        dataRepository = storage
        templates = templatesReader.readTemplates()
    }
    
    // MARK: - Data updating logic
    
    func dataModelIndex(from uiIndex: IndexPath) -> IndexPath? {
        if dataRepository?.isBookmarksActive == true {
            return IndexPath(row: uiIndex.row - 1, section: uiIndex.section)
        } else if dataRepository?.isBookmarksActive == false {
            if uiIndex.section == 1 {
                return IndexPath(row: uiIndex.row, section: uiIndex.section - 1)
            } else if uiIndex.section == 2 {
                return IndexPath(row: uiIndex.row - 1, section: uiIndex.section - 1)
            }
        }
        return nil
    }
    
    func uiIndex(from dataModelIndex: IndexPath) -> IndexPath? {
        if dataRepository?.isBookmarksActive == true {
            return IndexPath(row: dataModelIndex.row + 1, section: dataModelIndex.section)
        } else if dataRepository?.isBookmarksActive == false {
            if dataModelIndex.section == 0 {
                return IndexPath(row: dataModelIndex.row, section: dataModelIndex.section + 1)
            } else if dataModelIndex.section == 1 {
                return IndexPath(row: dataModelIndex.row + 1, section: dataModelIndex.section + 1)
            }
        }
        return nil
    }
 
    lazy var onStarAction: (IndexPath) -> Void = { [weak self] index in
        guard let indexToUpdate = self?.dataModelIndex(from: index) else { return }
        if let item = self?.dataRepository?.item(at: indexToUpdate) {
            self?.onBookmarkItem?(item)
        }
    }
    
    private lazy var onRecategorizeAction: (IndexPath) -> Void = { [weak self] index in
        guard let indexOfitem = self?.dataModelIndex(from: index) else { return }
        if let item = self?.dataRepository?.item(at: indexOfitem) {
            self?.onRecategorizeItem?(item)
        }
    }
    
    private lazy var onShareAction: (IndexPath) -> Void = { [weak self] index in
        guard let indexOfitem = self?.dataModelIndex(from: index) else { return }
        if let item = self?.dataRepository?.item(at: indexOfitem) {
            self?.onShareItem?(item)
        }
    }
        
    // MARK: - Rows and section loading
    
    override func loadSections() -> [Any] {
        guard let bookmarks = dataRepository?.isBookmarksActive else { return [] }
        return FeedSectionType.sections(isBookmarksActive: bookmarks)
    }
    
    override func loadRows(withSection section: Any) -> [Any] {
        guard let feedSection = section as? FeedSectionType,
            let unwrappedRepository = dataRepository else { return [] }
        if feedSection.rawValue == 1 {
            return FeedRowType.rows(for: feedSection, items: unwrappedRepository.mostRecentItems)
        } else if feedSection.rawValue == 2 {
            return FeedRowType.rows(for: feedSection, items: unwrappedRepository.earlierItems)
        } else if feedSection.rawValue == 3 {
            return FeedRowType.bookmarkedRows(from: dataRepository)
        } else {
            return FeedRowType.rows(for: feedSection, items: [], dataRepository: dataRepository)
        }
    }
    
    // MARK: - Model creation logic
    
    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        guard let unwrappedRowType = rowType as? FeedRowType,
            let unwrappedSection = sectionType as? FeedSectionType else { return BaseTableModel() }
        
        var item: FeedItem?
        if unwrappedSection == .mostRecent {
            item = dataRepository?.todayItem(at: indexPath.row)
        } else if unwrappedSection == .earlier {
            let index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            item = dataRepository?.item(at: index)
        } else if unwrappedSection == .bookmarks && indexPath.row > 0 {
            if let array = dataRepository?.bookmarkedItems, array.count > 0 {
                item = array[indexPath.row - 1]
            }
        }
        
        guard let unwrappedRepository = dataRepository else { return BaseTableModel() }
        let template = templates?.first(where: { $0.category == item?.category })
        switch unwrappedRowType {
        case .todayHeader:
            let date = unwrappedRepository.mostRecentTimestamp() ?? Int32(Date().timeIntervalSince1970)
            var title: String = ""
            if dataRepository?.isBookmarksActive == true {
                title = LocalizedStringKey.FeedViewHelper.Bookmarks
            } else {
                title = dateConverter.isToday(date) ? LocalizedStringKey.FeedViewHelper.Today : dateConverter.timeAgoInWords(from: date)
            }
            return FeedHeaderInfo(title: title, value: unwrappedRepository.isBookmarksActive)
        case .earlierHeader:
            let date = dataRepository?.mostRecentTimestamp() ?? 0
            let title = dateConverter.isToday(date) ? LocalizedStringKey.FeedViewHelper.YesterdayHeaderTitle : LocalizedStringKey.FeedViewHelper.EarlierHeaderTitle
            return FeedHeaderInfo(title: title, value: false)
        case .generic:
            return FeedGenericItemInfo(thread: item?.threadEntity, template: template, category: item?.feedCategory)
        case .news:
            return FeedNewsItemInfo(thread: item?.threadEntity, template: template, category: item?.feedCategory)
        case .briefHeader:
            return BriefHeaderInfo()
        case .briefCategory:
            let index = IndexPath(row: indexPath.row - 2, section: indexPath.section)
            guard let categoryInfo = BriefInfoModelBuilder().briefCategoryInfo(dataRepository: dataRepository, at: index) else {
                return BaseTableModel()
            }
            return categoryInfo
        case .briefRequests:
            guard let requestsInfoModel = BriefInfoModelBuilder().briefRequestsInfo(dataRepository: dataRepository) else {
                return BaseTableModel()
            }
            return requestsInfoModel
        case .briefGenericItem, .briefWideItem:
            return briefModel(for: unwrappedRowType, sectionType: unwrappedSection, at: indexPath)
        case .briefCategoryControl:
            guard let controlInfoModel = BriefInfoModelBuilder().briefControlInfo(dataRepository: dataRepository) else {
                return BaseTableModel()
            }
            return controlInfoModel
        case .pendingSubscriptions:
            guard let count = dataRepository?.pendingSubscriptionsCount else {
                return BaseTableModel()
            }
            let title = LocalizedStringKey.RequestNotificationViewHelper.newSubscriptionsTitle
            return PendingRequestItemInfo(title: title, count: count)
        default:
            return BaseTableModel()
        }
    }
    
    private func briefModel(for rowType: FeedRowType, sectionType: FeedSectionType, at indexPath: IndexPath) -> BaseTableModel {
        guard let currentBrief = dataRepository?.briefsManager.currentBrief else { return BaseTableModel() }
        guard let rows = loadRows(withSection: sectionType) as? [FeedRowType] else { return BaseTableModel() }
        
        var itemIndex: Int = 0
        for index in 0..<indexPath.row {
            if rows[index] == .briefWideItem || rows[index] == .briefGenericItem {
                itemIndex += 1
            }
        }
        
        guard let unwrappedCategoryId = currentBrief.selectedCategoryId,
            let threads = currentBrief.categoriesMap[unwrappedCategoryId],
            let category = dataRepository?.category(with: unwrappedCategoryId) else { return BaseTableModel() }
        
        let currentThread = threads[itemIndex]
        let template = templates?.first(where: { $0.category == unwrappedCategoryId })
        
        switch rowType {
        case .briefGenericItem:
            return FeedGenericItemInfo(thread: currentThread, template: template, category: category)
        case .briefWideItem:
            return FeedNewsItemInfo(thread: currentThread, template: template, category: category)
        default:
            break
        }
        return BaseTableModel()
    }
    
    // MARK: - Binding model to view
    
    func bind(model: BaseTableModel?, to cell: FeedItemCell, at indexPath: IndexPath, with rowType: FeedRowType) {
        guard let feedInfo = model as? FeedGenericItemInfo else { return }
        var cardView = FeedCardViewBuilder.cardView(for: rowType, at: cell.frame, at: indexPath)
        cardView.itemInfo = feedInfo
        cardView.onRemoveBookmarkAction = onStarAction
        cell.set(feedView: cardView)
        bindSwipes(of: cell, at: indexPath, to: model)
    }
    
    private func bindSwipes(of cell: FeedItemCell, at indexPath: IndexPath, to model: BaseTableModel?) {
        viewHelper.configureSwipe(for: cell, at: indexPath, with: model)
    }
    
    // MARK: - UI calculation delegation
    
    func height(for indexPath: IndexPath, at tableView: UITableView) -> CGFloat {
        guard let section = loadSections()[indexPath.section] as? FeedSectionType,
            let rowType = loadRows(withSection: section)[indexPath.row] as? FeedRowType else { return 0 }
        return viewHelper.height(for: rowType, at: tableView)
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return viewHelper.headerHeight(for: section)
    }
    
    func cancelSwipeForPendigCell() {
        viewHelper.cancelSwipeForPendigCell()
    }
}
