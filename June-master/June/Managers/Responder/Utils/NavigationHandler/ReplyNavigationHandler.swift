//
//  ReplyNavigationHandler.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyNavigationHandler: INavigationHandler {
    
    // MARK: - Variables
    
    unowned var rootViewController: UIViewController
    var defaultHeight: CGFloat {
        get { return  0.336 * UIScreen.main.bounds.width }
    }
    
    var initialResponderMinimizeFrame: CGRect = .zero
    
    // MARK: - Initializer
    
    required init(rootVC: UIViewController) {
        rootViewController = rootVC
    }
    
    // MARK: - Public part
    
    func show(_ viewController: ResponderViewControllerOld) {
        addChild(viewController)
    }
    
    func hide(_ viewController: ResponderViewControllerOld) {
        removeChild(viewController)
    }
    
    // MARK: - Private part
    
    private func addChild(_ viewController: ResponderViewControllerOld) {
        var height: CGFloat = 0
        var delta: CGFloat = 0
        let minimizeHeight = 0.144 * UIScreen.main.bounds.width
        if viewController.config?.isMinimizationEnabled == true {
            height = minimizeHeight
            if #available(iOS 11.0, *) {
                if let bottomInsets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom {
                    delta = bottomInsets
                }
            }
        } else {
            height = 0.336 * UIScreen.main.bounds.width
        }
        guard let navigationController = rootViewController.navigationController else { return }        
        viewController.view.frame = CGRect(x: 0, y: navigationController.view.frame.height - height - delta, width: navigationController.view.frame.width, height: height)
        
        navigationController.view.addSubview(viewController.view)
        
        //MARK: - calculate inital frame for responder minimize state
       calculateresponderMinimizeFrame(viewController, in: navigationController, with: delta)
    }
    
    func calculateresponderMinimizeFrame(_ viewController: ResponderViewControllerOld, in navigationVC: UINavigationController, with delta: CGFloat) {
        let minimizeHeight = 0.144 * UIScreen.main.bounds.width
        
        if viewController.config?.isMinimizationEnabled == true {
            initialResponderMinimizeFrame = viewController.view.frame
        } else {
            initialResponderMinimizeFrame =  CGRect(x: 0, y: navigationVC.view.frame.height - minimizeHeight - delta, width: navigationVC.view.frame.width, height: minimizeHeight)
        }
    }
    
    private func removeChild(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
    }
    
    func collapse(_ viewController: ResponderViewControllerOld, to lastHeight: CGFloat?) {
        let currentHeight = viewController.view.frame.height
        var targetViewHeight: CGFloat = 0
        if let unwrappedLastHeight = lastHeight {
            targetViewHeight = unwrappedLastHeight
        } else {
            if (viewController.accessoryView?.isAttchmentsExist())! {
                targetViewHeight = (0.336 + 0.15) * UIScreen.main.bounds.width
            } else {
               targetViewHeight = 0.336 * UIScreen.main.bounds.width
            }
        }
//        let targetViewHeight = lastHeight == nil ? 0.336 * UIScreen.main.bounds.width : lastHeight!
        
        let heightDelta = currentHeight - targetViewHeight
        let targetOriginY = viewController.view.frame.origin.y + heightDelta
        
        UIView.animate(withDuration: 0.3, animations: { [unowned viewController] in
            viewController.view.frame.origin.y = targetOriginY
            viewController.view.frame.size.height = targetViewHeight
            viewController.accessoryView?.frame.size.height = targetViewHeight
            viewController.accessoryView?.updateLayout(for: targetViewHeight)
        })
    }
}
