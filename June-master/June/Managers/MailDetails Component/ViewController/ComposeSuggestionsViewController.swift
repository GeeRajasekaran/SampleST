//
//  ComposeSuggestionsViewController.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeSuggestionsViewController: UIViewController {
    
    // MARK: - Views
    
    var suggestionsTableView: UITableView?
    private var previousQuery: String?
    
    lazy var searchEngine: SearchEngine = {
        let engine = SearchEngine()
        return engine
    }()
    
    // MARK: - Variables
    
    let dataStorage = SuggestReceiversDataRepository()
    
    lazy fileprivate var uiInitializer: ComposeSuggestionsUIInitializer = { [unowned self] in
        let initializer = ComposeSuggestionsUIInitializer(parentVC: self)
        return initializer
    }()
    
    lazy var dataSource: ComposeSuggestionsDataSource = { [unowned self] in
        let source = ComposeSuggestionsDataSource(storage: self.dataStorage)
        return source
    }()
    
    lazy var delegate: ComposeSuggestionsDelegate = { [unowned self] in
        let delegate = ComposeSuggestionsDelegate(storage: self.dataStorage)
        delegate.onSelectAction = self.onSelectAction
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
    
    var onSelectAction: ((EmailReceiver) -> Void)?
    
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
