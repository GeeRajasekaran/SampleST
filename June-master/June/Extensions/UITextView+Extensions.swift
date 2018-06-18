//
//  UITextView+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

public extension UITextView {
    
    public var visibleRange: NSRange? {
        if let start = closestPosition(to: contentOffset) {
            if let end = characterRange(at: CGPoint(x: contentOffset.x + bounds.maxX, y: contentOffset.y + bounds.maxY))?.end {
                return NSMakeRange(offset(from: beginningOfDocument, to: start), offset(from: start, to: end))
            }
        }
        return nil
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
    func linesCount() -> Int {
        
        let contentHeight = self.contentSize.height
        let topInset = self.contentInset.top
        let bottomInset = self.contentInset.bottom
        
        if let lineHeight = self.font?.lineHeight {
            let linesCount = (contentHeight - topInset - bottomInset) / lineHeight
            return Int(linesCount)
        }
        
        return 0
    }
}
