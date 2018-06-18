//
//  EmailOAuthDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 7/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SafariServices

class EmailOAuthDelegate: NSObject {
    unowned var parentVC: EmailOAuthViewController
    
    init(parentVC: EmailOAuthViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
}

// MARK:- UITextFieldDelegate

extension EmailOAuthDelegate:SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                
    }
    
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        print("absolute url ", URL.absoluteString)
        print("Title ", title!)
        return []
    }

}
