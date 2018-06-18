//
//  INavigationHandler.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol INavigationHandler {
    
    var rootViewController: UIViewController { get }
    var defaultHeight: CGFloat { get }
    var initialResponderMinimizeFrame: CGRect { get }
    
    init(rootVC: UIViewController)
    
    func show(_ viewController: ResponderViewControllerOld)
    func hide(_ viewController: ResponderViewControllerOld)
    
    func expand(_ viewController: ResponderViewControllerOld)
    func collapse(_ viewController: ResponderViewControllerOld, to lastHeight: CGFloat?)
    
    func startSearch(_ viewController: ResponderViewControllerOld)
    func endSearch(_ viewController: ResponderViewControllerOld)
    
    func showSuggestions(_ viewController: ReceiversSuggestionViewController, from parent: UIViewController)
    func showExpandedSuggesstions(_ viewController: UIViewController, from parent: ResponderViewControllerOld)
    func hideSuggestions(_ viewController: UIViewController)
}

    // Default implementation of expand method
    // allows not to implement this in two classes of navigation handlers.
    // This solution was choosen, because expand should work in the same way in both cases

extension INavigationHandler {
    
    func expand(_ viewController: ResponderViewControllerOld) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let viewOriginY = viewController.view.frame.origin.y
        let viewHeight = viewController.view.frame.height
        
        let finalViewHeight = viewOriginY + viewHeight - statusBarHeight - 4
        
        UIView.animate(withDuration: 0.3, animations: { [unowned viewController] in
            
            viewController.view.frame.origin.y = 0 + statusBarHeight + 4
            viewController.view.frame.size.height = finalViewHeight
            viewController.accessoryView?.frame.size.height = finalViewHeight
            viewController.accessoryView?.updateLayout(for: finalViewHeight)
        })
    }
    
    func startSearch(_ viewController: ResponderViewControllerOld) {
        let tableViewHeight = 0.336 * UIScreen.main.bounds.width
        
        let finalOriginY = viewController.view.frame.origin.y - tableViewHeight
        let finalViewHeight = viewController.view.frame.size.height + tableViewHeight
        
        UIView.animate(withDuration: 0.3, animations: { [unowned viewController] in
            viewController.view.frame.origin.y = finalOriginY
            viewController.view.frame.size.height = finalViewHeight
            viewController.accessoryView?.frame.origin.y += tableViewHeight
        })
    }
    
    func endSearch(_ viewController: ResponderViewControllerOld) {
        let tableViewHeight = 0.336 * UIScreen.main.bounds.width
        
        let finalOriginY = viewController.view.frame.origin.y + tableViewHeight
        let finalViewHeight = viewController.view.frame.size.height - tableViewHeight
        
        UIView.animate(withDuration: 0.3, animations: { [unowned viewController] in
            viewController.view.frame.origin.y = finalOriginY
            viewController.view.frame.size.height = finalViewHeight
            viewController.accessoryView?.frame.origin.y -= tableViewHeight
        })
    }
    
    func showExpandedSuggesstions(_ viewController: UIViewController, from parent: ResponderViewControllerOld) {
        let tableViewHeight = 0.336 * UIScreen.main.bounds.width
        guard let textViewOrigin = parent.accessoryView?.textViewOrigin else { return }
        let translatedOrigin = parent.view.convert(textViewOrigin, to: parent.view)
        
        let frame = CGRect(x: 0, y: translatedOrigin.y, width: UIScreen.main.bounds.width, height: tableViewHeight)
        viewController.view.frame = frame
        
        viewController.view.drawThinBottomShadow()
        parent.addChildViewController(viewController)
        parent.view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: parent)
    }
    
    func showSuggestions(_ viewController: ReceiversSuggestionViewController, from parent: UIViewController) {
        let tableViewHeight = 0.336 * UIScreen.main.bounds.width
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tableViewHeight)
        viewController.view.frame = frame
        viewController.view.backgroundColor = .clear
        viewController.suggestionsTableView?.backgroundColor = .white
        
        viewController.view.drawTopShadow()
        parent.addChildViewController(viewController)
        parent.view.addSubview(viewController.view)
        parent.view.sendSubview(toBack: viewController.view)
        viewController.didMove(toParentViewController: parent)
    }
    
    func hideSuggestions(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

