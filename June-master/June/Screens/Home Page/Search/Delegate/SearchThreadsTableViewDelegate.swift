//
//  SearchThreadsTableViewDelegate.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchThreadsTableViewDelegate: NSObject {
    let screenWidth = UIScreen.main.bounds.width
    var dataStorage: SearchThreadsDataRepository?
    
    var tableViewDidSelectRowAction: ((IndexPath, ThreadsReceiver) -> Void)?
    var onMoreThreads: (() -> Void)?
    var tableViewDidFinishScrolling: (() -> Void)?
    var tableViewStartScrolling: (() -> Void)?
    
    // MARK: - Initialization
    init(with storage: SearchThreadsDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension SearchThreadsTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.261
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataStorage?.getCount() == 0 {
            return 0
        }
        return screenWidth * 0.12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if dataStorage?.getCount() == 0 {
            return nil
        }
        let view = SearchTableHeaderView()
        view.setupView()
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let receiver = dataStorage?.receiver(by: indexPath.row) else { return }
        tableViewDidSelectRowAction?(indexPath, receiver)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let unwrappedSource = dataStorage else { return }
        if indexPath.item == unwrappedSource.getCount() - 5 {
            onMoreThreads?()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            tableViewStartScrolling?()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableViewDidFinishScrolling?()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            tableViewDidFinishScrolling?()
        }
    }
}
