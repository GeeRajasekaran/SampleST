//
//  SpinnerProvider.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/24/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

import UIKit

struct SpinnerPadding {
    static let Left: CGFloat = 20.0
    static let Right: CGFloat = 20.0
}

struct SpinnerConstants {
    static let Alpha: CGFloat = 0.6
    static let CornerRadius: CGFloat = 5
}

class SpinnerProvider: NSObject {
    private var shouldShowSpinner: Bool = true
    private var spinner : UIActivityIndicatorView!
    private var spinnerBackgroundView : UIView!
    
    override init() {
        super.init()
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    }
    
    func startSpinner() {
        shouldShowSpinner = true
        perform(#selector(startSpinnerAnimation), with: nil, afterDelay: 0.7)
    }
    
    func stopSpinner() {
        shouldShowSpinner = false
        stopSpinnerAnimation()
    }
    
    @objc fileprivate func startSpinnerAnimation() {
        if shouldShowSpinner {
            if !spinner.isAnimating {
                spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                let window = UIApplication.shared.keyWindow
                spinnerBackgroundView = UIView()
                spinnerBackgroundView.frame.size = CGSize(width: spinner!.frame.size.width + SpinnerPadding.Left, height: spinner!.frame.size.height + SpinnerPadding.Right)
                spinnerBackgroundView.center = CGPoint(x: window!.frame.size.width/2, y: window!.frame.size.height/2)
                spinner.center = CGPoint(x: spinnerBackgroundView!.frame.size.width/2, y: spinnerBackgroundView!.frame.size.height/2)
                spinnerBackgroundView.layer.cornerRadius = SpinnerConstants.CornerRadius
                spinnerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(SpinnerConstants.Alpha)
                
                spinnerBackgroundView.addSubview(spinner)
                window?.addSubview(spinnerBackgroundView)
                spinner.startAnimating()
            }
        }
    }
    
    fileprivate func stopSpinnerAnimation() {
        if spinner.isAnimating {
            spinner.stopAnimating()
            spinnerBackgroundView.removeFromSuperview()
        }
    }
    
}

