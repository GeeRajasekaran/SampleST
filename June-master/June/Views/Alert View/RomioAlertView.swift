//
//  RomioAlertView.swift
//  Romio
//
//  Created by Joshua Cleetus on 10/31/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import UIKit

enum RomioAlertViewType: Int {
    case oneButton = 1
    case twoButton = 2
    case applyTotal = 3
}

enum RomioAlertViewPresentationStyle {
    case top
    case center
    case bottom
}

typealias RomioAlertViewTapHandler = (() -> Void)

class RomioAlertView: UIView {
    
    static let messageFont = UIFont.latoStyleAndSize(style: .semibold, size: .large)
    static let buttonFont = UIFont.latoStyleAndSize(style: .semibold, size: .medium)
    static let buttonHeight: CGFloat = 48.0
    static let textFieldHeight: CGFloat = 48.0
    
    private let viewType: RomioAlertViewType
    let messageLabel = UILabel()
    let bodyLabel = UILabel()
    let textField = UITextField()
    let buttons: [UIButton]
    let messageSeparatorView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1.0))
    let buttonSeparatorView = UIView(frame: CGRect(x: 0, y: 0, width: 1.0, height: 0))
    
    private let successTapHandler: RomioAlertViewTapHandler
    private var dismissTapHandler: RomioAlertViewTapHandler?
    
    var alertHeight: CGFloat {
        var _height = UIView.narrowMargin.plusOne.plusOne + UIView.singleMargin.plusOne
        let widthOffset = UIScreen.size.width - UIView.largeMargin -  (2 * UIView.midLargeMargin)
        _height += messageLabel.text?.height(withConstrainedWidth: widthOffset, font: RomioAlertView.messageFont) ?? 0.0
        _height += RomioAlertView.buttonHeight
        _height += UIView.narrowMidSecondVariantMargin
        return _height
    }
    
    var heightApplyTotal: CGFloat {
        var _height = UIView.narrowMargin.plusOne.plusOne + UIView.singleMargin.plusOne
        let widthOffset = UIScreen.size.width - UIView.largeMargin -  (2 * UIView.narrowMargin)
        _height += messageLabel.text?.height(withConstrainedWidth: widthOffset, font: RomioAlertView.messageFont) ?? 0.0
        _height += bodyLabel.text?.height(withConstrainedWidth: widthOffset, font: RomioAlertView.messageFont) ?? 0.0
        _height += UIView.narrowMidMargin
        _height += RomioAlertView.textFieldHeight
        _height += UIView.slimMargin
        _height += RomioAlertView.buttonHeight
        _height += UIView.narrowMargin
        return _height
    }
    
    init(type: RomioAlertViewType, message: String, body: String = "",  successTapHandler: @escaping RomioAlertViewTapHandler, dismissTapHandler: RomioAlertViewTapHandler? = nil) {
        self.viewType = type
        self.successTapHandler = successTapHandler
        var _buttons: [UIButton] = []
        for _ in 0..<viewType.rawValue {
            _buttons.append(UIButton())
        }
        buttons = _buttons
        super.init(frame: CGRect.zero)
        self.dismissTapHandler = dismissTapHandler
        setupView(type: type)
        messageLabel.text = message
        bodyLabel.text = body
        
        setupConstraints(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(type: RomioAlertViewType = .twoButton) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 2.0
        
        messageLabel.sizeToFit()
        messageLabel.font = RomioAlertView.messageFont
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center
        addSubview(messageLabel)
        
        if type == .applyTotal {
            bodyLabel.sizeToFit()
            bodyLabel.font = RomioAlertView.messageFont
            bodyLabel.textColor = UIColor.romioBattleshipGreyText.withAlphaComponent(0.8)
            bodyLabel.numberOfLines = 0
            bodyLabel.lineBreakMode = .byWordWrapping
            bodyLabel.textAlignment = .center
            addSubview(bodyLabel)
            
            textField.sizeToFit()
            textField.keyboardType = .decimalPad
            textField.textColor = .romioBattleshipGreyText
            textField.font = RomioAlertView.messageFont
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.romioLightGray.cgColor
            textField.textAlignment = .center
            textField.delegate = self
            addSubview(textField)
        }
        
        messageSeparatorView.backgroundColor = UIColor.romioCoolGreyTwo
        addSubview(messageSeparatorView)
        
        buttonSeparatorView.backgroundColor = UIColor.romioCoolGreyTwo
        addSubview(buttonSeparatorView)
        
        buttons.forEach {
            (button) in
            button.sizeToFit()
            button.backgroundColor = .white
            button.titleLabel?.font = RomioAlertView.buttonFont
            addSubview(button)
        }
        
        switch viewType {
        case .oneButton:
            guard let firstButton = buttons.first else {
                return
            }
            firstButton.setTitle(Localized.string(forKey: .RomioAlertViewOKButtonTitle), for: .normal)
            firstButton.setTitleColor(UIColor.romioAlmostBlack, for: .normal)
            firstButton.setTitleColor(UIColor.romioBattleshipGreyText, for: .selected)
            
            firstButton.addTarget(self, action: #selector(didTap(firstButton:)), for: .touchUpInside)
            
        case .twoButton:
            guard
                let firstButton = buttons.first,
                let lastButton = buttons.last
                else {
                    return
            }
            
            firstButton.setTitle(Localized.string(forKey: .RomioAlertViewNoButtonTitle), for: .normal)
            firstButton.setTitleColor(UIColor.romioAlmostBlack, for: .normal)
            firstButton.setTitleColor(UIColor.romioBattleshipGreyText, for: .selected)
            firstButton.addTarget(self, action: #selector(didTap(firstButton:)), for: .touchUpInside)
            
            lastButton.setTitle(Localized.string(forKey: .RomioAlertViewYesButtonTitle), for: .normal)
            lastButton.setTitleColor(UIColor.romioTealish, for: .normal)
            lastButton.setTitleColor(UIColor.romioButtonNotReadyGreen, for: .selected)
            lastButton.addTarget(self, action: #selector(didTap(lastButton:)), for: .touchUpInside)
            
        case .applyTotal:
            guard let firstButton = buttons.first else {
                return
            }
            firstButton.setTitle(Localized.string(forKey: .RomioAlertViewApplyTotalButtonTitle), for: .normal)
            firstButton.setTitleColor(UIColor.romioTealish, for: .normal)
            firstButton.setTitleColor(UIColor.romioButtonNotReadyGreen, for: .selected)
            firstButton.addTarget(self, action: #selector(didTap(firstButton:)), for: .touchUpInside)
            messageSeparatorView.backgroundColor = UIColor.white
        }
    }
    
    private func setupConstraints(type: RomioAlertViewType = .twoButton) {
        
        switch viewType {
        case .oneButton:
            if let firstButton = buttons.first {
                firstButton.snp.remakeConstraints({
                    (make) in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(RomioAlertView.buttonHeight)
                })
                firstButton.layoutIfNeeded()
                
                messageSeparatorView.snp.remakeConstraints {
                    (make) in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalTo(1.0)
                    make.bottom.equalTo(firstButton.snp.top)
                }
                messageSeparatorView.layoutIfNeeded()
                
                messageLabel.snp.remakeConstraints {
                    (make) in
                    make.height.equalTo(messageLabel)
                    make.leading.equalToSuperview().offset(UIView.midLargeMargin)
                    make.trailing.equalToSuperview().offset(-UIView.midLargeMargin)
                    make.bottom.equalTo(messageSeparatorView.snp.top).offset(UIView.narrowMidSecondVariantMargin.inverse)
                }
                messageLabel.layoutIfNeeded()
            }
            
        case .twoButton:
            guard
                let firstButton = buttons.first,
                let lastButton = buttons.last
                else {
                    ifDebug {
                        preconditionFailure("ViewType is twoButton but unable to unwrap both buttons.")
                    }
                    return
            }
            
            buttonSeparatorView.snp.remakeConstraints {
                (make) in
                make.height.equalTo(RomioAlertView.buttonHeight)
                make.width.equalTo(1.0)
                make.centerX.equalTo(self)
                make.bottom.equalTo(self)
            }
            buttonSeparatorView.layoutIfNeeded()
            
            lastButton.snp.remakeConstraints({
                (make) in
                make.trailing.equalTo(self)
                make.bottom.equalTo(self)
                make.leading.equalTo(buttonSeparatorView.snp.trailing)
                make.height.equalTo(RomioAlertView.buttonHeight)
            })
            lastButton.setNeedsLayout()
            
            firstButton.snp.remakeConstraints({
                (make) in
                make.leading.equalTo(self)
                make.bottom.equalTo(self)
                make.trailing.equalTo(buttonSeparatorView.snp.leading).offset(UIView.singleMargin.inverse)
                make.height.equalTo(RomioAlertView.buttonHeight)
            })
            firstButton.setNeedsLayout()
            
            messageSeparatorView.snp.remakeConstraints {
                (make) in
                make.leading.equalTo(self)
                make.trailing.equalTo(self)
                make.height.equalTo(1.0)
                make.bottom.equalTo(buttonSeparatorView.snp.top)
            }
            messageSeparatorView.layoutIfNeeded()
            
            messageLabel.snp.remakeConstraints {
                (make) in
                make.height.equalTo(messageLabel)
                make.leading.equalToSuperview().offset(UIView.midLargeMargin)
                make.trailing.equalToSuperview().offset(-UIView.midLargeMargin)
                make.bottom.equalTo(messageSeparatorView.snp.top).offset(UIView.narrowMidSecondVariantMargin.inverse)
            }
            messageLabel.layoutIfNeeded()
            
        case .applyTotal:
            if let firstButton = buttons.first {
                firstButton.snp.remakeConstraints({
                    (make) in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview().offset(UIView.narrowMargin.inverse)
                    make.height.equalTo(RomioAlertView.buttonHeight)
                })
                firstButton.layoutIfNeeded()
                
                messageSeparatorView.snp.remakeConstraints {
                    (make) in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalTo(1.0)
                    make.bottom.equalTo(firstButton.snp.top)
                }
                messageSeparatorView.layoutIfNeeded()
            }
            
            textField.snp.remakeConstraints({
                (make) in
                make.height.equalTo(RomioAlertView.textFieldHeight)
                make.leading.equalToSuperview().offset(UIView.midLargeMargin)
                make.trailing.equalToSuperview().offset(-UIView.midLargeMargin)
                make.bottom.equalTo(messageSeparatorView.snp.top).offset(UIView.slimMargin.inverse)
            })
            textField.setNeedsLayout()
            
            bodyLabel.snp.remakeConstraints({
                (make) in
                make.height.equalTo(bodyLabel)
                make.leading.equalToSuperview().offset(UIView.narrowMargin)
                make.trailing.equalToSuperview().offset(-UIView.narrowMargin)
                make.bottom.equalTo(textField.snp.top).offset(UIView.narrowMidMargin.inverse)
            })
            bodyLabel.setNeedsLayout()
            
            messageLabel.snp.remakeConstraints {
                (make) in
                make.height.equalTo(messageLabel)
                make.leading.equalTo(bodyLabel)
                make.trailing.equalTo(bodyLabel)
                make.bottom.equalTo(bodyLabel.snp.top)
            }
            messageLabel.layoutIfNeeded()
        }
    }
    
    @objc internal func cancelButtonAction() {
        dismiss()
    }
    
    @objc func didTap(firstButton sender: UIButton) {
        dismissTapHandler?()
        dismiss()
    }
    
    @objc func didTap(lastButton sender: UIButton) {
        successTapHandler()
        dismiss()
    }
    
    @objc func didTapBackgroundView(backgroundView sender: UIButton) {
        dismiss()
    }
    
    func present(with backgroundColor: UIColor = .clear, shadow: Bool = false, type: RomioAlertViewType = .twoButton) {
        DispatchQueue.main.async {
            self.setupConstraintsWithinUIWindow(with: backgroundColor, shadow: shadow, type: type)
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.superview?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    private func setupConstraintsWithinUIWindow(with backgroundColor: UIColor = .clear, shadow: Bool, type: RomioAlertViewType = .twoButton) {
        frame = CGRect(x: 0, y: 0, width: UIScreen.size.width, height: height)
        if shadow == true {
            layer.borderWidth = 1
            layer.borderColor = UIColor.romioGray.cgColor
            layer.shadowColor = UIColor.romioGray.cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: -8, height: 10)
            layer.shadowRadius = 6
        }
        let backgroundView = UIView()
        backgroundView.addSubview(self)
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        snp.remakeConstraints {
            (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height/4)
            if type == .applyTotal {
                let tapBackgroundView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView(backgroundView:)))
                backgroundView.isUserInteractionEnabled =  true
                backgroundView.addGestureRecognizer(tapBackgroundView)
                backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
                make.height.equalTo(heightApplyTotal)
            } else {
                backgroundView.backgroundColor = backgroundColor
                make.height.equalTo(height)
            }
            make.width.equalTo(UIScreen.size.width - UIView.largeMargin)
        }
        layoutIfNeeded()
        
        backgroundView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundView.layoutIfNeeded()
    }
}

extension RomioAlertView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.dropFirst().isEmpty || (Double(newText.dropFirst()) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let attributedString = NSMutableAttributedString(string: "$")
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.romioBattleshipGreyText, range: NSMakeRange(0,1))
        textField.attributedText = attributedString
    }
}
