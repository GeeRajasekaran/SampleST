//
//  ConvosNewTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 1/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ConvosNewViewCellDelegate: class {
    func convosNewView(didTapItem sender: ConvosNewTableViewCell, thread: Threads?, indexPath: IndexPath)
    func convosNewView(didSwipeItem sender: ConvosNewTableViewCell, thread: Threads?, indexPath: IndexPath, xValue: CGFloat)
}

class ConvosNewTableViewCell: SwipyCell, ConvosNewViewDelegate {

    let mailView: ConvosNewView = ConvosNewView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: ConvosNewView.heightForView()))
    var bottomSeperatorView: UIView?
    weak var mDelegate: ConvosNewViewCellDelegate?
    var thread: Threads? = nil
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
        
        addSubview(backgroundLabel)
        addSubview(clearIcon)
        setupView()
        setupConstraints()
        bottomSeperatorView = setupStandardSeperator(withOffset: 12.0, bothSides: true, color: .romioLightGray)

        // add a pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let kUICuesMargin: CGFloat = 60.0, kUICuesWidth: CGFloat = 400.0, kUICuesCreateIconWidth: CGFloat = 37.0, kUICueCreateIconHeight: CGFloat = 57.0

    override func layoutSubviews() {
        super.layoutSubviews()
        // ensure the gradient layer occupies the full bounds
        backgroundLabel.frame = CGRect(x: -kUICuesWidth, y: 0,
                                       width: kUICuesWidth, height: ConvosView.fixedHeight())
        clearIcon.frame = CGRect(x: -kUICuesCreateIconWidth - kUICuesMargin, y: 22, width: kUICuesCreateIconWidth, height: kUICueCreateIconHeight)
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
        self.thread = thread
        mailView.delegate = self
        mailView.configure(thread: thread)
    }
    
    override func prepareForReuse() {
        mailView.prepareForReuse()
        mailView.isHidden = false
        clearIcon.isHidden = false
        self.backgroundColor = UIColor.white
        mailView.backgroundColor = .white
        contentView.backgroundColor = .white
        super.prepareForReuse()
    }
    
    class func reuseIdentifier() -> String {
        return "ConvosNewTableViewCell"
    }
    
    class func heightForCell() -> CGFloat {
        return ConvosNewPreviewView.fixedHeight()
    }
    
    func convosNewView(didTapItem sender: ConvosNewView) {
        self.clipsToBounds = true
        if let mDelegate = self.mDelegate, let indexPath = self.indexPath {
            mDelegate.convosNewView(didTapItem: self, thread: sender.thread, indexPath: indexPath)
        }
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
            self.clipsToBounds = false
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x > 40
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
        self.clipsToBounds = false
        UIView.animate(withDuration: 0.05, animations: {
            self.frame = CGRect(x: self.frame.size.width, y: self.frame.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
        }) { [weak self](finished) in
            self?.mailView.isHidden = true
            self?.contentView.backgroundColor = .juneGreen
            self?.clearIcon.isHidden = true
            if let strongSelf = self {
                if let delegate = strongSelf.mDelegate, let thread = strongSelf.thread, let indexPath = strongSelf.indexPath {
                    // notify the delegate that this item should be deleted
                    delegate.convosNewView(didSwipeItem: strongSelf, thread: thread, indexPath: indexPath, xValue: strongSelf.frame.origin.x)
                }
            }
        }
    }
    
}
