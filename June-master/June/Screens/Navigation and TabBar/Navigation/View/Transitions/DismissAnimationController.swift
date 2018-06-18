//
//  DismissAnimationController.swift
//  Romio
//
//  Created by Arjun Busani on 8/1/17.
//  Copyright © 2017 Romio. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let leftOffset: CGFloat = 200
    var destinationFrame = CGRect.zero

    // Navigation Bar Placeholder
    var navigationRect: CGRect = CGRect.zero
    var navBarHeight: CGFloat {
        get {
            return navigationRect.origin.y
        }
    }

    // Progress View
    var progressView: NavigationProgressView = NavigationProgressView(frame: CGRect.zero)

    var fromPosition: CGFloat = 0
    var initialPoision: CGRect {
        get {
            let width = navigationRect.size.width*toPosition
            return CGRect(x: 0, y: navBarHeight, width: width, height: NavigationProgressView.lineHeight)
        }
    }
    
    var toPosition: CGFloat = 0
    var finalPosition: CGFloat {
        get {
            return navigationRect.size.width*fromPosition
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CustomNavBarViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)  as? CustomNavBarViewController
            else {
                return
        }

        fromVC.showProgressView = false
        toVC.showProgressView = true

        let offScreenRight = CGAffineTransform(translationX: containerView.frame.width, y: 0)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        toVC.view.frame.origin.x = -leftOffset
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        self.progressView = NavigationProgressView.progressView(frame: self.initialPoision)
        containerView.addSubview(progressView)
        containerView.bringSubview(toFront: progressView)

        toVC.view.isHidden = false
        fromVC.view.isHidden = false
        
        let duration = self.transitionDuration(using: transitionContext)
        
        fromVC.fadeOutNavBarAnimation(withDuration: duration, direction: .right, show: false, completion: {})
        let titleOriginX: CGFloat = toVC.resetNavBarElements(hide: true)
        toVC.fadeInNavBarAnimation(withDuration: duration, direction: .right, titleOriginX: titleOriginX, show: true, completion: {})
        
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.transform = offScreenRight
            toVC.view.frame.origin.x = 0
            self.progressView.frame.size.width = self.finalPosition
        }, completion: { (finished) in
            self.progressView.removeFromSuperview()
            fromVC.view.isHidden = false
            toVC.view.isHidden = false
            toVC.view.frame = finalFrame
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
