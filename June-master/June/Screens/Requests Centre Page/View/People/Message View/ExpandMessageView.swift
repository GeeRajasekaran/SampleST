//
//  ExpandMessageView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import Down

class ExpandMessageView: UIView {

    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let subjectFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private let toFont = UIFont.latoStyleAndSize(style: .regular, size: .regular)
    private let toSenderFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
    private let dateFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    
    private let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    private weak var messageInfo: MessageInfo?
    private var webViewLoadedHeight: CGFloat = 0
    private var shouldLoadWebView = true
    
    var onReplyButtonTapped: ((RightImageButton) -> Void)?
    var onCannedResponseButtonTapped: ((RightImageButton) -> Void)?
    
    //MARK: - subviewsbounds
    private var toLabel: UILabel?
    private var dateLabel: UILabel?
    private var messageWebView: UIWebView?
    private var attachmentsView: AttachmentsView?
    
    var messageLoaded: ((MessageInfo, CGFloat) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    
    private func loadMessage(text: String?) {
        if let unwrappedMessageText = text {
            if shouldLoadWebView {
                let down = Down(markdownString: unwrappedMessageText)
                do {
                    let html = try down.toHTML()
                    let testFont = "<font face='Lato' size='3' color='black'>"
                    let appendedHTML = testFont + html
                    messageWebView?.loadHTMLString(appendedHTML, baseURL: nil)
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    private func showAttachmentsIfNeeded() {
        guard let hasAttachments = messageInfo?.hasAttachments else { return }
        if hasAttachments {
            attachmentsView?.setupSubviews(for: messageInfo?.message?.entity, shouldDrawShadow: false)
            attachmentsView?.snp.updateConstraints { make in
                make.height.equalTo(attachmentsViewHeight)
            }
        }
    }
    
    //MARK: - Private part
    private func addToLabel() {
        if toLabel != nil { return  }
        let toLabelFrame = CGRect(x: 0.02 * screenWidth, y: 0.016 * screenWidth, width: 0.776 * screenWidth, height: 0.04 * screenWidth)
        toLabel = UILabel(frame: toLabelFrame)
        if toLabel != nil {
            addSubview(toLabel!)
        }
    }
    
    private func addDateLabel() {
        if dateLabel != nil { return }
        var topFrame: CGRect = .zero
        if let topViewFrame = toLabel?.frame {
            topFrame = topViewFrame
        }
        let dateLabelFrame = CGRect(x: topFrame.origin.x, y: topFrame.origin.y + topFrame.height + 0.008 * screenWidth, width: topFrame.width, height: topFrame.height)
        dateLabel = UILabel(frame: dateLabelFrame)
        dateLabel?.font = dateFont
        dateLabel?.textColor = UIColor.requestsDateColor
        if dateLabel != nil {
            addSubview(dateLabel!)
        }
    }
    
    private func addMessageWebView() {
        if messageWebView != nil {
            shouldLoadWebView = false
            addSubview(messageWebView!)
            return
        }
        shouldLoadWebView = true
        var topFrame: CGRect = .zero
        if let topViewFrame = dateLabel?.frame {
            topFrame = topViewFrame
        }
        let webViewFrame = CGRect(x: 0, y: topFrame.origin.y + topFrame.height + 0.024 * screenWidth, width: 0.776 * screenWidth, height: 1)
        messageWebView = UIWebView(frame: webViewFrame)
        messageWebView?.delegate = self
        messageWebView?.scrollView.isScrollEnabled = false
        messageWebView?.isOpaque = false
        messageWebView?.backgroundColor = .white
        
        if messageWebView != nil {
            addSubview(messageWebView!)
        }
    }
    
    private func addAttachmentsView() {
        if attachmentsView != nil { return }
        attachmentsView = AttachmentsView()
        attachmentsView?.onOpenAttachment = onOpenAttachment
        if attachmentsView != nil {
            addSubview(attachmentsView!)
            attachmentsView?.snp.makeConstraints { make in
                make.height.equalTo(0)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    //MARK: - attributted string
    private func addAttributedString(senderName: String?) {
        let toAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsEmailColor, NSAttributedStringKey.font: toFont]
        let senderAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsEmailColor, NSAttributedStringKey.font: toSenderFont]
        
        guard let sender = senderName else { return }
        let partOne = NSAttributedString(string: "to ", attributes: toAttribute)
        let partTwo = NSAttributedString(string: sender, attributes: senderAttribute)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        toLabel?.attributedText = combination
    }
}

extension ExpandMessageView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        if webView == messageWebView {
            let currentContentSize = webView.scrollView.contentSize
            webViewLoadedHeight = currentContentSize.height
            guard let info = messageInfo else { return }
            updateFrame()
            messageLoaded?(info, iMessageViewHeight)
            shouldLoadWebView = false
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            guard let url = request.url else { return true }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            return true
        }
    }
}

extension ExpandMessageView: IMessageView {
    var iMessageViewHeight: CGFloat {
        get {
            var totalHeight = 0.128 * screenWidth + webViewLoadedHeight
            if let hasAttachments = messageInfo?.hasAttachments {
                if hasAttachments {
                    totalHeight += attachmentsViewHeight
                }
            }
            return totalHeight
        }
    }
    
    // MARK: - Layout setup logic
    func setupSubviews() {
        snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        addToLabel()
        addDateLabel()
        addAttachmentsView()
        addMessageWebView()
        backgroundColor = .white
    }
    
    //MARK: - Data loading
    func loadData(info: MessageInfo) {
        self.messageInfo = info
        addAttributedString(senderName: info.toName)
        dateLabel?.text = info.date
        showAttachmentsIfNeeded()
        loadMessage(text: info.body)
        
    }
    
    func updateFrame() {
        snp.updateConstraints { make in
            make.height.equalTo(iMessageViewHeight)
        }
    }
}
