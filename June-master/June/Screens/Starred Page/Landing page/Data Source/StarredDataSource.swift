//
//  StarredDataSource.swift
//  June
//
//  Created by Tatia Chachua on 05/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit
import CoreData

class StarredDataSource: NSObject {
    
    private var pendingRequestWorkItem: DispatchWorkItem?

    let starredViewHelper: StarredViewHelper = StarredViewHelper()
    
    unowned var parentVC: StarredViewController
    
    init(parentVC: StarredViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITableViewDataSource
extension StarredDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if tableView == self.parentVC.tableView {
            if self.parentVC.fetchedResultController != nil {
                if let sections = self.parentVC.fetchedResultController.sections {
                    return sections.count
                }
            }
        }
        if tableView == self.parentVC.feedTable {
            if self.parentVC.fetchedResultController2 != nil {
                if let sections = self.parentVC.fetchedResultController2.sections {
                    return sections.count
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.parentVC.tableView {
            if self.parentVC.fetchedResultController != nil {
                if let sections = self.parentVC.fetchedResultController.sections {
                    let currentSection = sections[section]
                    return currentSection.numberOfObjects
                }
            }
        } else if tableView == self.parentVC.feedTable {
            if self.parentVC.fetchedResultController2 != nil {
                if let sections = self.parentVC.fetchedResultController2.sections {
                    let currentSection = sections[section]
                    return currentSection.numberOfObjects
                }
            } else {
                print("there is zero starred feed")
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: StarredTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: StarredTableViewCell.reuseIdentifier()) as? StarredTableViewCell)!
        
        if (cell == nil) {
            cell = StarredTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: StarredTableViewCell.reuseIdentifier())
        }
        if tableView == self.parentVC.tableView {
            
            if self.parentVC.fetchedResultController != nil {
 //              self.parentVC.tableViewIsNotEmpty()
                let thread = self.parentVC.fetchedResultController.object(at: indexPath)
                cell?.delegate = self.parentVC
                cell?.indexPath = indexPath
      
                DispatchQueue.main.async {
                    cell?.setThreadCellWith(thread: thread)
                }
                cell?.selectionStyle = .none
                cell?.rightActions = [
                    CustomStarredAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.leftActions = [
                    CustomStarredAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.contentView.setNeedsLayout()
            }
            
            if (indexPath.row > 15) && (indexPath.row >= (self.parentVC.fetchedResultController.fetchedObjects?.count)! - 1) {
                if self.parentVC.isLoading == false && self.parentVC.shouldLoadNextMessages {
                    let skip = self.parentVC.fetchedResultController.fetchedObjects?.count
                    self.parentVC.fetchMoreStarredMessages(_withSkip: skip!)
                    
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    
                    tableView.tableFooterView = spinner
                    tableView.tableFooterView?.isHidden = false
                }
            }

        }
        
        if tableView == self.parentVC.feedTable {
            if self.parentVC.fetchedResultController2 != nil {
//                self.parentVC.tableViewIsNotEmpty()
                cell?.delegate = self.parentVC
                cell?.indexPath = indexPath
                
                let thread = self.parentVC.fetchedResultController2.object(at: indexPath)
                DispatchQueue.main.async {
                    cell?.setThreadCellWith(thread: thread)
                }
                
                cell?.rightActions = [
                    CustomStarredAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.leftActions = [
                    CustomStarredAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.selectionStyle = .none
                cell?.contentView.setNeedsLayout()
            }
            if (indexPath.row > 15) && (indexPath.row >= (self.parentVC.fetchedResultController2.fetchedObjects?.count)! - 1) {
                if self.parentVC.isLoading == false && self.parentVC.shouldLoadNextFeedItems {
                    let skip = self.parentVC.fetchedResultController2.fetchedObjects?.count
                    self.parentVC.fetchMoreStarredFeeds2(_withSkip: skip!)
                    
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    
                    tableView.tableFooterView = spinner
                    tableView.tableFooterView?.isHidden = false
                }
            }
            
        }
        
        return cell!
    }
    
    
}
