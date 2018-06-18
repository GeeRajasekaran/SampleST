//
//  MessageHeaderView.swift
//  June
//
//  Created by Ostap Holub on 9/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MessageHeaderView: UIView {
    
    // MARK: - Variables
    
    private let screenWidth = UIScreen.main.bounds.width
    private var vendorDetailsView: VendorDetailsView?
    
    var onHideResponder: (() -> Void)?
    
    // MARK: - View initialization
    
    func setupSubview() {
        let height = 0.093 * screenWidth
        let originX = 0.032 * screenWidth
        let vendorDetailsFrame = CGRect(x: originX, y: 0.04 * screenWidth, width: screenWidth - 2 * originX, height: height)
        
        vendorDetailsView = VendorDetailsView(frame: vendorDetailsFrame)
        vendorDetailsView?.onHideResponder = onHideResponder
        vendorDetailsView?.setupSubviews()
        
        addSubviewIfNeeded(vendorDetailsView!)
        addTopSeparator(to: self)
    }
    
    func loadMessage(_ message: Message) {
        vendorDetailsView?.loadMessage(message)
    }
    
    // MARK: - Private part
    
    private func addTopSeparator(to view: UIView) {
        let shadowFrame = CGRect(x: 8, y: 0, width: screenWidth - 16, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        
        view.addSubview(shadowView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onHideResponder?()
    }
}
