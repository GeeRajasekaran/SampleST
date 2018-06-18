//
//  StarButton.swift
//  June
//
//  Created by Ostap Holub on 9/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class StarButton: UIButton {
    
    // MARK: - Nested state struct
    
    enum SelectionState {
        case idle
        case selected
    }
    
    // MARK: - Variables
    
    private var animator = StarButtonAnimator()
    var selectionState: SelectionState = .idle
    
    // MARK: - Public part
    
    func changeState() {
        if selectionState == .idle {
            selectionState = .selected
            animator.performSelect(for: self)
        } else {
            selectionState = .idle
            animator.performDeselect(for: self)
        }
    }
}
