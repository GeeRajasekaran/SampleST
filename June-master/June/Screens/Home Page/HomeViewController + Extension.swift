//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 1/8/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension HomeViewController {
    
    // MARK: - Marking with notification dots logic
    func markWithRedDot(at index: Int) {
        if notificationDots[index] != nil { return }
        let screenWidth = UIScreen.main.bounds.width
        let tabButtonView = tabBar.buttons()[index]
        let x = tabButtonView.frame.origin.x + 35
        let y = 0.04 * screenWidth
        
        let notificationDot = tabBarInititalizer.buildNotificationView(at: CGPoint(x: x, y: y))
        notificationDots[index] = notificationDot
        tabBar.addSubview(notificationDot)
    }
    
    func removeRedDot(at index: Int) {
        if let dotView = notificationDots[index] {
            notificationDots.removeValue(forKey: index)
            dotView.removeFromSuperview()
        }
    }
    
    //MARK: - actions
    @objc func composeButtonClicked() {
        composeViewController = ComposeViewController()
        composeViewController?.notificationPresenter = notificationPresenter
        composeViewController?.modalTransitionStyle = .coverVertical
        present(composeViewController!, animated: true, completion: nil)
    }
    
    func reopenLastComposeViewController() {
        guard let vc = composeViewController else { return }
        present(vc, animated: true, completion: {
            vc.textInputView?.becomeFirstResponder()
        })
    }
    
    // UITabBarControllerDelegate method
    @objc func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(String(describing: viewController))")
        
        if let tab = TabsRealTimeManager.RealTimeTabName(rawValue: tabBarController.selectedIndex) {
            realTimeManager.setActive(true, for: tab)
            removeRedDot(at: tab.rawValue)
        }
        
        if tabBarController.selectedIndex == 0  {
            tapCounter += 1
            if self.tapCounter == 2  {
                self.tapCounter = 0
                let threadsVC: RolodexsViewController = self.viewControllers![0] as! RolodexsViewController
                threadsVC.tapStyle = "double"
                viewController.loadViewIfNeeded()
            }
            if self.tapCounter == 1 {
                let delayTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    let threadsVC: RolodexsViewController = self.viewControllers![0] as! RolodexsViewController
                    threadsVC.tapStyle = "single"
                    if self.tapCounter != 2 {
                        viewController.loadViewIfNeeded()
                    }
                    self.tapCounter = 0
                }
            }
            
        }
        
        if tabBarController.selectedIndex == 1  {
            print("Feed button pressed")
            tapCounter += 1
            if self.tapCounter == 2  {
                self.tapCounter = 0
                if let feedVC: FeedPageViewController = self.viewControllers![1] as? FeedPageViewController {
                feedVC.tapStyle = "double"
                viewController.loadViewIfNeeded()
                }
            }
            if self.tapCounter == 1 {
                let delayTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
                    self.tapCounter = 0
                }
            }
            
        }
        
        if tabBarController.selectedIndex == 3  {
            print("Starred button pressed")
            tapCounter += 1
            if self.tapCounter == 2  {
                self.tapCounter = 0
//                let threadsVC: FavoritesViewController = self.viewControllers![3] as! FavoritesViewController
//                threadsVC.tapStyle = "double"
                viewController.loadViewIfNeeded()
            }
            if self.tapCounter == 1 {
                let delayTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.tapCounter = 0
                }
            }
        }
        
    }
        
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let tab = TabsRealTimeManager.RealTimeTabName(rawValue: tabBarController.selectedIndex) {
            realTimeManager.update(timestamp: Date.timestampOfNow, for: tab)
            realTimeManager.setActive(false, for: tab)
        }
        return true
    }
    
    func setProfileImage() {
        if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
            if userObject["profile_image"] != nil {
                if let profileImagePath = userObject["profile_image"] as? String {
                    Alamofire.request(profileImagePath).responseImage { response in
                        if let image = response.result.value {
                            let scaledImage = image.imageResize(sizeChange: CGSize.init(width: 30, height: 30))
                            self.menuButton.setImage(scaledImage, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
}
