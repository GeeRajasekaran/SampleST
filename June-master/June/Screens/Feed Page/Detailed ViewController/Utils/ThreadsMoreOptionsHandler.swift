//
//  ThreadsMoreOptionHandler.swift
//  June
//
//  Created by Ostap Holub on 12/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ThreadsMoreOptionsHandler: MoreOptionsActionSheetHandler {
    
    override func buildActionSheet() {
        
        actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let recategorizeAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.RecategorizeTitle, style: .default, handler: { _ in self.recategorizeAction() })
        let cancelAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.CancelTitle, style: .cancel, handler: nil)
        
        actionSheet?.addAction(recategorizeAction)
        actionSheet?.addAction(cancelAction)
        
        
    }
}
