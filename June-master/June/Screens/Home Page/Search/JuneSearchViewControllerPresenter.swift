//
//  JuneSearchViewControllerPresenter.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class JuneSearchViewControllerPresenter: NSObject {
    
    private var searchVC: JuneSearchViewController?
    private unowned var parentVC: UIViewController
    
    lazy var didTapOnBackButton: (UIView) -> Void = { _ in
        self.hide()
    }
    
    init(with controller: UIViewController) {
        parentVC = controller
    }
    
    func show() {
        let searchVC = JuneSearchViewController()
        let navController = UINavigationController()
        searchVC.didTapOnBackButton = didTapOnBackButton
        navController.setViewControllers([searchVC], animated: false)
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .crossDissolve
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        tapGesture.delegate = searchVC
        searchVC.view.addGestureRecognizer(tapGesture)
        parentVC.present(navController, animated: false, completion: nil)
    }
    
    @objc func hide() {
        parentVC.dismiss(animated: true, completion: nil)
    }
}
