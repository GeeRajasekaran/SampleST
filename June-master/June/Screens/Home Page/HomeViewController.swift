//
//  HomeViewController.swift
//  June
//
//  Created by Joshua Cleetus on 7/26/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
    
    var notificationCircle : UIImageView!
    var menuButton : UIButton!
    var menuCloseButton : UIButton!
    var searchButton : UIButton!
    var requestsCenterButton : UIButton!
    var tapCounter = 0
    var isFromSpam = false

    var composeViewController: ComposeViewController?

    private lazy var accountsRealTimeManager: AccountsRealTimeManager = { [weak self] in
        let manager = AccountsRealTimeManager(action: self?.onEventTriggered)
        return manager
    }()

    private let navBarTitleFont = UIFont.latoStyleAndSize(style: .bold, size: .large)
    
    private lazy var defaultTabBarHeight = { [unowned self] in
        self.tabBar.frame.size.height
    }()
    
    lazy var realTimeManager: TabsRealTimeManager = { [unowned self] in
        let manager = TabsRealTimeManager(parentVC: self)
        return manager
    }()
    
    var notificationDots = [Int: UIView]()
    
    lazy var searchViewPresenter: JuneSearchViewControllerPresenter = { [unowned self] in
        let presenter = JuneSearchViewControllerPresenter(with: self)
        return presenter
    }()
    
    lazy var tabBarInititalizer: UITabBarInitializer = { [unowned self] in
        let inititalizer = UITabBarInitializer(with: self)
        return inititalizer
    }()

    lazy var notificationPresenter: NotificationViewPresenter = { [weak self] in
        let presenter = NotificationViewPresenter()
        presenter.delegate = self
        return presenter
        }()
    
    @objc func accountsButtonPressed() {
        // Access an instance of AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Reference drawerContainer object declared inside of AppDelegate and call toggleDrawerSide function on it
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
//        print(appDelegate.drawerContainer?.visibleLeftDrawerWidth as Any)
    }
    
    @objc func searchButtonPressed() {
//        if let convos = viewControllers?.first as? ConvosViewController {
//            convos.convosRealTime.switchOffThreadsRealtimeListener()
//        }
        searchViewPresenter.show()
    }
    
    @objc func requestsCenterButtonPressed() {
        let requestsVC = RequestsCentreViewController()
        self.navigationController?.pushViewController(requestsVC, animated: true)
    }
    
    // MARK: - Request center notification
    
    func subscribeForRequestCenterEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpeningPeoplesPage), name: Notification.Name(rawValue: "OnOpenRequestsWithPeople"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpeningSubscriptionsPage), name: Notification.Name(rawValue: "OnOpenRequestsWithSubscriptions"), object: nil)
    }
    
    @objc private func handleOpeningSubscriptionsPage() {
        let requestsVC = RequestsCentreViewController()
        self.navigationController?.pushViewController(requestsVC, animated: true)
        requestsVC.changeRequestsWith(screenType: .subscriptions)
        requestsVC.selectSubscriptionsButton()
    }
    
    @objc private func handleOpeningPeoplesPage() {
        let requestsVC = RequestsCentreViewController()
        requestsVC.screenType = .people
        self.navigationController?.pushViewController(requestsVC, animated: true)
    }
    
    private lazy var onEventTriggered: () -> Void = {
        print("Account sync_state now is not equal to running, should show error!")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Change tab bar height
        let offset = 0.037 * UIScreen.main.bounds.width
        let newTabBarHeight = defaultTabBarHeight + offset
        var newTabBarFrame = tabBar.frame
        newTabBarFrame.size.height = newTabBarHeight
        newTabBarFrame.origin.y = view.frame.size.height - newTabBarHeight
        tabBar.frame = newTabBarFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForRequestCenterEvents()
        self.view.backgroundColor = UIColor.white
        accountsRealTimeManager.subscribe()
        realTimeManager.subscribe()
        realTimeManager.loadInitialState()
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: navBarTitleFont
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        tabBarInititalizer.layoutSubviews()
       
        // Create Tab one
        let tabOne = RolodexsViewController()
        let tabOneBarItem = UITabBarItem(title: LocalizedStringKey.HomeViewHelper.tabOneTitle, image: UIImage(named: LocalizedImageNameKey.HomeViewHelper.ConvosIcon), selectedImage: UIImage(named: LocalizedImageNameKey.HomeViewHelper.ConvosIcon))
        tabOne.tabBarItem = tabOneBarItem
        tabOneBarItem.titlePositionAdjustment = UIOffsetMake(0, -4)
        
        // Create Compose Tab
        let composeTab = RolodexsViewController()
        let composeTabBarItem = UITabBarItem(title: "", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        composeTab.tabBarItem = composeTabBarItem
        
        // Create Feed Tab
        let feedTab = FeedPageViewController()
        feedTab.requestData()
        feedTab.dataRepository.requestRecentItems()
        feedTab.dataRepository.threadsDataProvider.subscribeForRealTimeEvents()
        let feedTabBarItem = UITabBarItem(title: Localized.string(forKey: LocalizedString.HomeViewTabTwoTitle), image: UIImage(named: LocalizedImageNameKey.HomeViewHelper.FeedIcon), selectedImage: UIImage(named: LocalizedImageNameKey.HomeViewHelper.FeedIcon))
        feedTab.tabBarItem = feedTabBarItem
        feedTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4)
        
        self.viewControllers = [tabOne, composeTab, feedTab]
        self.view.backgroundColor = UIColor.white
        self.delegate = self
        
        menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: LocalizedImageNameKey.HomeViewHelper.MenuButtonBackgroundImageName), for: .normal)
        menuButton.frame = CGRect(x: 10, y: 45, width: 30, height: 30)
        menuButton.addTarget(self, action: #selector(self.accountsButtonPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: menuButton)
        menuButton.imageView?.layer.cornerRadius = 15
        menuButton.imageView?.clipsToBounds = true
        menuButton.imageView?.sizeToFit()
        menuButton.imageView?.contentMode = .scaleAspectFit
        self.setProfileImage()
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1875*self.view.frame.size.width, height: 30))
        rightView.backgroundColor = UIColor.clear
        let rightBtn = UIBarButtonItem(customView: rightView)
        
        searchButton = UIButton(type: .custom)
        searchButton.setImage(#imageLiteral(resourceName: "search-light-vector-icon"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 0.08*self.view.frame.size.width, height:30)
        searchButton.addTarget(self, action: #selector(self.searchButtonPressed), for: .touchDown)
        rightView.addSubview(searchButton)
        
        requestsCenterButton = UIButton(type: .custom)
        requestsCenterButton.setImage(#imageLiteral(resourceName: "requests-light-vector-icon"), for: .normal)
        requestsCenterButton.frame = CGRect(x: searchButton.frame.size.width + 10, y: 0, width: 0.08*self.view.frame.size.width, height: 30)
        requestsCenterButton.imageView?.contentMode = .scaleAspectFill
        requestsCenterButton.addTarget(self, action: #selector(self.requestsCenterButtonPressed), for: .touchDown)
        rightView.addSubview(requestsCenterButton)
        
        self.menuCloseButton = UIButton(type: .custom)
        self.menuCloseButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.menuCloseButton.addTarget(self, action: #selector(self.accountsButtonPressed), for: .touchUpInside)
        self.navigationController?.view.addSubview(self.menuCloseButton)
        
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        self.navigationItem.setRightBarButtonItems([rightBtn], animated: true)
        
        notificationCircle = UIImageView()
        notificationCircle.frame = CGRect(x: 55, y: self.view.frame.size.height - self.tabBar.frame.size.height - 64 + 5, width: 7, height: 7)
        notificationCircle.layer.cornerRadius = 7/2
        notificationCircle.backgroundColor = .white  
    }
    
    func addBottomShadowView() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let shadowImageViewHeight: CGFloat = 0.016*screenWidth
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navigationControllerHeigh: CGFloat = 44
        if let navControllerHeigh = navigationController?.navigationBar.frame.height {
            navigationControllerHeigh = navControllerHeigh
        }
        
        var originY = screenHeight - shadowImageViewHeight - statusBarHeight - navigationControllerHeigh - tabBar.frame.height
        
        if #available(iOS 11.0, *) {
            originY -= ((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!
        }
        
        let shadowFrame = CGRect(x: 0, y: originY, width: screenWidth, height: shadowImageViewHeight)
        
        let bottomShadowView = UIImageView(image: #imageLiteral(resourceName: "shadow_bottom"))
        bottomShadowView.frame = shadowFrame
        self.view.addSubview(bottomShadowView)
        bottomShadowView.backgroundColor = .clear
        bottomShadowView.contentMode = .scaleAspectFit
        bottomShadowView.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        realTimeManager.unsubscribe()
        
    }
    
}

extension HomeViewController: NotificationViewPresenterDelegate {
    
    func didTapOnUndoButton(_ button: UIButton) {
        composeViewController?.discardScheduledMessageSending()
        reopenLastComposeViewController()
        composeViewController?.checkSendButtonAvailability()
    }
    
    func didHideViewAfterDelay(_ view: NotificationView) {
        composeViewController?.triggerScheduledMessageSending()
    }
}
