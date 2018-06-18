//
//  ResponderViewController.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderViewController: UIViewController, IResponderViewController {
    
    // MARK: - Variables & Constants
    
    weak var metadata: ResponderMetadata?
    var responderAccessoryView: ResponderAccessoryView?
    
    private lazy var uiInitializer: ResponderViewInitializer = { [unowned self] in
        let initializer = ResponderViewInitializer(viewController: self)
        return initializer
    }()
    
    // MARK: - View life cycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
    }
}

    // MARK: - IResponderMovable

extension ResponderViewController {
    
    func moveUp(_ delta: CGFloat) {
        view.frame.origin.y -= delta
    }
    
    func moveDown(_ delta: CGFloat) {
        view.frame.origin.y += delta
    }
}
