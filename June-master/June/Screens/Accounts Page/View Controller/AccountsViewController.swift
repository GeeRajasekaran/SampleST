//
//  AccountsViewController.swift
//  June
//
//  Created by Joshua Cleetus on 8/3/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import NVActivityIndicatorView
import Alamofire
import AlamofireImage

class AccountsViewController: UIViewController, SettingsViewDelegate, AddAccountViewDelegate, NVActivityIndicatorViewable {

    var menuCloseButton : UIButton!
    var profileImageView : UIImageView!
    var fullNameLabel : UILabel!
    var usernameLabel : UILabel!

    var settingsImageView : UIImageView!

    var settingsButton : UIButton!
    var fullName : String!
    var profilePictureURLString : String!
    var profilePicture : UIImage!
    var userObject: Dictionary = [String: Any]()

    var emailAccountsLabel: UILabel!

    var helpButton: UIButton!
    
    var versionLabel: UILabel!
    var spamButton: UIButton!
    var accountsTableView: UITableView = UITableView()
    
    static let fullNameLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .large)
    static let usernameLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
    static let viewAllLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let emailAccountsLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
    static let versionLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regular)
    static let spamButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
    static let settingsButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
    
    
    //UIInitialozer
    lazy var uiInitializer: AccountsUIInitializer = {
        let initializer = AccountsUIInitializer(with: self)
        return initializer
    }()
    
    //Data repository
    lazy var dataRepository: AccountsDataRepository = {
        let source = AccountsDataRepository()
        return source
    }()
    
    //Data source
    lazy var accountsDataSource: AccountsDataSource = {
        let source = AccountsDataSource(with: self.dataRepository)
        return source
    }()
    
    //Delegates
    lazy var accountsDelegate: AccountsDelegate = {
        let delegate = AccountsDelegate(with: self.dataRepository)
        delegate.onReauthenticateAccount = onReauthenticateAccount
        return delegate
    }()
    
    //MARK: - handler
    lazy var linkEmailHandler: LinkEmailHandler = {
        let handler = LinkEmailHandler(with: self)
        handler.onSuccessLinkEmail = onSuccessLinkEmail
        return handler
    }()
    
    //MARK: - Reauthentacate
    lazy var onReauthenticateAccount: ((Account) -> Void) = { [weak self] account in
        self?.linkEmailHandler.reauthenticate(account)
    }
    
    lazy var onSuccessLinkEmail: (() -> Void) = { [weak self] in
        self?.pullUserFromFeathers()
    }
    
    @objc func accountsButtonPressed() {
        // Access an instance of AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Reference drawerContainer object declared inside of AppDelegate and call toggleDrawerSide function on it
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @objc func spamButtonPressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Reference drawerContainer object declared inside of AppDelegate and call toggleDrawerSide function on it
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "spam"), object: nil)
    }
    
    @objc func settingsButtonPressed() {
        let settingsVC = SettingsViewController()
        settingsVC.settingsViewDelegate = self
        settingsVC.fullName = self.fullName
        settingsVC.profilePictureImage = self.profileImageView.image
        self.present(settingsVC, animated: true, completion: nil)
        print(fullName)
    }
    
    func fullNameEdited(_ editedFullName: String?) {
        if !(editedFullName?.isEmpty)! {
            self.fullName = editedFullName
            self.fullNameLabel.text = self.fullName
            self.pullUserFromFeathers()
        }
    }
    
    func profilePictureEdited(_ editedProfileImage: UIImage?) {
        if editedProfileImage != nil {
            self.profilePicture = editedProfileImage
            self.pullUserFromFeathers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.menuCloseButton = UIButton(type: .custom)
        self.menuCloseButton.frame = CGRect(x: self.view.frame.size.width - (self.view.frame.size.width * 0.17333333), y: 20, width: self.view.frame.size.width * 0.17333333, height: self.view.frame.size.height)
        self.menuCloseButton.addTarget(self, action: #selector(self.accountsButtonPressed), for: .touchUpInside)
        self.menuCloseButton.backgroundColor = .black // .clear
        self.menuCloseButton.alpha = 0.55
        UIApplication.shared.keyWindow?.addSubview(self.menuCloseButton);
        self.menuCloseButton.isHidden = true
        
        let profileHolderImage = UIImage(named: "june_profile_pic_bg.png")
        self.profileImageView = UIImageView(image: profileHolderImage!)
        self.profileImageView.frame = CGRect(x: self.view.frame.size.width * 0.28533333333, y: self.view.frame.size.width * 0.28533333333, width: self.view.frame.size.width * 0.29912, height: self.view.frame.size.width * 0.29912)
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        self.view.addSubview(self.profileImageView)
        self.profileImageView.backgroundColor = .white
        self.profileImageView.contentMode = .scaleToFill
        
        self.fullNameLabel = UILabel(frame: CGRect(x: self.view.frame.size.width * 0.05333333, y: 0.072 * self.view.frame.size.width, width: self.view.frame.size.width - (self.view.frame.size.width * 0.10666667) - (self.view.frame.size.width * 0.17333333), height: 18))
        self.fullNameLabel.textAlignment = .center
        self.fullNameLabel.textColor = .black
        self.fullNameLabel.font = AccountsViewController.fullNameLabelFont
        self.view .addSubview(self.fullNameLabel)
        
        self.usernameLabel = UILabel(frame: CGRect(x: 0.05333333 * self.view.frame.size.width, y: 0.64 * self.view.frame.size.width, width: self.view.frame.size.width - (0.28 * self.view.frame.size.width), height: 0.04266667 * self.view.frame.size.width))
        self.usernameLabel.textAlignment = .center
        self.usernameLabel.textColor = UIColor.init(hexString:"#9E9E9E")
        self.usernameLabel.font = AccountsViewController.usernameLabelFont
        self.view.addSubview(self.usernameLabel)
        
        let line3 = UIView()
        line3.frame = CGRect(x: 0, y: 329, width: self.view.frame.size.width, height: 2)
        line3.backgroundColor = UIColor.init(hexString:"#A19FAB")
        line3.alpha = 0.15
        self.view.addSubview(line3)
        
        self.emailAccountsLabel = UILabel(frame: CGRect(x: 0.074666666 * self.view.frame.size.width, y: 297, width: 0.261333333 * self.view.frame.size.width, height: 0.042666666 * self.view.frame.size.width))
        self.emailAccountsLabel.font = AccountsViewController.emailAccountsLabelFont
        self.emailAccountsLabel.textAlignment = .left
        self.emailAccountsLabel.textColor = UIColor.darkGray
        self.emailAccountsLabel.backgroundColor = .clear
        self.emailAccountsLabel.text = Localized.string(forKey: LocalizedString.AccountsViewEmailAccountsLabelTitle)
        self.view.addSubview(emailAccountsLabel)
  
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: self.view.frame.size.height - 160, width: self.view.frame.size.width, height: 160)
        bottomView.backgroundColor = UIColor.clear
        self.view.addSubview(bottomView)
        
        let line1 = UIView()
        line1.frame = CGRect(x: 0, y: 49, width: self.view.frame.size.width, height: 2)
        line1.backgroundColor = UIColor.init(hexString:"#979797")
        line1.alpha = 0.15
        bottomView.addSubview(line1)
        
        let line2 = UIView()
        line2.frame = CGRect(x: 0, y: 108, width: self.view.frame.size.width, height: 2)
        line2.backgroundColor = UIColor.init(hexString:"#979797")
        line2.alpha = 0.15
        bottomView.addSubview(line2)
        
        let spamIcon = UIImageView()
        spamIcon.image = #imageLiteral(resourceName: "warning_icon")
        spamIcon.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        self.spamButton = UIButton.init(type: .custom)
        self.spamButton.frame = CGRect(x: 32, y: 6, width: 75, height: 16)
        self.spamButton.setTitleColor(UIColor.init(hexString:"#85868C"), for: .normal)
        self.spamButton.setTitle("Spam", for: .normal)
        self.spamButton.titleLabel?.font = AccountsViewController.spamButtonFont
        self.spamButton.titleEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0)
        self.spamButton.addTarget(self, action: #selector(self.spamButtonPressed), for: .touchUpInside)
        self.spamButton.backgroundColor = .clear
        self.spamButton.addSubview(spamIcon)
        bottomView.addSubview(self.spamButton)
        
        let settingsIcon = UIImageView()
        settingsIcon.image = #imageLiteral(resourceName: "settings_cog")
        settingsIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        self.settingsButton = UIButton.init(type: .custom)
        self.settingsButton.frame = CGRect(x: 30, y: 71, width: 128, height: 20)
        self.settingsButton.setTitleColor(UIColor.init(hexString:"#85868C"), for: .normal)
        self.settingsButton.setTitle("Settings", for: .normal)
        self.settingsButton.titleLabel?.font = AccountsViewController.settingsButtonFont
        self.settingsButton.titleEdgeInsets = UIEdgeInsetsMake(2, 17, 1, 1)
        self.settingsButton.addTarget(self, action: #selector(self.settingsButtonPressed), for: .touchUpInside)
        self.settingsButton.backgroundColor = .clear
        self.settingsButton.addSubview(settingsIcon)
        bottomView.addSubview(self.settingsButton)
        
        self.versionLabel = UILabel()
        self.versionLabel.font = AccountsViewController.versionLabelFont
        self.versionLabel.textColor = UIColor.gray
        self.versionLabel.frame = CGRect(x: 24, y: 122, width: 65, height: 16)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    //we are running on iPhone X
                    self.menuCloseButton.frame = CGRect(x: self.view.frame.size.width - (self.view.frame.size.width * 0.17333333), y: 32, width: self.view.frame.size.width * 0.17333333, height: self.view.frame.size.height)
                    bottomView.frame = CGRect(x: 0, y: 635, width: self.view.frame.size.width, height: 217)
                }
            }
        }
        bottomView.addSubview(versionLabel)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) != nil {
                let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                self.versionLabel.text = "V: \(version) " + "(" + " \(build)" + ")"
            }
        }
        
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.menuCloseButton.isHidden = false
        if (self.profilePicture != nil) {
            self.profileImageView.image = self.profilePicture
        }
        pullUserFromFeathers()
    }
    
    
    func pullUserFromFeathers() {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            
            if userObject["_id"] != nil {
                let userID = userObject["_id"] as! String
                FeathersManager.Services.users.request(.get(id:userID , query: nil)).on(value: { response in
                    print(response)
                    let json: Dictionary = JSON(response.data.value).dictionaryObject! 
                    let total = json.keys.count
                    if total > 0 {
            
                        self.userObject = json
                        if self.userObject["username"] != nil {
                            let username = self.userObject["username"] as! String
                            self.usernameLabel.text = "@" + username
                        }

                        self.setProfileImage()
                        
                        self.dataRepository.clear()
                        let primaryAccount = userObject["primary_email"] as? String
                        let jsonObject = JSON(response.data.value)
                        let accounts = jsonObject["accounts"].arrayValue
                        for account in accounts {
                            let userAccount = Account(withJson: account)
                            if let primary = primaryAccount {
                                if userAccount.email == primary {
                                    userAccount.isPrimary = true
                                }
                            }
                            self.dataRepository.append(userAccount)
                        }
                        
                        self.uiInitializer.updateTableViewHeightIFNeeded()
                        self.accountsTableView.reloadData()
                        
                        let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: self.userObject)
                        _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                    }
                }).startWithFailed { (error) in
                    print(error)
                }
                let userIDData = KeyChainManager.stringToNSDATA(string: userID)
                _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userID, data: userIDData)
            }
        }
    }
    
    func setProfileImage() {
        if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
            if userObject["profile_image"] != nil {
                if let profileImagePath = userObject["profile_image"] as? String {
                    Alamofire.request(profileImagePath).responseImage { response in
                        if let image = response.result.value {
                            let scaledImage = image.imageResize(sizeChange: CGSize.init(width: self.view.frame.size.width * 0.29912, height: self.view.frame.size.width * 0.29912))
                            self.profileImageView.image = scaledImage
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.menuCloseButton.isHidden = true
    }
    
    func alertViewClosed() {
        self.menuCloseButton.isHidden = false
        self.pullUserFromFeathers()
    }
    
    func load_image(image_url_string:String, view:UIImageView) {
        
        let image_url: URL = URL(string: image_url_string)!
        let image_from_url_request: URLRequest = URLRequest(url: image_url as URL)
        
        URLSession.shared.dataTask(with: image_from_url_request) {data, response, error in
            if error == nil && data != nil {
                view.image = UIImage(data: data!)
                self.profilePicture = view.image
            } else {
                print("Error : \(String(describing: error?.localizedDescription))");
            }
            }.resume();
    }
}
