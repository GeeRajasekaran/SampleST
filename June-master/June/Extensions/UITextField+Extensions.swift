//
//  UITextField+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 7/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

public extension UITextField {
    
    func setPlaceHolderColor(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#000000")])
    }
}
