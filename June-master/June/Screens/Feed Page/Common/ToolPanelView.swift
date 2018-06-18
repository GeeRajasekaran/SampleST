//
//  ToolPanelView.swift
//  June
//
//  Created by Ostap Holub on 9/1/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ToolPanelView: UIView {
    
    // MARK: - Variables
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var moreOptionsButton = UIButton()
    var bookmarkButton = StarButton()
    var shareButton = UIButton()
    var recategorizeButton = UIButton()
    
    // MARK: - Public part
    
    func setupSubviews() {
        addBookmarkButton()
        addShareButton()
        addMoreOptionsButton()
    }
    
    func starIfNeeded(for thread: Threads?) {
        var imageName = ""
        if thread?.starred == true {
            imageName = LocalizedImageNameKey.DetailViewHelper.BookmarkIconSelected
            bookmarkButton.selectionState = .selected
        } else if thread?.starred == false {
            imageName = LocalizedImageNameKey.DetailViewHelper.BookmarkIconIdle
            bookmarkButton.selectionState = .idle
        }
        let image = UIImage(named: imageName)
        bookmarkButton.setImage(image, for: .normal)
    }
    
    // MARK: - Options button
    
    private func addMoreOptionsButton() {
        let width = frame.width / 4
        
        let optionsFrame = CGRect(x: shareButton.frame.origin.x - width, y: 0, width: width, height: frame.height)
        let size = CGSize(width: 0.013 * screenWidth, height: 0.047 * screenWidth)
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.MoreOptions)?.imageResize(sizeChange: size)
        
        moreOptionsButton = UIButton(frame: optionsFrame)
        moreOptionsButton.backgroundColor = .clear
        moreOptionsButton.setImage(image, for: .normal)
        moreOptionsButton.contentMode = .scaleAspectFit
        
        addSubviewIfNeeded(moreOptionsButton)
    }
    
    // MARK: - Star button
    
    private func addBookmarkButton() {
        let width = frame.width / 4
        
        let bookmarkFrame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
        let size = CGSize(width: 0.04 * screenWidth, height: 0.048 * screenWidth)
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.BookmarkIconIdle)?.imageResize(sizeChange: size)
        
        bookmarkButton = StarButton(frame: bookmarkFrame)
        bookmarkButton.backgroundColor = .clear
        bookmarkButton.setImage(image, for: .normal)
        bookmarkButton.contentMode = .scaleAspectFit
        
        addSubviewIfNeeded(bookmarkButton)
    }
    
    // MARK: - Share button
    
    private func addShareButton() {
        let width = frame.width / 4
        
        let shareFrame = CGRect(x: bookmarkButton.frame.origin.x - width, y: 0, width: width, height: frame.height)
        let size = CGSize(width: 0.058 * screenWidth, height: 0.045 * screenWidth)
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.Share)?.imageResize(sizeChange: size)
        
        shareButton = UIButton(frame: shareFrame)
        shareButton.backgroundColor = .clear
        shareButton.setImage(image, for: .normal)
        shareButton.contentMode = .scaleAspectFit
        
        addSubviewIfNeeded(shareButton)
    }
    
    private func addRecategorizeButton() {
        let width = frame.width / 4
        
        let recategorizeFrame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        let size = CGSize(width: 0.056 * screenWidth, height: 0.053 * screenWidth)
        let image = UIImage(named: LocalizedImageNameKey.DetailViewHelper.Recategorize)?.imageResize(sizeChange: size)
        
        recategorizeButton = UIButton(frame: recategorizeFrame)
        recategorizeButton.backgroundColor = .clear
        recategorizeButton.setImage(image, for: .normal)
        recategorizeButton.contentMode = .scaleAspectFit
        
        addSubviewIfNeeded(recategorizeButton)
    }
}
