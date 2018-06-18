//
//  UnreadCountView.swift
//  June
//
//  Created by Ostap Holub on 4/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class UnreadCountView: UIView {
    
    // MARK: - Variables & Constants
    
    private var titleLabel: UILabel?
    
    var count: Int16? {
        didSet {
            guard let unwrappedCount = count else { return }
            let title = "\(unwrappedCount) New"
            backgroundColor = UIColor(hexString: "256CFF")
            titleLabel?.text = title
        }
    }
    
    // MARK: - Public view setup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 7.5
    }
    
    func setupSubviews() {
        backgroundColor = .clear
        addTitleLabel()
    }
    
    // MARK: - Private title label setup
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        
        if titleLabel != nil {
            addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(6)
                make.trailing.equalToSuperview().offset(-6)
                make.top.equalToSuperview().offset(1)
                make.bottom.equalToSuperview().offset(-1)
            }
        }
    }
}
