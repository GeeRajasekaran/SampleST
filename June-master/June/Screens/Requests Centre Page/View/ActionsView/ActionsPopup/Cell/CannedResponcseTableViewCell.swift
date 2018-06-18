//
//  CannedResponcseTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class CannedResponcseTableViewCell: UITableViewCell {

    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    private let labelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private var cannedResponse: ReplyAction?
    
    // MARK: - Views
    private var topSeparatorView: UIView?
    private var messageLabel: UILabel?
    
    // MARK: - Initialization
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func loadData(from cannedResponse: ReplyAction) {
        self.cannedResponse = cannedResponse
        messageLabel?.text = cannedResponse.title
    }
    
    // MARK: - UI Setup
    func setupUI(shouldShowLine: Bool = true) {
        if shouldShowLine {
            addTopLineView()
        }
        addMessageLabel()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topSeparatorView?.removeFromSuperview()
        messageLabel?.removeFromSuperview()
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
    
    private func addMessageLabel() {
        if messageLabel != nil { return }
        let messageHeight = 0.048 * screenWidth
        let messageFrame = CGRect(x: 0.04 * screenWidth, y: frame.size.height/2 - messageHeight/2, width: 0.586 * screenWidth, height: messageHeight)
        messageLabel = UILabel(frame: messageFrame)
        messageLabel?.font = labelFont
        messageLabel?.textColor = UIColor.requestsUnSelectedTitleColor
        if messageLabel != nil {
            addSubview(messageLabel!)
        }
    }
}
