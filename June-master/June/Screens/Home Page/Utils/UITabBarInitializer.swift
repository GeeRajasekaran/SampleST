//
//  UITabBarInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class UITabBarInitializer {

    // MARK: - Variables & Constants
    
    private unowned var parentVC: HomeViewController
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Initialization
    
    init(with rootVC: HomeViewController) {
        parentVC = rootVC
    }
    
    // MARK: - Public part
    
    func layoutSubviews() {
        setupTabBar()
        addComposeButton()
        addLineView()
    }
    
    func buildNotificationView(at position: CGPoint) -> UIView {
        let size = CGSize(width: 7, height: 7)
        let notificationDot = UIImageView()
        notificationDot.frame = CGRect(origin: position, size: size)
        notificationDot.layer.cornerRadius = size.height / 2
        notificationDot.backgroundColor = UIColor.init(hexString: "#00DEE8")
        return notificationDot
    }
    
    //MARK: - Private part
    private func setupTabBar() {
        let tabBar = parentVC.tabBar
        tabBar.barTintColor = UIColor.init(hexString: "#FCFDFD") 
        tabBar.tintColor =  UIColor.init(hexString: "#00487C")
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.init(hexString: "#B9C1CC")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.latoStyleAndSize(style: .regular, size: .smallMedium), NSAttributedStringKey.foregroundColor: UIColor.init(hexString: "#6B798E")], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.latoStyleAndSize(style: .regular, size: .smallMedium), NSAttributedStringKey.foregroundColor: UIColor.init(hexString: "#00204A")], for: .selected)
    }
    
    private func addComposeButton() {
        let composeImageName = LocalizedImageNameKey.HomeViewHelper.ComposeImage
        let composeImage = UIImage(named: composeImageName)
        let composeImageView = UIImageView(image: composeImage!)
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let composeImageViewHeight = 0.128*screenWidth
        let composeImageViewWidth = 0.128*screenWidth
        
        let offset = parentVC.tabBar.frame.height/2 - composeImageViewHeight/2
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navigationControllerHeigh: CGFloat = 44
        if let navControllerHeigh = parentVC.navigationController?.navigationBar.frame.height {
            navigationControllerHeigh = navControllerHeigh
        }
        
        let originY = screenHeight - composeImageViewHeight - statusBarHeight - navigationControllerHeigh - offset
        let composeFrame = CGRect(x: screenWidth/2 - composeImageViewWidth/2, y: originY, width: composeImageViewWidth, height: composeImageViewHeight)
        
        composeImageView.frame = composeFrame
        parentVC.view.addSubview(composeImageView)
        composeImageView.backgroundColor = .clear
        composeImageView.contentMode = .scaleToFill
        
        if #available(iOS 11, *) {
            composeImageView.translatesAutoresizingMaskIntoConstraints = false
            let guide = parentVC.view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                guide.bottomAnchor.constraint(equalTo: composeImageView.bottomAnchor, constant: 5),
                composeImageView.heightAnchor.constraint(equalToConstant:composeImageViewHeight),
                composeImageView.widthAnchor.constraint(equalToConstant:composeImageViewWidth),
                composeImageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
                ])
        }
        //Add compose button action
        let tapGestureRecognizer = UITapGestureRecognizer(target: parentVC, action: #selector(parentVC.composeButtonClicked))
        composeImageView.isUserInteractionEnabled = true
        composeImageView.addGestureRecognizer(tapGestureRecognizer)
    }
   
    private func addLineView() {
        let lineView = UIView(frame: CGRect(x: 0.5, y: 0.0, width: parentVC.tabBar.frame.width, height: 1))
        lineView.backgroundColor = UIColor.init(hexString: "#CBCECE")
        lineView.isUserInteractionEnabled = false
        parentVC.tabBar.addSubview(lineView)
    }
    
}
