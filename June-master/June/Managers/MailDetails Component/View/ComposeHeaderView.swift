//
//  ComposeHeaderView.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let titleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private var titleLabel: UILabel?
    private var closeButton: UIButton?
    
    var onCloseAction: (() -> Void)?
    
    // MARK: - Subviews setup
    
    func setupSubviews() {
        backgroundColor = .white
        addTitleLabel()
        addCloseButton()
        addBottomShadowLineView()
    }
    
    func loadData(text: String) {
        titleLabel?.text = text
        updateTitleFrame(with: text)
    }
    
    // MARK: - Title label creation
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        let width = 0.3 * screenWidth
        let height = 0.053 * screenWidth
        
        let labelFrame = CGRect(x: frame.width / 2 - width / 2, y: frame.height / 2 - height / 2, width: width, height: height)
        titleLabel = UILabel(frame: labelFrame)
        titleLabel?.font = titleLabelFont
        titleLabel?.textColor = .black
        titleLabel?.text = LocalizedStringKey.ComposeHelper.HeaderTitle
        titleLabel?.textAlignment = .center
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
    
    // MARK: - Close button creation
    
    private func addCloseButton() {
        guard closeButton == nil else { return }
        let buttonWidth = 0.117 * screenWidth
        
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: frame.height)
        let image = UIImage(named: LocalizedImageNameKey.ComposeHelper.Close)
        
        closeButton = UIButton(frame: buttonFrame)
        closeButton?.setImage(image, for: .normal)
        closeButton?.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        
        if closeButton != nil {
            addSubview(closeButton!)
        }
    }
    
    //MARK: - update frame
    private func updateTitleFrame(with text: String) {
        let width = text.width(usingFont: titleLabelFont)
        let orifinX = frame.width / 2 - width / 2
        titleLabel?.frame.origin.x = orifinX
        titleLabel?.frame.size.width = width
    }
    
    @objc private func handleCloseButtonTap() {
        onCloseAction?()
    }
}
