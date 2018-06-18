//
//  FeedCellsFactory.swift
//  June
//
//  Created by Ostap Holub on 11/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedCellsFactory {
    
    class func cell(for item: FeedItem, at indexPath: IndexPath, for tableView: UITableView) -> FeedItemCell {
        if item.isAmazonItem() {
            return tableView.dequeueReusableCell(withIdentifier: FeedAmazonCardTableViewCell.reuseIdentifier(), for: indexPath) as! FeedItemCell
        } else if item.isCalendarInvite() {
            return tableView.dequeueReusableCell(withIdentifier: FeedCalendarInviteTableViewCell.reuseIdentifier(), for: indexPath) as! FeedItemCell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: FeedGenericCardTableViewCell.reuseIdentifier(), for: indexPath) as! FeedItemCell
        }
    }
}
