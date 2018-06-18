//
//  ShareBottomView.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ShareBottomView: UIView {
    
    var topLineView: UIView?
    var messageLabel: UILabel?
    var shareCardView: ShareCardView?

    func setupSubviews() {
        backgroundColor = UIColor.shareCardViewBackgroundColor
        addTopLineView()
        addCardView()
    }
    
    func loadData(cardView: IFeedCardView?) {
        shareCardView?.cardView = cardView
    }
    
    //MARK: - private part
    private func addTopLineView() {
        if topLineView != nil { return }
        topLineView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        topLineView?.backgroundColor = UIColor.gray.withAlphaComponent(0.21)
        if topLineView != nil {
            addSubview(topLineView!)
        }
    }
    
    private func addCardView() {
        if shareCardView != nil { return }
        shareCardView = ShareCardView()
        shareCardView?.frame = bounds
        addSubview(shareCardView!)
    }
}
