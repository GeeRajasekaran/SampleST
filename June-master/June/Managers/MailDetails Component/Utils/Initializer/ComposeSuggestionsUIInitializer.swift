//
//  ComposeSuggestionsUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeSuggestionsUIInitializer {
    
    // MARK: - Variables
    
    private unowned var parentViewController: ComposeSuggestionsViewController
    
    // MARK: - Initialization
    
    init(parentVC: ComposeSuggestionsViewController) {
        parentViewController = parentVC
    }
    
    // MARK: - Private part
    
    func initialize() {
        addTableView()
    }
    
    func showTableView() {
        guard let tableView = parentViewController.suggestionsTableView else { return }
        UIView.animate(withDuration: 0.3, animations: { [unowned tableView] in
            tableView.frame.origin.y = 0
            tableView.isHidden = false
        })
    }
    
    // MARK: - Table view creation
    
    private func addTableView() {
        let tableViewHeight: CGFloat = 0.344 * UIScreen.main.bounds.width
        let tableViewFrame = CGRect(x: 0, y: 0, width: parentViewController.view.frame.width, height: tableViewHeight)
        let tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.separatorStyle = .none
        
        tableView.register(ComposeSuggestionTableViewCell.self, forCellReuseIdentifier: ComposeSuggestionTableViewCell.reuseIdentifier())
        tableView.dataSource = parentViewController.dataSource
        tableView.delegate = parentViewController.delegate
        
        parentViewController.view.addSubview(tableView)
        parentViewController.suggestionsTableView = tableView
    }
}

