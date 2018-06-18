//
//  SubjectDetailsView.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SubjectDetailsView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private var textField: UITextField?
    
    var subject: String? {
        get { return textField?.text }
    }
    
    // MARK: - Setup subviews
    
    func setupSubviews() {
        backgroundColor = .white
        addTextField()
        addComposeShadowView()
    }
    
    // MARK: - Text field creation
    
    private func addTextField() {
        guard textField == nil else { return }
        let textFieldFrame = CGRect(x: 0.048 * screenWidth, y: 0, width: screenWidth - 2 * UIView.midLargeMargin, height: frame.height)
        let textFieldFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        
        textField = UITextField(frame: textFieldFrame)
        let placeholderFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        textField?.font = textFieldFont
        textField?.attributedPlaceholder = NSAttributedString(string: "Subject", attributes: [.foregroundColor: UIColor.composeTitleGray.withAlphaComponent(0.65), .font: placeholderFont])
        textField?.textColor = UIColor.tableHeaderTitleGray
        textField?.autocorrectionType = .yes
        if textField != nil {
            addSubview(textField!)
        }
    }
    
}
