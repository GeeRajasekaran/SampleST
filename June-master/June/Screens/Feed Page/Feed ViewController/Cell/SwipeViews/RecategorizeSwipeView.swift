//
//  RecategorizeSwipeView.swift
//  June
//
//  Created by Ostap Holub on 1/15/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RecategorizeSwipeView: UIView, ISwipeView {
    
    // MARK: - Variables
    
    let screenWidth = UIScreen.main.bounds.width
    var indexPath: IndexPath?
    var parentCell: FeedSwipyCell?
    
    private var recategorizeButton: UIButton?
    private var shareButton: UIButton?
    private var recategorizeTitleLabel: UILabel?
    private var shareTitleLabel: UILabel?
    
    var actions = [(IndexPath, FeedSwipyCell) -> Void]()
    
    // MARK: - View setup
    
    func setupView(actions: [(IndexPath, FeedSwipyCell) -> Void]) {
        backgroundColor = UIColor.swipeBackgroundColor
        self.actions = actions
        addRecategorizeButton()
        addShareButton()
        addRecategorizeTitleLabel()
        addShareTitleLabel()
    }
    
    // MARK: - Recategorize  button setup
    
    private func recategorizeImage(with name: String) -> UIImage? {
        return UIImage(named: name)?.imageResize(sizeChange: CGSize(width: 0.053 * screenWidth, height: 0.056 * screenWidth))
    }
    
    private func shareImage(with name: String) -> UIImage? {
        return UIImage(named: name)?.imageResize(sizeChange: CGSize(width: 0.069 * screenWidth, height: 0.058 * screenWidth))
    }
    
    private func addRecategorizeButton() {
        guard recategorizeButton == nil else { return }
        
        let size = CGSize(width: 0.117 * screenWidth, height: 0.117 * screenWidth)
        let origin = CGPoint(x: frame.width - (0.386 * screenWidth), y: (frame.height / 2 - size.height / 2) - 0.1 * frame.height)
        
        recategorizeButton = SwipeActionButtonBuilder.buildAttributedButton(with: CGRect(origin: origin, size: size))
        let normalImage = recategorizeImage(with: LocalizedImageNameKey.FeedViewHelper.SwipeRecategorizeNormal)
        let highlightedImage = recategorizeImage(with: LocalizedImageNameKey.FeedViewHelper.SwipeRecategorizeHighlighted)
        recategorizeButton?.setImage(normalImage, for: .normal)
        recategorizeButton?.setImage(highlightedImage, for: .highlighted)
        recategorizeButton?.addTarget(self, action: #selector(handleRecategorizeClick), for: .touchUpInside)
        recategorizeButton?.tag = 0
        
        if recategorizeButton != nil {
            addSubview(recategorizeButton!)
        }
    }
    
    @objc private func handleRecategorizeClick() {
        if let tag = recategorizeButton?.tag, let unwrappedIndex = indexPath, let unwrappedCell = parentCell {
            let action = actions[tag]
            action(unwrappedIndex, unwrappedCell)
        }
    }
    
    // MARK: - Recategorize title setup
    
    private func addRecategorizeTitleLabel() {
        guard recategorizeTitleLabel == nil else { return }
        
        let size = CGSize(width: 0.25 * screenWidth, height: 0.04 * screenWidth)
        recategorizeTitleLabel = SwipeActionButtonBuilder.buildTitle(for: recategorizeButton, with: size)
        recategorizeTitleLabel?.text = LocalizedStringKey.FeedViewHelper.SwipeRecategorizeTitle
        
        if recategorizeTitleLabel != nil {
            addSubview(recategorizeTitleLabel!)
        }
    }
    
    // MARK: - Share button setup
    
    private func addShareButton() {
        guard shareButton == nil else { return }
        guard let recategorizeFrame = recategorizeButton?.frame else { return }
        
        let size = CGSize(width: 0.117 * screenWidth, height: 0.117 * screenWidth)
        let origin = CGPoint(x: recategorizeFrame.origin.x + recategorizeFrame.width + 0.08 * screenWidth, y: (frame.height / 2 - size.height / 2) - 0.1 * frame.height)
        
        shareButton = SwipeActionButtonBuilder.buildAttributedButton(with: CGRect(origin: origin, size: size))
        let normalImage = shareImage(with: LocalizedImageNameKey.FeedViewHelper.SwipeShareNormal)
        let highlitghtedImage = shareImage(with: LocalizedImageNameKey.FeedViewHelper.SwipeShareHighlithed)
        shareButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.01 * screenWidth, bottom: 0.01 * screenWidth, right: 0)
        shareButton?.setImage(normalImage, for: .normal)
        shareButton?.setImage(highlitghtedImage, for: .highlighted)
        shareButton?.addTarget(self, action: #selector(handleShareClick), for: .touchUpInside)
        shareButton?.tag = 1
        
        if shareButton != nil {
            addSubview(shareButton!)
        }
    }
    
    @objc private func handleShareClick() {
        if let tag = shareButton?.tag, let unwrappedIndex = indexPath, let unwrappedCell = parentCell {
            if tag >= 0 && tag < actions.count {
                let action = actions[tag]
                action(unwrappedIndex, unwrappedCell)
            }
        }
    }
    
    // MARK: - Share title setup
    
    private func addShareTitleLabel() {
        guard shareTitleLabel == nil else { return }
        
        let size = CGSize(width: 0.15 * screenWidth, height: 0.04 * screenWidth)
        shareTitleLabel = SwipeActionButtonBuilder.buildTitle(for: shareButton, with: size)
        shareTitleLabel?.text = LocalizedStringKey.FeedViewHelper.SwipeShareTitle
        
        if shareTitleLabel != nil {
            addSubview(shareTitleLabel!)
        }
    }
}
