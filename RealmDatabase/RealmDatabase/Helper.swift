//
//  Helper.swift
//  RealmDatabase
//
//  Created by Guru Prasad chelliah on 12/26/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

import UIKit
import Foundation

let TAG_LOADING = 100
let TAG_NO_DATA = 200
let TAG_RETRY = 300
let TAG_NO_INTERNET = 400

typealias RetryCallBack = () -> Void

class Helper: NSObject {
    
    var myRetryCallBack:RetryCallBack!

    static let sharedInstance: Helper = {
        
        let instance = Helper()
        
        // setup code
        return instance
    }()
    
    //MARK:- Loading animation
    func showLoadingViewAnimation(viewController : UIViewController) {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewLoadingContainer.tag = TAG_LOADING
        
        showAndHideContainer(intTag: TAG_LOADING, netWorkView: aViewNetworkView)
        
        aViewNetworkView.gIndicatorLoading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        aViewNetworkView.gIndicatorLoading.startAnimating()
        aViewNetworkView.gIndicatorLoading.tintColor = UIColor.red
        aViewNetworkView.gLblLoading.isHidden = true
        
        aViewNetworkView.backgroundColor = UIColor.yellow
        aViewNetworkView.gViewLoadingContainer?.backgroundColor = UIColor.red
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewLoadingContainer)
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            aViewNetworkView.gViewLoadingContainer?.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            
        })
    }
    
    func showNoDataAlert(viewController : UIViewController) {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewNetworkContainer.tag = TAG_NO_DATA
        
        aViewNetworkView.gImgViewAlert.image =  UIImage(named:"icon_no_data")!
        aViewNetworkView.gLblAlertTtle.text = "No data"
        
        showAndHideContainer(intTag: TAG_NO_DATA, netWorkView: aViewNetworkView)
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewNetworkContainer)
    }
    
    func showNoDataWithRetryAlert(viewController: UIViewController, retryBlock aRetryCallBack: @escaping RetryCallBack)  {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewNetworkContainer.tag = TAG_RETRY
        
        aViewNetworkView.gImgViewAlert.image =  UIImage(named:"icon_no_data")!
        aViewNetworkView.gLblAlertTtle.text = "No data"
        
        showAndHideContainer(intTag: TAG_RETRY, netWorkView: aViewNetworkView)
        
        myRetryCallBack = aRetryCallBack
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEvent))
        aViewNetworkView.gViewNetworkContainer?.addGestureRecognizer(tapGesture)
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewNetworkContainer)
        
//        UIView.animate(withDuration: 0.2, animations: {() -> Void in
//            aViewNetworkView.gViewNetworkContainer.alpha = 1
//        }) {() -> Void in }
        
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                aViewNetworkView.gViewNetworkContainer?.alpha = 1.0
            }, completion: {(_ finished: Bool) -> Void in

            })
        
    }
    
    func showNetworkWithRetryAlert(viewController: UIViewController, retryBlock aRetryCallBack: @escaping RetryCallBack)  {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewNetworkContainer.tag = TAG_RETRY
        
        aViewNetworkView.gImgViewAlert.image =  UIImage(named:"icon_no_internet")!
        aViewNetworkView.gLblAlertTtle.text = "No Internet"
        
        showAndHideContainer(intTag: TAG_RETRY, netWorkView: aViewNetworkView)
        
        myRetryCallBack = aRetryCallBack
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEvent))
        aViewNetworkView.gViewNetworkContainer?.addGestureRecognizer(tapGesture)
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewNetworkContainer)
    }
    
    func tapEvent(_ sender: UIGestureRecognizer) {
        //let aView = sender.view as? NetworkView
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            sender.view?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                sender.view?.transform = .identity
            }, completion: {(_ finished: Bool) -> Void in
                
                if (self.myRetryCallBack != nil) {
                    self.myRetryCallBack()
                }
            })
        })
    }
    
    func hideLoadingAnimation(viewController: UIViewController)  {
        
        let aLoadingView: UIView? = viewController.view.viewWithTag(TAG_LOADING)
        
        if (aLoadingView != nil) {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                aLoadingView?.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                aLoadingView?.removeFromSuperview()
            })
        }
    }
    
    func removeNetworlAlertIn(viewController: UIViewController)  {
        
        let aRetryView: UIView? = viewController.view.viewWithTag(TAG_RETRY)
        
        if (aRetryView != nil) {
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                aRetryView?.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                aRetryView?.removeFromSuperview()
            })
        }
        
        aRetryView?.removeFromSuperview()
    }
    
    func updateConstraints(viewController : UIViewController, inputView:UIView) {
        
        viewController.view.addSubview(inputView)
        
        let aTopLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 0)
        let aBottomLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .bottom, relatedBy: .equal, toItem: viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let aLeftLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .left, relatedBy: .equal, toItem: viewController.view, attribute: .left, multiplier: 1.0, constant: 0)
        let aRightLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .right, relatedBy: .equal, toItem: viewController.view, attribute: .right, multiplier: 1.0, constant: 0)
        
        viewController.view.addConstraints([aTopLayoutConstraint, aBottomLayoutConstraint, aLeftLayoutConstraint, aRightLayoutConstraint])
        
        viewController.view.layoutIfNeeded()
    }
    
    func showAndHideContainer(intTag : NSInteger, netWorkView : NetworkView)  {
        
        if intTag == TAG_LOADING {
            
            netWorkView.gViewLoadingContainer.isHidden = false
            netWorkView.gViewNetworkContainer.isHidden = true
        }
        
        else if intTag == TAG_RETRY {
            
            netWorkView.gViewLoadingContainer.isHidden = true
            netWorkView.gViewNetworkContainer.isHidden = false
        }
        
        else if intTag == TAG_NO_DATA {
            
            netWorkView.gViewLoadingContainer.isHidden = true
            netWorkView.gViewNetworkContainer.isHidden = false
        }
    }
    
    // MARK:- Coloe code string
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
