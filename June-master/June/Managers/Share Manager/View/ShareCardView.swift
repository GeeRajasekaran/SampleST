//
//  ShareCardView.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ShareCardView: UIView {

    private var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    // MARK: - Variables & Constants
    
    var cardView: IFeedCardView? {
        didSet {
            addCardView()
        }
    }

    // MARK: - Add card view
    private func addCardView() {
        guard let view = cardView?.view else { return }
        let originX = frame.size.width/2 - view.frame.width/2
        view.frame.origin.x = originX
        if cardView?.view != nil {
            addSubview(view)
        }
    }
}
