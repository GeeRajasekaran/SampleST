//
//  SpoolItemTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import SnapKit

struct SpoolItemStyle {
    var subjectFont: UIFont
    var senderFont: UIFont
    var backgroundColor: UIColor
}

class SpoolItemTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private var subjectLabel: UILabel?
    private var senderLabel: UILabel?
    private var messageLabel: UILabel?
    private var dateLabel: UILabel?
    
    private var unreadView: UnreadCountView?
    
    // MARK: - Reuse logic
    
    override func layoutSubviews() {
        super.layoutSubviews()
        unreadView?.snp.makeConstraints { [weak self] make in
            guard let right = self?.dateLabel?.snp.leading else { return }
            guard let bottom = self?.dateLabel?.snp.bottom else { return }
            make.trailing.equalTo(right).offset(-5)
            make.bottom.equalTo(bottom)
        }
        
        subjectLabel?.snp.makeConstraints { [weak self] make in
            guard let right = self?.unreadView?.snp.leading else { return }
            make.trailing.equalTo(right).offset(-5)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.62)
        }
    }
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subjectLabel?.removeFromSuperview()
        subjectLabel = nil
        senderLabel?.removeFromSuperview()
        senderLabel = nil
        messageLabel?.removeFromSuperview()
        messageLabel = nil
        dateLabel?.removeFromSuperview()
        dateLabel = nil
        unreadView?.removeFromSuperview()
        unreadView = nil
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        selectionStyle = .none
        clipsToBounds = false
        backgroundColor = UIColor(hexString: "F8F9F9")
        addShadow()
        addSubjectLabel()
        addSenderLabel()
        addMessageLabel()
        addDateLabel()
        addUnreadCountView()
    }
    
    func apply(style: SpoolItemStyle) {
        subjectLabel?.font = style.subjectFont
        senderLabel?.font = style.senderFont
        backgroundColor = style.backgroundColor
    }
    
    func load(model: BaseTableModel) {
        guard let spoolModel = model as? SpoolItemInfo else { return }
        subjectLabel?.text  = spoolModel.title
        messageLabel?.text = spoolModel.summary
        dateLabel?.text = FeedDateConverter().timeAgoInWords(from: spoolModel.timestamp)
        senderLabel?.text = spoolModel.participants
        apply(style: SpoolItemStyleBuilder.style(for: spoolModel))
        if spoolModel.unread {
            guard let count = spoolModel.unreadCount else { return }
            unreadView?.count = count
        }
    }
    
    // MARK: - Private shadow setup
    
    private func addShadow() {
        layer.shadowColor = UIColor(hexString: "A4AEB3").withAlphaComponent(0.12).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 6
    }
    
    // MARK: - Private subject label setup
    
    private func addSubjectLabel() {
        guard subjectLabel == nil else { return }
        subjectLabel = UILabel()
        subjectLabel?.textColor = UIColor(hexString: "0E0E0E")
        
        if subjectLabel != nil {
            addSubview(subjectLabel!)
            subjectLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(22)
                make.top.equalToSuperview().offset(14)
                make.trailing.equalToSuperview().offset(-45)
            }
        }
    }
    
    // MARK: - Private sender setup
    
    private func addSenderLabel() {
        guard senderLabel == nil else { return }
        
        senderLabel = UILabel()
        senderLabel?.textColor = UIColor(hexString: "757575")
        
        if senderLabel != nil {
            addSubview(senderLabel!)
            senderLabel?.snp.makeConstraints { [weak self] make in
                guard let top = self?.subjectLabel else { return }
                make.leading.equalToSuperview().offset(22)
                make.top.equalTo(top.snp.bottom).offset(1)
            }
        }
    }
    
    // MARK: - Private message label setup
    
    private func addMessageLabel() {
        guard messageLabel == nil else { return }
        
        messageLabel = UILabel()
        messageLabel?.textColor = UIColor(hexString: "757575")
        messageLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        messageLabel?.lineBreakMode = .byTruncatingTail
        
        if messageLabel != nil {
            addSubview(messageLabel!)
            messageLabel?.snp.makeConstraints { [weak self] make in
                guard let top = self?.senderLabel?.snp else { return }
                make.leading.equalToSuperview().offset(22)
                make.trailing.equalToSuperview().offset(-45)
                make.top.equalTo(top.bottom).offset(1)
            }
        }
    }
    
    // MARK: - Private date label setup
    
    private func addDateLabel() {
        guard dateLabel == nil else { return }
        
        dateLabel = UILabel()
        dateLabel?.textColor = UIColor(hexString: "9A9CA2")
        dateLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        dateLabel?.textAlignment = .right
        
        if dateLabel != nil {
            addSubview(dateLabel!)
            dateLabel?.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-8)
                make.top.equalToSuperview().offset(16)
            }
        }
    }
    
    // MARK: - Private unread view count
    
    private func addUnreadCountView() {
        guard unreadView == nil else { return }
        
        unreadView = UnreadCountView()
        unreadView?.translatesAutoresizingMaskIntoConstraints = false
        unreadView?.setupSubviews()
        
        if unreadView != nil {
            addSubview(unreadView!)
        }
    }
}
