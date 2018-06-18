//
//  MoreOptionsActionSheetHandler.swift
//  June
//
//  Created by Ostap Holub on 9/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MoreOptionsActionSheetHandler {
    
    // MARK: - Variables
    
    var recategorizeAction: (() -> Void)! = nil
    var replyAction: (() -> Void)! = nil
    var unsubscribeAction: (() -> Void)! = nil
    
    var actionSheet: UIAlertController?
    private var presentingVC: UIViewController?
    
    // MARK: - Initialization
    
    init(with vc: UIViewController) {
        presentingVC = vc
        buildActionSheet()
    }
    
    // MARK: - Public part
    
    func show() {
        guard let sheet = actionSheet else { return }
        
        if let presentedVC = presentingVC?.presentedViewController {
            presentedVC.present(sheet, animated: true, completion: nil)
        } else {
           presentingVC?.present(sheet, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private part
    
    func buildActionSheet() {
        actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let replyAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.ReplyTitle, style: .default, handler: { _ in self.replyAction() })
        let recategorizeAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.RecategorizeTitle, style: .default, handler: { _ in self.recategorizeAction() })
        let unsubscribeAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.UnsubscribeTitle, style: .default, handler: { _ in self.unsubscribeAction() })
        let cancelAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.CancelTitle, style: .cancel, handler: nil)
        
        actionSheet?.addAction(replyAction)
        actionSheet?.addAction(recategorizeAction)
        actionSheet?.addAction(unsubscribeAction)
        actionSheet?.addAction(cancelAction)
    }
}
