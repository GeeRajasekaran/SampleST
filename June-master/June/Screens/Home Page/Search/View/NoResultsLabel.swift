//
//  NoResultsLabel.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/25/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class NoResultsLabel: UILabel {

    override var text: String? {
        didSet {
            textAlignment = .center
            font = UIFont(name: LocalizedFontNameKey.SearchViewHelper.NoResultsFont, size: 22)
            textColor = UIColor.textGray
        }
    }
}
