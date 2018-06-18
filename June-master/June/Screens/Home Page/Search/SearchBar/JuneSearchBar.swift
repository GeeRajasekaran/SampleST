//
//  JuneSearchBar.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol JuneSearchBarDelegate: class {
    func searchBar(_ searchBar: UISearchBar, didTapOnExitButtonWith textField: UITextField)
    func searchBar(_ searchBar: UISearchBar, didTapOnReturnButtonWith textField: UITextField)
    func searchBar(_ searchBar: UISearchBar, didTapOnCancelButtonWith button: UIButton)
}

class JuneSearchBar: UISearchBar {
    
    var savedFrame: CGRect?
    weak var juneDelegate: JuneSearchBarDelegate?
    
    override func layoutSubviews() {
        if let unwrappedFrame = savedFrame {
            frame = unwrappedFrame
        }
        super.layoutSubviews()
        setShowsCancelButton(true, animated: false)
        tintColor = UIColor.searchBarTintColor
        
        configureSearchField()
        configureCancelButton()
    }
    
    @objc func onCancelButtonClicked(_ sender: UIButton) {
        juneDelegate?.searchBar(self, didTapOnCancelButtonWith: sender)
    }
    
    //MARK: - items configuration
    func configureSearchField() {
        if let textField = value(forKey: "_searchField") as? UITextField {
            textField.backgroundColor = UIColor.searchBarBackgroundColor.withAlphaComponent(0.68)
            textField.font = UIFont(name: LocalizedFontNameKey.SearchViewHelper.SearchBarFont, size: 15)
            textField.textColor = UIColor.searchBarTextColor
            let paddingView = UIView()
            textField.leftViewMode = .always
            textField.leftView = paddingView
            textField.layer.cornerRadius = textField.frame.height/2
            textField.clipsToBounds = true
            textField.delegate = self
            configurePlaceholderLabel(in: textField)
        }
    }
    
    func configureCancelButton() {
        if let cancelButton = value(forKey: "_cancelButton") as? UIButton {
            cancelButton.setTitleColor(UIColor.searchBarTintColor, for: .normal)
            cancelButton.titleLabel?.font = UIFont(name: LocalizedFontNameKey.SearchViewHelper.SearchBarFont, size: 15)
            cancelButton.addTarget(self, action: #selector(onCancelButtonClicked(_:)), for: .touchUpInside)
        }
    }
    
    func configurePlaceholderLabel(in textField: UITextField) {
        if let placeholderLabel = textField.value(forKey: "_placeholderLabel") as? UILabel {
            placeholderLabel.textColor = UIColor.searchBarPlaceholderColor
            placeholderLabel.font = UIFont(name: LocalizedFontNameKey.SearchViewHelper.SearchBarFont, size: 15)
        }
    }
}

extension JuneSearchBar: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        juneDelegate?.searchBar(self, didTapOnExitButtonWith: textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        juneDelegate?.searchBar(self, didTapOnReturnButtonWith: textField)
        return true
    }
}
