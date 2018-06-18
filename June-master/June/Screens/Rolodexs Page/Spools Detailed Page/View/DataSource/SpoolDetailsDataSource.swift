//
//  SpoolDetailsDataSource.swift
//  June
//
//  Created by Ostap Holub on 4/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import WebKit

class SpoolDetailsDataSource: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var builder: SpoolDetailsScreenBuilder?
    var onWebViewLoaded: ((String, CGFloat, WKWebView) -> Void)?
    var onPaginateAction: (() -> Void)?
    
    private var webViewsCache: [String: WKWebView]
    
    // MARK: - Initialization
    
    init(builder: SpoolDetailsScreenBuilder?) {
        self.builder = builder
        webViewsCache = [String: WKWebView]()
    }
    
    func save(_ webView: WKWebView, for id: String) {
        webViewsCache[id] = webView
    }
}

extension SpoolDetailsDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = builder?.loadRows(withSection: SpoolDetailsSectionType.messages).count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rows = builder?.loadRows(withSection: SpoolDetailsSectionType.messages) as? [SpoolDetailsRowType] else {
            return UITableViewCell()
        }
        
        guard 0..<rows.count ~= indexPath.row else {
            return UITableViewCell()
        }
        let currentRow = rows[indexPath.row]
        guard let model = builder?.loadModel(for: SpoolDetailsSectionType.messages, rowType: currentRow, forPath: indexPath) else {
            return UITableViewCell()
        }
        
        switch currentRow {
        case .message:
            return messageCell(in: tableView, at: indexPath, with: model)
        case .showOlderMessages:
            return viewOlderMessagesCell(in: tableView, at: indexPath, with: model)
        }
    }
    
    private func messageCell(in tableView: UITableView, at indexPath: IndexPath, with model: BaseTableModel) -> UITableViewCell {
        guard let messageModel = model as? SpoolMessageInfo else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: SpoolMessageTableViewCell.reuseIdentifier(), for: indexPath) as! SpoolMessageTableViewCell
        if let id = messageModel.id {
            cell.setupSubviews(with: webViewsCache[id])
        } else {
            cell.setupSubviews(with: nil)
        }
        cell.onWebViewLoaded = onWebViewLoaded
        cell.load(messageModel)
        return cell
    }
    
    private func viewOlderMessagesCell(in tableView: UITableView, at indexPath: IndexPath, with model: BaseTableModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpoolOlderMessageTableViewCell.reuseIdentifier(), for: indexPath) as! SpoolOlderMessageTableViewCell
        cell.onViewOlderAction = onPaginateAction
        cell.setupSubviews()
        cell.load(model)
        return cell
    }
}
