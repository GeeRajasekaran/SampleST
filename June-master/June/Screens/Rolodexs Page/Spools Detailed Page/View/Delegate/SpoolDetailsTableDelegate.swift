//
//  SpoolDetailsTableDelegate.swift
//  June
//
//  Created by Ostap Holub on 4/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolDetailsTableDelegate: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var builder: SpoolDetailsScreenBuilder?
    private let viewOlderMessageHeight: CGFloat = 50.0
    
    private var webViewHeights: [String: CGFloat]
    var onCollapse: (() -> Void)?
    
    // MARK: - Initialization
    
    init(builder: SpoolDetailsScreenBuilder?) {
        self.builder = builder
        webViewHeights = [String: CGFloat]()
    }
    
    func save(height: CGFloat, for messageId: String) {
        webViewHeights[messageId] = height
    }
}

extension SpoolDetailsTableDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rows = builder?.loadRows(withSection: SpoolDetailsSectionType.messages) as? [SpoolDetailsRowType] else {
            return 0
        }
        guard 0..<rows.count ~= indexPath.row else {
            return 0
        }
        
        let currentRow: SpoolDetailsRowType = rows[indexPath.row]
        switch currentRow {
        case .message:
            return messageHeight(at: indexPath, and: currentRow)
        case .showOlderMessages:
            return viewOlderMessageHeight
        }
    }
    
    private func messageHeight(at indexPath: IndexPath, and rowType: SpoolDetailsRowType) -> CGFloat {
        guard let model = builder?.loadModel(for: SpoolDetailsSectionType.messages, rowType: rowType, forPath: indexPath) as? SpoolMessageInfo else { return 200 }
        guard let id = model.id else { return 200 }
        if let webViewHeight = webViewHeights[id] {
            return webViewHeight + 43
        } else {
            return 200
        }
    }
}
