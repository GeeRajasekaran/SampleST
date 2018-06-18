//
//  EmailLinkFlow.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SafariServices
import NVActivityIndicatorView
import AlertBar

class LinkEmailHandler {
    
    private var emailLinker: EmailLinker?
    private var safariVC: SFSafariViewController?
    private unowned var parentVC: UIViewController
    
    var oAuthCode: String?
    
    private let dataProvider = EmailLinkerDataProvider()
    private var isReauthenticate = false
    
    var onSuccessLinkEmail: (() -> Void)?
    var onErrorLinkEmail: (() -> Void)?
    
    lazy var loader: Loader = {
        let loader = Loader(with: parentVC as! UIViewController & NVActivityIndicatorViewable, isTimeOutNeeded: false)
        loader.config.type = NVActivityIndicatorType(rawValue: 0)!
        return loader
    }()
    
    init(with parentVC: UIViewController) {
        self.parentVC = parentVC
    }
    
    lazy var onPasswordAction: ((String) -> Void) = { [weak self] password in
        self?.linkEmail(with: password)
    }
    
    //MARK: - public methods for link email
    func reauthenticate(_ account: Account) {
        isReauthenticate = true
        loader.config.message = "Checking Email..."
        loader.show()
        dataProvider.reauthenticate(account.email) { (result) in
            self.loader.hide()
            switch result {
            case .Success(let linker):
                self.openAccounts(linker)
            case .Error( _):
                self.showErrorAlert("Something went wrong")
            }
        }
    }
    
    func discoverEmail(_ email: String) {
        isReauthenticate = false
        loader.config.message = "Checking Email..."
        loader.show()
        
        dataProvider.discoverEmail(with: email) { result in
            self.loader.hide()
            switch result {
            case .Success(let emailLinker):
                self.openAccounts(emailLinker)
            case .Error( _):
               self.onErrorLinkEmail?()
            }
        }
    }
    
    private func openAccounts(_ emailLinker: EmailLinker) {
        self.emailLinker = emailLinker
        if !emailLinker.isGeneric() {
            self.showGoogleOAuth(with: emailLinker.authorizationUrl)
        } else {
            self.goToAddAccountPage()
        }
    }
    
    private func showGoogleOAuth(with url: String) {
        if let authURL = URL(string: url) {
            self.safariVC = SFSafariViewController(url: authURL, entersReaderIfAvailable: true)
            parentVC.present(self.safariVC!, animated: true)
        }
    }
    
    private func goToAddAccountPage() {
        let addAccountPage = AddAccountViewController()
        addAccountPage.onPasswordAction = onPasswordAction
        addAccountPage.isReauthenticate = isReauthenticate
        parentVC.present(addAccountPage, animated: true, completion: nil)
    }
    
    private func linkEmail(with password: String? = nil) {
        guard let text = emailLinker?.email, let linker = emailLinker else { return }
        loader.config.message = loaderMessage()
        loader.show()
        dataProvider.linkEmail(with: text, dataOfLinkEmail: linker, code: self.oAuthCode, and: password) { result in
            self.loader.hide()
            switch result {
            case .Success(let response):
                print(response)
                if response.isSuccess {
                    let accountIDData = KeyChainManager.stringToNSDATA(string: response.accountId)
                    _ = KeyChainManager.save(key: JuneConstants.KeychainKey.accountID, data: accountIDData)
                    self.onSuccessLinkEmail?()
                } else {
                    self.showErrorAlert("Failed to connect email. Please try again.")
                }
            case .Error( _):
//                self.showErrorAlert("Failed to connect email. Please try again.")
                self.onErrorLinkEmail?()
            }
        }
    }
    
    //MARK: - method that called after oAuth login finished, link email method called
    @objc func safariLogin(notification: NSNotification) {
        // get the url form the auth callback
        let url = notification.object as! NSURL
        let urlString = url.absoluteString
        if !((urlString?.isEmpty)!) && (urlString?.count)! > 13 {
            let subString = urlString?.subString(13)  // playground
            if !(subString?.isEmpty)! {
                self.oAuthCode = subString
                self.linkEmail()
            } else {
                self.showErrorAlert("Failed to authenticate email. Please try again.")
            }
        } else {
            self.showErrorAlert("Failed to authenticate email. Please try again.")
        }
        
        // then do whatever you like, for example :
        // get the code (token) from the URL
        // and do a request to get the information you need (id, name, ...)
        // Finally dismiss the Safari View Controller with:
        guard let unwrappedSafariVC = safariVC else { return }
        unwrappedSafariVC.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - error
    private func showErrorAlert(_ message: String) {
        AlertBar.show(.error, message: message)
    }
    
    //MARKL - set loader message
    private func loaderMessage() -> String {
        if isReauthenticate {
            return "Reauthenticate..."
        } else {
            return "Linking Email..."
        }
    }
    
    //MARK: - subscribe and unsubscribe from notifications
    func unsubscribeForLinkNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribeForLinkNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.safariLogin(notification:)), name: NSNotification.Name(rawValue: kCloseSafariViewControllerNotification), object: nil)
    }
}
