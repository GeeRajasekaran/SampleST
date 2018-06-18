//
//  MessageBodyTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class MessageBodyTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var contentWebView: UIWebView?
    var indexPath: IndexPath?
    private var shouldLoadWebView = true
    
    var onWebViewLoaded: ((Int, CGFloat) -> Void)?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
    }
    
    // MARK: - Public view setup
    
    func setupSubviews(at index: IndexPath) {
        indexPath = index
        selectionStyle = .none
        backgroundColor = .white
        addContentWebView()
    }
    
    func load(model: MessageBodyInfo) {
        if let unwrappedBody = model.body {
            if shouldLoadWebView {
                contentWebView?.loadHTMLString(unwrappedBody, baseURL: nil)
            }
        }
    }
    
    // MARK: - Content web view setup
    
    private func addContentWebView() {
        if contentWebView != nil {
            shouldLoadWebView = false
            addSubview(contentWebView!)
            return
        }
        shouldLoadWebView = true
        contentWebView = UIWebView(frame: bounds)
        contentWebView?.backgroundColor = .clear
        contentWebView?.delegate = self
        contentWebView?.scrollView.isScrollEnabled = false
        contentWebView?.isHidden = true
        contentWebView?.scalesPageToFit = true
        if contentWebView != nil {
            addSubview(contentWebView!)
//            contentWebView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//            contentWebView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            contentWebView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            contentWebView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}

extension MessageBodyTableViewCell: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let webView = contentWebView, let unwrappedIndex = indexPath else { return }
        let currentContentSize = webView.scrollView.contentSize
        let viewSize = webView.frame
        
        let zoom = viewSize.width / currentContentSize.width
        let desiredSize = CGSize(width: screenWidth, height: currentContentSize.height * zoom)
        webView.frame = CGRect(origin: webView.frame.origin, size: desiredSize)
        
        onWebViewLoaded?(unwrappedIndex.section, desiredSize.height)
        webView.isHidden = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
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
