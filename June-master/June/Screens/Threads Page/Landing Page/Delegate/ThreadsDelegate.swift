//
//  ThreadsDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 8/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData

class ThreadsDelegate: NSObject, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    let threadsViewHelper: ThreadsViewHelper = ThreadsViewHelper()
    var heightAtIndexPath = NSMutableDictionary()

    unowned var parentVC: ThreadsViewController
    
    init(parentVC: ThreadsViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        print((maximumOffset - currentOffset) as Any)
        if maximumOffset - currentOffset <= 50.0 {
            print("load more")
            if self.parentVC.shouldLoadMoreReadThreads {
                if self.parentVC.lastSelectedTableViewTag == 10 {
                    if self.parentVC.fetchedResultController?.fetchedObjects?.isEmpty == false {
                        self.parentVC.shouldLoadMoreNewThreads = false
                        guard let repoCount = self.parentVC.fetchedResultController?.fetchedObjects?.count else { return }
                        self.parentVC.fetchMoreUnreadThreads(_withSkip: repoCount)
                        if self.parentVC.tableView != nil {
                            addSpinner(to: self.parentVC.tableView!)
                        }
                    }
                }
                
                if self.parentVC.lastSelectedTableViewTag == 20 {
                    if self.parentVC.fetchedResultController2?.fetchedObjects?.isEmpty == false {
                        self.parentVC.shouldLoadMoreNewThreads = false
                        guard let repoCount = self.parentVC.fetchedResultController2?.fetchedObjects?.count else { return }
                        self.parentVC.fetchMoreReadThreads(_withSkip: repoCount)
                        if self.parentVC.readTableView != nil {
                            addSpinner(to: self.parentVC.readTableView!)
                        }
                    }
                }
                
                if self.parentVC.lastSelectedTableViewTag == 30 {
                    if self.parentVC.fetchedResultController3?.fetchedObjects?.isEmpty == false {
                        self.parentVC.shouldLoadMoreNewThreads = false
                        guard let repoCount = self.parentVC.fetchedResultController3?.fetchedObjects?.count else { return }
                        self.parentVC.fetchMoreTrashThreads(_withSkip: repoCount)
                        if self.parentVC.trashTableView != nil {
                            addSpinner(to: self.parentVC.trashTableView!)
                        }
                    }
                }
                
                if self.parentVC.lastSelectedTableViewTag == 40 {
                    if self.parentVC.fetchedResultController4?.fetchedObjects?.isEmpty == false {
                        self.parentVC.shouldLoadMoreNewThreads = false
                        guard let repoCount = self.parentVC.fetchedResultController4?.fetchedObjects?.count else { return }
                        self.parentVC.fetchMoreSpamThreads(_withSkip: repoCount)
                        if self.parentVC.spamTableView != nil {
                            addSpinner(to: self.parentVC.spamTableView!)
                        }
                    }
                }

            }
        }
    }
    
}

// MARK:- UITableViewDelegate

