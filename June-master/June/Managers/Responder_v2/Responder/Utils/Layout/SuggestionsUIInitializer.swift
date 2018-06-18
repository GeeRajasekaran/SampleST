//
//  SuggestionsUIInitializer.swift
//  June
//
//  Created by Ostap Holub on 9/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class SuggestionsUIInitializer {
    
    // MARK: - Variables
    
    private unowned var parentViewController: ReceiversSuggestionViewController
    
    // MARK: - Initialization
    
    init(parentVC: ReceiversSuggestionViewController) {
        parentViewController = parentVC
    }
    
    // MARK: - Private part
    
    func initialize() {
        addTableView()
    }
    
    private func addShadow(for state: ResponderState) {
        let offset: CGFloat = state == .regular ? -11 : 11
        parentViewController.view.clipsToBounds = false
        parentViewController.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        parentViewController.view.layer.shadowOpacity = 1
        parentViewController.view.layer.shadowOffset = CGSize(width: 0, height: offset)
        parentViewController.view.layer.shadowRadius = 9
    }
    
    func showTableView() {
        guard let tableView = parentViewController.suggestionsTableView else { return }
        UIView.animate(withDuration: 0.01, animations: { [unowned tableView] in
            tableView.frame.origin.y = 0
            tableView.isHidden = false
            self.parentViewController.view.backgroundColor = .white
            }, completion: { [weak self] _ in
                if let unwrappedMetadata = self?.parentViewController.metadata {
                    self?.addShadow(for: unwrappedMetadata.state)
                }
        })
    }
    
    func hideTableView() {
        guard let tableView = parentViewController.suggestionsTableView else { return }
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.layer.shadowOpacity = 0.0
    }
    
    // MARK: - Table view creation
    
    private func addTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.separatorStyle = .none
        
        tableView.register(SuggestedReceiverTableViewCell.self, forCellReuseIdentifier: SuggestedReceiverTableViewCell.reuseIdentifier())
        tableView.dataSource = parentViewController.dataSource
        tableView.delegate = parentViewController.delegate
        
        parentViewController.view.addSubview(tableView)
        parentViewController.suggestionsTableView = tableView
        
        tableView.snp.makeConstraints { [weak self] make in
            guard let view = self?.parentViewController.view else { return }
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}
