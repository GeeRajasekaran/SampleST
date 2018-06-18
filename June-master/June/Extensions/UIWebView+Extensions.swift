//
//  UIWebView+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 9/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

extension UIWebView {
    ///Method to fit content of webview inside webview according to different screen size
    func resizeWebContent() {
        let contentSize = self.scrollView.contentSize
        let viewSize = self.bounds.size
        let zoomScale = viewSize.width/contentSize.width
        self.scrollView.minimumZoomScale = zoomScale
        self.scrollView.maximumZoomScale = zoomScale
        self.scrollView.zoomScale = zoomScale
    }
}
