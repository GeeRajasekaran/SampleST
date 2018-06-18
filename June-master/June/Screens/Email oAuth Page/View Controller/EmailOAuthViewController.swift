//
//  EmailOAuthViewController.swift
//  June
//
//  Created by Joshua Cleetus on 7/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SafariServices

class EmailOAuthViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var authorizationURL: String = String()
    
    var delegate: SFSafariViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showGoogleOAuth()
    
    }
    
    func showGoogleOAuth() {
        if let url = URL(string: authorizationURL) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Did Finish")
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("didLoadSuccessfully: \(didLoadSuccessfully)")
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        print(URL.baseURL?.absoluteString as Any)
        return []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
