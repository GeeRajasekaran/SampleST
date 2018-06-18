//
//  ConvosSpamTableViewCell.swift
//  June
//
//  Created by Tatia Chachua on 31/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ConvosSpamViewCellDelegate: class {
    func convosSpamView(didTapItem sender: ConvosSpamTableViewCell, thread: Threads?)
}

class ConvosSpamTableViewCell: UITableViewCell, ConvosSpamViewDelegate {
    
    let mailView: ConvosSpamView = ConvosSpamView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: ConvosSpamView.heightForView()))
    var bottomSeperatorView: UIView?
    weak var mDelegate: ConvosSpamViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        bottomSeperatorView = setupStandardSeperator(withOffset: 12.0, bothSides: true, color: .romioLightGray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    internal func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        mailView.sizeToFit()
        contentView.addSubview(mailView)
    }
    
    //MARK: - Constraints
    internal func setupConstraints() {
        mailView.snp.remakeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    //MARK: - Configuration
    func configure(thread: Threads) {
        mailView.delegate = self
        mailView.configure(thread: thread)
    }
    
    //MARK: - Reuse
    override func prepareForReuse() {
        mailView.prepareForReuse()
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "ConvosSpamTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        return ConvosClearedView.fixedHeight()
    }
    
    func convosSpamView(didTapItem sender: ConvosSpamView) {
//        if let mDelegate = self.mDelegate {
////            mDelegate.convosSpamView(didTapItem: self, thread: sender.thread)
//        }
    }

}
