//
//  BriefItemCell.swift
//  June
//
//  Created by Ostap Holub on 2/1/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefItemCell: BaseBriefTableViewCell {
    
    // MARK: - Variables & Constants
    
    var cardView: IFeedCardView? {
        didSet {
            addCardView()
        }
    }
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView?.view.removeFromSuperview()
    }
    
    // MARK: - Primary view setup
    
    override func addContainerView() {
        super.addContainerView()
        containerView?.addSideBorders(color: UIColor.briefCellBorderColor)
    }
    
    // MARK: - Card view setup
    
    private func addCardView() {
        guard let containerFrame = containerView?.frame else { return }
        let leftInset: CGFloat = 0.042 * screenWidth
        let rightInset: CGFloat = 0.032 * screenWidth
        let topInset: CGFloat = 0.021 * screenWidth
        let rect = CGRect(x: leftInset, y: topInset, width: containerFrame.width - (leftInset + rightInset), height: containerFrame.height - 2 * topInset)
        cardView?.view.frame = rect
        cardView?.setupSubviews()
        if cardView?.view != nil {
            containerView?.addSubview(cardView!.view)
        }
    }
}
