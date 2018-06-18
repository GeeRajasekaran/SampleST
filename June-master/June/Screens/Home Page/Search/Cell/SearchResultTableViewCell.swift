//
//  SearchResultTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - Variables & constants
    var receiver: ContactReceiver?
    private let screenWidth = UIScreen.main.bounds.width
    private let offset = UIScreen.main.bounds.width*0.024
    
    //MARK: - Views
    var receiverLabel: UILabel = UILabel()
    var receiverImageView: UIImageView = UIImageView()
    var separatorView: UIView = UIView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        receiverLabel.removeFromSuperview()
        receiverImageView.removeFromSuperview()
        separatorView.removeFromSuperview()
    }
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    //Public part
    func loadData(from contact: ContactReceiver) {
        self.receiver = contact
        setImage(receiver?.imageURL)

        if let unwrappedName = receiver?.name, let unwrappedEmail = receiver?.email {
            addAttributedString(with: unwrappedName, and: unwrappedEmail)
        } else {
            addAttributedString(with: "", and: "")
        }
        
    }
    
    // MARK: - UI Setup
    func setupUI() {
        addReceiverImageView()
        addReceiverLabel()
        addSeparator()
        setupSelectedCell()
    }
    
    //Private part
    private func addReceiverImageView() {
        let imageViewWidth = 0.04*screenWidth
        let imageViewHeight = imageViewWidth
        let originY = frame.height/2 - imageViewHeight/2
        let imageViewFrame = CGRect(x: 0.04*screenWidth, y: originY, width: imageViewWidth, height: imageViewHeight)
        receiverImageView.frame = imageViewFrame
        receiverImageView.contentMode = .scaleAspectFill
        receiverImageView.clipsToBounds = true
        receiverImageView.layer.cornerRadius = imageViewHeight/2
        addSubviewIfNeeded(receiverImageView)
    }
    
    private func addReceiverLabel() {
        let originX = receiverImageView.frame.origin.x + receiverImageView.frame.width + offset
        let labelHeight = 0.04*screenWidth
        let originY = frame.height/2 - labelHeight/2
        let labelFrame = CGRect(x: originX, y: originY, width: screenWidth*0.866, height: labelHeight)
        receiverLabel.font = UIFont(name: LocalizedFontNameKey.SearchViewHelper.ContactNameFont, size: 14)
        receiverLabel.textColor = UIColor.tableHeaderTitleGray
        receiverLabel.frame = labelFrame
        addSubviewIfNeeded(receiverLabel)
    }
    
    private func addSeparator() {
        let originX = receiverImageView.frame.origin.x + receiverImageView.frame.width + offset
        separatorView.frame = CGRect(x: originX, y: frame.height - 1, width: 0.818*screenWidth, height: 1)
        let lineColor = UIColor.lineGray.withAlphaComponent(0.07)
        separatorView.backgroundColor = lineColor
        addSubviewIfNeeded(separatorView)
    }
    
    private func setImage(_ imageUrl: String?) {
        if let unwrappedUrl = imageUrl, let url = URL(string: unwrappedUrl) {
            receiverImageView.hnk_setImageFromURL(url)
        } else {
            receiverImageView.image = UIImage(named: LocalizedImageNameKey.SearchViewHelper.DefaultImage)
        }
    }
    
    private func addAttributedString(with name: String, and email: String) {
        let nameAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.tableHeaderTitleGray, NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.SearchViewHelper.ContactNameFont, size: 14)!]
        let emailAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.tableHeaderTitleGray, NSAttributedStringKey.font: UIFont(name: LocalizedFontNameKey.SearchViewHelper.ThreadSnippet, size: 14)!]
        
        let partOne = NSAttributedString(string: name, attributes: nameAttribute)
        let partTwo = NSAttributedString(string: " " + email, attributes: emailAttribute)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        receiverLabel.numberOfLines = 1
        receiverLabel.attributedText = combination
    }
}
