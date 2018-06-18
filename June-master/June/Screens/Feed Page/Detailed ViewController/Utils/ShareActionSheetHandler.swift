//
//  ShareActionSheetHandler.swift
//  June
//
//  Created by Ostap Holub on 9/4/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ShareActionSheetHandler {
    
    // MARK: - Variables
    
    var inJuneAction: (() -> Void)! = nil
    var iniOSAction: (() -> Void)! = nil
    
    private var actionSheet: UIAlertController?
    private var presentingVC: UIViewController?
    
    // MARK: - Initialization
    
    init(with vc: UIViewController) {
        presentingVC = vc
        buildActionSheet()
    }
    
    // MARK: - Public part
    
    func show() {
        guard let sheet = actionSheet else { return }
        presentingVC?.present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - Private part
    
    private func buildActionSheet() {
        actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareInJuneAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.ShareInJuneTitle, style: .default, handler: { _ in self.inJuneAction() })
        let shareIniOSAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.ShareInIOSTitle, style: .default, handler: { _ in self.iniOSAction() })
        let cancelAction = UIAlertAction(title: LocalizedStringKey.DetailedViewHelper.CancelTitle, style: .cancel, handler: nil)
        
        actionSheet?.addAction(shareInJuneAction)
        actionSheet?.addAction(shareIniOSAction)
        actionSheet?.addAction(cancelAction)
    }
}
