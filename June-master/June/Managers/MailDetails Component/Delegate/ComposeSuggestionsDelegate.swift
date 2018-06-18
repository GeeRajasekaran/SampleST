//
//  ComposeSuggestionsDelegate.swift
//  June
//
//  Created by Ostap Holub on 11/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ComposeSuggestionsDelegate: NSObject {
    
    // MARK: - Variables
    
    fileprivate weak var dataStorage: SuggestReceiversDataRepository?
    var onSelectAction: ((EmailReceiver) -> Void)?
    var onMoreContacts: (() -> Void)?
    
    // MARK: - Initialization
    
    init(storage: SuggestReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension ComposeSuggestionsDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (0.344 * UIScreen.main.bounds.width / 3)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let receiver = dataStorage?.receiver(at: indexPath.row) {
            onSelectAction?(receiver)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let unwrappedSource = dataStorage else { return }
        if indexPath.item == unwrappedSource.count - 5 {
            onMoreContacts?()
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ComposeSuggestionTableViewCell {
            cell.showSelection()
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ComposeSuggestionTableViewCell {
            cell.hideSelection()
        }
    }
}
