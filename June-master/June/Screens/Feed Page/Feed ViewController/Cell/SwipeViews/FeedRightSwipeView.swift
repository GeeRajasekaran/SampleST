//
//  FeedLeftSwipeView.swift
//  June
//
//  Created by Ostap Holub on 11/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedRightSwipeView: UIView, ISwipeView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private var starActionButton: UIButton?
    private var titleLabel: UILabel?
    
    var indexPath: IndexPath?
    var parentCell: FeedSwipyCell?
    
    var actions = [(IndexPath, FeedSwipyCell) -> Void]()
    
    // MARK: - General view setup
    
    func updateIcon(_ isStarred: Bool) {
//        let imageName = isStarred ? LocalizedImageNameKey.FeedViewHelper.SwipeUnstarIcon : LocalizedImageNameKey.FeedViewHelper.SwipeStarIcon
//        let image = UIImage(named: imageName)?.imageResize(sizeChange: CGSize(width: 0.061 * screenWidth, height: 0.061 * screenWidth))
//        starActionButton?.setImage(image, for: .normal)
    }
    
    func setupView(at indexPath: IndexPath, with actions: [(IndexPath, FeedSwipyCell) -> Void], isStarred: Bool) {
        backgroundColor = UIColor.swipeBackgroundColor
        self.indexPath = indexPath
        self.actions = actions
        addStarActionButton(isStarred)
        addTitleLabel(isStarred)
    }
    
    // MARK: - Button setup
    
    private func addStarActionButton(_ isStarred: Bool) {
        guard starActionButton == nil else { return }
        let rightInset = 0.205 * screenWidth
        
        let size = CGSize(width: 0.117 * screenWidth, height: 0.117 * screenWidth)
        let origin = CGPoint(x: frame.width - (0.09 * screenWidth + rightInset), y: (frame.height / 2 - size.height / 2) - 0.1 * frame.height)
        starActionButton = SwipeActionButtonBuilder.buildAttributedButton(with: CGRect(origin: origin, size: size))
        
//        let imageName = isStarred ? LocalizedImageNameKey.FeedViewHelper.SwipeUnstarIcon : LocalizedImageNameKey.FeedViewHelper.SwipeStarIcon
//        let image = UIImage(named: imageName)?.imageResize(sizeChange: CGSize(width: 0.061 * screenWidth, height: 0.061 * screenWidth))
//        starActionButton?.setImage(image, for: .normal)
        starActionButton?.addTarget(self, action: #selector(handleStarAction), for: .touchUpInside)
        starActionButton?.tag = 0
        
        if starActionButton != nil {
            addSubview(starActionButton!)
        }
    }
    
    @objc private func handleStarAction() {
        if let tag = starActionButton?.tag, let unwrappedIndex = indexPath, let cell = parentCell {
            if tag >= 0 && tag < actions.count {
                let action = actions[tag]
                action(unwrappedIndex, cell)
            }
        }
    }
    
    // MARK: - Title label setup
    
    private func addTitleLabel(_ isStarred: Bool) {
        guard titleLabel == nil else { return }
        
        let size = CGSize(width: 0.15 * screenWidth, height: 0.032 * screenWidth)
        titleLabel = SwipeActionButtonBuilder.buildTitle(for: starActionButton, with: size)
        titleLabel?.text = isStarred ? LocalizedStringKey.FeedViewHelper.SwipeUnstarTitle : LocalizedStringKey.FeedViewHelper.SwipeStarTitle
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
}
