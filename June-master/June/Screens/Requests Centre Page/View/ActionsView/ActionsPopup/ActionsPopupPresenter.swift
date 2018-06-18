//
//  ActionsPopupPresenter.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ActionsPopupPresenterDelegate: class {
    func presenter(_ presenter: ActionsPopupPresenter, dismissPopupWith replyAction: ReplyAction, requestItem: RequestItem)
}

enum ActionsPopupType {
    case reply, cannedResponse
}

class ActionsPopupPresenter: NSObject {

    private var popup: ActionsPopup?
    private unowned var parentVC: UIViewController
    private var type: ActionsPopupType = .reply
    private let window = UIApplication.shared.keyWindow
    private var view: UIView?
    
    weak var delegate: ActionsPopupPresenterDelegate?
    
    var contact: RequestItem?
    
    init(with controller: UIViewController) {
        parentVC = controller
    }
    
    func showPopup(view: UIView, and type: ActionsPopupType) {
        self.view = view
        popup = ActionsPopup()
        popup?.type = type
        popup?.delegate = self
        popup?.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popup?.modalTransitionStyle = .crossDissolve
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopup))
        tapGesture.delegate = popup
        popup?.view.addGestureRecognizer(tapGesture)
        parentVC.present(popup!, animated: true, completion: nil)
        updatePopupFrame(near: view)
    }
    
    @objc func hidePopup() {
        parentVC.dismiss(animated: true, completion: nil)
        guard let replyButton = view as? RightImageButton else { return }
        replyButton.changeImage(with: LocalizedImageNameKey.RequestsViewHelper.ReplyIconName)
    }
    
    // MARK: Private
    private func updatePopupFrame(near view: UIView) {
        guard let cannedButton = view as? RightImageButton else { return }
        let viewScreenFrame = view.convert(view.bounds, to: window)
        let offset: CGFloat = 0.014 * UIScreen.main.bounds.width
        if isPopupAboveViewt(view) {
            let popupOriginY = viewScreenFrame.origin.y - (popup?.parentView.frame.height)! - offset
            popup?.parentView.frame.origin.y = popupOriginY
            cannedButton.changeImage(with: LocalizedImageNameKey.RequestsViewHelper.ReplySelectedIconName)
            popup?.addBottomArrow()
        } else {
            let popupOriginY = viewScreenFrame.origin.y + viewScreenFrame.size.height + offset
            popup?.parentView.frame.origin.y = popupOriginY
            cannedButton.changeImage(with: LocalizedImageNameKey.RequestsViewHelper.ReplySelectedIconName)
            popup?.addTopArrow()
        }
    }
    
    fileprivate func isPopupAboveViewt(_ view: UIView) -> Bool {
        let viewScreenFrame = view.convert(view.bounds, to: window)
        return viewScreenFrame.origin.y > (popup?.parentView.frame.height)!
    }
}

extension ActionsPopupPresenter: ActionsPopupDelegate {
    func popup(_ popup: ActionsPopup, didSelectAction action: ReplyAction) {
        hidePopup()
        guard let unwrappedContact = contact else { return }
        delegate?.presenter(self, dismissPopupWith: action, requestItem: unwrappedContact)
    }
}
