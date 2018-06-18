//
//  MessageHeaderTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Haneke

class MessageHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var separatorView: UIView?
    private var profileImageView: UIImageView?
    private var vendorNameLabel: UILabel?
    private var toNamesLabel: UILabel?
    private var dateLabel: UILabel?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView?.removeFromSuperview()
        vendorNameLabel?.removeFromSuperview()
        toNamesLabel?.removeFromSuperview()
        dateLabel?.removeFromSuperview()
        profileImageView = nil
        vendorNameLabel = nil
        toNamesLabel = nil
        dateLabel = nil
    }
    
    // MARK: - Data loading
    
    func load(model: MessageHeaderInfo) {
        vendorNameLabel?.text = model.vendorName
        dateLabel?.text = FeedDateConverter().timeAgoInWords(from: model.date)
        if model.toNames.first == "" {
            toNamesLabel?.attributedText = attributedString(with: model.toEmails)
        } else {
            toNamesLabel?.attributedText = attributedString(with: model.toNames)
        }
        loadVendorImage(from: model.profileImageURL)
    }
    
    private func loadVendorImage(from url: URL?) {
        guard let unwrappedURL = url else { return }
        profileImageView?.hnk_setImageFromURL(unwrappedURL, placeholder: nil, format: nil, failure: nil, success: { [weak self] image in
            self?.profileImageView?.image = image
            self?.drawImageViewBorder()
        })
    }
    
    private func attributedString(with names: [String]) -> NSAttributedString {
        let initialString = NSString(string: "to \(names.joined(separator: ", "))")
        let finalString = NSMutableAttributedString(string: initialString as String)
        
        let range = initialString.range(of: "to")
        finalString.addAttribute(.foregroundColor, value: UIColor.composeTitleGray, range: range)
        finalString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .regular, size: .regular), range: range)
        
        names.forEach { name in
            let range = initialString.range(of: name)
            finalString.addAttribute(.foregroundColor, value: UIColor.composeTitleGray, range: range)
            finalString.addAttribute(.font, value: UIFont.latoStyleAndSize(style: .bold, size: .regular), range: range)
        }
        
        return finalString
    }
    
    // MARK: - Public view setup
    
    func setupSubviews() {
        selectionStyle = .none
        backgroundColor = .white
        separatorView = addFeedDetailedViewSeparator()
        addProfileImageView()
        addVendorNameLabel()
        addToNamesLabel()
        addDateLabel()
    }
    
    // MARK: - Vendor profile image view  setup
    
    private func addProfileImageView() {
        guard profileImageView == nil else { return }
        
        let dimension: CGFloat = 0.085 * screenWidth
        let rect = CGRect(x: 0.045 * screenWidth, y: 0.042 * screenWidth, width: dimension, height: dimension)
        profileImageView = UIImageView(frame: rect)
        profileImageView?.backgroundColor = .clear
        profileImageView?.layer.cornerRadius = dimension / 2
        profileImageView?.contentMode = .scaleAspectFit
        profileImageView?.clipsToBounds = true
        
        if profileImageView != nil {
            addSubview(profileImageView!)
        }
    }
    
    private func drawImageViewBorder() {
        profileImageView?.layer.borderWidth = 1
        profileImageView?.layer.borderColor = UIColor.vendorImageViewBorderColor.cgColor
    }
    
    // MARK: - Vendor name label setup
    
    private func addVendorNameLabel() {
        guard vendorNameLabel == nil else { return }
        guard let imageView = profileImageView else { return }
        
        vendorNameLabel = UILabel()
        vendorNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        vendorNameLabel?.backgroundColor = .clear
        vendorNameLabel?.font = UIFont.latoStyleAndSize(style: .black, size: .mediumLarge)
        vendorNameLabel?.textColor = UIColor.tableHeaderTitleGray
        
        if vendorNameLabel != nil {
            addSubview(vendorNameLabel!)
            vendorNameLabel?.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0.026 * screenWidth).isActive = true
            vendorNameLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 0.032 * screenWidth).isActive = true
            vendorNameLabel?.heightAnchor.constraint(equalToConstant: 0.058 * screenWidth).isActive = true
            vendorNameLabel?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    // MARK: - To name label setup
    
    private func addToNamesLabel() {
        guard toNamesLabel == nil else { return }
        guard let nameLabel = vendorNameLabel else { return }
        guard let imageView = profileImageView else { return }
        
        toNamesLabel = UILabel()
        toNamesLabel?.translatesAutoresizingMaskIntoConstraints = false
        toNamesLabel?.backgroundColor = .clear
        
        if toNamesLabel != nil {
            addSubview(toNamesLabel!)
            toNamesLabel?.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0.03 * screenWidth).isActive = true
            toNamesLabel?.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0.003 * screenWidth).isActive = true
            toNamesLabel?.heightAnchor.constraint(equalToConstant: 0.05 * screenWidth).isActive = true
            toNamesLabel?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    // MARK: - Data label setup
    
    private func addDateLabel() {
        guard dateLabel == nil else { return }
        guard let toLabel = toNamesLabel else { return }
        guard let imageView = profileImageView else { return }
        
        dateLabel = UILabel()
        dateLabel?.translatesAutoresizingMaskIntoConstraints = false
        dateLabel?.backgroundColor = .clear
        dateLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .regular)
        dateLabel?.textColor = UIColor.searchResultTimestemptColor
        
        if dateLabel != nil {
            addSubview(dateLabel!)
            dateLabel?.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0.03 * screenWidth).isActive = true
            dateLabel?.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 0.01 * screenWidth).isActive = true
            dateLabel?.heightAnchor.constraint(equalToConstant: 0.042 * screenWidth).isActive = true
            dateLabel?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}
