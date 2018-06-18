//
//  NetworkViewController.swift
//  CommonNetwork
//
//  Created by Guru Prasad chelliah on 8/28/17.
//  Copyright © 2017 Network. All rights reserved.
//

import UIKit

class NetworkViewController: UIViewController {

    @IBOutlet var myViewLoaingContainer: UIView!
    @IBOutlet var myActivityIndicatorLoaing: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showLoadingView() {
        
        print(myViewLoaingContainer)
        
        myViewLoaingContainer.alpha = 1.0
        myActivityIndicatorLoaing.alpha = 1.0
        myActivityIndicatorLoaing.startAnimating()
    }
    
    func hideLoadingView() {
        
        myViewLoaingContainer.alpha = 0.0
        myActivityIndicatorLoaing.alpha = 0.0
    myActivityIndicatorLoaing.stopAnimating()
    }
}
