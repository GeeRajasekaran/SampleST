//
//  EmailTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class EmailTableViewCell: UITableViewCell {
    
    // MARK: - Views
    private let screenWidth = UIScreen.main.bounds.width
    
    private var emailImageView: UIImageView?
    private var emailLabel: UILabel?
    private var separatorView: UIView?
    
    // MARK: - Data setting logic
    
    var profileImage: String? {
        didSet {
            if profileImage != nil {
                let image = UIImage(named: profileImage!)
                emailImageView?.image = image
            }
        }
    }
    
    var emailText: String? {
        didSet {
            emailLabel?.text = emailText
        }
    }
    
    // MARK: - Reuse logic
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emailImageView?.removeFromSuperview()
        emailLabel?.removeFromSuperview()
        separatorView?.removeFromSuperview()
        emailImageView = nil
        emailLabel = nil
        separatorView = nil
    }
    
    // MARK: - Subviews setup
    
    func setupSubviews() {
        backgroundColor = .clear
        // note, that calling order of next methods is important
        addImageView()
        addEmaiLabel()
        addSeparator()
    }
    
    // MARK: - Email image view creation
    
    private func addImageView() {
        guard emailImageView == nil else { return }
        
        let height = 0.034 * screenWidth
        let imageViewFrame = CGRect(x: UIView.midLargeMargin, y: frame.height / 2 - height / 2, width: height, height: height)
        emailImageView = UIImageView(frame: imageViewFrame)
        emailImageView?.layer.cornerRadius = height / 2
        emailImageView?.clipsToBounds = true
        
        if emailImageView != nil {
            addSubview(emailImageView!)
        }
    }
    
    // MARK: - Email label creation
    
    private func addEmaiLabel() {
        guard emailLabel == nil else { return }
        guard let imageViewFrame = emailImageView?.frame else { return }
        
        let height = 0.034 * screenWidth
        let originX = imageViewFrame.origin.x + imageViewFrame.width + UIView.narrowMidMargin
        let width = frame.width - originX - UIView.largeMargin
        let labelFrame = CGRect(x: originX, y: frame.height / 2 - height / 2, width: width, height: height)
        
        let emailLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .small)
        
        emailLabel = UILabel(frame: labelFrame)
        emailLabel?.textAlignment = .left
        emailLabel?.font = emailLabelFont
        emailLabel?.textColor = UIColor.receiverTitleGrey
        
        if emailLabel != nil {
            addSubview(emailLabel!)
        }
    }
    
    // MARK: - Separator creation logic
    
    private func addSeparator() {
        guard separatorView == nil else { return }
        
        let inset: CGFloat = 11
        let separatorFrame = CGRect(x: inset, y: frame.height - 0.5, width: screenWidth - 2 * inset, height: 0.5)
        separatorView = UIView(frame: separatorFrame)
        separatorView?.backgroundColor = UIColor.lineGray.withAlphaComponent(0.15)
        
        if separatorView != nil {
            addSubview(separatorView!)
        }
    }
}
