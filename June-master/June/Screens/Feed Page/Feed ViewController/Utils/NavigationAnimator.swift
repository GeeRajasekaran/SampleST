//
//  NavigationAnimator.swift
//  June
//
//  Created by Ostap Holub on 8/31/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class NavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originalFrame: CGRect = .zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let initialFrame = originalFrame
        
        guard let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        snapshot.frame = initialFrame
        snapshot.layer.masksToBounds = true
        snapshot.alpha = 0.0
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        snapshot.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                fromVC.view.layer.transform = CATransform3DMakeScale(0, 0, 1)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5, animations: {
                fromVC.view.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                snapshot.layer.transform = CATransform3DMakeScale(1, 1, 1)
                snapshot.alpha = 1.0
            })
        }, completion: { _ in
            fromVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
            fromVC.view.alpha = 1.0
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
