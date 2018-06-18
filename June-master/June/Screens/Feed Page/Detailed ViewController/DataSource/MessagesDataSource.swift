//
//  MessagesDataSource.swift
//  June
//
//  Created by Ostap Holub on 9/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MessagesDataSource: NSObject {
    
    // MARK: - Varibles
    fileprivate weak var dataStorage: MessagesDataRepository?
    var onWebViewLoadedAction: ((Int, CGFloat) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    var onWebViewClicked: (() -> Void)?
    
    private var cashedWebViews: [Int: UIWebView]
    // MARK: - Initialization
    
    init(with storage: MessagesDataRepository?) {
        dataStorage = storage
        cashedWebViews = [:]
        super.init()
    }
    
    lazy fileprivate var onWebViewLoaded: (Message, UIWebView, CGFloat) -> Void = { [weak self] m, w, h in
        if let strongSelf = self, let index = strongSelf.dataStorage?.index(of: m) {
            strongSelf.onWebViewLoadedAction?(index, h)
            strongSelf.cashedWebViews[index] = w
        }
    }
}

    // MARK: - UITableViewDataSource

extension MessagesDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let messagesCount = dataStorage?.count {
            return messagesCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier(), for: indexPath) as! MessageTableViewCell
        
        if let message = dataStorage?.message(at: indexPath.section) {
            cell.onOpenAttachment = onOpenAttachment
            cell.onWebViewClicked = onWebViewClicked
            cell.setupSubview(for: message, in: cashedWebViews[indexPath.section])
            cell.load(message: message, completion: onWebViewLoaded)
        }
        return cell
    }
}
