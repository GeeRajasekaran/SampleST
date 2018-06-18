//
//  UIButton+Extensions.swift
//  June
//
//  Created by Ostap Holub on 2/2/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

extension UIButton {
    
    func makeRightSideImageButton() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
}
