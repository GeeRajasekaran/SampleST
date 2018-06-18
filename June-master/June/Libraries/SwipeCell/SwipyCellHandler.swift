//
//  SwipyCellHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SwipyCellHandler: NSObject {

    typealias SwipeAction = (IndexPath, FeedSwipyCell) -> Void
    
    // MARK: - Swipe views array    
    var leftViewsMap = [Int: [BookmarkSwipeView]]()
    var rightViewsMap = [Int: [RecategorizeSwipeView]]()
    
    var isSwipeEnabled = true
    private let screenWidth = UIScreen.main.bounds.width
    private let feedTableInset: CGFloat = -0.032
    private var pendingCell: SwipyCell?
    
    //TODO: configure cell in method
    func configure(_ cell: SwipyCell?) {
        isSwipeEnabled = true
        cell?.delegate = self
    }
    
    // MARK: - Feed swipe cell configuration
    
    func configure(feedCell: FeedSwipyCell, at indexPath: IndexPath, with leftActions: [SwipeAction], rightActions: [SwipeAction], item: FeedGenericItemInfo) {
        isSwipeEnabled = true
        feedCell.delegate = self
        
        let swipeViewFrame = CGRect(x: feedTableInset * screenWidth, y: 0, width: screenWidth, height: feedCell.frame.height - 2 * FeedGenericCardLayoutConstants.bottomInset)
        let leftView = buildLeftSwipeView(with: swipeViewFrame, at: indexPath, cell: feedCell, actions: leftActions, isBookmarked: item.starred)
        let rightView = buildRightSwipeView(with: swipeViewFrame, at: indexPath, cell: feedCell, actions: rightActions)
        
        feedCell.setTriggerPoints(points: [0.2, 0.5, 0.8])
        feedCell.addSwipeTrigger(forState: .state(0, .left), withMode: .none, swipeView: leftView, swipeColor: UIColor.recentTableViewBackgroundColor, completion: nil)
        feedCell.addSwipeTrigger(forState: .state(0, .right), withMode: .none, swipeView: rightView, swipeColor: UIColor.recentTableViewBackgroundColor, completion: nil)
    }
    
    // MARK: - Private feed cell setup
    
    private func buildLeftSwipeView(with rect: CGRect, at indexPath: IndexPath, cell: FeedSwipyCell, actions: [SwipeAction], isBookmarked: Bool) -> BookmarkSwipeView {        
        let leftView = BookmarkSwipeView(frame: rect)
        leftView.setupView(at: indexPath, with: actions, isBookmarked: isBookmarked)
        leftView.parentCell = cell
        
        if let leftViews = leftViewsMap[indexPath.section] {
            if indexPath.row < leftViews.count {
                leftViewsMap[indexPath.section]?[indexPath.row] = leftView
            } else {
                leftViewsMap[indexPath.section]?.append(leftView)
            }
        } else {
            leftViewsMap[indexPath.section] = [leftView]
        }
        return leftView
    }
    
    private func buildRightSwipeView(with rect: CGRect, at indexPath: IndexPath, cell: FeedSwipyCell, actions: [SwipeAction]) -> RecategorizeSwipeView {
        let rightView = RecategorizeSwipeView(frame: rect)
        rightView.indexPath = indexPath
        rightView.parentCell = cell
        rightView.setupView(actions: actions)
        
        if let rightViews = rightViewsMap[indexPath.section] {
            if indexPath.row < rightViews.count {
                rightViewsMap[indexPath.section]?[indexPath.row] = rightView
            } else {
                rightViewsMap[indexPath.section]?.append(rightView)
            }
        } else {
            rightViewsMap[indexPath.section] = [rightView]
        }
        return rightView
    }
    
    func cancelSwipeForPendigCell() {
        pendingCell?.swipeToOrigin { [weak self] in
            self?.pendingCell = nil
            self?.isSwipeEnabled = true
        }
    }
}

extension SwipyCellHandler: SwipyCellDelegate {

    func shouldSwipeCell(_ cell: SwipyCell) -> Bool {
        if pendingCell == nil {
            pendingCell = cell
            if isSwipeEnabled {
                isSwipeEnabled = false
                return true
            }
            return false
        } else {
            return pendingCell == cell
        }
    }
    
    func swipyCellDidStartSwiping(_ cell: SwipyCell) {
        if let cardCell = cell as? FeedItemCell {
            cardCell.cardView?.view.layer.shadowOpacity = 0.0
        }
    }
    
    func swipyCellDidFinishSwiping(_ cell: SwipyCell, atState state: SwipyCellState, triggerActivated activated: Bool) {
        if let cardCell = cell as? FeedItemCell {
            cardCell.cardView?.view.layer.shadowOpacity = 0.5
        }
        isSwipeEnabled = true
        pendingCell = nil
    }
    
    func swipyCell(_ cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat, currentState state: SwipyCellState, triggerActivated activated: Bool) {
    }
}
