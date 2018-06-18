//
//  ContactsSuggestionViewController.swift
//  June
//
//  Created by Ostap Holub on 9/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReceiversSuggestionViewController: UIViewController, IContactsSuggestionsViewController {
    
    // MARK: - Views
    
    var suggestionsTableView: UITableView?
    
    // MARK: - Variables

    let dataStorage = SuggestReceiversDataRepository()
    weak var metadata: ResponderMetadata?
    private var previousQuery: String?
    
    lazy var searchEngine: SearchEngine = {
        let engine = SearchEngine()
        return engine
    }()
    
    lazy fileprivate var uiInitializer: SuggestionsUIInitializer = {
        let initializer = SuggestionsUIInitializer(parentVC: self)
        return initializer
    }()
    
    lazy var dataSource: SuggestedReceiversDataSource = {
        let source = SuggestedReceiversDataSource(storage: self.dataStorage)
        return source
    }()
    
    lazy var delegate: SuggestedReceiversDelegate = {
        let delegate = SuggestedReceiversDelegate(storage: self.dataStorage)
        delegate.onMoreContacts = self.onMoreContacts
        return delegate
    }()
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
    }
    
    // MARK: - Data loading and updating
    
    func updateData(with receivers: [EmailReceiver], append: Bool) {
        if receivers.count == 0 && dataStorage.count == 0 {
            clear()
            uiInitializer.hideTableView()
            return
        }
        if dataStorage.count == 0 {
            uiInitializer.showTableView()
        }
        
        if append {
            dataStorage.append(receivers)
        } else {
            dataStorage.replace(with: receivers)
        }
        suggestionsTableView?.reloadData()
    }
    
    // MARK: - Select action
    
    
    private lazy var onMoreContacts: () -> Void = { [weak self] in
        if let query = self?.previousQuery {
            self?.search(by: query)
        }
    }
    
    // MARK: - Searching logic
    
    func clear() {
        dataStorage.clear()
        suggestionsTableView?.reloadData()
    }
    
    func search(by query: String) {
        previousQuery = query
        searchEngine.search(by: query, completion: { [weak self] recipients, shouldAppend in
            self?.updateData(with: recipients, append: shouldAppend)
        })
    }
}
