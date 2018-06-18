//
//  FeedSwipyCell.swift
//  June
//
//  Created by Ostap Holub on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedSwipyCell: SwipyCell {
    
    // MARK: - Variables
    
    private var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    private var thresholdPoints: [CGFloat] = [0.2]
    private var stopPoints: [CGFloat] = [0.45]
    private var isRightActionTriggered: Bool = false
    private var isLeftActionTriggered: Bool = false
    
    // MARK: - Active view frame building
    
    override func colorIndicatorRect(with rect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0.016 * screenWidth, width: bounds.width, height: bounds.height - 0.032 * screenWidth)
    }
    
    override func buildActiveViewFrame(with position: CGPoint, for viewSize: CGSize) -> CGRect {
        let originX = direction == .left ? position.x + (viewSize.width / 2.0) / 8.0 : position.x - viewSize.width
        return CGRect(x: originX,
                      y: position.y - (viewSize.height / 2.0) - 0.016 * screenWidth,
                      width: viewSize.width,
                      height: viewSize.height + (0.01 * screenWidth))
    }
    
    // MARK: - Extended swiping logic
    
    private func swipeToOriginAndTrigger() {
        swipeToOrigin {
            self.resetActiveTrigger()
        }
    }
    
    private func setTriggerActive() {
        if direction == .right {
            isLeftActionTriggered = true
        } else {
            isRightActionTriggered = true
        }
    }
    
    private func resetActiveTrigger() {
        if direction == .right {
            isLeftActionTriggered = false
        } else {
            isRightActionTriggered = false
        }
    }
    
    override func handleRegularSwipingBack(_ cell: SwipyCell, atState state: SwipyCellState, triggerActivated activated: Bool) {
        let coef: CGFloat = direction == .right ? 1.0 : -1.0
        let stopPointHit = direction == .right ? isLeftActionTriggered : isRightActionTriggered
        
        if stopPointHit && coef * (contentScreenshotView?.frame.origin.x ?? 0) < stopPoints[0] * UIScreen.main.bounds.width {
            swipeToOriginAndTrigger()
            delegate?.swipyCellDidFinishSwiping(cell, atState: state, triggerActivated: activated)
        } else if coef * (contentScreenshotView?.frame.origin.x ?? 0) < thresholdPoints[0] * UIScreen.main.bounds.width {
            swipeToOriginAndTrigger()
            delegate?.swipyCellDidFinishSwiping(cell, atState: state, triggerActivated: activated)
        } else if coef * (contentScreenshotView?.frame.origin.x ?? 0) >= thresholdPoints[0] * UIScreen.main.bounds.width {
            let stopPoint = stopPoints[0]
            setTriggerActive()
            let duration = Double(0.2 * velocity)
            UIView.animate(withDuration: duration, animations: {
                self.contentScreenshotView?.frame.origin.x = coef * stopPoint * UIScreen.main.bounds.width
            })
        }
    }
}
