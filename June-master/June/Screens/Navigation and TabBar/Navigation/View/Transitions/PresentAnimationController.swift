//
//  PresentAnimationController.swift
//  June
//
//  Created by Joshua Cleetus on 12/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRect.zero
    
    // Navigation Bar Placeholder
    var navigationRect: CGRect = CGRect.zero
    var navBarHeight: CGFloat {
        get {
            return navigationRect.origin.y
        }
    }
    
    // Progress View
    var progressView: NavigationProgressView?
    
    var fromPosition: CGFloat = 0
    var initialPoision: CGRect {
        get {
            let width = navigationRect.size.width*fromPosition
            return CGRect(x: 0, y: navBarHeight, width: width, height: NavigationProgressView.lineHeight)
        }
    }
    
    var toPosition: CGFloat = 0
    var finalPosition: CGFloat {
        get {
            return navigationRect.size.width*toPosition
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CustomNavBarViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? CustomNavBarViewController
            else {
                return
        }
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let offScreenLeft = CGAffineTransform(translationX: -(containerView.frame.width), y: navBarHeight)
        let offScreenRight = CGAffineTransform(translationX: containerView.frame.width, y: 0)
        
        let initialLeft = CGAffineTransform(translationX: 0, y: navBarHeight)
        let initiaFrame = CGAffineTransform(translationX: 0, y: 0)
        
        toVC.view.transform = offScreenRight
        toVC.view.frame.origin.y = 0
        
        DispatchQueue.main.async {
            toVC.showProgressView = false
            
            let fromSnapshot = fromVC.view.snapshotView(frame: self.navigationRect)
            
            fromSnapshot?.transform = initialLeft
            
            if let fromScreenshot = fromSnapshot {
                containerView.addSubview(fromScreenshot)
            }
            containerView.addSubview(toVC.view)
            
            self.progressView = NavigationProgressView.progressView(frame: self.initialPoision)
            if let progressView = self.progressView {
                containerView.addSubview(progressView)
            }
            
            toVC.view.isHidden = false
            
            DispatchQueue.main.async(execute: {
                
                let duration = self.transitionDuration(using: transitionContext)
                let titleOriginX = toVC.resetNavBarElements(hide: true)
                toVC.fadeInNavBarAnimation(withDuration: duration, direction: .left, titleOriginX: titleOriginX, completion: { })
                fromVC.fadeOutNavBarAnimation(withDuration: duration, direction: .left, completion: {})
                
                UIView.animate(withDuration: duration, animations: {
                    fromSnapshot?.transform = offScreenLeft
                    toVC.view.transform = initiaFrame
                    self.progressView?.frame.size.width = self.finalPosition
                }, completion: { (finished) in
                    self.progressView?.removeFromSuperview()
                    toVC.view.isHidden = false
                    toVC.view.frame = finalFrame
                    fromVC.view.transform = initiaFrame
                    fromVC.view.isHidden = false
                    fromSnapshot?.removeFromSuperview()
                    toVC.showProgressView = true
                    fromVC.showProgressView = true
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            })
        }
    }
}

