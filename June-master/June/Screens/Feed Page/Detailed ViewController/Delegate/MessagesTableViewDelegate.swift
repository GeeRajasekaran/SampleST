//
//  MessagesTableViewDelegate.swift
//  June
//
//  Created by Ostap Holub on 9/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MessagesTableViewDelegate: NSObject {
    
    // MARK: - Variables
    
    private let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    fileprivate weak var dataStorage: MessagesDataRepository?
    fileprivate var webViewHeighs: [Int: CGFloat]
    var onHideResponder: (() -> Void)?
    
    // MARK: - Initialization
    
    init(with storage: MessagesDataRepository?) {
        dataStorage = storage
        webViewHeighs = [:]
        super.init()
    }
    
    // MARK: - Accessors
    
    func put(_ height: CGFloat, at index: Int) {
        webViewHeighs[index] = height
    }
}

    // MARK: - UITableViewDelegate

extension MessagesTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return 0.176 * screenWidth
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MessageHeaderView()
        view.onHideResponder = onHideResponder
        view.setupSubview()
        if let message = dataStorage?.message(at: section) {
            view.loadMessage(message)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var rowHeight: CGFloat = 100
        if let height = webViewHeighs[indexPath.section] {
            rowHeight = height
        }
        
        if let message = dataStorage?.message(at: indexPath.section) {
            if message.hasAttachments == true {
                rowHeight += attachmentsViewHeight
            }
        }
        return rowHeight
    }
    
}
