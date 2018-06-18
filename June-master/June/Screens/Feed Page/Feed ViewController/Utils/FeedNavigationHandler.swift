//
//  FeedNavigationHandler.swift
//  June
//
//  Created by Ostap Holub on 8/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol FeedNavigationDelegate: class {
    func handler(_ navigationHandler: FeedNavigationHandler, didHideSingleCategoryViewWith category: FeedCategory)
}

class FeedNavigationHandler: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Variables & Constants
    
    fileprivate unowned var rootViewController: UIViewController
    weak var delegate: FeedNavigationDelegate?
    private weak var lastSavedCategory: FeedCategory?
    fileprivate var animator = NavigationAnimator()
    
    // MARK: - Initialization
    
    init(with rootVC: UIViewController) {
        rootViewController = rootVC
    }
    
    // MARK: - Navigation to detail view
    
    func showDetailView(for card: FeedItem, with recagorizeCategories: [FeedCategory], cardView: IFeedCardView? = nil, provider: ThreadsDataProvider?) {
        let vc = FeedDetailedViewController()
        vc.cardView = cardView
        vc.currentCard = card
        vc.categories = recagorizeCategories
        vc.threadsDataProvider = provider
        rootViewController.navigationController?.interactivePopGestureRecognizer?.delegate = self
        rootViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Single category view
    
    func showSingleCategoryView(with category: FeedCategory, using storage: FeedDataRepository, recategorizeHandler: RecategorizeHandler?, with selectionDelegate: SingleCategorySelectionDelegate? = nil) {
        
        let singleCategoryVC = SingleCategoryViewController()
        singleCategoryVC.selectionDelegate = selectionDelegate
        singleCategoryVC.selectedCategory = category
        singleCategoryVC.dataRepository = storage
        singleCategoryVC.recategorizeHandler = recategorizeHandler
        rootViewController.navigationController?.pushViewController(singleCategoryVC, animated: true)
    }
    
    func hideSingleCategoryView() {
        if let childVC = rootViewController.childViewControllers.first {
            childVC.removeFromParentViewController()
            childVC.didMove(toParentViewController: nil)
            performHidingAnimation(with: childVC.view)
        }
    }
    
    func updateSingleCategoryView(with category: FeedCategory) {
        if let singleCategoryVC = rootViewController.childViewControllers.first as? SingleCategoryViewController {
            lastSavedCategory = category
            singleCategoryVC.selectedCategory = category
        }
    }
    
    // MARK: - Private part
    
    private func performShowingAnimation(with view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.frame.origin.x = 0
        })
    }
    
    private func performHidingAnimation(with view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.frame.origin.x = UIScreen.main.bounds.width
        }, completion: { [weak self] _ in
            view.removeFromSuperview()
            guard let strongSelf = self, let unwrappedCategory = strongSelf.lastSavedCategory else { return }
            self?.delegate?.handler(strongSelf, didHideSingleCategoryViewWith: unwrappedCategory)
        })
    }
}

extension FeedNavigationHandler: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        animator.originalFrame = UIScreen.main.bounds
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        animator.originalFrame = UIScreen.main.bounds
        return animator
    }
}
