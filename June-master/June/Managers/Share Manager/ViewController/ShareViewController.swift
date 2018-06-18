//
//  ShareViewController.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/8/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ShareViewController: BaseMailDetailsViewController {

    var baseView: UIScrollView = UIScrollView()
    var bottomView: ShareBottomView?
    
    var cardView: IFeedCardView?
    var message: Messages?
    
    let messageProxy = MessagesProxy()
    let shareEngine = ShareEngine()
    
    override var baseViewWidth: CGFloat {
        get { return baseView.frame.width }
    }

    //MARK: - initializer
    lazy var uiInitializer: ShareUIInitializer = { [unowned self] in
        let initializer = ShareUIInitializer(parentVC: self)
        return initializer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
    }
    
    override lazy var onSendAction: () -> Void = { [weak self] in
        guard let sSelf = self else { return }
        if let cardView = sSelf.cardView {
            if let threadId = sSelf.cardView?.itemInfo?.thread?.id {
                if let messageId = sSelf.messageProxy.fetchMessages(for: threadId).first?.id {
                    sSelf.sendAction(messageId)
                }
            }
        } else if let messageId = sSelf.message?.id {
            sSelf.sendAction(messageId)
        }
    }
    
    private func sendAction(_ messageId: String) {
        if let bodyText = textInputView?.text {
            let receivers = receiversHandler.receiversDataRepository.receivers
            actionsView?.disableSendButton()
            shareEngine.share(with: messageId, and: bodyText, for: receivers, completion: { [weak self]
                result in
                guard let sSelf = self else { return }
                sSelf.actionsView?.enableSendButton()
                switch result {
                case .Success (_):
                    sSelf.showSuccessAlertView()
                case .Error (_):
                    sSelf.handleErrorResponse()
                }
            })
        }
    }
    
    func showSuccessAlertView() {
       
        let sentView = UIImageView()
        sentView.image = #imageLiteral(resourceName: "no_internet_alert")
        if UIScreen.isPhoneX {
            sentView.frame = CGRect.init(x: 110, y: 667, width: 140, height: 50)
        } else if UIScreen.is6Or6S() {
            sentView.frame = CGRect.init(x: 110, y: 475, width: 140, height: 50)
        } else if UIScreen.is6PlusOr6SPlus() {
            sentView.frame = CGRect.init(x: 110, y: 540, width: 140, height: 50)
        }
        self.view.addSubview(sentView)
        
        let title = UILabel()
        title.frame = CGRect(x: 25, y: 13, width: 90, height: 22)
        title.text = "Message Sent"
        title.textAlignment = .center
        title.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        title.textColor = UIColor(hexString: "#FFFFFF")
        title.backgroundColor = .clear
        sentView.addSubview(title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.onCloseAction()
        }
    }
    
    //MARK: - requests handler
  
    private func handleErrorResponse() {
        showErrorAlertView()
    }
    
    private func showErrorAlertView() {
        let alert = UIAlertController(title: LocalizedStringKey.ShareHelper.ErrorTitle, message: LocalizedStringKey.ShareHelper.ErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: LocalizedStringKey.ShareHelper.OkTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension ShareViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.subviews.forEach { view in
            if let placeholderLabel = view as? UILabel {
                placeholderLabel.isHidden = !textView.text.isEmpty
            }
        }
    }
}
