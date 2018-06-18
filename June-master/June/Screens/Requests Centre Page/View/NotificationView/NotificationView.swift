//
//  NotificationView.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/19/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol NotificationViewDelegate: class {
    func didTapOnUndoButton(_ button: UIButton)
}

class NotificationView: UIView {
    
    weak var delegate: NotificationViewDelegate?
    private let screenWidth = UIScreen.main.bounds.width
    
    private var titleFont = UIFont.latoStyleAndSize(style: .regular, size: .regular)
    private var buttonFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
    
    var titleLabel = UILabel()
    var undoButton = UIButton()
    
    var title: String
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        title = ""
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        title = ""
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        self.frame = frame
        self.title = title
        //let customFrame = CGRect(x: 0, y: 0, width: screenWidth * 0.904, height: screenWidth * 0.124)
        //frame = customFrame
    }
    
    //Public part
    func setupSubviews() {
        clipsToBounds = true
        backgroundColor = UIColor.notificationViewBackgroundColor
        layer.cornerRadius = 0.04 * screenWidth
        addTitleLabel()
        addUndoButton()
        addShadow()
    }
    
    func updateFrame(with title: String) {
        self.title = title
        titleLabel.text = title
        print(title)
        
        let screenBounds = UIScreen.main.bounds
        let viewHeight = 0.124 * screenBounds.width
        let originY = screenBounds.height - screenBounds.width*0.333
        
        let titleHeight = 0.0586000000 * screenBounds.width
        let titleY = 0.02933333333 * screenBounds.width
        let titleX = 0.048 * screenBounds.width
        
        if (title.isEqualToString(find: "Moved to 'Conversations'")) || (title.isEqualToString(find: "Moved to 'Notifications'")) {
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: 151, height: titleHeight)
            self.frame = CGRect(x: 0.173333333333 * screenBounds.width, y: originY, width: 261, height: viewHeight)
        } else if (title.isEqualToString(find: "Moved to 'Purchases'")) || (title.isEqualToString(find: "Moved to 'Promotions'")) || (title.isEqualToString(find: "Moved to 'Finance'")) {
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: 133, height: titleHeight)
            self.frame = CGRect(x: 0.197333333333 * screenBounds.width, y: originY, width: 243, height: viewHeight)
        }  else if (title.isEqualToString(find: "Moved to 'Trips'")) || (title.isEqualToString(find: "Moved to 'News'")) ||
            (title.isEqualToString(find: "Moved to 'Social'")) {
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: 113, height: titleHeight)
            self.frame = CGRect(x: 0.25066666666 * screenBounds.width, y: originY, width: 203, height: viewHeight) 
        }
    }
    
    //Private part
    private func addShadow() {
        clipsToBounds = false
        layer.shadowColor = UIColor.notificationViewShadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
       // layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height/2).cgPath
    }
    
    private func addTitleLabel() {
        titleLabel.text = title
        setTitleFrame()
        titleLabel.font = titleFont
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        addSubview(titleLabel)
        print(title)
        updateFrame(with: title)
    }
    
    private func setTitleFrame() {
        let width = screenWidth*0.589
        let height = title.height(withConstrainedWidth: width, font: titleFont)
        
        let titleFrame = CGRect(x: screenWidth*0.069, y: frame.height/2 - height/2, width: width, height: height)
        titleLabel.frame = titleFrame
    }
    
    private func addUndoButton() {
        undoButton.setTitle(LocalizedStringKey.RequestsViewHelper.UndoTitle, for: .normal)
        undoButton.titleLabel?.font = buttonFont
        undoButton.setTitleColor(UIColor.white, for: .normal)
        undoButton.titleLabel?.textAlignment = .center
        undoButton.backgroundColor = UIColor.undoBackgroundColor
        let originX = self.frame.size.width - 81
        let width = 0.176 * screenWidth
        let height = 0.068 * screenWidth
        undoButton.layer.cornerRadius = height/2
        let buttonFrame = CGRect(x: originX, y: frame.height/2 - height/2, width: width, height: height)
        undoButton.frame = buttonFrame
        undoButton.addTarget(self, action: #selector(undoButtonTapped(sender:)), for: .touchUpInside)
        addSubview(undoButton)
    }
    
    //MARK: - actions
    @objc private func undoButtonTapped(sender:UIButton){
        delegate?.didTapOnUndoButton(sender)
    }
}
