//
//  CustomTableViewController.swift
//  Romio
//
//  Created by Romaine Hinds on 11/7/17.
//  Copyright © 2017 HomePeople Corporation. All rights reserved.
//

import UIKit
import SnapKit

class CustomTableViewController: UITableViewController {
    
    let customNavBarHeight: CGFloat = 64.0
    let statusBarHeight: CGFloat = 20
    
    var navigationBar = CustomNavigationBar()
    
    let seperator = UIView()
    
    var navigationRect: CGRect {
        get {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            return CGRect(x: 0, y: self.navrBarHeight, width: UIScreen.size.width, height: UIScreen.size.height - self.navrBarHeight - statusBarHeight)
        }
    }
    
    // Activity Indicator
    var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    let seperatorHeight: CGFloat = 1.0
    var navrBarHeight: CGFloat {
        get {
            return seperatorHeight + customNavBarHeight
        }
    }
    var tabBarHeight: CGFloat = 49.0
    
    // Animation Constants
    let duration: TimeInterval = 1.0
    let delay: TimeInterval = 0.4
    let damping: CGFloat = 0.6
    let velocity: CGFloat = 6
    
//    // Alert View
//    var ribbonAlertView: RibbonAlertView?
//    var ribbonAlertIsShowing: Bool {
//        get {
//            if let rView = self.ribbonAlertView {
//                return rView.isDescendant(of: self.view)
//            }
//            return false
//        }
//    }
//    var alertTimer: Timer?
//    let ribbonAlertHeightTopOffset : CGFloat = 20.0
//    var presentationStyle: RibbonAlertPresentationType = .withNavBar
    
    // Progress View
    var progressView: NavigationProgressView = NavigationProgressView(frame: CGRect.zero)
    var showProgressView: Bool = false {
        didSet {
            if showProgressView {
                setupProgressView()
            } else {
                progressView.removeFromSuperview()
            }
            progressView.isHidden = !showProgressView
        }
    }
    
    // Error Message
//    let fieldErrorMessage = Localized.string(forKey: .GlobalIncompleteFieldsError)
    
    // Bottom Navigation Bar
//    let bottomBar: BottomBar = BottomBar(frame: CGRect(x: 0, y: UIScreen.size.height - BottomBar.viewHeight(), width: UIScreen.size.width, height: BottomBar.viewHeight()))
//    var bottomBarHeight: CGFloat {
//        return BottomBar.viewHeight()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        showProgressView = false
    }
    
    internal func setupNavBar() {
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: customNavBarHeight)
        view.addSubview(navigationBar)
        
        seperator.backgroundColor = .romioGray
        seperator.frame = CGRect(x: 0, y: navigationBar.frame.height, width: view.frame.width, height: seperatorHeight)
        view.addSubview(seperator)
    }
    
    func setupSeperator(withColor color: UIColor) {
        seperator.backgroundColor = color
    }
    
//    func setupBottomBar() {
//        bottomBar.removeFromSuperview()
//        view.addSubview(bottomBar)
//    }
//    
//    func hideBottomBar() {
//        bottomBar.removeFromSuperview()
//    }
    
    func setupActivityIndicator() {
        spinnerView.hidesWhenStopped = true;
        spinnerView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        spinnerView.center = view.center;
        view.addSubview(spinnerView)
        spinnerView.isHidden = true
    }
    
    func hideNavBar() {
        seperator.isHidden = true
        navigationBar.isHidden = true
    }
    
    func showNavBar() {
        seperator.isHidden = false
        navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK:- Spinner View
    
    func dismissSpinner() {
        DispatchQueue.main.async(execute: { [weak self]() -> Void in
            if let strongSelf = self {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                strongSelf.spinnerView.stopAnimating()
                strongSelf.spinnerView.removeFromSuperview()
            }
        })
    }
    
    func showSpinnerWithDelay(_ delayTime : DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self]() -> Void in
            if let strongSelf = self {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                strongSelf.spinnerView.removeFromSuperview();
                strongSelf.spinnerView.activityIndicatorViewStyle = .gray
                strongSelf.spinnerView.center = strongSelf.view.center
                strongSelf.spinnerView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                strongSelf.spinnerView.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
                strongSelf.view.addSubview(strongSelf.spinnerView)
                strongSelf.view.bringSubview(toFront: strongSelf.spinnerView)
                strongSelf.spinnerView.startAnimating()
            }
        }
    }
    
