//
//  BaseMailDetailViewController.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/9/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class BaseMailDetailsViewController: UIViewController {

    // MARK: - Views
    var topHeaderView: ComposeHeaderView?
    var mailDetailsView: MailDetailsView?
    var textInputView: ComposeTextView?
    var actionsView: AccessoryActionsView?
    
    var baseViewWidth: CGFloat {
        get { return view.frame.width }
    }
    var emailTableViewController = EmailsTableViewController()
    var onHidePopup: (() -> Void)?
    
    lazy var receiversHandler: ReceiversHandler = { [unowned self] in
        let handler = ReceiversHandler(parentVC: self)
        handler.insertReceiver = insertReceiver
        handler.removeReceiver = removeReceiver
        handler.updatePlaceholder = updatePlaceholder
        return handler
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTableViewController.onSelect = onSelect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userEmail = UserInfoLoader.userPrimaryEmail {
            mailDetailsView?.set(SenderEmail(email: userEmail, url: ""))
        }
        receiversHandler.subscribeForToFieldNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        receiversHandler.unsubscribeForToFieldNotifications()
    }
    
    //MARK: - actions
    //MARK: - Close action
    lazy var onCloseAction: () -> Void = { [weak self] in
        self?.actionsView?.enableSendButton()
        self?.dismiss(animated: true, completion: nil)
        self?.onHidePopup?()
    }
    
    //MARK: - receiver remove/inser actions
    lazy var removeReceiver: (IndexPath) -> Void = { [weak self] indexPath in
        self?.mailDetailsView?.removeReceiver(at: indexPath)
    }
    
    lazy var insertReceiver: (IndexPath) -> Void = { [weak self] indexPath in
        self?.mailDetailsView?.insertReceiver(at: indexPath)
    }
    
    lazy var updatePlaceholder: (Int) -> Void = { [weak self] index in
        self?.mailDetailsView?.updatePlaceholder(at: index)
    }
    
    // MARK: - Receiver selection action
    
    lazy var onSelect: (SenderEmail) -> Void = { [weak self] sender in
        self?.mailDetailsView?.set(sender)
    }
    
    //MARK: - send action
    lazy var onSendAction: () -> Void = { [weak self] in
       
    }
}
