//
//  MessageTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 9/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    fileprivate let screenWidth = UIScreen.main.bounds.width
    private let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    private var contentWebView: UIWebView?
    private var attachmentsView: AttachmentsView?
    private var gradientView: GradientView?
    
    private var onWebViewDidFinishLoading: ((Message, UIWebView, CGFloat) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    var onWebViewClicked: (() -> Void)?
    fileprivate weak var currentMessage: Message?
    
    private var shouldLoadWebView = true
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentWebView?.removeFromSuperview()
        attachmentsView?.removeFromSuperview()
        gradientView?.removeFromSuperview()
        
        attachmentsView = nil
        gradientView = nil
    }
    
    // MARK: - Subviews setup
    
    func setupSubview(for message: Message, in webView: UIWebView?) {
        contentWebView = webView
        addContentWebView(for: message)
        addBottomAttachmentsView(with: message)
    }
    
    // MARK: - Data loading
    
    func load(message: Message, completion: @escaping (Message, UIWebView, CGFloat) -> Void) {
        if let body = message.htmlBody {
            onWebViewDidFinishLoading = completion
            currentMessage = message
            load(html: body)
        }
    }
    
    private func load(html bodyHtml: String) {
        if shouldLoadWebView == false { return }
        contentWebView?.loadHTMLString(bodyHtml, baseURL: nil)
    }
    
    // MARK: - Private initialization part
    
    private func addContentWebView(for message: Message) {
        if contentWebView != nil {
            shouldLoadWebView = false
            addGradientShadowView(to: contentWebView!)
            addSubview(contentWebView!)
            return
        }
        shouldLoadWebView = true
        var webViewFrame: CGRect = .zero
        if message.hasAttachments == true {
            webViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - attachmentsViewHeight)
        } else {
            webViewFrame = bounds
        }
        contentWebView = UIWebView(frame: webViewFrame)
        contentWebView?.backgroundColor = .clear
        contentWebView?.delegate = self
        contentWebView?.scrollView.isScrollEnabled = false
        contentWebView?.isHidden = true
        contentWebView?.scalesPageToFit = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(webViewTapped(_:)))
        tapGesture.delegate = self
        contentWebView?.addGestureRecognizer(tapGesture)
        if contentWebView != nil {
            addGradientShadowView(to: contentWebView!)
            addSubview(contentWebView!)
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func webViewTapped(_ sender: UITapGestureRecognizer) {
        onWebViewClicked?()
    }
    
    private func addBottomAttachmentsView(with message: Message) {
        if attachmentsView != nil { return }
        let attachmentsViewFrame = CGRect(x: 0, y: bounds.height - attachmentsViewHeight, width: screenWidth, height: attachmentsViewHeight)
        
        attachmentsView = AttachmentsView(frame: attachmentsViewFrame)
        attachmentsView?.onOpenAttachment = onOpenAttachment
        attachmentsView?.setupSubviews(for: message.entity)
        
        if attachmentsView != nil {
            addSubview(attachmentsView!)
        }
    }
    
    private func addGradientShadowView(to view: UIView) {
        if gradientView != nil { return }
        let viewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 7)
        
        gradientView = GradientView(frame: viewFrame)
        gradientView?.drawVerticalGradient(with: UIColor.bottomShadowColor)
        
        if gradientView != nil {
            view.addSubview(gradientView!)
        }
    }
}

extension MessageTableViewCell: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let unwrappedMessage = currentMessage {
            guard let webView = contentWebView else { return }
            let currentContentSize = webView.scrollView.contentSize
            let viewSize = webView.frame

            let zoom = viewSize.width / currentContentSize.width
            let desiredSize = CGSize(width: screenWidth, height: currentContentSize.height * zoom)
            webView.frame = CGRect(origin: webView.frame.origin, size: desiredSize)
            
            onWebViewDidFinishLoading?(unwrappedMessage, webView, desiredSize.height)
            webView.isHidden = false
            attachmentsView?.frame.origin.y = webView.frame.height
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            return true
        }
    }
}
