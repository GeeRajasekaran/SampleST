//
//  FeedDetailedDataSource.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedDetailedDataSource: NSObject {
    
    // MARK: - Variables & Constants
    
    private let numberOfSections: Int = 1
    private let numberOfRows: Int = 3
    private weak var builder: FeedDetailedScreenBuilder?
    
    var onWebViewLoadedAction: ((Int, CGFloat) -> Void)?
    
    // MARK: - Initialization
    
    init(builder: FeedDetailedScreenBuilder?) {
        self.builder = builder
    }
}

    // MARK: - UITableViewDataSource

extension FeedDetailedDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = builder?.rowType(at: indexPath) else { return UITableViewCell() }
        guard let info = builder?.loadModel(for: FeedDetailedRowType.header, rowType: rowType, forPath: indexPath) else { return UITableViewCell() }
        
        switch rowType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageHeaderTableViewCell.reuseIdentifier(), for: indexPath) as! MessageHeaderTableViewCell
            cell.setupSubviews()
            if let model = info as? MessageHeaderInfo {
                cell.load(model: model)
            }
            return cell
        case .subject:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageSubjectTableViewCell.reuseIdentifier(), for: indexPath) as! MessageSubjectTableViewCell
            cell.setupSubviews()
            if let model = info as? MessageSubjectInfo {
                cell.load(model: model)
            }
            return cell
        case .message:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageBodyTableViewCell.reuseIdentifier(), for: indexPath) as! MessageBodyTableViewCell
            cell.setupSubviews(at: indexPath)
            cell.onWebViewLoaded = onWebViewLoadedAction
            if let model = info as? MessageBodyInfo {
                cell.load(model: model)
            }
            return cell
        }
    }
}
