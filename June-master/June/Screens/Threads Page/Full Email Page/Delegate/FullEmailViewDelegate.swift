//
//  FullEmailViewDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 10/3/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData


class FullEmailViewDelegate: NSObject {
    private unowned var parentVC: FullEmailViewController
    
    init(parentVC: FullEmailViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

extension FullEmailViewDelegate : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
}

extension FullEmailViewDelegate: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webViewResizeToContent(webView: webView)
    }
    
    func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()
        
        // Set to smallest rect value
        var frame:CGRect = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        var height:CGFloat = webView.scrollView.contentSize.height
        
        if height < 250 {
            height = 250
        }
        webView.frame.size.height = height
//        webView.heightAnchor.constraint(equalToConstant: height).isActive = true
        webView.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.parentVC.scrollView.snp.leading).offset(12)
            make.top.equalTo(self.parentVC.dateLabel.snp.bottom).offset(10)
            make.width.equalTo(0.85 * self.parentVC.view.frame.size.width)
            make.height.equalTo(height)
        }
        var contentRect = CGRect.zero
        for view in self.parentVC.scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.parentVC.scrollView.contentSize = contentRect.size
        
        // Set layout flag
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
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
