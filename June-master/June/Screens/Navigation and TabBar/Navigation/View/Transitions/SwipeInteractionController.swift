//
//  SwipeInteractionController.swift
//  Romio
//
//  Created by Arjun Busani on 8/1/17.
//  Copyright © 2017 Romio. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    var interactionInProgress = false
    
    fileprivate var shouldCompleteTransition = false
    fileprivate weak var viewController: UIViewController!

    func wireToViewController(_ viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }

    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }

    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 300)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            viewController.navigationController?.popViewController(animated: true)
            
        case .changed:
            shouldCompleteTransition = progress > 0.4
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
}
