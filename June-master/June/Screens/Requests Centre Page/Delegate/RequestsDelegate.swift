//
//  RequestsDelegate.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RequestsDelegate: NSObject {
    
    private weak var builder: RequestsScreenBuilder?
    var tableViewStartScrolling: (() -> Void)?
    
    init(builder: RequestsScreenBuilder?) {
        self.builder = builder
    }
}

extension RequestsDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = builder?.height(for: indexPath) else { return 0 }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let unwrappedBuilder = builder, let provider = builder?.dataRepository?.contactsDataProvider, let count = builder?.dataRepository?.getCount() else { return }
        if indexPath.row == count - 1 && provider.shouldLoadMore {
            unwrappedBuilder.loadNext(with: count)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset == 0 {
            tableViewStartScrolling?()
        }
    }
}
