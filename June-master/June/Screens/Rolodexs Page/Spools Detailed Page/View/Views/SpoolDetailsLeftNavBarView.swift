//
//  SpoolDetailsLeftNavBarView.swift
//  June
//
//  Created by Ostap Holub on 4/6/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SpoolDetailsLeftNavBarView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    private var subjectLabel: UILabel?
    private var nameLabel: UILabel?
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        backgroundColor = .white
        addSubjectLabel()
        addNameLabel()
    }
    
    func load(_ model: SpoolDetailsHeaderInfo) {
        subjectLabel?.text = model.subject
        nameLabel?.text = model.name
    }
    
    // MARK: - Private name label setup
    
    private func addSubjectLabel() {
        guard subjectLabel == nil else { return }
        
        subjectLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0.053 * screenWidth))
        subjectLabel?.font = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        subjectLabel?.textColor = UIColor.spoolNameHeaderColor
        subjectLabel?.textAlignment = .left
        subjectLabel?.lineBreakMode = .byTruncatingTail
        
        if subjectLabel != nil {
            addSubview(subjectLabel!)
        }
    }
    
    // MARK: - Private view more setup
    
    private func addNameLabel() {
        guard nameLabel == nil else { return }
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0.053 * screenWidth, width: frame.width, height: 0.053 * screenWidth))
        nameLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        nameLabel?.textColor = UIColor(hexString: "757575")
        nameLabel?.textAlignment = .left
        
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
}
