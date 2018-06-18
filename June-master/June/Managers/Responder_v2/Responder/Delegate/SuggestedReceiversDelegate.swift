//
//  SuggestedReceiversDelegate.swift
//  June
//
//  Created by Ostap Holub on 9/21/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class SuggestedReceiversDelegate: NSObject {
    
    // MARK: - Variables
    
    fileprivate weak var dataStorage: SuggestReceiversDataRepository?
    var onMoreContacts: (() -> Void)?
    
    // MARK: - Initialization
    
    init(storage: SuggestReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
}

extension SuggestedReceiversDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let receiver = dataStorage?.receiver(at: indexPath.row) {
            let userInfo: [AnyHashable: Any] = ["recipient": receiver]
            NotificationCenter.default.post(name: .onAddRecipient, object: nil, userInfo: userInfo)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let unwrappedSource = dataStorage else { return }
        if indexPath.item == unwrappedSource.count - 5 {
            onMoreContacts?()
        }
    }
}
