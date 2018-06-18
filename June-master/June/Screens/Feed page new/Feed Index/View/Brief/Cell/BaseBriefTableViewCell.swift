//
//  BaseBriefTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 1/29/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BaseBriefTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    struct LayoutConstant {
        static let leftInset: CGFloat = 10
        static let rightInset: CGFloat = 6
        static let cornerRadius: CGFloat = 5
    }
    
    var containerView: UIView?
    private var colorLineView: UIView?
    
    // MARK: - Reuse logic
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView?.removeFromSuperview()
        containerView = nil
        colorLineView?.removeFromSuperview()
        colorLineView = nil
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        addContainerView()
        addColorLineView()
    }
    
    // MARK: - Common container view setup
    
    func addContainerView() {
        guard containerView == nil else { return }
        
        let rect = CGRect(x: LayoutConstant.leftInset, y: 0, width: frame.width - (LayoutConstant.leftInset + LayoutConstant.rightInset), height: frame.height)
        containerView = UIView(frame: rect)
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        containerView?.backgroundColor = .white
        containerView?.clipsToBounds = true
        
        if containerView != nil {
            addSubview(containerView!)
        }
    }
    
    // MARK: - Color line view setup
    
    private func addColorLineView() {
        guard colorLineView == nil else { return }
        guard let containerFrame = containerView?.frame else { return }
        
        let rect = CGRect(x: 0, y: 0, width: 0.016 * screenWidth, height: containerFrame.height)
        colorLineView = UIView(frame: rect)
        colorLineView?.backgroundColor = UIColor.briefLineViewColor
        
        if colorLineView != nil {
            containerView?.addSubview(colorLineView!)
        }
    }
    
    // MARK: - Common separator setup
    
    func addSeparatorView() {
        guard let containerFrame = containerView?.frame else { return }
        
        let separatorRect = CGRect(x: LayoutConstant.rightInset, y: containerFrame.height - 1, width: containerFrame.width - (LayoutConstant.rightInset + LayoutConstant.leftInset), height: 1)
        let separatorView = UIView(frame: separatorRect)
        separatorView.backgroundColor = UIColor.briefCellSeparatorColor
        
        containerView?.addSubview(separatorView)
    }
}
