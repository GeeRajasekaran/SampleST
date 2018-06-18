//
//  FeedLeftSwipeView.swift
//  June
//
//  Created by Ostap Holub on 11/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class FeedLeftSwipeView: UIView, ISwipeView {
    
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
    
    func setupView() {
        backgroundColor = UIColor.swipeBackgroundColor
        addRecategorizeButton()
        addShareButton()
        addRecategorizeTitleLabel()
        addShareTitleLabel()
    }
    
    // MARK: - Recategorize  button setup
    
    private func addRecategorizeButton() {
        guard recategorizeButton == nil else { return }
        
        let size = CGSize(width: 0.117 * screenWidth, height: 0.117 * screenWidth)
        let origin = CGPoint(x: 0.114 * screenWidth, y: (frame.height / 2 - size.height / 2) - 0.1 * frame.height)
        
        recategorizeButton = SwipeActionButtonBuilder.buildAttributedButton(with: CGRect(origin: origin, size: size))
        let image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.SwipeRecategrizeIcon)?.imageResize(sizeChange: CGSize(width: 0.053 * screenWidth, height: 0.056 * screenWidth))
        recategorizeButton?.setImage(image, for: .normal)
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
        let image = UIImage(named: LocalizedImageNameKey.FeedViewHelper.SwipeShareIcon)?.imageResize(sizeChange: CGSize(width: 0.069 * screenWidth, height: 0.058 * screenWidth))
        shareButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.013 * screenWidth, bottom: 0, right: 0)
        shareButton?.setImage(image, for: .normal)
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
