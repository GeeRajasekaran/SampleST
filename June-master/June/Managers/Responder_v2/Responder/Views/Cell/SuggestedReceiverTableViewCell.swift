//
//  SuggestedReceiverTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 9/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke
import SnapKit

class SuggestedReceiverTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private struct Constans {
        static let imageDimension: CGFloat = 15
        static let imageOffset: CGFloat = 9
        static let leftOffset: CGFloat = 33
    }
    
    var receiverTextLabel: UILabel?
    private var iconImageView: UIImageView?
    
    // MARK: - Reuse logic
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        receiverTextLabel?.removeFromSuperview()
        iconImageView?.removeFromSuperview()
        iconImageView = nil
    }
    
    // MARK: - Public view setup
    
    func setupSubViews(for receiver: EmailReceiver) {
        backgroundColor = .clear
        addReceiverTextLabel()
        addIconImageView(for: receiver)
        combineText(for: receiver)
        addSeparator()
    }
    
    // MARK: - Image view
    
    private func addIconImageView(for recipient: EmailReceiver) {
        guard iconImageView == nil else { return }
        
        let iconFrame = CGRect(x: Constans.imageOffset, y: frame.height / 2 - (Constans.imageDimension + 1) / 2, width: Constans.imageDimension, height: Constans.imageDimension)
        iconImageView = UIImageView(frame: iconFrame)
        iconImageView?.contentMode = .scaleAspectFit
        iconImageView?.clipsToBounds = true
        iconImageView?.layer.cornerRadius = Constans.imageDimension/2
        
        if let urlString = recipient.profileImage, let url = URL(string: urlString) {
            iconImageView?.hnk_setImageFromURL(url)
        }
        
        if iconImageView != nil {
            addSubview(iconImageView!)
        }
    }
    
    // MARK: - Separator
    
    private func addSeparator() {
        let separatorFrame = CGRect(x: Constans.leftOffset, y: frame.height - 1, width: UIScreen.main.bounds.width - Constans.leftOffset * 2, height: 0.5)
        
        let separatorView = UIView(frame: separatorFrame)
        separatorView.backgroundColor = UIColor.newsCardSeparatorGray
        addSubview(separatorView)
    }
    
    // MARK: - Receiver label setup
    
    private func addReceiverTextLabel() {
        let labelFrame = CGRect(x: Constans.leftOffset, y: 0, width: frame.width - UIView.midMargin, height: frame.height)
        
        receiverTextLabel = UILabel(frame: labelFrame)
        
        if receiverTextLabel != nil {
            addSubview(receiverTextLabel!)
        }
    }
    
    // MARK: - Text setting logic
    
    private func combineText(for receiver: EmailReceiver) {
        let maxCharactersCount = 43
        var name = receiver.name ?? ""
        var email = receiver.email ?? ""
        
        //1. Trim name for 43 characters
        if name.count > maxCharactersCount {
            name = trim(name, to: maxCharactersCount)
        }
        //2. Trim email for 43 characters
        if email.count > maxCharactersCount {
            email = trim(email, to: maxCharactersCount)
        }
        
        //3. Combine it in one string
        var combinedInfoString = name
        if name == "" {
            combinedInfoString = email
        } else {
            combinedInfoString += " " + email
        }
        let attributedCombinedString = NSMutableAttributedString(string: combinedInfoString)
        
        //4. Get range of name and email
        
        if let rName = combinedInfoString.range(of: name) {
            let nameRange = combinedInfoString.nsRange(from: rName)
            attributedCombinedString.addAttribute(.foregroundColor, value: UIColor(hexString: "404040"), range: nameRange)
            attributedCombinedString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .bold, size: .regMid), range: nameRange)
        }
        
        if let rEmail = combinedInfoString.range(of: email) {
            let emailRange = combinedInfoString.nsRange(from: rEmail)
            attributedCombinedString.addAttribute(.foregroundColor, value: UIColor(hexString: "404040"), range: emailRange)
            attributedCombinedString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .regular, size: .regMid), range: emailRange)
        }
        
        receiverTextLabel?.attributedText = attributedCombinedString
    }
    
    private func trim(_ string: String, to count: Int) -> String {
        let stringCopy = string
        let delta = stringCopy.count - count
        let index = stringCopy.index(stringCopy.endIndex, offsetBy: -delta)
        return stringCopy[stringCopy.startIndex ..< index] + "..."
    }
}
