//
//  ForwardNavigationHandler.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ForwardNavigationHandler: INavigationHandler {
    
    unowned var rootViewController: UIViewController
    var defaultHeight: CGFloat {
        get { return 0.336 * UIScreen.main.bounds.width + 0.096 * UIScreen.main.bounds.width }
    }
    
    var initialResponderMinimizeFrame: CGRect = .zero
    
    required init(rootVC: UIViewController) {
        rootViewController = rootVC
    }
    
    func show(_ viewController: ResponderViewControllerOld) {
        var height: CGFloat = 0
        let minimizeHeight = 0.144 * UIScreen.main.bounds.width
        if viewController.config?.isMinimizationEnabled == true {
            height = minimizeHeight
        } else {
            height = 0.336 * UIScreen.main.bounds.width + 0.096 * UIScreen.main.bounds.width
        }
        guard let navigationController = rootViewController.navigationController else { return }
        viewController.view.frame = CGRect(x: 0, y: navigationController.view.frame.height - height, width: navigationController.view.frame.width, height: height)

        navigationController.view.addSubview(viewController.view)
        
        //MARK: - calculate inital frame for responder minimize state
        calculateresponderMinimizeFrame(viewController, in: navigationController)
    }
    
    func calculateresponderMinimizeFrame(_ viewController: ResponderViewControllerOld, in navigationVC: UINavigationController) {
        let minimizeHeight = 0.144 * UIScreen.main.bounds.width
        
        if viewController.config?.isMinimizationEnabled == true {
            initialResponderMinimizeFrame = viewController.view.frame
        } else {
            initialResponderMinimizeFrame =  CGRect(x: 0, y: navigationVC.view.frame.height - minimizeHeight, width: navigationVC.view.frame.width, height: minimizeHeight)
        }
    }
    
    func hide(_ viewController: ResponderViewControllerOld) {
        viewController.view.removeFromSuperview()
    }
    
    func collapse(_ viewController: ResponderViewControllerOld, to lastHeight: CGFloat?) {
        let currentHeight = viewController.view.frame.height
//        let targetViewHeight = 0.336 * UIScreen.main.bounds.width + 0.096 * UIScreen.main.bounds.width
        
//        let targetViewHeight = lastHeight == nil ? 0.336 * UIScreen.main.bounds.width + 0.096 * UIScreen.main.bounds.width : lastHeight!
        var targetViewHeight: CGFloat = 0
        if let unwrappedLastHeight = lastHeight {
            targetViewHeight = unwrappedLastHeight
        } else {
            if let isAttchmentsExist = viewController.accessoryView?.isAttchmentsExist() {
                if isAttchmentsExist {
                    targetViewHeight = (0.336 + 0.15 + 0.096) * UIScreen.main.bounds.width
                } else {
                    targetViewHeight = (0.336 +  0.096) * UIScreen.main.bounds.width
                }
            } else {
                targetViewHeight = (0.336 +  0.096) * UIScreen.main.bounds.width
            }
        }
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
