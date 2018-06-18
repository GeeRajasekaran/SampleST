//
//  StarButtonAnimator.swift
//  June
//
//  Created by Ostap Holub on 9/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class StarButtonAnimator {
    
    // MARK: - Nested constants struct
    
    private struct Constants {
        static let growUpDuration = 0.5
        static let shrinkDuration = 0.1
        static let fillUpDuration = 0.1
    }
    
    // MARK: - Animations
    
    func performSelect(for button: StarButton) {
        let filledImage = UIImage(named: LocalizedImageNameKey.DetailViewHelper.BookmarkIconSelected)
        button.setImage(filledImage, for: .normal)
        UIView.animate(withDuration: Constants.growUpDuration, animations: { [weak self] in
            self?.makeScale(for: button.imageView!)
        })
    }
    
    func performDeselect(for button: StarButton) {
        let clearImage = UIImage(named: LocalizedImageNameKey.DetailViewHelper.BookmarkIconIdle)
        button.setImage(clearImage, for: .normal)
        UIView.animate(withDuration: Constants.growUpDuration, animations: { [weak self] in
            self?.makeScale(for: button.imageView!)
        })
    }
    
    // MARK: - Private part
    
    private func makeScale(for view: UIView) {
        let frame = view.frame
        let newFrame = CGRect(x: frame.origin.x + 3, y: frame.origin.y + 3, width: frame.size.width - 6, height: frame.size.height - 6)
        view.frame = newFrame
    }
}
