//
//  ThreadsDetailViewDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData

class ThreadsDetailViewDelegate: NSObject, UIScrollViewDelegate {
    unowned var parentVC: ThreadsDetailViewController
    let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    init(parentVC: ThreadsDetailViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
    // we set a variable to hold the contentOffSet before scroll view scrolls
    var lastContentOffset: CGFloat = 0
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // moved to top
            self.parentVC.movedToBottom = false
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // moved to bottom
            self.parentVC.movedToBottom = true
        } else {
            // didn't move
        }
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < -50 {
            if ((self.parentVC.dataArray.count) < self.parentVC.totalNewMessagesCount) && self.parentVC.shouldLoadMoreMessagesThreads {
                let skip = self.parentVC.dataArray.count
                self.parentVC.shouldLoadMoreMessagesThreads = false
                self.addSpinner(to: self.parentVC.tableView!)
                self.parentVC.loadMoreMessagesFromBackend(with: skip)
            }
        }
        
    }

    func addSpinner(to tableView: UITableView) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableHeaderView = spinner
        tableView.tableHeaderView?.isHidden = false
    }

}

// MARK:- UITableViewDelegate

extension ThreadsDetailViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var rowHeight: CGFloat = 200
        
        print(self.parentVC.mainContentHeights as Any)
        
        if self.parentVC.mainContentHeights != nil {
            let isIndexValid = self.parentVC.dataArray.indices.contains(indexPath.row)
            if isIndexValid {
                if tableView == self.parentVC.tableView {
                    
                    let isMainContentHeightsIndexValid = self.parentVC.mainContentHeights.indices.contains(indexPath.row)
                    if isMainContentHeightsIndexValid {
                        if self.parentVC.mainContentHeights[indexPath.row] != 0 {
                            rowHeight = self.parentVC.mainContentHeights[indexPath.row]
                        }
                    }
                                        
                    if self.parentVC.forwardedMessagesDictionary[indexPath.row] != nil {
                        rowHeight += 75
                    }
                    let messages: [Messages] = self.parentVC.dataArray
                    if let messagesFiles = messages[indexPath.row].messages_files {
                        if messagesFiles.count != 0 {
                            rowHeight += attachmentsViewHeight
                        }
                    }
                }
            }
        }
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("will display cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parentVC.fullEmailButtonPressedActionView(indexPath: indexPath)
    }

}

extension ThreadsDetailViewDelegate: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("NSFetchedResultsChangeType.Insert detected")
        case .delete:
            print("NSFetchedResultsChangeType.Delete detected")
        case .move:
            print("NSFetchedResultsChangeType.Move detected")
        case .update:
            print("NSFetchedResultsChangeType.Update detected")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("did change content")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("will change content")
    }

}

extension ThreadsDetailViewDelegate: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("webview failed with errors ", error)
        webView.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
    }
    
    func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()
        
    }
    
}
