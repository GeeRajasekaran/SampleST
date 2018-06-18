//
//  EmailsDelegate.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class EmailsDelegate: NSObject {
    
    // MARK: - Variables & Constants
    
    private var onSelectAction: (Int) -> Void
    
    // MARK: - Inititalization
    
    init(action: @escaping (Int) -> Void) {
        onSelectAction = action
        super.init()
    }
}

// MARK: - UITableViewDelegate

extension EmailsDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectAction(indexPath.row)
    }
}
