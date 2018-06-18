//
//  RomioMessage.swift
//  Romio
//
//  Created by Joshua Cleetus on 11/9/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import UIKit

typealias RomioMessageTapHandler = () -> Void

enum RomioMessageType {
    case simple
    case dismissable
}

class RomioMessage: UIView {

    static let bodyFont = UIFont.sfTextOfStyleAndSize(style: .medium, size: .large)
    
    let style: RomioAlertViewPresentationStyle
    let type: RomioMessageType
    
    let bodyLabel = UILabel()
    let iconImageView = JuneImageView(viewType: .circle)
    let dismissButton = UIButton()
    
    var tapHandler: RomioMessageTapHandler? {
        didSet {
            DispatchQueue.main.async {
                switch self.type {
                case .dismissable:
                    self.dismissButton.addTarget(self, action: #selector(self.didTapHandler), for: .touchUpInside)
                default:
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapHandler))
                    tapGesture.numberOfTapsRequired = 1
                    self.addGestureRecognizer(tapGesture)
                }
            }
        }
    }
    
    var alertHeight: CGFloat {
        var _height = UIView.midStandardMargin.plusOne
        let widthOffset = frame.width - UIView.narrowMidSecondVariantMargin.plusOne - UIView.midLargeMargin.plusOne
        _height += (bodyLabel.text ?? "").height(withConstrainedWidth: widthOffset, font: RomioMessage.bodyFont)
        
        if type == .dismissable {
            _height += UIView.largeInterMargin * 4
        } else {
            _height += UIView.midStandardMargin.plusOne.plusOne
        }
        
        return _height
    }
    
    init(style: RomioAlertViewPresentationStyle, type: RomioMessageType = .simple) {
        self.style = style
        self.type = type
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        super.init(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0))
        setupView()
    }
    
    deinit {
        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSimpleMessage(withBody message: String, messageFont: UIFont? = nil, backgroundColor: UIColor, textColor: UIColor = .white, iconImage: UIImage?, tapHandler: RomioMessageTapHandler? = nil) {
        
        self.backgroundColor = backgroundColor
        
        bodyLabel.text = message
        bodyLabel.textColor = textColor
        
        if let image = iconImage {
            iconImageView.imageView.image = image
        } else {
            iconImageView.imageView.image = nil
        }
        
        if let font = messageFont {
            bodyLabel.font = font
        }
        
        if let handler = tapHandler {
            self.tapHandler = handler
        }
    }
    
    private func setupView() {
        bodyLabel.sizeToFit()
        bodyLabel.font = RomioMessage.bodyFont
        bodyLabel.numberOfLines = 0
        bodyLabel.adjustsFontSizeToFitWidth = true
        addSubview(bodyLabel)
        
        iconImageView.sizeToFit()
        addSubview(iconImageView)
        
        if type == .dismissable {
            dismissButton.sizeToFit()
            var closeImage = UIImage(named: "close-icon")
            closeImage = closeImage?.withRenderingMode(.alwaysTemplate)
            dismissButton.imageView?.tintColor = .white
            dismissButton.setImage(closeImage, for: .normal)
            
            addSubview(dismissButton)
        }
    }
    
    private func setupConstraints() {
        snp.remakeConstraints {
            (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
        layoutIfNeeded()
        
        if type == .dismissable {
            bodyLabel.snp.remakeConstraints {
                (make) in
                make.top.equalToSuperview().offset(UIView.largeInterMargin * 2)
                make.leading.equalToSuperview().offset(UIView.narrowMidSecondVariantMargin.plusOne)
                make.bottom.equalToSuperview().offset((UIView.largeInterMargin * 2).inverse)
                 make.trailing.equalToSuperview().offset(UIView.narrowMidSecondVariantMargin.plusOne.inverse)
                make.height.equalTo(bodyLabel)
            }
            bodyLabel.layoutIfNeeded()
        } else {
            bodyLabel.snp.remakeConstraints {
                (make) in
                make.top.equalToSuperview().offset(UIView.midStandardMargin.plusOne)
                make.leading.equalToSuperview().offset(UIView.narrowMidSecondVariantMargin.plusOne)
                make.bottom.equalToSuperview().offset(UIView.midStandardMargin.plusOne.plusOne.inverse)
                guard iconImageView.imageView.image != nil else {
                    make.trailing.equalToSuperview().offset(UIView.narrowMidSecondVariantMargin.plusOne.inverse)
                    return
                }
                make.trailing.equalTo(iconImageView.snp.leading).offset(UIView.midLargeMargin.plusOne.inverse)
                make.height.equalTo(bodyLabel)
            }
            bodyLabel.layoutIfNeeded()
        }
        
        
        if iconImageView.imageView.image != nil {
            iconImageView.snp.remakeConstraints({
                (make) in
                let size: CGFloat = 36.0
                make.top.equalToSuperview().offset(UIView.midLargeMargin)
                make.trailing.equalToSuperview().offset(UIView.midLargeMargin.minusOne.inverse)
                make.height.equalTo(size)
                make.width.equalTo(size)
            })
            iconImageView.layoutIfNeeded()
        }
        
        if type == .dismissable {
            dismissButton.snp.remakeConstraints({
                (make) in
                let size: CGFloat = 15.0
                make.top.equalToSuperview().offset(UIView.narrowMidSecondVariantMargin.plusOne)
                make.trailing.equalToSuperview().offset(UIView.midLargeMargin.plusOne.inverse)
                make.height.equalTo(size)
                make.width.equalTo(size)
            })
            dismissButton.layoutIfNeeded()
        }
    }
        
    func present() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(self)
        setupConstraints()
    }
    
    func dismiss() {
        removeFromSuperview()
    }
    
    @objc func didTapHandler() {
        tapHandler?()
    }
}
