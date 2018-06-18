//
//  SearchViewController.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class JuneSearchViewController: UIViewController {

    var tableView = UITableView()
    var searchEngine = SearchEngine()
    
    //UIInitializer
    lazy var uiInitializer: JuneSearchViewControllerInitializer = { [unowned self] in
        let initializer = JuneSearchViewControllerInitializer(with: self)
        return initializer
    }()
    
    //Data repository
   var dataRepository: SearchDataRepository = SearchDataRepository()

    //Data source
    lazy var listDataSource: SearchTableViewDataSource = { [unowned self] in
        var source = SearchTableViewDataSource(with: dataRepository)
        return source
    }()
    
    //Delegate
    lazy var listDelegate: SearchTableViewDelegate = { [unowned self] in
        var delegate = SearchTableViewDelegate(with: dataRepository)
        delegate.tableViewDidSelectRowAction = self.tableViewDidSelectRowAction
        delegate.onMoreContacts = onMoreContacts
        return delegate
    }()
    
    //Search result handler
    var searchResultHandler = SearchResultHandler()

    lazy var tableViewDidSelectRowAction: ((Int, ContactReceiver) -> Void) = { [weak self] _, contact in
        //Show search result VC
        self?.openSearchResultsWith(contact.email)
    }
    
    lazy fileprivate var onMoreContacts: () -> Void = { [weak self] in
        self?.requestMoreContacts()
    }
    
    //MARK: - search closed
    var didCloseSearch: (() -> Void)?
    
    //MARK: - search result
    lazy var didTapOnCancelButton: (() -> Void) = { [weak self] in
        self?.onBackButtonTapped()
    }

    lazy var updateSearchResults: ((UISearchController) -> Void) = { [weak self] searchVC in
        self?.requestSearch()
    }
    
    lazy var didTapOnReturnButton: ((UITextField, UISearchController) -> Void) = { [weak self] textField, _ in
        guard let text = textField.text else { return }
        if text != "" {
            self?.openSearchResultsWith(text)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchResultHandler.didTapOnCancelButton = didTapOnCancelButton
        searchResultHandler.didTapOnExitButton = nil
        searchResultHandler.updateSearchResults = updateSearchResults
        searchResultHandler.didTapOnReturnButton = didTapOnReturnButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(0.1) { self.searchResultHandler.searchController.searchBar.becomeFirstResponder() }
    }
    
    //MARK: - actions
    @objc func onBackButtonTapped() {
        didCloseSearch?()
    }
    
    func openSearchResultsWith(_ text: String) {
        let controller = JuneSearchResultViewController()
        controller.delegate = self
        controller.searchResultHandler = searchResultHandler
        controller.searchText = text
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.pushViewController(controller, animated: false)
        dataRepository.clean()
        searchResultHandler.resignFirstResponder()
        uiInitializer.hideTableView()
        tableView.reloadData()
    }
    
    //MARK: - delay
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    //MARK: - more contacts
    func requestMoreContacts() {
        //TODO: - request more contacts
//        if let query = searchResultHandler.searchController.searchBar.text {
//            searchEngine.searchContacts(by: query, completion: { [weak self] receivers, shouldAppend in
//                self?.updateSearch(with: receivers, shouldAppend: shouldAppend)
//            })
//        }
    }
    
    // MARK: - update search
    func requestSearch() {
        if searchResultHandler.searchBarIsEmpty() {
            dataRepository.clean()
            uiInitializer.hideTableView()
            tableView.reloadData()
        } else {
            searchEngine.searchContacts(by: searchResultHandler.textFromSearchBar(), completion: { [weak self] receivers, shouldAppend in
                self?.updateSearch(with: receivers, shouldAppend: shouldAppend)
            })
        }
    }
    
    func updateSearch(with receivers: [ContactReceiver], shouldAppend: Bool) {
        if searchResultHandler.searchState == .started {
            if receivers.count == 0 {
                dataRepository.clean()
                uiInitializer.hideTableView()
                tableView.reloadData()
            } else {
                if shouldAppend {
                    dataRepository.append(receivers)
                } else {
                    dataRepository.replace(with: receivers)
                }
                uiInitializer.showTableViewIFNeeded()
                tableView.reloadData()
            }
        }
    }
}

extension JuneSearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let isDescendant = touch.view?.isDescendant(of: tableView) else { return true }
        if isDescendant {
            return false
        }
        return true
    }
}

extension JuneSearchViewController: JuneSearchResultViewControllerDelegate {
    func closeController(_ searchController: JuneSearchResultViewController) {
        didCloseSearch?()
    }
}

