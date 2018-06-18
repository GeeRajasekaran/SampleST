//
//  RequestNotificationView.swift
//  June
//
//  Created by Ostap Holub on 3/27/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestNotificationView: UIView {
    
    // MARK: - Variables & Constants
    
    private struct LayoutConstants {
        // Image size
        struct Size {
            static let closeSize: CGSize = CGSize(width: 8, height: 8)
        }
        
        // Close button width
        struct Width {
            static let closeWidth: CGFloat = 30
        }
        
        struct CloseButton {
            static let leading: CGFloat = 4
        }
        
        // Title related constants
        struct Title {
            static let leading: CGFloat = 0
        }
        
        // Count related constants
        struct Count {
            static let leading: CGFloat = 6
            static let trailing: CGFloat = -6
            static let top: CGFloat = 2
            static let bottom: CGFloat = -2
        }
        
        // Rounded view constants
        struct RoundedView {
            static let trailing: CGFloat = -12
        }
    }
    
    private var closeButton: UIButton?
    private var titleLabel: UILabel?
    private var countLabel: UILabel?
    private var countBackgroundView: UIView?
    
    private var topSeparatorView: UIView?
    private var bottomSeparatorView: UIView?
    
    var onClose: (() -> Void)?
    
    // MARK: - Primary view setup\
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let height = countBackgroundView?.frame.height else { return }
        countBackgroundView?.layer.cornerRadius = height / 2
    }
    
    func setupSubviews() {
        isUserInteractionEnabled = true
        backgroundColor = UIColor(hexString: "F8F8F8")
        addCloseButton()
        addTitleLabel()
        addCountLabel()
        addTopSeparatorView()
        addBottomSeparatorView()
    }
    
    func loadModel(_ model: PendingRequestItemInfo) {
        titleLabel?.text = model.title
        countLabel?.text = String(model.count)
    }
    
    // MARK: - Private close button setup
    
    private func addCloseButton() {
        guard closeButton == nil else { return }
        
        closeButton = UIButton()
        closeButton?.translatesAutoresizingMaskIntoConstraints = false
        closeButton?.addTarget(self, action: #selector(handleOnCloseClick), for: .touchUpInside)
        
        let image = UIImage(named: "expanded_share_header_close")?.imageResize(sizeChange: LayoutConstants.Size.closeSize)
        closeButton?.setImage(image, for: .normal)
        
        if closeButton != nil {
            addSubview(closeButton!)
            closeButton?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(LayoutConstants.CloseButton.leading)
                make.top.equalToSuperview()
                make.width.equalTo(LayoutConstants.Width.closeWidth)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    @objc private func handleOnCloseClick() {
        onClose?()
    }
    
    // MARK: - Private title label setup
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        titleLabel?.textColor = .black
        
        if titleLabel != nil {
            addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints { [weak self] make in
                guard let leading = self?.closeButton else { return }
                make.leading.equalTo(leading.snp.trailing).offset(LayoutConstants.Title.leading)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    // MARK: - Private count label setup
    
    private func addCountLabel() {
        guard countLabel == nil else { return }
        guard countBackgroundView == nil else { return }
        
        countLabel = UILabel()
        countLabel?.translatesAutoresizingMaskIntoConstraints = false
        countLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        countLabel?.textColor = .white
        
        countBackgroundView = UIView()
        countBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
        countBackgroundView?.backgroundColor = UIColor(hexString: "256CFF")
        
        if countLabel != nil {
            countBackgroundView?.addSubview(countLabel!)
            countLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(LayoutConstants.Count.leading)
                make.trailing.equalToSuperview().offset(LayoutConstants.Count.trailing)
                make.top.equalToSuperview().offset(LayoutConstants.Count.top)
                make.bottom.equalToSuperview().offset(LayoutConstants.Count.bottom)
            }
            
            addSubview(countBackgroundView!)
            countBackgroundView?.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(LayoutConstants.RoundedView.trailing)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    // MARK: - Private separators setup
    
    private func addTopSeparatorView() {
        guard topSeparatorView == nil else { return }
        
        topSeparatorView = UIView()
        topSeparatorView?.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView?.backgroundColor = UIColor(hexString: "F3F4F5")
        
        if topSeparatorView != nil {
            addSubview(topSeparatorView!)
            topSeparatorView?.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
    
    private func addBottomSeparatorView() {
        guard bottomSeparatorView == nil else { return }
        
        bottomSeparatorView = UIView()
        bottomSeparatorView?.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView?.backgroundColor = UIColor(hexString: "F3F4F5")
        
        if bottomSeparatorView != nil {
            addSubview(bottomSeparatorView!)
            bottomSeparatorView?.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
}
