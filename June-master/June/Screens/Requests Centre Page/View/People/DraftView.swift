//
//  DiscardView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class DraftView: UIView {

    // MARK: - Variables & constants
    private weak var draftInfo: DraftInfo?
    
    private let screenWidth = UIScreen.main.bounds.width
    private let messageFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    private let buttonFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
    
    // MARK: - Subviews
    private var messageLabel: UILabel?
    private var discardButton: UIButton?
    
    //MARK: - actions
    
    var onDiscardButtonTapped: ((DraftView, DraftInfo) -> Void)?
    var onViewTapped: ((DraftView, DraftInfo) -> Void)?
    
    // MARK: - Layout setup logic
    func setupSubviews() {
        basicSetup()
        addDiscardButton()
        addMessageLabel()
    }
    
    //MARK: - Data loading
    func loadData(draft: DraftInfo?) {
        self.draftInfo = draft
        messageLabel?.text = draftInfo?.text
    }
    
    //MARK: - Private part
    private func basicSetup() {
        backgroundColor = .white
        layer.cornerRadius = 0.04 * screenWidth
        layer.borderColor = UIColor.discardButtonBorderColor.cgColor
        layer.borderWidth = 1
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    private func addMessageLabel() {
        if messageLabel != nil { return  }
        messageLabel = UILabel()
        messageLabel?.font = messageFont
        messageLabel?.textColor = UIColor.discardButtonMessageColor
        if messageLabel != nil {
            addSubview(messageLabel!)
        }
        addMessageLabelConstraints()
    }
    
    private func addDiscardButton() {
        if discardButton != nil { return }
        discardButton = UIButton()
        discardButton?.titleLabel?.font = buttonFont
        discardButton?.setTitleColor(UIColor.discardButtonColor, for: .normal)
        discardButton?.layer.borderColor = UIColor.discardButtonBorderColor.cgColor
        discardButton?.layer.borderWidth = 1
        discardButton?.layer.cornerRadius = 0.0425 * screenWidth
        discardButton?.addTarget(self, action: #selector(discardButtonTapped), for: .touchUpInside)
        discardButton?.setTitle("Discard", for: .normal)
        if discardButton != nil {
            addSubview(discardButton!)
        }
        addDiscardButtonConstraints()
    }
    
    //MARK: - constraints
    private func addMessageLabelConstraints() {
        messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        messageLabel?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messageLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.036 * screenWidth).isActive = true
        messageLabel?.widthAnchor.constraint(equalToConstant: 0.472 * screenWidth)
        messageLabel?.heightAnchor.constraint(equalToConstant: 0.04 * screenWidth).isActive = true
    }
    
    private func addDiscardButtonConstraints() {
        discardButton?.translatesAutoresizingMaskIntoConstraints = false
        discardButton?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        discardButton?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0.016 * screenWidth).isActive = true
        discardButton?.heightAnchor.constraint(equalToConstant: 0.085 * screenWidth).isActive = true
        discardButton?.widthAnchor.constraint(equalToConstant: 0.184 * screenWidth).isActive = true
    }
    
    //MARK: - actions
    @objc func discardButtonTapped() {
        guard let info = draftInfo else { return }
        onDiscardButtonTapped?(self, info)
    }
    
    @objc func viewTapped() {
        guard let info = draftInfo else { return }
        onViewTapped?(self, info)
    }
}
