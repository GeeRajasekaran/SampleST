//
//  UISelectableButton.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

enum ButtonState {
    case selected
    case started
}

class UISelectableButton: UIButton {

    private let buttonFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
    private var textColor: UIColor?
    private var borderColor: UIColor?
    var selectState: ButtonState
    
    override init(frame: CGRect) {
        selectState = .started
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        selectState = .started
        super.init(coder: aDecoder)
    }
    
    func setupUI(textColor: UIColor, borderColor: UIColor, title: String) {
        self.textColor = textColor
        self.borderColor = borderColor
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = buttonFont
        backgroundColor = UIColor.white
        layer.borderWidth = 2
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = frame.height/2
    }
    
    func changeState() {
        if selectState == .selected {
            deselect()
        } else {
            select()
        }
    }
    
    func select() {
        selectState = .selected
        setTitleColor(.white, for: .normal)
        backgroundColor = borderColor
    }
    
    func deselect() {
        selectState = .started
        setTitleColor(textColor, for: .normal)
        backgroundColor = .white
    }
}
