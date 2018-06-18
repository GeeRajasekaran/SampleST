//
//  ConvosClearedTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 1/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ConvosClearedViewCellDelegate: class {
    func convosClearedView(didTapItem sender: ConvosClearedTableViewCell, thread: Threads?, indexPath: IndexPath)
}

class ConvosClearedTableViewCell: UITableViewCell, ConvosClearedViewDelegate {

    let mailView: ConvosClearedView = ConvosClearedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: ConvosClearedView.heightForView()))
    var bottomSeperatorView: UIView?
    weak var mDelegate: ConvosClearedViewCellDelegate?
    var indexPath: IndexPath?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        bottomSeperatorView = setupStandardSeperator(withOffset: 12.0, bothSides: true, color: .romioLightGray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        mailView.sizeToFit()
        contentView.addSubview(mailView)
    }
    
    internal func setupConstraints() {
        mailView.snp.remakeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    func configure(thread: Threads) {
        mailView.delegate = self
        mailView.configure(thread: thread)
    }
    
    override func prepareForReuse() {
        mailView.prepareForReuse()
        mailView.isHidden = false
        self.backgroundColor = UIColor.white
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "ConvosClearedTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        return ConvosClearedView.fixedHeight()
    }
    
    func convosClearedView(didTapItem sender: ConvosClearedView) {
        self.clipsToBounds = true
        if let mDelegate = self.mDelegate, let indexPath = self.indexPath {
            mDelegate.convosClearedView(didTapItem: self, thread: sender.thread, indexPath: indexPath)
        }
    }

}
