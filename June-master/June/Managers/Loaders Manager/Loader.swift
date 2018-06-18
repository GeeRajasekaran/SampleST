//
//  Loader.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderConfig {
    var message: String
    var type: NVActivityIndicatorType
    var size: CGSize
    private var screenWidth = UIScreen.main.bounds.width
    
    init() {
        message = "Loading..."
        type = .ballPulse
        size = CGSize(width: screenWidth*0.08, height: screenWidth*0.08)
    }
}

class Loader: NSObject {
    
    private var rootViewController: UIViewController & NVActivityIndicatorViewable
    private var isTimeOutNeeded: Bool
    var config: LoaderConfig
    
    init(with controller: UIViewController & NVActivityIndicatorViewable, and config: LoaderConfig = LoaderConfig(), isTimeOutNeeded: Bool = true) {
        rootViewController = controller
        self.isTimeOutNeeded = isTimeOutNeeded
        self.config = config
        super.init()
    }
    
    func show() {
        startAnimation()
        if isTimeOutNeeded {
            perform(#selector(stopAnimation), with: nil, afterDelay: 5)
        }
    }
    
    // show loader is sometimes not appearing so i added this line - josh
    func showLoaderTempFix() {
        startAnimation()
    }
    
    func hide() {
        stopAnimation()
    }
    
    @objc private func startAnimation() {
        rootViewController.startAnimating(config.size, message: config.message, type: config.type)
    }
    
    @objc private func stopAnimation() {
        rootViewController.stopAnimating()
    }
}
