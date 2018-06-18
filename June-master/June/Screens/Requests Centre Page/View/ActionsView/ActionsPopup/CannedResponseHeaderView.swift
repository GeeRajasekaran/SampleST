//
//  CannedResponseHeaderView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/29/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class CannedResponseHeaderView: UIView {
    
    // MARK: - Variables & Constants
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var titleLabel: UILabel?
    
    // MARK: - Public view setup
    
    func setupSubviews(with title: String) {
        addTitleLabel(title)
    }
    
    // MARK: - Create title label
    
    private func addTitleLabel(_ text: String) {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        titleLabel?.text = text
        titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .smallMedium)
        titleLabel?.textColor = UIColor.cannedResponseHeaderColor
        titleLabel?.textAlignment = .left
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if titleLabel != nil {
            addSubview(titleLabel!)
            titleLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.024 * screenWidth).isActive = true
            titleLabel?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            titleLabel?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            titleLabel?.heightAnchor.constraint(equalToConstant: 0.056 * screenWidth).isActive = true
        }
    }
}
