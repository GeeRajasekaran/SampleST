//
//  ReplyView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import Down
import Alamofire

class ReplyView: UIView {
    // MARK: - Variables & constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let messageViewOffset = 0.048 * UIScreen.main.bounds.width
    private var webViewLoadedHeight: CGFloat = 0
    private let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    private let repliedFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    
    // MARK: - Subviews
    private var leftLineView: UIView?
    private var profileImageView: UIImageView?
    private var repliedLabel: UILabel?
    private var messageWebView: UIWebView?
    private var attachmentsView: AttachmentsView?
    
    private var messageInfo: MessageInfo?
    private var isWebViewLoaded = false
    
    var messageLoaded: ((MessageInfo, CGFloat) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    
    private func loadMessage(text: String?) {
        if let unwrappedMessageText = text {
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

    //MARK: - private part
    
    private func showAttachmentsIfNeeded() {
        guard let hasAttachments = messageInfo?.hasAttachments else { return }
        if hasAttachments {
            attachmentsView?.setupSubviews(for: messageInfo?.message?.entity, shouldDrawShadow: false)
            attachmentsView?.snp.updateConstraints { make in
                make.height.equalTo(attachmentsViewHeight)
            }
        }
    }
    
    //MARK: - setup views
    private func addLeftLineView() {
        if leftLineView != nil { return }
        let frame = CGRect(x: 0, y: messageViewOffset/2, width: 0.008 * screenWidth, height: iMessageViewHeight - messageViewOffset)
        leftLineView = UIView(frame: frame)
        leftLineView?.backgroundColor = UIColor.searchBarTintColor
        leftLineView?.layer.cornerRadius = 0.004 * screenWidth
        if leftLineView != nil {
            addSubview(leftLineView!)
        }
    }
    
    private func addProfileImageView() {
        if profileImageView != nil { return }
        profileImageView = UIImageView()
        profileImageView?.frame.origin = CGPoint(x: 0.04 * screenWidth, y: messageViewOffset/2)
        profileImageView?.frame.size = CGSize(width: 0.072 * screenWidth, height: 0.072 * screenWidth)
        profileImageView?.layer.borderWidth = 1
        profileImageView?.layer.borderColor = UIColor.requestsBorderColor.cgColor
        profileImageView?.layer.cornerRadius = 0.072 * screenWidth/2
        profileImageView?.contentMode = .scaleAspectFit
        profileImageView?.image = UIImage(named: LocalizedImageNameKey.HomeViewHelper.MenuButtonBackgroundImageName)
        if profileImageView != nil {
            addSubview(profileImageView!)
        }
    }
    
    private func addRepliedLabel() {
        if repliedLabel != nil { return }
        var leftFrame: CGRect = .zero
        if let imageViewFrame = profileImageView?.frame {
            leftFrame = imageViewFrame
        }
        repliedLabel = UILabel(frame: CGRect(x: leftFrame.origin.x + leftFrame.width + 0.024 * screenWidth, y: leftFrame.origin.y, width: 0.24 * screenWidth, height: leftFrame.height))
        repliedLabel?.font = repliedFont
        repliedLabel?.textColor = UIColor.requestsSubjectColor
        repliedLabel?.textAlignment = .left
        if repliedLabel != nil {
            addSubview(repliedLabel!)
        }
    }
    
    private func addMessageWebView() {
        if messageWebView != nil { return }
        var topView: CGRect = .zero
        if let imageViewFrame = profileImageView?.frame {
            topView = imageViewFrame
        }
        messageWebView = UIWebView()
        messageWebView?.frame.origin = CGPoint(x: messageViewOffset + 0.008 * screenWidth, y: topView.origin.y + topView.height + messageViewOffset/2)
        messageWebView?.frame.size = CGSize(width: 0.696 * screenWidth, height: 1)
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
                guard let left = leftLineView else { return }
                make.height.equalTo(0)
                make.bottom.equalToSuperview()
                make.leading.equalTo(left.snp.trailing).offset(messageViewOffset)
                make.trailing.equalToSuperview()
            }
        }
    }
}

extension ReplyView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        if webView == messageWebView {
            let currentContentSize = webView.scrollView.contentSize
            webViewLoadedHeight = currentContentSize.height
            guard let info = messageInfo else { return }
            messageLoaded?(info, iMessageViewHeight)
            updateFrame()
            isWebViewLoaded = true
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

extension ReplyView: IMessageView {
    open var iMessageViewHeight: CGFloat {
        get {
            var totalHeight = 0.12 * screenWidth + webViewLoadedHeight
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
        
        addLeftLineView()
        addProfileImageView()
        addRepliedLabel()
        addAttachmentsView()
        addMessageWebView()
    }
    
    func loadData(info: MessageInfo) {
        self.messageInfo = info
        repliedLabel?.text = "You replied..."
        if let url = UserInfoLoader.profileImageURL {
            profileImageView?.hnk_setImageFromURL(url)
        }
        if isWebViewLoaded == false {
            loadMessage(text: info.body)
        }
        showAttachmentsIfNeeded()
    }
    
    func updateFrame() {
        leftLineView?.frame.size.height = iMessageViewHeight - messageViewOffset
        snp.updateConstraints { make in
            make.height.equalTo(iMessageViewHeight)
        }
    }
}
