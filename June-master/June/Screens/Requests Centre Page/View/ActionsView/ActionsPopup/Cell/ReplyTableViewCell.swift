//
//  ReplyTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/29/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    private let labelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private var replyAction: ReplyAction?
    
    // MARK: - Views
    private var topSeparatorView: UIView?
    private var messageLabel: UILabel?
    private var itemImageView: UIImageView?
    
    // MARK: - Initialization
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func loadData(from replyAction: ReplyAction) {
        self.replyAction = replyAction
        messageLabel?.text = replyAction.title
        guard let imageName = replyAction.imageName else { return }
        itemImageView?.image = UIImage(named: imageName)
    }
    
    // MARK: - UI Setup
    func setupUI(shouldShowLine: Bool) {
        if shouldShowLine {
            addTopLineView()
        }
        addMessageLabel()
        addImageView()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topSeparatorView?.removeFromSuperview()
        messageLabel?.removeFromSuperview()
        itemImageView?.removeFromSuperview()
        itemImageView = nil
        topSeparatorView = nil
        messageLabel = nil
    }
    
    //UI building
    private func addTopLineView() {
        if topSeparatorView != nil { return }
        let lineHeight = 0.0053 * screenWidth
        let lineFrame = CGRect(x: 0, y: 0, width: frame.width, height: lineHeight)
        topSeparatorView = UIView(frame: lineFrame)
        topSeparatorView?.backgroundColor = UIColor.cannedResponseLineColor.withAlphaComponent(0.11)
        if topSeparatorView != nil {
            addSubview(topSeparatorView!)
        }
    }
    
    private func addImageView() {
        if itemImageView != nil { return }
        let height = 0.04 * screenWidth
        let width = 0.056 * screenWidth
        let imageViewFrame = CGRect(x: 0.024 * screenWidth, y: frame.size.height/2 - height/2, width: width, height: height)
        itemImageView = UIImageView(frame: imageViewFrame)
        if itemImageView != nil {
            addSubview(itemImageView!)
        }
    }
    
    private func addMessageLabel() {
        if messageLabel != nil { return }
        let messageHeight = 0.048 * screenWidth
        let messageFrame = CGRect(x: 0.096 * screenWidth, y: frame.size.height/2 - messageHeight/2, width: 0.586 * screenWidth, height: messageHeight)
        messageLabel = UILabel(frame: messageFrame)
        messageLabel?.font = labelFont
        messageLabel?.textColor = UIColor.requestsUnSelectedTitleColor
        if messageLabel != nil {
            addSubview(messageLabel!)
        }
    }
}