//    // MARK:- Alert View
//
//    @discardableResult
//    func showAlertView(ofType type: RibbonAlertType, presentationStyle: RibbonAlertPresentationType, message: NSAttributedString) -> RibbonAlertView? {
//        if !ribbonAlertIsShowing {
//            let yOffset: CGFloat = presentationStyle == .withoutNavBar ? 0 : -RibbonAlertView.ribbonHeight(text: message.string)
//            let ribbonAlertViewFrame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: RibbonAlertView.ribbonHeight(text: message.string))
//            ribbonAlertView = RibbonAlertView(frame: ribbonAlertViewFrame, alertType: type, attributedText: message)
//            ribbonAlertView?.alpha = 0
//
//            switch presentationStyle {
//            case .withNavBar:
//                if let ribbonAlertView = ribbonAlertView {
//                    view.insertSubview(ribbonAlertView, belowSubview: navigationBar)
//                }
//                ribbonAlertView?.alpha = 1
//                view.setNeedsUpdateConstraints()
//                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseOut, animations: {[weak self]() -> Void in
//
//                    if let strongSelf = self {
//                        if let ribbonAlertView = strongSelf.ribbonAlertView {
//                            ribbonAlertView.frame = CGRect(x: 0.0, y: strongSelf.navigationBar.frame.height-strongSelf.ribbonAlertHeightTopOffset, width: ribbonAlertView.frame.size.width, height: ribbonAlertView.frame.size.height)
//                        }
//                    }
//
//                    }, completion:{(success) -> Void in
//                })
//                break
//
//            case .withoutNavBar:
//                if let ribbonAlertView = ribbonAlertView {
//                    view.addSubview(ribbonAlertView)
//                    view.bringSubview(toFront: ribbonAlertView)
//                }
//                view.setNeedsUpdateConstraints()
//                UIView.animate(withDuration: duration, animations: {
//                    self.ribbonAlertView?.alpha = 1
//
//                }, completion: { (success) in
//
//                })
//                break
//
//            }
//            self.presentationStyle = presentationStyle
//            if let alertTimer = self.alertTimer {
//                if alertTimer.isValid {
//                    alertTimer.invalidate()
//                }
//            }
//
//            let timeInterval: TimeInterval = type == .genericError ? 5.0 : 25.0
//            alertTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CustomNavBarViewController.hideAlertWithTimer), userInfo: nil, repeats: false)
//            return ribbonAlertView
//        }
//        return nil
//    }
//
//    @objc func hideAlertWithTimer() {
//        if ribbonAlertIsShowing {
//            hideAlertView(presentationStyle)
//        }
//    }
//
//    func hideAlertView(_ presentationStyle: RibbonAlertPresentationType) {
//        if (self.ribbonAlertIsShowing) {
//            alertTimer?.invalidate()
//
//            switch presentationStyle {
//            case .withNavBar:
//                UIView.animate(withDuration: duration*1.5, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseOut, animations: {[weak self]() -> Void in
//                    if let strongSelf = self {
//                        if let ribbonAlertView = strongSelf.ribbonAlertView {
//                            ribbonAlertView.frame = CGRect(x: 0, y: -ribbonAlertView.frame.size.height, width: ribbonAlertView.frame.size.width, height: ribbonAlertView.frame.size.height)
//                        }
//                    }
//                    }, completion:{[weak self](success) -> Void in
//                        if let strongSelf = self {
//                            strongSelf.ribbonAlertView?.removeFromSuperview()
//                        }
//                })
//                break
//
//            case .withoutNavBar:
//                UIView.animate(withDuration: duration, animations: {
//                    if let ribbonAlertView = self.ribbonAlertView {
//                        ribbonAlertView.alpha = 0
//                    }
//                }, completion: {[weak self] (success) in
//                    if let strongSelf = self {
//                        strongSelf.ribbonAlertView?.removeFromSuperview()
//                    }
//                })
//                break
//
//            }
//        }
//    }
//
//    // MARK: Error Messages
//
//    func processErrorMessage(_ errorMessage: String?, shouldShow: Bool, presentationStyle: RibbonAlertPresentationType, type: RibbonAlertType) {
//        if shouldShow {
//            if let eMessage = errorMessage {
//                _ = showAlertView(ofType: type, presentationStyle: presentationStyle, message: NSAttributedString(string: eMessage))
//            }
//        } else {
//            hideAlertView(presentationStyle)
//        }
//    }
    
    // MARK: Navigation Animation
    
    let titleOffset: CGFloat = 50
    
    func fadeOutNavBarAnimation(withDuration: TimeInterval, direction: NavigationBarAnimationDirection, show: Bool = false, completion: @escaping () -> ()) {
        UIView.animate(withDuration: withDuration, animations: {
            if let titleView = self.navigationBar.titleView {
                let currentOriginX = titleView.frame.origin.x
                self.navigationBar.titleView?.frame.origin.x = direction == .left ? (currentOriginX - self.titleOffset) : currentOriginX
            }
            self.navigationBar.titleView?.alpha = show ? 1 : 0
            self.navigationBar.leftItem?.alpha =  show ? 1 : 0
            self.navigationBar.rightItem?.alpha =  show ? 1 : 0
        }) { (finished) in
            completion()
        }
    }
    
    func fadeInNavBarAnimation(withDuration: TimeInterval, direction: NavigationBarAnimationDirection, titleOriginX: CGFloat, show: Bool = true, completion: @escaping () -> ()) {
        self.navigationBar.titleView?.frame.origin.x = direction == .left ? (titleOriginX + titleOffset) : titleOriginX
        
        UIView.animate(withDuration: withDuration, animations: {
            self.navigationBar.titleView?.frame.origin.x = direction == .left ? titleOriginX : (titleOriginX + self.titleOffset)
            self.navigationBar.titleView?.alpha = show ? 1 : 0
            self.navigationBar.leftItem?.alpha = show ? 1 : 0
            self.navigationBar.rightItem?.alpha = show ? 1 : 0
        }) { (finished) in
            completion()
        }
    }
    
    @discardableResult
    func resetNavBarElements(hide: Bool = false) -> CGFloat {
        var xOrigin: CGFloat = 0
        if let titleView = self.navigationBar.titleView {
            xOrigin = titleView.frame.origin.x
        }
        self.navigationBar.titleView?.alpha = hide ? 0 : 1
        self.navigationBar.leftItem?.alpha = hide ? 0 : 1
        self.navigationBar.rightItem?.alpha = hide ? 0 : 1
        return xOrigin
    }
    
    // MARK: Progress View
    
    func setScreenProgress(position: CGFloat) {
        showProgressView = true
        progressView.setProgress(position: position)
    }
    
    internal func setupProgressView() {
        view.insertSubview(progressView, belowSubview: navigationBar)
        
        progressView.snp.remakeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view).offset(navrBarHeight+(NavigationProgressView.lineHeight/2))
            make.height.equalTo(NavigationProgressView.lineHeight)
        }
    }
    
    // Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK :- UIGestureRecognizerDelegate

extension CustomTableViewController: UIGestureRecognizerDelegate {
    
}
