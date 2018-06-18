//
//  MessageSubjectTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class MessageSubjectTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var separatorView: UIView?
    private var subjectLabel: UILabel?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    // MARK: - Public view setup
    
    func setupSubviews() {
        selectionStyle = .none
        backgroundColor = .white
        separatorView = addFeedDetailedViewSeparator()
        addSubjectLabel()
    }
    
    func load(model: MessageSubjectInfo) {
        subjectLabel?.text = model.subject
    }
    
    // MARK: - Subject label setup
    
    private func addSubjectLabel() {
        guard subjectLabel == nil else { return }
        
        subjectLabel = UILabel()
        subjectLabel?.translatesAutoresizingMaskIntoConstraints = false
        subjectLabel?.backgroundColor = .clear
        subjectLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
        subjectLabel?.textColor = UIColor.searchBarTextColor
        subjectLabel?.numberOfLines = 0
        subjectLabel?.lineBreakMode = .byWordWrapping
        
        if subjectLabel != nil {
            addSubview(subjectLabel!)
            subjectLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.04 * screenWidth).isActive = true
            subjectLabel?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0.04 * screenWidth).isActive = true
            subjectLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 0.032 * screenWidth).isActive = true
            subjectLabel?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.045 * screenWidth).isActive = true
        }
    }
    
}
