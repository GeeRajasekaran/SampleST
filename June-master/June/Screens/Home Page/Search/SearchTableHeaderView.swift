//
//  SearchTableHeaderView.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/24/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchTableHeaderView: UIView {
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let headerHeight = UIScreen.main.bounds.width * 0.12
    private let titleFont = UIFont(name: LocalizedFontNameKey.SearchViewHelper.ResultsFont, size: 17)
    
    // MARK: - Views
    private var titleLabel: UILabel?
    private var borderView: UIView?

    // MARK: - UI setup
    func setupView() {
        // any UI setup goes here
        addTitleLabel()
        addBottomBorder()
        backgroundColor = UIColor.searchResultBackgroundColor
    }
    
    private func addTitleLabel() {
        if titleLabel != nil { return }
        let text = LocalizedStringKey.SearchViewHelper.ResultsTitle
        let labelWidth = text.width(usingFont: titleFont!)
        let labelHeight = text.height(withConstrainedWidth: labelWidth, font: titleFont!)
        titleLabel = UILabel(frame: CGRect(x: screenWidth * 0.048, y: headerHeight/2 - labelHeight/2, width: labelWidth, height: labelHeight))
        titleLabel?.textColor = UIColor.searchBarTextColor
        titleLabel?.text = text
        titleLabel?.font = titleFont
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
    
    private func addBottomBorder() {
        if borderView != nil { return }
        let height: CGFloat = 1
        let originY = headerHeight - height
        borderView = UIView(frame: CGRect(x: 0, y: originY, width: screenWidth, height: height))
        borderView?.backgroundColor = UIColor.searchResultBorderColor
        if borderView != nil {
            addSubview(borderView!)
        }
    }
}
