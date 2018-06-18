//
//  FavsTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class FavsTableViewCell: UITableViewCell {

    let mailView: FavsView = FavsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: FavsView.fixedHeight()))
    var bottomSeperatorView: UIView?
    var favorites: Favorites? = nil
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var clearIcon: UIImageView
    var backgroundLabel: UILabel
    var indexPath: IndexPath?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        
        func createCueImageView() -> UIImageView {
            let imageView = UIImageView(frame: CGRect.null)
            return imageView
        }
        
        // labels for context cues
        backgroundLabel = createCueLabel()
        backgroundLabel.backgroundColor = UIColor.juneGreen
        
        clearIcon = createCueImageView()
        clearIcon.image = #imageLiteral(resourceName: "clear-swipe-icon")
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(backgroundLabel)
        contentView.addSubview(clearIcon)
        setupView()
        self.shouldIndentWhileEditing = false
        setupConstraints()
        bottomSeperatorView = setupStandardSeperator(withOffset: 0, bothSides: false, backgroundColor: .romioLightGray, height: 1)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let kUICuesMargin: CGFloat = 60.0, kUICuesWidth: CGFloat = UIScreen.main.bounds.size.width, kUICuesCreateIconWidth: CGFloat = 37.0, kUICueCreateIconHeight: CGFloat = 57.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // ensure the gradient layer occupies the full bounds
        backgroundLabel.frame = CGRect(x: -(kUICuesWidth * 2), y: 0,
                                       width: kUICuesWidth * 2, height: ConvosView.fixedHeight())
        clearIcon.frame = CGRect(x: -kUICuesCreateIconWidth - kUICuesMargin, y: 22, width: kUICuesCreateIconWidth, height: kUICueCreateIconHeight)
    }
    
    internal func setupView() {
        backgroundColor = .white
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
    
    func configure(favorites: Favorites) {
        self.favorites = favorites
        mailView.configure(favorites: favorites)
    }
    
    override func prepareForReuse() {
        mailView.prepareForReuse()
        mailView.isHidden = false
        clearIcon.isHidden = false
        self.backgroundColor = UIColor.white
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "FavsTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        return FavsView.fixedHeight()
    }
    
    class func footerHeight() -> CGFloat {
        return 35
    }

}
