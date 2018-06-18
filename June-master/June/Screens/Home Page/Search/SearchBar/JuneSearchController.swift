//
//  JuneSearchController.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol JuneSearchControllerDelegate: class {
    func updateSearchBar()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBar(_ searchBar: UISearchBar, didTapOnExitButton with: UITextField)
    func searchBar(_ searchBar: UISearchBar, didTapOnReturnButtonWith textField: UITextField)
    func searchBar(_ searchBar: UISearchBar, didTapOnCancelButtonWith button: UIButton)
}

class JuneSearchController: UISearchController {
    
    var searchBarRect: CGRect?
    weak var juneDelegate: JuneSearchControllerDelegate?
    
    private lazy var _searchBar: JuneSearchBar = { [unowned self] in
        var rect: CGRect = .zero
        if let unwrappedRect = searchBarRect {
            rect = unwrappedRect
        }
        let result = JuneSearchBar(frame: rect)
        result.delegate = self
        
        return result
    }()
    
    override var searchBar: UISearchBar {
        get {
            _searchBar.savedFrame = searchBarRect
            _searchBar.juneDelegate = self
            return _searchBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        searchBar.delegate = self
    }
}

extension JuneSearchController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searchBar.becomeFirstResponder()
    }
}

extension JuneSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        juneDelegate?.updateSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        juneDelegate?.searchBar(searchBar, textDidChange: searchText)
    }
}

extension JuneSearchController: JuneSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, didTapOnExitButtonWith textField: UITextField) {
        juneDelegate?.searchBar(searchBar, didTapOnExitButton: textField)
    }
    
    func searchBar(_ searchBar: UISearchBar, didTapOnReturnButtonWith textField: UITextField) {
        juneDelegate?.searchBar(searchBar, didTapOnReturnButtonWith: textField)
    }
    
    func searchBar(_ searchBar: UISearchBar, didTapOnCancelButtonWith button: UIButton) {
        juneDelegate?.searchBar(searchBar, didTapOnCancelButtonWith: button)
    }
}
