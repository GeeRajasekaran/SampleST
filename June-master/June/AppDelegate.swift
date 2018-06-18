//
//  AppDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 7/18/17.
//  Copyright © 2017 Project Core Inc. All rights reserved.
//

import UIKit
import Foundation
import Fabric
import Crashlytics
import CoreData
import KeychainSwift
import Instabug
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate{

    var window: UIWindow?
    var mainView: UIViewController?
    var userID:String!
    var userObject: Dictionary = [String: Any]()
    var accountsObject: NSArray = []
    var accountsDict: Dictionary = [String: Any]()
    var accountID: String!
    var drawerContainer: MMDrawerController?
    private var templatesLoader: ITemplateLoadable = TemplatesHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        templatesLoader.loadFeedTemplates()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }

        // launch Instabug
        Instabug.start(withToken: "0a847366c05fb582ca6997ed4b1649b9", invocationEvent: .shake)
        Instabug.setEmailFieldRequired(false)
        Instabug.setReproStepsMode(.enable)
        Instabug.setAutoScreenRecordingEnabled(true)
        Instabug.setAutoScreenRecordingDuration(60.0)

        // launch Fabric
        Fabric.with([Crashlytics.self, Answers.self])

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        
        self.mainView = LoginSignupViewController()
        
        if UIApplication.isFirstLaunch() {
            self.mainView = LoginSignupViewController()
            if let usernameData = KeyChainManager.load(key: JuneConstants.KeychainKey.username) {
                _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.username, data: usernameData)
            }
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
            }
            if let userAccountData = KeyChainManager.load(key: JuneConstants.KeychainKey.accountID) {
                _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.accountID, data: userAccountData)
            }
            if let userIDData = KeyChainManager.load(key: JuneConstants.KeychainKey.userID) {
                _ = KeyChainManager.delete(key: JuneConstants.KeychainKey.userID, data: userIDData)
            }
        } else {
            if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                self.userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
                if self.userObject["accounts"] != nil {
                    self.accountsObject = self.userObject["accounts"] as! NSArray
                    if self.accountsObject.count > 0 {
                        self.accountsDict = self.accountsObject[0] as! [String : Any]
                        if self.accountsDict["account_id"] != nil {
                            self.accountID = self.accountsDict["account_id"] as! String
                            self.buildNavigationDrawer()
                            return true
                        } else {
                            self.mainView = EmailDiscoveryViewController()
                        }
                    } else {
                        self.mainView = EmailDiscoveryViewController()
                    }
                } else {
                    self.buildNavigationDrawer()
                    return true
                }
            } else {
                KeychainSwift().delete(JuneConstants.Feathers.jwtToken)
                self.mainView = LoginSignupViewController()
            }
        }
        
       
        nav1.viewControllers = [self.mainView!]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        return true
        
    }
    
    func buildNavigationDrawer() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Instantiate Main.storyboard
        self.mainView = UINavigationController(rootViewController:HomeViewController())
        let leftSideMenu = AccountsViewController()
        // Wrap into Navigation controllers
        let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
        // Cerate MMDrawerController
        let rightSideMenu = UIViewController()
        let rightSideMenuNav = UINavigationController(rootViewController: rightSideMenu)
        drawerContainer = MMDrawerController(center: self.mainView, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
        drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
        drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
        // Assign MMDrawerController to our window's root ViewController
        self.window?.rootViewController = self.drawerContainer
        self.window?.makeKeyAndVisible()

    }
    
    func showSignUpPage() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let nav1 = UINavigationController()
        self.mainView = SignUpViewController()
        nav1.viewControllers = [self.mainView!]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()        
    }
    
    func showLoginSignupPage() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        self.mainView = LoginSignupViewController()
        nav1.viewControllers = [self.mainView!]
        self.window?.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }
    
    func showLoginPage() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let nav1 = UINavigationController()
        self.mainView = LoginViewController()
        nav1.viewControllers = [self.mainView!]
        self.window?.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }
    
    func showHomePage() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        self.mainView = HomeViewController()
        nav1.viewControllers = [self.mainView!]
        self.window?.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }
    
    func emailDiscoveryPage() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        self.mainView = EmailDiscoveryViewController()
        nav1.viewControllers = [self.mainView!]
        self.window?.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let sourceApplication = options[.sourceApplication] {
            if (String(describing: sourceApplication) == "com.apple.SafariViewService") {
                NotificationCenter.default.post(name: Notification.Name(kCloseSafariViewControllerNotification), object: url)
                return true
            }
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SocketIOManager.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.listenToClientEvents()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.        
        let token = KeychainSwift().get(JuneConstants.Feathers.jwtToken)
        if token != nil && !(token?.isEmpty)! {
            SocketIOManager.sharedInstance.refreshJWTToken()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CoreDataManager.sharedInstance.saveContext()
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device_token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        saveDeviceTokenInFeathers(deviceToken: device_token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func saveDeviceTokenInFeathers(deviceToken: String) {
        if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
            if let userId = userObject["_id"] {
                let params = ["ios_device_tokens": [deviceToken]] as [String : Any]
                FeathersManager.Services.users.request(.patch(id: userId as? String, data: params, query: nil)).on(value: { response in
                    let data = response.data.value as! [String: Any]
                    print(data as Any)
                }).startWithFailed { (error) in
                    print(error as Any)
                }
            }
        }
    }
}
