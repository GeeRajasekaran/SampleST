//
//  RequestsScreenBuilder.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RequestsScreenBuilder: ScreenTableModelBuilder {
    
    weak var dataRepository: RequestsDataRepository?
    var currentSegment: RequestsScreenType?
    
    private lazy var viewHelper: RequestsViewHelper = { [weak self] in
        let helper = RequestsViewHelper(storage: self?.dataRepository)
        return helper
    }()
    
    //MARK: - initialization
    init(model: Any?, storage: RequestsDataRepository?) {
        dataRepository = storage
    }
    
    // MARK: - Rows and section loading
    override func loadSegment() -> Any {
        if let segment = currentSegment {
            return segment
        }
        return RequestsScreenType.people
    }
    
    override func switchSegment(_ segment: Any) {
        guard let currentSegment = segment as? RequestsScreenType else { return }
        self.currentSegment = currentSegment
    }
    
    override func loadSections() -> [Any] {
        return RequestsSectionType.sections(for: RequestsScreenType.people)
    }
    
    override func loadRows(withSection section: Any) -> [Any] {
        guard let requestsItems = dataRepository?.items else { return [] }
        return RequestsRowType.rows(for: requestsItems)
    }

    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T: RawRepresentable, Q: RawRepresentable {
        guard let requestsItems = dataRepository?.items else { return BaseTableModel() }
        return requestsItems[indexPath.row]
    }
    
    //MARK: - row validation
    func rowType(at indexPath: IndexPath) -> RequestsRowType? {
        let rowTypes = loadRows(withSection: 1)
        guard rowTypes.count != 0 else { return nil }
        if indexPath.row >= 0 && indexPath.row < rowTypes.count {
            return rowTypes[indexPath.row] as? RequestsRowType
        }
        return nil
    }
    
    // MARK: - UI calculation delegation
    func height(for indexPath: IndexPath) -> CGFloat {
        guard let screenType = loadSegment() as? RequestsScreenType else { return 0 }
        return viewHelper.height(for: screenType, indexPath: indexPath)
    }
    
    func put(_ height: CGFloat, at index: Int) {
        viewHelper.put(height, at: index)
    }
    
    func cleatHeights() {
        viewHelper.clearHeights()
    }
    
    //MARK: - add empty view if needed
    func addNoResultsViewIfNeeded(count: Int, withTableView tableView: UITableView) {
        if count == 0 {
            let noResultsView = NoResultsView(frame: .zero, title: LocalizedStringKey.RequestsViewHelper.NoResultsTitle)
            tableView.backgroundView = noResultsView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    //MARK: - pagination
    func loadNext(with count: Int) {
        guard let screenType = loadSegment() as? RequestsScreenType, let repo = dataRepository else { return }
        switch screenType {
        case .people:
            repo.loadNextPeople(with: count)
        case .subscriptions:
            repo.loadNextSubscriptions(with: count)
        case .blockedPeople:
            repo.loadNextBlockedPeople(with: count)
        case .blockedSubscriptions:
            repo.loadNextBlockedSubscriptions(with: count)
        }
    }
    
    //MARK: - real time
    func realTime(with item: RequestItem, and tableView: UITableView) {
        guard let screenType = loadSegment() as? RequestsScreenType, let repo = dataRepository, let itemType = item.type else { return }
        if let index = repo.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            guard tableView.cellForRow(at: indexPath) != nil else {
                tableView.reloadData()
                return
            }
            if itemType == screenType {
                repo.update(item)
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                repo.remove(item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if itemType == screenType {
            repo.append([item])
            tableView.reloadData()
        }
    }    
}
