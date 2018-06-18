//
//  ActionButtonsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ActionButtonsDelegate: class {
    func didTapOnReplyButton(_ button: RightImageButton)
}

class ActionButtonsView: UIView {

    private let screenWidth = UIScreen.main.bounds.width
    private var replyButton: RightImageButton?
    
    weak var delegate: ActionButtonsDelegate?
    
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
        let customFrame = CGRect(x: 0, y: 0, width: 0.81 * screenWidth, height: 0.168 * screenWidth)
        frame = customFrame
        addReplyButton()
    }
    
    //MARK: - private part
    
    private func addReplyButton() {
        if replyButton != nil { return }
        let buttonHeight = frame.height
        let buttonWidth = buttonHeight
        let rightOffset = 0.056 * screenWidth
        let buttonFrame = CGRect(x: frame.width - buttonWidth - rightOffset, y: frame.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight)
        replyButton = RightImageButton(frame: buttonFrame, image: LocalizedImageNameKey.RequestsViewHelper.ReplyIconName)
        replyButton?.tapButton = replyButtonTapped
        
        if replyButton != nil {
            addSubview(replyButton!)
        }
    }
    
    //MARK: - action
    lazy var replyButtonTapped: (RightImageButton) -> Void = { [weak self] button in
        self?.delegate?.didTapOnReplyButton(button)
    }
}
