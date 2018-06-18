//
//  CollapsibleViewController.swift
//  Romio
//
//  Created by Arjun Busani on 10/24/17.
//  Copyright © 2017 HomePeople Corporation. All rights reserved.
//

import UIKit

class CollapsibleViewController: CustomNavBarViewController {
    
    var collapsibleView: CollapsibleView
    var tableView: UITableView?
    
    var previousContentOffset: CGFloat = 0
    var tableViewFlipped: Bool = false
    let segmentOffsetPercent: CGFloat = 2.5

    var _keyboardHeight: CGFloat = 216.0
    var keyboardHeight: CGFloat  {
        set {
            _keyboardHeight = newValue
        }
        get {
            return _keyboardHeight
        }
    }
    
    var isCollapsibleViewShowing: Bool {
        get {
            if collapsibleView.frame.origin.y <= barHeight - collapsibleView.viewHeight() {
                return false
            }
            return true
        }
    }


    init(collapsibleView: CollapsibleView) {
        self.collapsibleView = collapsibleView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.insertSubview(collapsibleView, belowSubview: navigationBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CollapsibleViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollapsibleViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {
            self.keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
            resetTableView(inputWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        resetTableView(inputWillShow: false)
    }
    
    func resetTableView(inputWillShow: Bool) {
        guard let tableView = self.tableView else {
            return
        }
        
        if inputWillShow {
            let contentInsets = UIEdgeInsetsMake(tableView.contentInset.top, 0.0, self.keyboardHeight - tabBarHeight, 0.0)
            self.tableView?.contentInset = contentInsets;
            self.tableView?.scrollIndicatorInsets = contentInsets;
        } else {
            UIView.animate(withDuration: 0, animations: {
                let contentInsets = UIEdgeInsetsMake(tableView.contentInset.top, 0.0, 0.0, 0.0)
                self.tableView?.contentInset = contentInsets;
                self.tableView?.scrollIndicatorInsets = contentInsets;
                UIView.performWithoutAnimation {
                    self.tableView?.beginUpdates()
                    self.tableView?.endUpdates()
                }
            }) { (completed) in
            }
        }
    }

    var previousDownOffset: CGFloat = 0
    var previousUpOffset: CGFloat = 0
    let animationDuration: TimeInterval = 0.1
    let autoAnimationDuration: TimeInterval = 0.25
    var barHeight: CGFloat = 0
    var scrollDirection: ScrollDirection = ScrollDirection.none
    var previousScrollDirection: ScrollDirection = ScrollDirection.none
    
    func handleScroll(scrollView: UIScrollView, includeNavBar: Bool = true) {
        previousScrollDirection = scrollDirection
        scrollDirection = scrollDirection(forScrollView: scrollView)
        
        // Determine whether to update header
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        let reachedBottom = distanceFromBottom < height
        let reachedTop = scrollView.contentOffset.y < 0
        let scrollPos = scrollView.contentOffset
        barHeight = includeNavBar ? self.navBarHeight : 0
        
        if !reachedBottom && !reachedTop {
            if let tableView = self.tableView {
                if tableViewFlipped || tableView.contentSize.height > tableView.frame.size.height + (collapsibleView.viewHeight()*segmentOffsetPercent) {
                    if scrollPos.y > previousContentOffset {
                        
                        // Determine the Offset
                        var y = previousUpOffset + (scrollPos.y - previousContentOffset)
                        y = (y >= collapsibleView.collapsedViewHeight()) ? collapsibleView.collapsedViewHeight() : y
                        if isCollapsibleViewShowing && y > 0 {
                            previousDownOffset = (previousDownOffset - y) >= 0 ? (previousDownOffset - y) : 0
                            previousUpOffset = y
                            
                            // Update the Header Interal View
                            let percent = y/collapsibleView.collapsedViewHeight()
                            self.collapsibleView.didScroll(withPercent: percent)
                            
                            // Animate the View
                            UIView.animate(withDuration: animationDuration, animations: {
                                self.collapsibleView.frame.origin.y = self.barHeight - y
                                tableView.frame.origin.y = self.barHeight + self.collapsibleView.viewHeight() - y
                                tableView.frame.size.height = (self.view.frame.height - self.barHeight - self.tabBarHeight - (self.collapsibleView.viewHeight() - y))
                                self.tableViewFlipped = true
                            })
                        }
                    } else if scrollPos.y < previousContentOffset {
                        
                        // Determine the Offset
                        var y = previousDownOffset + (previousContentOffset - scrollPos.y)
                        y = (y >= collapsibleView.collapsedViewHeight()) ? collapsibleView.collapsedViewHeight() : y
                        previousDownOffset = y
                        previousUpOffset = previousUpOffset - y <= 0 ? 0 : previousUpOffset - y
                        
                        // Update the Header Interal View
                        let percent = 1 - y/collapsibleView.collapsedViewHeight()
                        self.collapsibleView.didScroll(withPercent: percent)
                        
                        // Animate the View
                        if collapsibleView.frame.origin.y != barHeight + collapsibleView.viewHeight() {
                            UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: {
                                self.collapsibleView.frame.origin.y = self.barHeight - self.collapsibleView.collapsedViewHeight() + y
                                tableView.frame.origin.y = self.barHeight + (self.collapsibleView.viewHeight() - self.collapsibleView.collapsedViewHeight()) + y
                            }, completion: { (completed) in
                                if tableView.frame.origin.y == self.barHeight + self.collapsibleView.collapsedViewHeight() {
                                    self.tableViewFlipped = false
                                }
                            })
                        }
                    }
                }
            }
        }
        previousContentOffset = scrollPos.y
    }
    
    func scrollDirection(forScrollView scrollView: UIScrollView, log: Bool = false) -> ScrollDirection {
        if (self.previousContentOffset > scrollView.contentOffset.y) {
            return ScrollDirection.up
        }
        else if (self.previousContentOffset < scrollView.contentOffset.y) {
            return ScrollDirection.down
        }
        return ScrollDirection.none
    }
    
    func completeTransition(forceOpen: Bool? = nil, includeNavBar: Bool = true) {
        
        // Calculate current position
        barHeight = includeNavBar ? self.navBarHeight : 0
        let y = collapsibleView.collapsedViewHeight()
        var collapse = false
        
        if let userForcedOpen = forceOpen {
            collapse = !userForcedOpen
        } else {
            switch scrollDirection {
            case .down:
                collapse = true
                
            case .up:
                collapse = false
                
            case .none:
                switch previousScrollDirection {
                case .down:
                    collapse = true
                    
                case .up:
                    collapse = false
                    
                case .none:
                    collapse = collapsibleView.frame.origin.y <= (barHeight - y)/2
                }
            }
        }

        // Complete the transition
        if let tableView = self.tableView {
            if collapse {
                if isCollapsibleViewShowing && y > 0 {
                    
                    // Determine the Offset
                    previousDownOffset = (previousDownOffset - y) >= 0 ? (previousDownOffset - y) : 0
                    previousUpOffset = y
                    
                    // Update the Header Interal View
                    let percent = y/collapsibleView.collapsedViewHeight()
                    self.collapsibleView.didScroll(withPercent: percent)
                    
                    UIView.animate(withDuration: autoAnimationDuration, animations: {
                        self.collapsibleView.frame.origin.y = self.barHeight - y
                        tableView.frame.origin.y = self.barHeight + self.collapsibleView.viewHeight() - y
                        tableView.frame.size.height = (self.view.frame.height - self.barHeight - self.tabBarHeight - (self.collapsibleView.viewHeight() - y))
                        self.tableViewFlipped = true
                    })
                }
            } else {
                if self.collapsibleView.frame.origin.y != self.barHeight - self.collapsibleView.collapsedViewHeight() + y {
                    
                    // Determine the Offset
                    previousDownOffset = y
                    previousUpOffset = previousUpOffset - y <= 0 ? 0 : previousUpOffset - y
                    
                    // Update the Header Interal View
                    let percent = 1 - y/collapsibleView.collapsedViewHeight()
                    self.collapsibleView.didScroll(withPercent: percent)
                    
                    UIView.animate(withDuration: autoAnimationDuration, delay: 0, options: [], animations: {
                        self.collapsibleView.frame.origin.y = self.barHeight - self.collapsibleView.collapsedViewHeight() + y
                        tableView.frame.origin.y = self.barHeight + (self.collapsibleView.viewHeight() - self.collapsibleView.collapsedViewHeight()) + y
                    }, completion: { (completed) in
                        if tableView.frame.origin.y == self.barHeight + self.collapsibleView.collapsedViewHeight() {
                            self.tableViewFlipped = false
                        }
                    })
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
