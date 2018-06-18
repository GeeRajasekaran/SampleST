//
//  FeedDetailedTableDelegate.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedDetailedTableDelegate: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var builder: FeedDetailedScreenBuilder?
    
    // MARK: - Initialization
    
    init(builder: FeedDetailedScreenBuilder?) {
        self.builder = builder
    }
}

    // MARK: - UITableViewDelegate

extension FeedDetailedTableDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = builder?.rowType(at: indexPath),
            let height = builder?.height(for: row, at: indexPath) else { return 0 }
        return height
    }
}
