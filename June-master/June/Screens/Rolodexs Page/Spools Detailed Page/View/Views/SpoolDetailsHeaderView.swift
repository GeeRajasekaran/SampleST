//
//  SpoolDetailsHeaderView.swift
//  June
//
//  Created by Ostap Holub on 4/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class SpoolDetailsHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private var titleLabel: UILabel?
    private var collapseButton: UIButton?
    private var separator: UIView?
    
    var onCollapse: (() -> Void)?
    
    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        backgroundColor = .white
        addCollapseButton()
        addTitleLabel()
        addSeparatorView()
    }
    
    // MARK: - Private title label setup
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.latoStyleAndSize(style: .black, size: .mediumLarge)
        titleLabel?.textColor = UIColor(hexString: "0E0E0E")
        titleLabel?.textAlignment = .left
        titleLabel?.lineBreakMode = .byTruncatingTail
        titleLabel?.text = "Test design thread"
        
        if titleLabel != nil {
            addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints { [weak self] make in
                guard let right = self?.collapseButton?.snp.leading else { return }
                make.leading.equalToSuperview().offset(18)
                make.trailing.equalTo(right)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    // MARK: - Private button setup
    
    private func addCollapseButton() {
        guard collapseButton == nil else { return }
        
        collapseButton = UIButton()
        collapseButton?.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "june_responder_collapse")?.imageResize(sizeChange: CGSize(width: 15, height: 15))
        collapseButton?.setImage(image, for: .normal)
        collapseButton?.addTarget(self, action: #selector(collapseButtonClick), for: .touchUpInside)
        
        if collapseButton != nil {
            addSubview(collapseButton!)
            collapseButton?.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-8)
                make.centerY.equalToSuperview()
                make.width.equalTo(40)
                make.height.equalTo(40)
            }
        }
    }
    
    @objc private func collapseButtonClick() {
        onCollapse?()
    }
    
    // MARK: - Private separator view setup
    
    private func addSeparatorView() {
        guard separator == nil else { return }
        separator = UIView()
        separator?.translatesAutoresizingMaskIntoConstraints = false
        separator?.backgroundColor = UIColor(hexString: "DFE0E0").withAlphaComponent(0.3)
        
        if separator != nil {
            addSubview(separator!)
            separator?.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
}
