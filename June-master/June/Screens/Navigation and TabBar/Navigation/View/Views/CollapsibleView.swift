//
//  CollapsibleView.swift
//  June
//
//  Created by Joshua Cleetus on 12/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol CollapsibleViewProtocol: class {
    func viewHeight() -> CGFloat
    func collapsedViewHeight() -> CGFloat
    func didScroll(withPercent percent: CGFloat)
}

class CollapsibleView: UIView, CollapsibleViewProtocol {
    
    private let DEFAULT_HEIGHT: CGFloat = 100
    
    func viewHeight() -> CGFloat {
        return DEFAULT_HEIGHT
    }
    
    func collapsedViewHeight() -> CGFloat {
        return DEFAULT_HEIGHT/2
    }
    
    func didScroll(withPercent percent: CGFloat) {}
}
