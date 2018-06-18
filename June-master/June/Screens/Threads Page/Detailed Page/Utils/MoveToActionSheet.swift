//
//  MoveToActionSheet.swift
//  June
//
//  Created by Tatia Chachua on 06/02/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class MoveToActionSheet: NSObject {

    private unowned var parentVC: ThreadsDetailViewController
    
    init(with controller: ThreadsDetailViewController) {
        parentVC = controller
    }
    
    func setupSubviews() {
        
        let actionSheet = UIAlertController(title: Localized.string(forKey: .ThreadsDetailViewActionSheetTitle), message: nil, preferredStyle: .actionSheet)
        
        let conversationAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetConversationsTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "conversations"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
            
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
   
        })
        let promotionAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetPromotionsTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "promotions"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let notificationsAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetNotificationsTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "notifications"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let tripsAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetTripsTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "trips"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let purchasesAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetPurchasesTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "purchases"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let financeAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetFinanceTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "finance"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let socialAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetSocialTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "social"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let newsAction = UIAlertAction(title: Localized.string(forKey: .ThreadsDetailViewActionSheetNewsTitle), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.parentVC.categoryName = "news"
            self.parentVC.changeCategoryOfMessage()
            
            if let controllerDelegate = self.parentVC.controllerDelegate, let category = self.parentVC.categoryName {
                
                controllerDelegate.recategorizeValue(_controller: self.parentVC, category: category)
            }
            
            self.parentVC.navigationController?.popViewController(animated: true)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        actionSheet.addAction(conversationAction)
        actionSheet.addAction(promotionAction)
        actionSheet.addAction(notificationsAction)
        actionSheet.addAction(tripsAction)
        actionSheet.addAction(purchasesAction)
        actionSheet.addAction(financeAction)
        actionSheet.addAction(socialAction)
        actionSheet.addAction(newsAction)
        actionSheet.addAction(cancelAction)
        
        parentVC.present(actionSheet, animated: true, completion: nil)
    }
    
}
