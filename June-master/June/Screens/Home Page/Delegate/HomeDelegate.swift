//
//  HomeDelegate.swift
//  June
//
//  Created by Tatia Chachua on 01/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class HomeDelegate: NSObject {
    
    unowned var parentVC: HomeViewController
    init(parentVC: HomeViewController) {
        self.parentVC = parentVC
        super.init()
    }

}
extension HomeDelegate:  UITabBarControllerDelegate {
    // UITabBarControllerDelegate method
    @objc func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(String(describing: viewController))")
        
        if tabBarController.selectedIndex == 2 {
            print("Compose button pressed")
            let composeViewController = ComposeViewController()
            composeViewController.modalTransitionStyle = .coverVertical
            self.parentVC.present(composeViewController, animated: true, completion: nil)
        }
    }
}
