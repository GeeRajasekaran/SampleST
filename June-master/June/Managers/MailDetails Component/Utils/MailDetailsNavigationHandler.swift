//
//  SuggestionsNavigationHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/8/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class MailDetailsNavigationHandler {

    // MARK: - Variables & Constanst
    
    private let screenWidth = UIScreen.main.bounds.width
    private unowned var rootViewController: BaseMailDetailsViewController
    private let window = UIApplication.shared.keyWindow
    
    // MARK: - Initialization
    
    init(rootVC: BaseMailDetailsViewController) {
        rootViewController = rootVC
    }
    
    // MARK: - Emails table view presentation and hiding logic
    
    func showEmailsTable(_ viewController: UIViewController) {
        rootViewController.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0.134 * screenWidth, width: screenWidth, height: 0)
        rootViewController.mailDetailsView?.addSubview(viewController.view)
        rootViewController.mailDetailsView?.sendSubview(toBack: viewController.view)
        viewController.didMove(toParentViewController: rootViewController)
    }
    
    // MARK: - Receivers suggestions presentation and hiding logic
    
    func showSuggestions(_ viewController: UIViewController) {
        if rootViewController.childViewControllers.contains(viewController) { return }
        var originY = 0.48 * screenWidth
        if let mailView = rootViewController.mailDetailsView {
            let mailViewFelativeToScreenFrame = mailView.convert(rootViewController.view.bounds, to: window)
            originY = mailViewFelativeToScreenFrame.origin.y + mailView.calculateToViewBottomPosition()
        }
        rootViewController.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 4, y: originY, width: rootViewController.view.frame.width, height: 0.344 * screenWidth)
        rootViewController.view.addSubview(viewController.view)
        rootViewController.view.bringSubview(toFront: viewController.view)
        viewController.didMove(toParentViewController: rootViewController)
        viewController.view.backgroundColor = UIColor.suggestionsBackgroundColor
        viewController.view.drawThinBottomShadow()
        if let vc = viewController as? ComposeSuggestionsViewController {
            vc.view.frame.size.width = rootViewController.baseViewWidth
            vc.suggestionsTableView?.frame.size.width = rootViewController.baseViewWidth
        }
    }
    
    func hideSuggestions(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
