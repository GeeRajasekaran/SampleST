//
//  StarredDelegate.swift
//  June
//
//  Created by Tatia Chachua on 05/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit
import CoreData

class StarredDelegate: NSObject {
    
    let starredViewhelper: StarredViewHelper = StarredViewHelper()
    var heightAtIndexPath = NSMutableDictionary()
    
    unowned var parentVC: StarredViewController
    
    init(parentVC: StarredViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

extension StarredDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return starredViewhelper.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 10 {
            if (self.parentVC.fetchedResultController.fetchedObjects?.count)! > 0 {
                let isIndexValid = self.parentVC.fetchedResultController.fetchedObjects?.indices.contains(indexPath.row)
                if isIndexValid! {
                    let thread : Threads = self.parentVC.fetchedResultController.object(at: indexPath)
                    if thread.id != nil {
                        let detailVC = ThreadsDetailViewController()
                        detailVC.threadId = thread.id
                        detailVC.threadAccountId = thread.account_id
                        detailVC.threadToRead = thread
                        detailVC.fromTableViewTag = tableView.tag
                        detailVC.starred = thread.starred
                        let subject = thread.subject
                        if  let title = subject, !title.isEmpty {
                            detailVC.subjectTitle = title
                        }
                        self.parentVC.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }            
        } else if tableView.tag == 20 {
            if (self.parentVC.fetchedResultController2.fetchedObjects?.count)! > 0 {
                let isIndexValid = self.parentVC.fetchedResultController2.fetchedObjects?.indices.contains(indexPath.row)
                if isIndexValid! {
                    let thread : Threads = self.parentVC.fetchedResultController2.object(at: indexPath)
                    if thread.id != nil {
                        let detailVC = ThreadsDetailViewController()
                        detailVC.threadId = thread.id
                        detailVC.threadAccountId = thread.account_id
                        detailVC.threadToRead = thread
                        let subject = thread.subject
                        if  let title = subject, !title.isEmpty {
                            detailVC.subjectTitle = title
                        }
                        detailVC.starred = thread.starred
                        detailVC.fromTableViewTag = tableView.tag
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
        let headerView = StarredHeaderViewCell(style:UITableViewCellStyle.default, reuseIdentifier: StarredHeaderViewCell.reuseIdentifier())
        headerView.delegate = self.parentVC
        headerView.frame = CGRect(x: 0, y: 0, width: self.parentVC.view.frame.size.width, height: starredViewhelper.tableViewHeaderHeight)
        headerView.updateViews(withTag: tableView.tag)
        headerView.layoutSubviews()
        let view = UIView.init()
        view.addSubview(headerView)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return starredViewhelper.tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return starredViewhelper.tableViewCellHeight
    }

}

extension StarredDelegate : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(type)
        switch type {
        case .insert:
            print("NSFetchedResultsChangeType.Insert detected")
//            if let newItemIndexPath = newIndexPath {
//            }
            if controller == self.parentVC.fetchedResultController {
                //self.parentVC.tableView?.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.automatic)
                self.parentVC.tableView?.reloadData()
            } else if controller == self.parentVC.fetchedResultController2 {
                //self.parentVC.feedTable?.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.automatic)
                self.parentVC.feedTable?.reloadData()
            }
            
        case .delete:
            print("NSFetchedResultsChangeType.Delete detected")
//            if let deleteIndexPath = indexPath {
//            }
            if controller == self.parentVC.fetchedResultController {
                //self.parentVC.tableView?.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.automatic)
                self.parentVC.tableView?.reloadData()
            } else if controller == self.parentVC.fetchedResultController2 {
                //self.parentVC.feedTable?.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.automatic)
                self.parentVC.feedTable?.reloadData()
            }

            
        case .move:
            print("NSFetchedResultsChangeType.Move detected")
        case .update:
            print("NSFetchedResultsChangeType.Update detected")
//            if let newItemIndexPath = newIndexPath {
//            }
            if controller == self.parentVC.fetchedResultController {
                // self.parentVC.tableView?.reloadRows(at: [newItemIndexPath], with: .automatic)
                self.parentVC.tableView?.reloadData()
            } else if controller == self.parentVC.fetchedResultController2 {
                // self.parentVC.feedTable?.reloadRows(at: [newItemIndexPath], with: .automatic)
                self.parentVC.feedTable?.reloadData()
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if controller == self.parentVC.fetchedResultController {
//            self.parentVC.tableView?.endUpdates()
//        } else if controller == self.parentVC.fetchedResultController2 {
//            self.parentVC.feedTable?.endUpdates()
//        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if controller == self.parentVC.fetchedResultController {
//            self.parentVC.tableView?.beginUpdates()
//        } else if controller == self.parentVC.fetchedResultController2 {
//            self.parentVC.feedTable?.beginUpdates()
//        }
    }
    
}

