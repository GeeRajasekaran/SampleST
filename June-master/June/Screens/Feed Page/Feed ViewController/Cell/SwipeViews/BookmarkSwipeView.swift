//
//  BookmarkSwipeView.swift
//  June
//
//  Created by Ostap Holub on 1/15/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BookmarkSwipeView: UIView, ISwipeView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private var bookmarkActionButton: UIButton?
    private var titleLabel: UILabel?
    
    private let addBookmarkSize = CGSize(width: 0.04 * UIScreen.main.bounds.width, height: 0.048 * UIScreen.main.bounds.width)
    
    private let removeBookmarkSize = CGSize(width: 0.053 * UIScreen.main.bounds.width, height: 0.053 * UIScreen.main.bounds.width)
    
    var indexPath: IndexPath?
    var parentCell: FeedSwipyCell?
    
    var actions = [(IndexPath, FeedSwipyCell) -> Void]()
    
    // MARK: - General view setup
    
    func updateIcon(_ isBookmarked: Bool) {
        
        let size = isBookmarked ? removeBookmarkSize : addBookmarkSize
        
        let normalImageName = isBookmarked ? LocalizedImageNameKey.FeedViewHelper.SwipeRemoveBookmarkIconNormal : LocalizedImageNameKey.FeedViewHelper.SwipeBookmarkIconNormal
        let hightlightedImageName = isBookmarked ? LocalizedImageNameKey.FeedViewHelper.SwipeRemoveBookmarkIconHighlighted : LocalizedImageNameKey.FeedViewHelper.SwipeBookmarkIconHighlighted
        let normalImage = UIImage(named: normalImageName)?.imageResize(sizeChange: size)
        let hightlightedImage = UIImage(named: hightlightedImageName)?.imageResize(sizeChange: size)
        bookmarkActionButton?.setImage(normalImage, for: .normal)
        bookmarkActionButton?.setImage(hightlightedImage, for: .highlighted)
    }
    
    func setupView(at indexPath: IndexPath, with actions: [(IndexPath, FeedSwipyCell) -> Void], isBookmarked: Bool) {
        backgroundColor = UIColor.swipeBackgroundColor
        self.indexPath = indexPath
        self.actions = actions
        addBookmarkActionButton(isBookmarked)
        addTitleLabel(isBookmarked)
    }
    
    // MARK: - Button setup
    
    private func addBookmarkActionButton(_ isBookmarked: Bool) {
        guard bookmarkActionButton == nil else { return }
        let rightInset = 0.198 * screenWidth
        
        let size = CGSize(width: 0.117 * screenWidth, height: 0.117 * screenWidth)
        let origin = CGPoint(x: rightInset, y: (frame.height / 2 - size.height / 2) - 0.1 * frame.height)
        bookmarkActionButton = SwipeActionButtonBuilder.buildAttributedButton(with: CGRect(origin: origin, size: size))
        
        updateIcon(isBookmarked)
        bookmarkActionButton?.addTarget(self, action: #selector(handleBookmarkAction), for: .touchUpInside)
        bookmarkActionButton?.tag = 0
        
        if bookmarkActionButton != nil {
            addSubview(bookmarkActionButton!)
        }
    }
    
    @objc private func handleBookmarkAction() {
        if let tag = bookmarkActionButton?.tag, let unwrappedIndex = indexPath, let cell = parentCell {
            if tag >= 0 && tag < actions.count {
                let action = actions[tag]
                action(unwrappedIndex, cell)
            }
        }
    }
    
    // MARK: - Title label setup
    
    private func addTitleLabel(_ isBookmarked: Bool) {
        guard titleLabel == nil else { return }
        
        let size = CGSize(width: 0.15 * screenWidth, height: 0.032 * screenWidth)
        titleLabel = SwipeActionButtonBuilder.buildTitle(for: bookmarkActionButton, with: size)
        titleLabel?.text = isBookmarked ? LocalizedStringKey.FeedViewHelper.SwipeRemoveBookmark : LocalizedStringKey.FeedViewHelper.SwipeAddBookmark
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
}
