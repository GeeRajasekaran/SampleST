//
//  ViewController.swift
//  June
//
//  Created by Joshua Cleetus on 7/18/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .yellow
        
        let button = UIButton(type: UIButtonType.roundedRect)
        button.setTitle("Trigger Key Metric", for: [])
        button.addTarget(self, action: #selector(self.anImportantUserAction), for: UIControlEvents.touchUpInside)
        button.sizeToFit()
        button.center = self.view.center
        view.addSubview(button)

    }
    
    func anImportantUserAction() {
        
        // TODO: Move this method and customize the name and parameters to track your key metrics
        //       Use your own string attributes to track common values over time
        //       Use your own number attributes to track median value over time
        Answers.logCustomEvent(withName: "Video Played", customAttributes: ["Category":"Comedy", "Length":350])
    }

}

