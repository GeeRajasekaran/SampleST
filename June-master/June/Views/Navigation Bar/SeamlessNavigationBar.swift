//
//  SeamlessNavigationBar.swift
//  Romio
//
//  Created by Romaine Hinds on 8/8/17.
//  Copyright © 2017 HomePeople Corporation. All rights reserved.
//

import UIKit

import UIKit

protocol SeamlessNavigationBar {
    func makeNavitionBarSeamless()
}

extension SeamlessNavigationBar where Self: CustomNavBarViewController {
    func makeNavitionBarSeamless() {
        seperator.backgroundColor = .clear
        seperator.isHidden = true
    }
}
