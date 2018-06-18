//
//  RolodexsTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RolodexsTableViewCell: UITableViewCell {

    let mailView: RolodexsView = RolodexsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: RolodexsView.heightForView()))
    var bottomSeperatorView: UIView?
    var rolodexs: Rolodexs? = nil
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
        // add a pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        recognizer.delegate = self
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
    
    func configure(rolodexs: Rolodexs) {
        self.rolodexs = rolodexs
        mailView.configure(rolodexs: rolodexs)
    }
    
    override func prepareForReuse() {
        mailView.prepareForReuse()
        mailView.isHidden = false
        clearIcon.isHidden = false
        self.backgroundColor = UIColor.white
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "RolodexsTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        return RolodexsView.fixedHeight()
    }
    
    class func heightForReadCell() -> CGFloat {
        return RolodexsView.readCellHeight()
    }
    
    class func footerHeight() -> CGFloat {
        return 35
    }
    
    func rolodexsView(didTapItem sender: RolodexsView) {
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            if panGestureRecognizer.isLeft(theViewYouArePassing: self) {
                return false
            }
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    //MARK: - horizontal pan gesture methods
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x > 0.236 * UIScreen.size.width
        }
        // 3
        if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                self.swipeCellRightProgramatically()
            }
        }
    }
    
    func swipeCellRightProgramatically() {
        
    }

}
