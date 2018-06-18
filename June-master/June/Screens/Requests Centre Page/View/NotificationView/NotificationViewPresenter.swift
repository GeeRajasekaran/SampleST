//
//  NotificationViewPresenter.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/19/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

fileprivate struct AnimationConstants {
    let minAlpha: CGFloat = 0.0
    let maxAlpha: CGFloat = 1.0
    let timeInterval: Double = 0.4
}

protocol NotificationViewPresenterDelegate: class {
    func didTapOnUndoButton(_ button: UIButton)
    func didHideViewAfterDelay(_ view: NotificationView)
}

class NotificationViewPresenter: NSObject {
    
    weak var delegate: NotificationViewPresenterDelegate?
    
    fileprivate var notificationView: NotificationView?
    fileprivate let window = UIApplication.shared.delegate?.window
    fileprivate var constants = AnimationConstants()
    private var alertWorkItem: DispatchWorkItem?
    fileprivate func initializeView(with title: String) {

        
        let screenBounds = UIScreen.main.bounds
        let viewWidth = 0.496 * screenBounds.width
        let viewHeight = 0.124 * screenBounds.width
        let originX = screenBounds.width/2 - viewWidth/2
        var originY = screenBounds.height - screenBounds.width*0.333
        
        if #available(iOS 11.0, *) {
            originY -= ((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!
        }

        notificationView = NotificationView(frame: CGRect(x: originX - 40, y: originY, width: 280, height: viewHeight), title: title)
        notificationView?.delegate = self
        notificationView?.alpha = constants.minAlpha
        notificationView?.setupSubviews()
        window??.addSubview(notificationView!)
    }
    
    func show(animated value: Bool = true, title text: String = "") {
        if notificationView == nil { initializeView(with: text) } else { notificationView?.updateFrame(with: text) }
        if value {
            UIView.animate(withDuration: constants.timeInterval, animations: { [weak self] in
                self?.notificationView?.alpha = (self?.constants.maxAlpha)!
            })
        } else {
            notificationView?.alpha = constants.maxAlpha
        }
        
        //hide after 4 sec
        hideAfterDeleay()
    }
    
    func hideAfterDeleay() {
        alertWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let unwrappedView = self?.notificationView else { return }
            self?.hide()
            self?.delegate?.didHideViewAfterDelay(unwrappedView)
        }
        alertWorkItem = workItem
        
        let when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when, execute: workItem)
    }
    
    func hide(animated value: Bool = true) {
        guard notificationView != nil else { return }
        
        if value {
            UIView.animate(withDuration: constants.timeInterval, animations: { [weak self] in
                self?.notificationView?.alpha = (self?.constants.minAlpha)!
                }, completion: { [weak self] finished in
                    self?.notificationView?.removeFromSuperview()
                    self?.notificationView = nil
            })
        } else {
            notificationView?.alpha = constants.maxAlpha
        }
    }
}

extension NotificationViewPresenter: NotificationViewDelegate {
    func didTapOnUndoButton(_ button: UIButton) {
        hide()
        delegate?.didTapOnUndoButton(button)
    }
}
