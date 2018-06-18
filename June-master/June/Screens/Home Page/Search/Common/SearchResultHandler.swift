//
//  SearchResultHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

enum SearchState {
    case started
    case finished
}

class SearchResultHandler: NSObject {

    var searchState = SearchState.started
    
    lazy var searchController: JuneSearchController = { [ unowned self] in
        let vc = JuneSearchController(searchResultsController: nil)
        return vc
    }()
    
    var didTapOnCancelButton: (() -> Void)?
    var didTapOnExitButton: (() -> Void)?
    var didTapOnReturnButton: ((UITextField, UISearchController) -> Void)?
    var updateSearchResults: ((UISearchController) -> Void)?
    
    override init() {
        super.init()
        searchController.juneDelegate = self
        searchController.searchResultsUpdater = self
    }
    
    //MARK: - search bar
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func textFromSearchBar() -> String {
        guard let text = searchController.searchBar.text else { return ""}
        return text
    }
    
    func set(_ text: String?) {
        searchController.searchBar.text = text
    }
    
    func becomeFirsResponder() {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func resignFirstResponder() {
       searchController.searchBar.resignFirstResponder()
    }
}

extension SearchResultHandler: JuneSearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, didTapOnExitButton with: UITextField) {
       didTapOnExitButton?()
    }

    func searchBar(_ searchBar: UISearchBar, didTapOnReturnButtonWith textField: UITextField) {
        didTapOnReturnButton?(textField, searchController)
    }

    func updateSearchBar() {
        updateSearchResults(for: searchController)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchState = .finished
        } else {
            searchState = .started
        }
    }

    func searchBar(_ searchBar: UISearchBar, didTapOnCancelButtonWith button: UIButton) {
        didTapOnCancelButton?()
    }
}

extension SearchResultHandler: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {        
        updateSearchResults?(searchController)
    }
}
