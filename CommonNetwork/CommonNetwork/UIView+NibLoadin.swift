//
//  UIView+NibLoadin.swift
//  CommonNetwork
//
//  Created by Guru Prasad chelliah on 8/28/17.
//  Copyright © 2017 Network. All rights reserved.
//

import Foundation
import UIKit

/// Protocol to be extended with implementations
protocol UIViewLoading {}

/// Extend UIView to declare that it includes nib loading functionality
extension UIView : UIViewLoading {}

/// Protocol implementation
extension UIViewLoading where Self : UIView {
    
    /**
     Creates a new instance of the class on which this method is invoked,
     instantiated from a nib of the given name. If no nib name is given
     then a nib with the name of the class is used.
     
     - parameter nibNameOrNil: The name of the nib to instantiate from, or
     nil to indicate the nib with the name of the class should be used.
     
     - returns: A new instance of the class, loaded from a nib.
     */
    static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        let nibName = nibNameOrNil ?? self.className
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
    static private var className: String {
        let className = "\(self)"
        let components = className.characters.split{$0 == "."}.map ( String.init )
        return components.last!
    }
    
}
