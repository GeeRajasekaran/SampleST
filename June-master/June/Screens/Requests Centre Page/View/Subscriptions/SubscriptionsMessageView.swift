//
//  SubscriptionsMessageView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SubscriptionsMessageView: UIView {

    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let subjectFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private let toFont = UIFont.latoStyleAndSize(style: .regular, size: .regular)
    private let toSenderFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
    private let dateFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    
    private let messageDetailLeftOffset = 0.032 * UIScreen.main.bounds.width
    private let leftOffset = 0.056 * UIScreen.main.bounds.width
    
    private weak var info: MessageInfo?
    private var webViewLoadedHeight: CGFloat = 0
    
    private var shouldLoadWebView = true
    
    var onWebViewLoadedAction: ((CGFloat) -> Void)?
    
    var messagesHeight: CGFloat {
        get {
            return 0.208 * screenWidth + webViewLoadedHeight
        }
    }
    
    //MARK: - subviewsbounds
    private var subjectLabel: UILabel?
    private var toLabel: UILabel?
    private var dateLabel: UILabel?
    private var topSeparatorView: UIView?
    private var bottomSeparatorView: UIView?
    private var messageWebView: UIWebView?
    private var indicatorView: UIActivityIndicatorView?
    
    // MARK: - Layout setup logic
    func setupSubviews() {
        addTopSeperatorView()
        addSubjectLabel()
        addToLabel()
        addDateLabel()
        addBottomSeperatorView()
        addMessageWebView()
    }
    
    //MARK: - Data loading
    func loadData(info: MessageInfo) {
        self.info = info
        addAttributedString(subject: info.subject)
        addAttributedString(senderName: info.toEmail)
        dateLabel?.text = info.date
    }
    
    func expandContent() {
        isHidden = false
        loadMessage(text: info?.body)
    }
    
    func collapseContent() {
        isHidden = true
        stopSpinner()
    }
    
    private func loadMessage(text: String?) {
        if let unwrappedMessageText = text {
            if shouldLoadWebView {
                startSpinner()
                messageWebView?.loadHTMLString(unwrappedMessageText, baseURL: nil)
            }
        }
    }
    
    //MARK: - Private part
    private func addSubjectLabel() {
        if subjectLabel != nil { return }
        subjectLabel = UILabel()
        if subjectLabel != nil {
            addSubview(subjectLabel!)
            subjectLabel?.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0.04 * screenWidth)
                make.height.equalTo(0.056 * screenWidth)
                make.leading.equalToSuperview().offset(leftOffset)
                make.trailing.equalToSuperview().offset(-0.02 * screenWidth)
            }
        }
    }
    
    private func addToLabel() {
        if toLabel != nil { return  }
        toLabel = UILabel()
        if toLabel != nil {
            addSubview(toLabel!)
            toLabel?.snp.makeConstraints { make in
                guard let top = subjectLabel else { return }
                make.top.equalTo(top.snp.bottom)
                make.height.equalTo(0.04 * screenWidth)
                make.trailing.equalToSuperview().offset(-0.02 * screenWidth)
                make.leading.equalToSuperview().offset(leftOffset + messageDetailLeftOffset)
                
            }
        }
    }
    
    private func addDateLabel() {
        if dateLabel != nil { return }
        dateLabel = UILabel()
        dateLabel?.font = dateFont
        dateLabel?.textColor = UIColor.requestsDateColor
        if dateLabel != nil {
            addSubview(dateLabel!)
            dateLabel?.snp.makeConstraints { make in
                guard let top = toLabel else { return }
                make.top.equalTo(top.snp.bottom)
                make.height.equalTo(0.04 * screenWidth)
                make.trailing.equalToSuperview().offset(0.02 * screenWidth)
                make.leading.equalToSuperview().offset(leftOffset + messageDetailLeftOffset)
            }
        }
    }
    
    private func addTopSeperatorView() {
        if topSeparatorView != nil { return }
        topSeparatorView = UIView()
        topSeparatorView?.backgroundColor = UIColor.separatorGrayColor
        if topSeparatorView != nil {
            addSubview(topSeparatorView!)
            topSeparatorView?.snp.makeConstraints { make in
                make.height.equalTo(0.002 * screenWidth)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
            }
        }
    }
    
    private func addBottomSeperatorView() {
        if bottomSeparatorView != nil { return }
        bottomSeparatorView = UIView()
        bottomSeparatorView?.backgroundColor = UIColor.separatorGrayColor
        if bottomSeparatorView != nil {
            addSubview(bottomSeparatorView!)
            bottomSeparatorView?.snp.makeConstraints { make in
                make.height.equalTo(0.002 * screenWidth)
                make.top.equalToSuperview().offset(0.03 * screenWidth)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    private func addMessageWebView() {
        if messageWebView != nil {
            shouldLoadWebView = false
            addSubview(messageWebView!)
            return
        }
        shouldLoadWebView = true
        messageWebView = UIWebView()
        messageWebView?.frame.size.width = screenWidth
        messageWebView?.delegate = self
        messageWebView?.scrollView.isScrollEnabled = false
        messageWebView?.isOpaque = false
        messageWebView?.backgroundColor = .clear
        if messageWebView != nil {
            addSubview(messageWebView!)
            messageWebView?.snp.makeConstraints { make in
                guard let top = dateLabel else { return }
                make.top.equalTo(top.snp.bottom).offset(0.032 * screenWidth)
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
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
    
    private func addAttributedString(subject: String?) {
        guard let unwrappedSubject = subject else { return }
        let dotAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsDotColor, NSAttributedStringKey.font: subjectFont]
        let subjectAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsSubjectColor, NSAttributedStringKey.font: subjectFont]
        let dotString = "• "
        let partOne = NSAttributedString(string: dotString, attributes: dotAttribute)
        let partTwo = NSAttributedString(string: unwrappedSubject, attributes: subjectAttribute)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        subjectLabel?.attributedText = combination
    }
    
    //MARK: - spinner
    private func startSpinner() {
        if indicatorView != nil {
            indicatorView?.startAnimating()
            return
        }
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        if let indicatorFrame = indicatorView?.frame {
            indicatorView?.frame.origin = CGPoint(x: frame.width - 2 * indicatorFrame.width, y: frame.height/2 - indicatorFrame.height/2 + 5)
        }
        indicatorView?.startAnimating()
        if indicatorView != nil {
            addSubview(indicatorView!)
        }
    }
    
    private func stopSpinner() {
        indicatorView?.stopAnimating()
    }
}

extension SubscriptionsMessageView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        guard let webView = messageWebView else { return }
        let currentContentSize = webView.scrollView.contentSize
        webViewLoadedHeight = currentContentSize.height
        shouldLoadWebView = false
        stopSpinner()
        onWebViewLoadedAction?(messagesHeight)
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
