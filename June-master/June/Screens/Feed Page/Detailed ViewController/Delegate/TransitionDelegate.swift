//
//  TransitionDelegate.swift
//  June
//
//  Created by Tatia Chachua on 31/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit


class TransitionDelegate: NSObject {
    
    unowned var parentVC: DetailViewController
    
    init(parentVC: DetailViewController) {
        self.parentVC = parentVC
        super.init()
    }
}
extension TransitionDelegate  {

    class TransitionDelegate: UIPercentDrivenInteractiveTransition {

    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func wireToViewController(viewController: UIViewController!) {
        self.viewController = viewController as! DetailViewController!
        prepareGestureRecognizerInView(view: viewController.view)
        print("working")
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleGesture))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            shouldCompleteTransition = progress > 0.5
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
}
