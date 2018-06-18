//
//  DocumentFileHandler.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/30/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class DocumentFileHandler: NSObject, IFileHandler {
    var parentVC: UIViewController?
    var picker = UIDocumentBrowserViewController()
    
    func open(_ parentVC: UIViewController) {
        self.parentVC = parentVC
        let barItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
        picker.additionalTrailingNavigationBarButtonItems = [barItem]
        picker.delegate = self
        parentVC.present(picker, animated: true, completion: nil)
    }
    
    @objc func dismiss() {
        picker.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 11.0, *)
extension DocumentFileHandler: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        print("temp")
    }
}
