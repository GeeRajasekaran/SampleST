//
//  ComposeTextView.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.size.height = 18
        return originalRect
    }
}
