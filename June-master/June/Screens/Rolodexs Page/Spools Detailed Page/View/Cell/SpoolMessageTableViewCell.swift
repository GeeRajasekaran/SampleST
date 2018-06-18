//
//  SpoolMessageTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 4/4/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class SpoolMessageTableViewCell: UITableViewCell {
    
    // MARK: - Variables & constans
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var headerView: SpoolMessageHeaderView?
    private var webView: WKWebView?
    
    var onWebViewLoaded: ((String, CGFloat, WKWebView) -> Void)?
    var isWebViewLoaded: Bool = false
    
    private var currentMessageId: String?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerView?.removeFromSuperview()
        headerView = nil
        webView?.removeFromSuperview()
        webView = nil
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews(with view: WKWebView?) {
        clipsToBounds = true
        selectionStyle = .none
        backgroundColor = .white
        addHeaderView()
        if view == nil {
            isWebViewLoaded = false
            addWebView()
        } else {
            let x: CGFloat = 0.133 * screenWidth
            let rightInset: CGFloat = 0.048 * screenWidth
            self.webView = view
            if webView != nil {
                addSubview(webView!)
                webView?.snp.makeConstraints { [weak self] make in
                    guard let top = self?.headerView?.snp.bottom else { return }
                    make.leading.equalTo(x)
                    make.trailing.equalToSuperview().offset(-rightInset)
                    make.top.equalTo(top).offset(-5)
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
    
    // MARK: - Loading message model
    
    func load(_ model: SpoolMessageInfo) {
        currentMessageId = model.id
        headerView?.load(model)
        if isWebViewLoaded { return }
        if let htmlBody = model.body {
            webView?.loadHTMLString(htmlBody, baseURL: nil)
        }
    }
    
    // MARK: - Private header view setup
    
    private func addHeaderView() {
        guard headerView == nil else { return }
        
        headerView = SpoolMessageHeaderView()
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        headerView?.setupSubviews()
        
        if headerView != nil {
            addSubview(headerView!)
            headerView?.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(43)
            }
        }
    }
    
    // MARK: - Private web view setup
    
    private func addWebView() {
        guard webView == nil else { return }
        
        let x: CGFloat = 0.133 * screenWidth
        let rightInset: CGFloat = 0.048 * screenWidth
        webView = WKWebView()
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.navigationDelegate = self
        
        if webView != nil {
            addSubview(webView!)
            webView?.snp.makeConstraints { [weak self] make in
                guard let top = self?.headerView?.snp.bottom else { return }
                make.leading.equalTo(x)
                make.trailing.equalToSuperview().offset(-rightInset)
                make.top.equalTo(top).offset(-5)
                make.bottom.equalToSuperview()
            }
        }
    }
}

    // MARK: - WKNavigationDelegate

extension SpoolMessageTableViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if self.isWebViewLoaded { return }
            self.isWebViewLoaded = true
            guard let id = self.currentMessageId else { return }
            print(webView.scrollView.contentSize)
            let currentContentSize = webView.scrollView.contentSize
            let viewSize = webView.frame
            
            let zoom = viewSize.width / currentContentSize.width
            let desiredSize = CGSize(width: self.frame.width - 0.133 * self.screenWidth - 0.048 * self.screenWidth, height: currentContentSize.height * zoom)
            webView.frame = CGRect(origin: webView.frame.origin, size: desiredSize)
            
            self.onWebViewLoaded?(id, desiredSize.height, webView)
        })
    }
}