extension ThreadsDelegate: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentVC.dataSource?.cellHandler.cancelSwipeForPendigCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return threadsViewHelper.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == self.parentVC.tableView?.tag {
            if (self.parentVC.fetchedResultController?.fetchedObjects?.count)! > 0 {
                let isIndexValid:Bool = (self.parentVC.fetchedResultController?.fetchedObjects?.indices.contains(indexPath.row))!
                if isIndexValid {
                    let thread : Threads = self.parentVC.fetchedResultController!.object(at: indexPath)
                    if thread.id != nil {
                        let detailVC:ThreadsDetailViewController = ThreadsDetailViewController()
                        detailVC.threadId = thread.id
                        detailVC.threadAccountId = thread.account_id
                        detailVC.threadToRead = thread
                        detailVC.fromTableViewTag = tableView.tag
                        detailVC.categories = parentVC.categories
                        self.parentVC.fromTableViewTag = tableView.tag
                        detailVC.starred = thread.starred
                        let subject = thread.subject
                        if  let title:String = subject, !title.isEmpty {
                            detailVC.subjectTitle = title
                        }
                        self.parentVC.lastSelectedIndexPath = indexPath
                        detailVC.controllerDelegate = self.parentVC
                        let cell = tableView.cellForRow(at: indexPath) as? ThreadsTableViewCell
                        detailVC.threadCell = cell
                        self.parentVC.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
        } else
        
        if tableView.tag == self.parentVC.readTableView?.tag {
            if (self.parentVC.fetchedResultController2?.fetchedObjects?.count)! > 0 {
                let isIndexValid:Bool = (self.parentVC.fetchedResultController2?.fetchedObjects?.indices.contains(indexPath.row))!
                if isIndexValid {
                    let thread : Threads = self.parentVC.fetchedResultController2!.object(at: indexPath)
                    if thread.id != nil {
                        let detailVC:ThreadsDetailViewController = ThreadsDetailViewController()
                        detailVC.threadId = thread.id
                        detailVC.threadAccountId = thread.account_id
                        detailVC.threadCell = nil
                        detailVC.threadToRead = thread
                        detailVC.categories = parentVC.categories
                        let subject = thread.subject
                        if  let title:String = subject, !title.isEmpty {
                            detailVC.subjectTitle = title
                        }
                        detailVC.starred = thread.starred
                        detailVC.fromTableViewTag = tableView.tag
                        self.parentVC.fromTableViewTag = tableView.tag
                        self.parentVC.lastSelectedIndexPath = indexPath
                        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
        } else
        
        if tableView.tag == self.parentVC.trashTableView?.tag {
            if (self.parentVC.fetchedResultController3?.fetchedObjects?.count)! > 0 {
                let isIndexValid:Bool = (self.parentVC.fetchedResultController3?.fetchedObjects?.indices.contains(indexPath.row))!
                if isIndexValid {
                    let thread : Threads = self.parentVC.fetchedResultController3!.object(at: indexPath)
                    if thread.id != nil {
                        let detailVC = ThreadsDetailViewController()
                        detailVC.threadCell = nil
                        detailVC.threadId = thread.id
                        detailVC.threadAccountId = thread.account_id
                        detailVC.threadToRead = thread
                        let subject = thread.subject
                        if  let title = subject, !title.isEmpty {
                            detailVC.subjectTitle = title
                        }
                        detailVC.categories = parentVC.categories
                        detailVC.starred = thread.starred
                        detailVC.fromTableViewTag = tableView.tag
                        self.parentVC.fromTableViewTag = tableView.tag
                        self.parentVC.lastSelectedIndexPath = indexPath
                        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
        } else
        
        if tableView.tag == self.parentVC.spamTableView?.tag {
            if (self.parentVC.fetchedResultController4?.fetchedObjects?.count)! > 0 {
                let isIndexValid:Bool = (self.parentVC.fetchedResultController4?.fetchedObjects?.indices.contains(indexPath.row))!
                if isIndexValid {
                    let thread : Threads = self.parentVC.fetchedResultController4!.object(at: indexPath)
                    if thread.id != nil {
                        let detailVC:ThreadsDetailViewController = ThreadsDetailViewController()
                        detailVC.threadCell = nil
                        detailVC.threadId = thread.id
                        detailVC.threadAccountId = thread.account_id
                        detailVC.threadToRead = thread
                        let subject = thread.subject
                        if  let title:String = subject, !title.isEmpty {
                            detailVC.subjectTitle = title
                        }
                        detailVC.categories = parentVC.categories
                        detailVC.starred = thread.starred
                        detailVC.fromTableViewTag = tableView.tag
                        self.parentVC.fromTableViewTag = tableView.tag
                        self.parentVC.lastSelectedIndexPath = indexPath
                        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
             }
        }
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ThreadsHeaderViewCell(style:UITableViewCellStyle.default, reuseIdentifier: ThreadsHeaderViewCell.reuseIdentifier())
        headerView.delegate = self.parentVC
        headerView.frame = CGRect(x: 0, y: 0, width: self.parentVC.view.frame.size.width, height: threadsViewHelper.tableViewHeaderHeight)
        headerView.updateViews(withTag: tableView.tag)
        headerView.layoutSubviews()
        let view = UIView.init()
        view.addSubview(headerView)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return threadsViewHelper.tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return threadsViewHelper.tableViewCellHeight;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func addSpinner(to tableView: UITableView) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
}

extension ThreadsDelegate: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("Josh NSFetchedResultsChangeType.Insert detected")
            if let newItemIndexPath = newIndexPath {
                //MARK: - DON'T REMOVE INSERT/UPDATE/DELETE ROWS FUNCTIONALLITY, BECAUSE SWIPE ANIMATION STOP WORKING
                if controller == self.parentVC.fetchedResultController {
                    self.parentVC.tableView?.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.top)
                } else if controller == self.parentVC.fetchedResultController2 {
                    self.parentVC.readTableView?.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.top)
                } else if controller == self.parentVC.fetchedResultController3 {
                    self.parentVC.trashTableView?.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.top)
                } else if controller == self.parentVC.fetchedResultController4 {
                    self.parentVC.spamTableView?.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.top)
                }
            }
        case .delete:
            print("Josh NSFetchedResultsChangeType.Delete detected")
            if let deleteIndexPath = indexPath {
                if controller == self.parentVC.fetchedResultController {
                    self.parentVC.tableView?.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.top)
                } else if controller == self.parentVC.fetchedResultController2 {
                    self.parentVC.readTableView?.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.automatic)
                } else if controller == self.parentVC.fetchedResultController3 {
                    self.parentVC.trashTableView?.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.automatic)
                } else if controller == self.parentVC.fetchedResultController4 {
                    self.parentVC.spamTableView?.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.automatic)
                }
            }
        case .move:
            print("Josh NSFetchedResultsChangeType.Move detected")
        case .update:
            print("Josh NSFetchedResultsChangeType.Update detected")
            //MARK: - updated cell without reloading
            if let newItemIndexPath = newIndexPath {
                if controller == self.parentVC.fetchedResultController {
                    let cell = parentVC.tableView?.cellForRow(at: newItemIndexPath) as? ThreadsTableViewCell
                    if let thread = controller.object(at: newItemIndexPath) as? Threads {
                         cell?.setThreadCellWith(thread: thread)
                    }
                } else if controller == self.parentVC.fetchedResultController2 {
                    let cell = parentVC.readTableView?.cellForRow(at: newItemIndexPath) as? ThreadsStarUnstarTableViewCell
                    if let thread = controller.object(at: newItemIndexPath) as? Threads {
                        cell?.setThreadCellWith(thread: thread)
                    }
                } else if controller == self.parentVC.fetchedResultController3 {
                    let cell = parentVC.trashTableView?.cellForRow(at: newItemIndexPath) as? ThreadsStarUnstarTableViewCell
                    if let thread = controller.object(at: newItemIndexPath) as? Threads {
                        cell?.setThreadCellWith(thread: thread)
                    }
                } else if controller == self.parentVC.fetchedResultController4 {
                    let cell = parentVC.spamTableView?.cellForRow(at: newItemIndexPath) as? ThreadsStarUnstarTableViewCell
                    if let thread = controller.object(at: newItemIndexPath) as? Threads {
                        cell?.setThreadCellWith(thread: thread)
                    }
                }
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == self.parentVC.fetchedResultController {
            self.parentVC.tableView?.endUpdates()
        } else if controller == self.parentVC.fetchedResultController2 {
            self.parentVC.readTableView?.endUpdates()
        } else if controller == self.parentVC.fetchedResultController3 {
            self.parentVC.trashTableView?.endUpdates()
        } else if controller == self.parentVC.fetchedResultController4 {
            self.parentVC.spamTableView?.endUpdates()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == self.parentVC.fetchedResultController {
            self.parentVC.tableView?.beginUpdates()
        } else if controller == self.parentVC.fetchedResultController2 {
            self.parentVC.readTableView?.beginUpdates()
        } else if controller == self.parentVC.fetchedResultController3 {
            self.parentVC.trashTableView?.beginUpdates()
        } else if controller == self.parentVC.fetchedResultController4 {
            self.parentVC.spamTableView?.beginUpdates()
        }
    }

}

