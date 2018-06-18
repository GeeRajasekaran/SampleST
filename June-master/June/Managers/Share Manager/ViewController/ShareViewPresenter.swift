//
//  ShareViewPresenter.swift
//  June
//
//  Created by Oksana Hanailiuk on 2/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class ShareViewPresenter {
    
    private unowned var parentVC: UIViewController
    
    var onHidePopupAction: (() -> Void)?
    
    init(with controller: UIViewController) {
        parentVC = controller
    }
    
    func show(_ cardView: IFeedCardView? = nil, message: Messages? = nil) {
        let controller = ShareViewController()
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.cardView = cardView
        controller.message = message
        controller.onHidePopup = onHidePopupAction
        if let presentedVC = parentVC.presentedViewController {
            presentedVC.present(controller, animated: true, completion: nil)
        } else {
            parentVC.present(controller, animated: true, completion: nil)
        }
    }
}
