//
//  ComposeSuggestionTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class ComposeSuggestionTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    var receiverTextLabel: UILabel?
    var receiverImageView: UIImageView?
    var selectionView: UIView?
    
    // MARK: - Reuse logic
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        receiverTextLabel?.removeFromSuperview()
        receiverImageView?.removeFromSuperview()
        selectionView?.removeFromSuperview()
    }
    
    // MARK: - Highlight logic
    
    func showSelection() {
        selectionView?.isHidden = false
        backgroundColor = UIColor.selectionCellColor
        contentView.backgroundColor = UIColor.selectionCellColor
    }
    
    func hideSelection() {
        selectionView?.isHidden = true
        backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = selectionView?.backgroundColor
        super.setSelected(selected, animated: animated)
        if selected {
            self.selectionView?.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = selectionView?.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            self.selectionView?.backgroundColor = color
        }
    }
    
    // MARK: - Public view setup
    
    func setupSubViews(for receiver: EmailReceiver) {
        backgroundColor = .white
        createSelectionView()
        addReceiverImageView()
        addReceiverTextLabel()
        combineText(for: receiver)
        if let unwrappedUrlString = receiver.profileImage, let url = URL(string: unwrappedUrlString) {
            receiverImageView?.hnk_setImageFromURL(url)
        }
        addSeparator()
    }
    
    // MARK: - Selection view creation
    
    private func createSelectionView() {
        let width = 0.016 * UIScreen.main.bounds.width
        
        let selectionFrame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        selectionView = UIView(frame: selectionFrame)
        selectionView?.isHidden = true
        selectionView?.backgroundColor = UIColor.selectedReceiverColor
        
        if selectionView != nil {
            addSubview(selectionView!)
        }
    }
    
    // MARK: - Separator
    
    private func addSeparator() {
        let separatorFrame = CGRect(x: 0, y: frame.height - 1, width: UIScreen.main.bounds.width, height: 0.5)
        
        let separatorView = UIView(frame: separatorFrame)
        separatorView.backgroundColor = UIColor.newsCardSeparatorGray
        addSubview(separatorView)
    }
    
    // MARK: - Receiver iamge setup
    
    private func addReceiverImageView() {
        let width = 0.04 * UIScreen.main.bounds.width
        let imageFrame = CGRect(x: UIView.midMargin, y: frame.height / 2 - width / 2, width: width, height: width)
        
        receiverImageView = UIImageView(frame: imageFrame)
        receiverImageView?.contentMode = .scaleAspectFit
        receiverImageView?.clipsToBounds = true
        receiverImageView?.layer.cornerRadius = width / 2
        
        if receiverImageView != nil {
            addSubview(receiverImageView!)
        }
    }
    
    // MARK: - Receiver label setup
    
    private func addReceiverTextLabel() {
        guard let imageFrame = receiverImageView?.frame else { return }
        let originX = imageFrame.origin.x + imageFrame.width + UIView.narrowMargin
        let labelFrame = CGRect(x: originX, y: 0, width: frame.width - originX - UIView.narrowMargin, height: frame.height)
        
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
            let font: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
            attributedCombinedString.addAttribute(.foregroundColor, value: UIColor.tableHeaderTitleGray, range: nameRange)
            attributedCombinedString.addAttribute(.font, value: font, range: nameRange)
        }
        
        if let rEmail = combinedInfoString.range(of: email) {
            let emailRange = combinedInfoString.nsRange(from: rEmail)
            let font: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regular)
            attributedCombinedString.addAttribute(.foregroundColor, value: UIColor.tableHeaderTitleGray, range: emailRange)
            attributedCombinedString.addAttribute(.font, value: font, range: emailRange)
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

