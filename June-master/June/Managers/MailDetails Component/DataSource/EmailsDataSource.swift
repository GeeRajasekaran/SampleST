//
//  EmailsDataSource.swift
//  June
//
//  Created by Ostap Holub on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class EmailsDataSource: NSObject {
    
    // MARK: - Variables & Constants
    
    private var emails = [SenderEmail]()
    
    // MARK: - Accessing methods
    
    var count: Int {
        get { return emails.count }
    }
    
    func email(at index: Int) -> SenderEmail? {
        if index >= 0 && index < emails.count {
            return emails[index]
        }
        return nil
    }
    
    func first() -> SenderEmail? {
        return emails.first
    }
    
    // MARK: - Loading logic
    
    func loadData() {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]] {
            accounts.forEach({ accountDictionary in
                if let email = accountDictionary["email_address"] as? String {
                    emails.append(SenderEmail(email: email, url: ""))
                }
            })
        }
    }
}

    // MARK: - UITableViewDataSource

extension EmailsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.reuseIdentifier(), for: indexPath) as! EmailTableViewCell
        cell.setupSubviews()
        
        if let email = email(at: indexPath.row) {
            cell.emailText = email.email
            cell.profileImage = email.profilePictureURL
        }
        return cell
    }
}
