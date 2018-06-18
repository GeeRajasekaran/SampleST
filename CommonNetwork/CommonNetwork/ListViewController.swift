//
//  ListViewController.swift
//  CommonNetwork
//
//  Created by Guru Prasad chelliah on 8/28/17.
//  Copyright © 2017 Network. All rights reserved.
//

import UIKit

class ListViewController: NetworkViewController {
    
    @IBOutlet var myContainerView: UIView!
    @IBOutlet var submitBtnTapped: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let myView = UIView()
//        myView.backgroundColor = UIColor.red
//        myView.translatesAutoresizingMaskIntoConstraints = false
//
//        let yConstraint = NSLayoutConstraint(item: myView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 100)
//        
//        let horizontalConstraint = NSLayoutConstraint(item: myView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//        
//        let widthConstraint = NSLayoutConstraint(item: myView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
//        
//        let heightConstraint = NSLayoutConstraint(item: myView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
//        
//        view.addConstraints([yConstraint, horizontalConstraint, widthConstraint, heightConstraint])
//        
//        
//        let myView1 = UIView()
//        myView1.backgroundColor = UIColor.red
//        myView1.translatesAutoresizingMaskIntoConstraints = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        
        self.myContainerView.alpha = 0.0
        
        showLoadingView()
    }
}
