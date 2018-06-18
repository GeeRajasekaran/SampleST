//
//  SettingsViewController.swift
//  June
//
//  Created by Joshua Cleetus on 8/8/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import ALCameraViewController
import AlertBar
import SwiftyJSON
import CoreData
import KeychainSwift
import Kingfisher
import NVActivityIndicatorView

class SettingsViewController: UIViewController, NVActivityIndicatorViewable {

    var closeButton : UIButton!
    var closeButtonOverlay : UIButton!
    var titleLabel : UILabel!
    
    var scrollView: UIScrollViewSuperTaps!

    var editPictureButton : UIButton!
    var userFullNameLabel : UILabel!
    var editFullNameButton : UIButton!
    var userNameLabel : UILabel!
    var passwordLabel : UILabel!
    var changePasswordLabel : UILabel!
    var autoRespondNotifications : UILabel!
    var signOutButton : UIButton!
    var notificationSwitch : UISwitch!
    var delegate: SettingsTextFieldDelegate?
    var fullName: String!
    var userName: String!
    var editFullNameImageView : UIImageView!
    var editFullNameTextField : UITextField! = UITextField()
    var editDoneButton : UIButton!
    var changePasswordButton : UIButton!
    var changePasswordBackgroundImageView : UIImageView!
    var originalPasswordTextField : UITextField! = UITextField()
    var changePasswordTextField : UITextField! = UITextField()
    var newPasswordTextField : UITextField! = UITextField()
    var profilePictureImage : UIImage!
    var profilePictureURLString : String!
    var userObject: Dictionary = [String: Any]()
    weak var settingsViewDelegate: SettingsViewDelegate?
    let notificationsDefaults = UserDefaults.standard
    
    var grayView1: UIView!
    var grayView2: UIView!
    var nerrowLine: UIImageView!
    var accountsLabel: UILabel!
    var settingsForFeedLab: UILabel!
    var onboardLabel: UILabel!
    var bottomEditButtton: UIButton!
    var infoButton1: UIButton!
    var infoButton2: UIButton!
    var editButton: UIButton!
    var bottomSubviews: UIView!
    var editButtonActive = false
    var addAccountButton: UIButton!
    var onboardingButton: UIButton!
    var accountsTableView: UITableView = UITableView()
    
    static let editFullNameTextFieldFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .large)
    static let editDoneButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
    static let titleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
    static let originalPasswordTextFieldFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .midSmall)
    static let changePasswordTextFieldFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .midSmall)
    static let newPasswordTextFieldFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .midSmall)
    static let saveButtonFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .midSmall)
    static let userFullNameFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .large)
    static let usernameLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .largeMedium)
    static let changePasswordLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    static let passwordLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let receiveNotificationsFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .midSmall)
    static let autoRespondRequestsFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    static let settingsForFeedLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    static let signOutLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    static let editAccountsLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
    static let bottomEditButttonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
    static let addAccountButtonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)

    //UIInitializer
    lazy var uiInitializer: SettingsUIInitializer = {
        let initializer = SettingsUIInitializer(with: self)
        return initializer
    }()
    
    //UIInitializer for settings for feed edit button action (shows pop up)
    lazy var uiInitializerForEditButton: SettingsForFeedEditAction = {
        let initializer = SettingsForFeedEditAction(with: self)
        return initializer
    }()
    
    //UIInitializer For Change Password Action
    lazy var uiInitializerForPasswordChange: SettingsChangePasswordUIAction = {
        let initializer = SettingsChangePasswordUIAction(with: self)
        return initializer
    }()
    
    //UIInitializer For Info Buttons Action
    lazy var uiInitializerForInfoAlert: SettingsInfoAlertsUIAction = {
        let initializer = SettingsInfoAlertsUIAction(with: self)
        return initializer
    }()
    
    //Data repository
    lazy var dataRepository: AccountDataRepository = {
        let source = AccountDataRepository()
        return source
    }()
    
    //Data source
    lazy var settingsDataSource: SettingsDataSource = {
        let source = SettingsDataSource(with: self.dataRepository)
        return source
    }()
    
    //Delegates
    lazy var accountsDelegate: SettingsDelegate = {
        let delegate = SettingsDelegate(with: self.dataRepository)
        return delegate
    }()
    
    //MARK: - handler
    lazy var linkEmailHandler: LinkEmailHandler = {
        let handler = LinkEmailHandler(with: self)
        handler.onSuccessLinkEmail = onSuccessLinkEmail
        return handler
    }()
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showErrorAlert(message:String) {
        AlertBar.show(.error, message: message)
    }
    
    func showSuccessAlert(message: String) {
        AlertBar.show(.success, message: message)
    }
    
    lazy var onSuccessLinkEmail: (() -> Void) = { [weak self] in
        self?.pullUserFromFeathers()
    }
    
    @objc func editPictureButtonPressed() {
        let croppingEnabled = true
        let croppingParameters = CroppingParameters(isEnabled: croppingEnabled, allowResizing: true, allowMoving: true, minimumSize: CGSize.init(width: 0.4 * (self.view.frame.size.width), height: 0.4 * (self.view.frame.size.width)))
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { [weak self] image, asset in
            if asset != nil {
                let scaledDownImage = image?.scaleDown(withSize: CGSize.init(width: 0.4 * (self?.view.frame.size.width)!, height: 0.4 * (self?.view.frame.size.width)!))
                self?.editPictureButton.setImage(scaledDownImage, for: .normal)
                self?.profilePictureImage = scaledDownImage
                self?.uploadPicture()
            }
            self?.dismiss(animated: true, completion: nil)
        })
        present(cameraViewController, animated: true, completion: nil)
    }
    
    func uploadPicture() {
        let imageData = UIImagePNGRepresentation(self.profilePictureImage) as NSData?
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        FeathersManager.Services.uploadImage.request(.create(data: [
            "uri": "data:image/png;base64," + strBase64!
            ], query: nil))
            .on(value: { response in
                print("upload response ", response)
                self.settingsViewDelegate?.profilePictureEdited(self.profilePictureImage)
          
            })
            .startWithFailed { (error) in
                print(error)
        }

    }
    
    @objc func editFullNameButtonPressed() {
        
        self.editFullNameButton.isEnabled = false
        self.editFullNameImageView = UIImageView.init()
        self.editFullNameImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.editFullNameImageView.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        self.editFullNameImageView.isUserInteractionEnabled = true
        self.view.addSubview(self.editFullNameImageView)
        self.editFullNameImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.editDoneButtonPressed)))
        self.editFullNameImageView.alpha = 0
        
        self.userFullNameLabel.text = ""
        self.editFullNameTextField = UITextField.init()
        self.editFullNameTextField.delegate = self.delegate
        self.editFullNameTextField.frame = CGRect(x: 0.168 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 55, width: 0.552 * self.view.frame.size.width, height: 0.05333333 * self.view.frame.size.width)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                  self.editFullNameTextField.frame = CGRect(x: 0.168 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width, width: 0.552 * self.view.frame.size.width, height: 0.05333333 * self.view.frame.size.width)
                }
            }
        }
        self.editFullNameTextField.borderStyle = .none
        self.editFullNameTextField.backgroundColor = .clear
        self.editFullNameTextField.autocorrectionType = .no
        self.editFullNameTextField.autocapitalizationType = .words
        self.editFullNameTextField.textColor = .black
        self.editFullNameTextField.returnKeyType = .done
        self.editFullNameTextField.font = SettingsViewController.editFullNameTextFieldFont
        self.editFullNameImageView.addSubview(self.editFullNameTextField)
        self.editFullNameTextField.text = self.fullName
        self.editFullNameTextField.becomeFirstResponder()
        
        self.editDoneButton = UIButton.init(type: .custom)
        self.editDoneButton.frame = CGRect(x: 0.74666667 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 55, width: 0.096 * self.view.frame.size.width, height: 0.05333333 * self.view.frame.size.width)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.editDoneButton.frame = CGRect(x: 0.74666667 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width, width: 0.096 * self.view.frame.size.width, height: 0.05333333 * self.view.frame.size.width)
                }
            }
        }
        self.editDoneButton.setTitle(Localized.string(forKey: .SettingsViewEditNameButtonTitle), for: .normal)
        self.editDoneButton.titleLabel?.font = SettingsViewController.editDoneButtonFont
        self.editDoneButton.setTitleColor(UIColor.init(hexString:"65BDFF"), for: .normal)
        self.editDoneButton.addTarget(self, action: #selector(self.editDoneButtonPressed), for: .touchUpInside)
        self.editFullNameImageView.addSubview(self.editDoneButton)
        
        UIView.transition(with: self.editFullNameImageView,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.editFullNameImageView.alpha = 0.75 },
                          completion: nil)
        
    }
    
    @objc func editDoneButtonPressed() {
        if !(self.editFullNameTextField.text?.isEmpty)! && self.editFullNameTextField.text != self.fullName{
            self.updateNameInFeathers()
        } else {
            let boundsWidth:CGFloat = 0.02933333 * self.view.frame.size.width
            self.userFullNameLabel.addIconToLabel(imageName: "june_edit_name_icon", labelText: self.fullName + "  ", bounds_x: 0, bounds_y: 0, boundsWidth: Double(boundsWidth), boundsHeight: Double(boundsWidth))
        }
        self.editFullNameImageView.alpha = 0.75
        UIView.transition(with: self.editFullNameImageView,
                          duration: 0.5, options: .transitionCrossDissolve,
                          animations: {self.editFullNameImageView.alpha = 0},
                          completion: { (success) in
            self.editFullNameImageView.removeFromSuperview()
            self.editFullNameButton.isEnabled = true
        })
    }
    
    func updateNameInFeathers() {
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if userObject["_id"] != nil {
                let userID = userObject["_id"] as! String
                FeathersManager.Services.users.request(.patch(id: userID, data: [
                    "name": self.editFullNameTextField.text!
                    ], query: nil))
                    .on(value: { response in
                        print(response)
                        self.editFullNameButton.isEnabled = true
                        let json:Dictionary = JSON(response.data.value).dictionaryObject as! NSMutableDictionary as Dictionary
                        let total = json.keys.count
                        if total > 0 {
                            self.userObject = json as! Dictionary
                            if self.userObject["name"] != nil {
                                let boundsWidth:CGFloat = 0.02933333 * self.view.frame.size.width
                                self.fullName = self.userObject["name"] as! String
                                self.userFullNameLabel.addIconToLabel(imageName: "june_edit_name_icon", labelText: self.fullName + "  ", bounds_x: 0, bounds_y: 0, boundsWidth: Double(boundsWidth), boundsHeight: Double(boundsWidth))
                                self.settingsViewDelegate?.fullNameEdited(self.fullName)
                                
                            }
                            let userObjectData = KeyChainManager.dictionaryToNSDATA(dictionary: self.userObject)
                            _ = KeyChainManager.save(key: JuneConstants.KeychainKey.userObject, data: userObjectData)
                        }
                        
                    }).startWithFailed { (error) in
                        print(error)
                        self.editFullNameButton.isEnabled = true
                }

            }
        }
    }
    
    @objc func signOutButtonPressed() {
        self.logOutUser()
    }
    
    public func logOutUser() {
        CoreDataManager.sharedInstance.deleteRecords()
        
        FeathersManager.Providers.feathersApp.logout().start()
        KeychainSwift().delete(JuneConstants.Feathers.jwtToken)
        
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginSignupPage()
    }
    
    @objc func notificationSwitchChanged() {
        self.notificationsDefaults.set(notificationSwitch.isOn, forKey: "notificationsSwitch")
        if notificationSwitch.isOn {

            self.infoButton1.isHidden = true
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "requests_auto_response": true
                        ], query: nil))
                    
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
            
        } else {
            self.infoButton1.isHidden = false

            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "requests_auto_response": false
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - change password button action
    @objc func changePasswordButtonPressed() {
        
        self.uiInitializerForPasswordChange.layoutSubviews()
        
        let closeAlertButton = UIButton.init(type: .custom)
         closeAlertButton.frame = CGRect(x: 0.79733333 * self.view.frame.size.width, y: 0.373333333 * self.view.frame.size.width, width: 0.04266667 * self.view.frame.size.width, height: 0.04266667 * self.view.frame.size.width)
        closeAlertButton.setImage(UIImage.init(named: "x_icon"), for: .normal)
        closeAlertButton.addTarget(self, action: #selector(self.closeAlertButtonPressed), for: .touchUpInside)
        self.changePasswordBackgroundImageView.addSubview(closeAlertButton)

        let saveChangesButton = UIButton.init(type: .custom)
         saveChangesButton.frame = CGRect(x: 0.09866667 * self.view.frame.size.width, y: 1.26666666666 * self.view.frame.size.width, width: 0.80533333 * self.view.frame.size.width, height: 0.03733333333 * self.view.frame.size.width)
        saveChangesButton.setTitle(Localized.string(forKey: .SettingsViewSaveChangesButtonTitle), for: .normal)
        saveChangesButton.setTitleColor(UIColor.init(hexString:"#7559FD"), for: .normal)
        saveChangesButton.backgroundColor = .clear
        saveChangesButton.titleLabel?.font = SettingsViewController.saveButtonFont
        saveChangesButton.addTarget(self, action: #selector(self.saveChangesButtonPressed), for: .touchUpInside)
        self.changePasswordBackgroundImageView.addSubview(saveChangesButton)
    }
    
    @objc func saveChangesButtonPressed() {
      
        if (self.originalPasswordTextField.text?.isEmpty)! {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertOldPasswordRequirement))
            return
        } else if (self.changePasswordTextField.text?.isEmpty)! {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertNewPasswordRequirement))
            return
        } else if (self.newPasswordTextField.text?.isEmpty)! {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertReenterNewPassword))
            return
        } else if self.newPasswordTextField.text != self.changePasswordTextField.text {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertNewPasswordMatch))
            return
        } else if self.originalPasswordTextField.text == self.changePasswordTextField.text {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertNewPasswordCannotMatchOldOne))
            return
        } else if (self.originalPasswordTextField.text?.count)! < 8 {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertwrongOldPassword))
            return
        } else if !((self.changePasswordTextField.text?.isEmpty)!) && (self.changePasswordTextField.text?.count)! < 8 {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlert8CharacterRequired))
        } else if !(self.changePasswordTextField.text?.containsLettersAndNumbers)! {
            self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertNumbersCharacterRequirement))
            return
        }  else {
            self.changePasswordButton.isEnabled = false
            self.checkCredentials()
        }
        
    }
    
    func checkCredentials() {
        
        FeathersManager.Providers.feathersApp.authenticate([
            "strategy": JuneConstants.Feathers.strategy,
            "username": self.userName,
            "password": self.changePasswordTextField.text!
            ])
            .on(value: { response in
                print("Feathers Response:", response)
                self.updatePassword()
            })
            .startWithFailed { (error) in
                print(error)
                self.changePasswordButton.isEnabled = true
                self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertCheckPassword))
        }
        
    }
    
    func updatePassword() {
        
        if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
            if userObject["_id"] != nil {
                let userID = userObject["_id"] as! String
                FeathersManager.Services.users.request(.patch(id: userID, data: [
                    "password": self.changePasswordTextField.text!
                    ], query: nil))
                    .on(value: { response in
                        print(response)
                        self.showSuccessAlert(message: Localized.string(forKey: .SettingsViewSuccessAlertPasswordChanged))
                        self.closeAlertButtonPressed()
                    }).startWithFailed { (error) in
                        print(error)
                        self.changePasswordButton.isEnabled = true
                        self.showErrorAlert(message: Localized.string(forKey: .SettingsViewErrorAlertSomethingWrong))
                }
            }
        }
    }
    
    @objc func closeAlertButtonPressed() {
        UIView.transition(with: self.changePasswordBackgroundImageView,
                          duration: 0.5, options: .transitionCrossDissolve,
                          animations: {self.changePasswordBackgroundImageView.alpha = 0},
                          completion: { (success) in
                            self.changePasswordBackgroundImageView.removeFromSuperview()
        })
    }
    
    //MARK: - settings for feed edit button action
    @objc func feedSettingsEditButtonClicked() {
        self.uiInitializerForEditButton.layoutSubviews()
    }
    
    func addBottomSubviews() {
        bottomSubviews = UIView()
        bottomSubviews.frame = CGRect(x: 0, y: 363, width: Int(self.view.frame.size.width), height: 364)
        if UIDevice.current.modelName == "iPhone 8 Plus" ||  UIDevice.current.modelName == "iPhone 7 Plus" || UIDevice.current.modelName == "iPhone 6 Plus" || UIDevice.current.modelName == "iPhone 6s Plus" {
            bottomSubviews.frame = CGRect(x: 0, y: 383, width: Int(self.view.frame.size.width), height: 364)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                   bottomSubviews.frame = CGRect(x: 0, y: 418, width: Int(self.view.frame.size.width), height: 364)
                }
            }
        }
        bottomSubviews.backgroundColor = UIColor.white
        self.scrollView.addSubview(bottomSubviews)
        
        let line1 = UIView(frame: CGRect(x: Int(0.032 * self.view.frame.size.width), y: 84, width: Int(self.view.frame.size.width) - 24, height: 2))
        line1.backgroundColor = UIColor.init(hexString: "BBBED0").withAlphaComponent(0.6)
        bottomSubviews.addSubview(line1)
        
        let line2 = UIView(frame: CGRect(x: Int(0.032 * self.view.frame.size.width), y: 145, width: Int(self.view.frame.size.width) - 24, height: 2))
        line2.backgroundColor = UIColor.init(hexString: "BBBED0").withAlphaComponent(0.6)
        bottomSubviews.addSubview(line2)
        
        let line3 = UIView(frame: CGRect(x: Int(0.032 * self.view.frame.size.width), y: 206, width: Int(self.view.frame.size.width) - 24, height: 2))
        line3.backgroundColor = UIColor.init(hexString: "BBBED0").withAlphaComponent(0.6)
        
        self.grayView2 = UIView()
        self.grayView2.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: 21)
        self.grayView2.backgroundColor = UIColor.init(hexString: "F8FAFA")
        bottomSubviews.addSubview(grayView2)
        
        self.changePasswordLabel = UILabel.init()
        self.changePasswordLabel.frame = CGRect(x: 18, y: 46, width: 0.33333333 * self.view.frame.size.width, height: 0.03733333 * self.view.frame.size.width)
        self.changePasswordLabel.textAlignment = .left
        self.changePasswordLabel.textColor = UIColor.init(hexString:"404040")
        self.changePasswordLabel.font = SettingsViewController.changePasswordLabelFont
        bottomSubviews.addSubview(self.changePasswordLabel)
        self.changePasswordLabel.text = Localized.string(forKey: LocalizedString.SettingsViewChangePasswordLabel)
        
        self.changePasswordButton = UIButton.init(type: .custom)
        self.changePasswordButton.frame = CGRect(x: 18, y: 43, width: self.view.frame.size.width - (0.18133333 * self.view.frame.size.width), height: (0.06666667 * self.view.frame.size.width))
        self.changePasswordButton.backgroundColor = .clear
        self.changePasswordButton.addTarget(self, action: #selector(self.changePasswordButtonPressed), for: .touchUpInside)
        bottomSubviews.addSubview(self.changePasswordButton)
        
        self.passwordLabel = UILabel.init()
        self.passwordLabel.frame = CGRect(x: 262, y: self.changePasswordLabel.frame.origin.y, width: 0.272 * self.view.frame.size.width, height: 0.04533333 * self.view.frame.size.width)
        self.passwordLabel.textAlignment = .right
        self.passwordLabel.textColor = UIColor.init(hexString:"797A83")
        self.passwordLabel.font = SettingsViewController.passwordLabelFont
        bottomSubviews.addSubview(self.passwordLabel)
        self.passwordLabel.text = Localized.string(forKey: LocalizedString.SettingsViewPasswordLabel)
        
        self.autoRespondNotifications = UILabel.init()
        self.autoRespondNotifications.frame = CGRect(x: 17, y:  105, width: 200, height: 0.03733333 * self.view.frame.size.width)
        self.autoRespondNotifications.textAlignment = .left
        self.autoRespondNotifications.textColor = UIColor.init(hexString:"404040")
        self.autoRespondNotifications.font = SettingsViewController.autoRespondRequestsFont
        self.autoRespondNotifications.text = Localized.string(forKey: LocalizedString.SettingsViewReceiveNotificationsLabel)
        bottomSubviews.addSubview(autoRespondNotifications)
        
        self.notificationSwitch = UISwitch.init()
        self.notificationSwitch.frame = CGRect(x: 312, y: 96, width: 0.136 * self.view.frame.size.width, height: 0.08266667 * self.view.frame.size.width)
        self.notificationSwitch.addTarget(self, action: #selector(self.notificationSwitchChanged), for: .valueChanged)
        self.notificationSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        self.notificationSwitch.isOn = self.notificationsDefaults.bool(forKey: "notificationsSwitch")
        bottomSubviews.addSubview(self.notificationSwitch)
        
        self.settingsForFeedLab = UILabel.init()
        self.settingsForFeedLab.frame = CGRect(x: self.changePasswordLabel.frame.origin.x, y: 164, width: 110, height: 16)
        self.settingsForFeedLab.textAlignment = .left
        self.settingsForFeedLab.font = SettingsViewController.settingsForFeedLabelFont
        self.settingsForFeedLab.textColor = UIColor.init(hexString:"404040")
        self.settingsForFeedLab.text = Localized.string(forKey: .SettingsViewSettingsForFeedTitle)
        
        self.bottomEditButtton = UIButton()
        self.bottomEditButtton.frame = CGRect(x: 312, y: 165, width: 53, height: 24)
        self.bottomEditButtton.layer.cornerRadius = self.bottomEditButtton.frame.size.height / 2
        self.bottomEditButtton.layer.borderColor = (UIColor.init(hexString: "#B7B7B7").cgColor)
        self.bottomEditButtton.layer.borderWidth = 1.5
        self.bottomEditButtton.setTitle(Localized.string(forKey: .SettingsViewBottomEditButtonTitle), for: .normal)
        self.bottomEditButtton.setTitleColor(UIColor.init(hexString: "#4A4A4A"), for: .normal)
        self.bottomEditButtton.titleLabel?.font = SettingsViewController.bottomEditButttonFont
        self.bottomEditButtton.addTarget(self, action: #selector(self.feedSettingsEditButtonClicked), for: .touchUpInside)
        
        self.infoButton1 = UIButton()
        self.infoButton1.frame = CGRect(x: 179, y: 99, width: 0.066666666 * self.view.frame.size.width, height: 0.066666666 * self.view.frame.size.width)
        self.infoButton1.addTarget(self, action: #selector(self.info1AutoRespondClicked), for: .touchUpInside)
        self.infoButton1.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.infoButton1.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        self.infoButton1.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        bottomSubviews.addSubview(infoButton1)
   
        self.infoButton2 = UIButton()
        self.infoButton2.frame = CGRect(x: 126, y: 160, width: 0.066666666 * self.view.frame.size.width, height: 0.066666666 * self.view.frame.size.width)
        self.infoButton2.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        self.infoButton2.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        self.infoButton2.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.infoButton2.addTarget(self, action: #selector(self.info2SettingsForFeedClicked), for: .touchUpInside)
 
        self.signOutButton = UIButton.init(type: .custom)
        self.signOutButton.frame = CGRect(x: 0.31466667 * self.view.frame.size.width, y: line3.frame.origin.y + 29, width: 0.370666666 * self.view.frame.size.width, height: 0.12 * self.view.frame.size.width)
        self.signOutButton.addTarget(self, action: #selector(self.signOutButtonPressed), for: .touchUpInside)
        bottomSubviews.addSubview(self.signOutButton)
        
        let signoutOval = UIImageView()
        signoutOval.frame = CGRect(x: 0, y: 0, width: self.signOutButton.frame.size.width, height: self.signOutButton.frame.size.height)
        signoutOval.image = #imageLiteral(resourceName: "signout_oval")
        self.signOutButton.addSubview(signoutOval)
        
        let signoutIcon = UIImageView()
        signoutIcon.frame = CGRect(x: 0.064 * self.view.frame.size.width, y: 0.034666666 * self.view.frame.size.width, width: 0.2186666666 * self.view.frame.size.width, height: 0.050666666 * self.view.frame.size.width)
        signoutIcon.image = #imageLiteral(resourceName: "bt_sign_out")
        self.signOutButton.addSubview(signoutIcon)
       
        
        self.onboardLabel = UILabel.init()
        self.onboardLabel.frame = CGRect(x: self.changePasswordLabel.frame.origin.x, y: 164, width: 110, height: 16)
        self.onboardLabel.textAlignment = .left
        self.onboardLabel.font = SettingsViewController.settingsForFeedLabelFont
        self.onboardLabel.textColor = UIColor.init(hexString:"404040")
        self.onboardLabel.text = "Onboarding"
        bottomSubviews.addSubview(onboardLabel)
        
        self.onboardingButton = UIButton()
        self.onboardingButton.frame = CGRect(x: 245, y: 164, width: 120, height: 0.066666666 * self.view.frame.size.width)
        self.onboardingButton.addTarget(self, action: #selector(self.showOnboarding), for: .touchUpInside)
        self.onboardingButton.setTitle("Getting Started", for: .normal)
        self.onboardingButton.setTitleColor(UIColor.init(hexString:"404040"), for: .normal)
        self.onboardingButton.layer.cornerRadius = self.bottomEditButtton.frame.size.height / 2
        self.onboardingButton.layer.borderColor = (UIColor.init(hexString: "#B7B7B7").cgColor)
        self.onboardingButton.layer.borderWidth = 1.5
        self.onboardingButton.titleLabel?.font = SettingsViewController.bottomEditButttonFont
        bottomSubviews.addSubview(onboardingButton)

    }
    
    @objc func showOnboarding() {
        let onboard = PageView(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        onboard.modalTransitionStyle = .crossDissolve
        self.present(onboard, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.delegate = SettingsTextFieldDelegate(parentVC: self)
        
        linkEmailHandler.subscribeForLinkNotifications()
        
        let screenWidth = self.view.frame.size.width
        
        scrollView = UIScrollViewSuperTaps(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 718)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.isUserInteractionEnabled = true
        self.view.addSubview(scrollView)
        
        uiInitializer.layoutSubviews()
        
        self.userFullNameLabel = UILabel.init()
        self.userFullNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 55, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.05333333 * self.view.frame.size.width)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.userFullNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.05333333 * self.view.frame.size.width)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.userFullNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.05333333 * self.view.frame.size.width)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.userFullNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.05333333 * self.view.frame.size.width)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.userFullNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.05333333 * self.view.frame.size.width)
        } 
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.userFullNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.70133333 * self.view.frame.size.width, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.05333333 * self.view.frame.size.width)
                }
            }
        }
        self.userFullNameLabel.textAlignment = .center
        self.userFullNameLabel.textColor = .black
        self.userFullNameLabel.font = SettingsViewController.userFullNameFont
        self.scrollView.addSubview(userFullNameLabel)
        
        self.editFullNameButton = UIButton.init(type: .custom)
        self.editFullNameButton.frame = self.userFullNameLabel.frame
        self.editFullNameButton.addTarget(self, action: #selector(self.editFullNameButtonPressed), for: .touchUpInside)
        self.editFullNameButton.backgroundColor = .clear
        self.scrollView.addSubview(editFullNameButton)
        
        self.userNameLabel = UILabel.init()
        self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth - 55, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
        } else {
            self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth - 75, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.userNameLabel.frame = CGRect(x: 0.08 * self.view.frame.size.width, y: 0.73866666 * screenWidth, width: self.view.frame.size.width - (0.16 * self.view.frame.size.width), height: 0.048 * self.view.frame.size.width)
                }
            }
        }
        self.userNameLabel.textAlignment = .center
        self.userNameLabel.textColor = UIColor.black.withAlphaComponent(0.51)
        self.userNameLabel.font = SettingsViewController.usernameLabelFont
        self.userNameLabel.text = Localized.string(forKey: LocalizedString.SettingsViewUserNameLabel)
        self.scrollView.addSubview(userNameLabel)
        
        self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth - 55, width: self.view.frame.size.width, height: 0.056 * screenWidth))
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth - 75, width: self.view.frame.size.width, height: 0.056 * screenWidth))
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth - 75, width: self.view.frame.size.width, height: 0.056 * screenWidth))
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth - 75, width: self.view.frame.size.width, height: 0.056 * screenWidth))
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth - 75, width: self.view.frame.size.width, height: 0.056 * screenWidth))
        } else {
            self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth - 75, width: self.view.frame.size.width, height: 0.056 * screenWidth))
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.grayView1 = UIView(frame: CGRect(x: 0, y: 0.869333333 * screenWidth, width: self.view.frame.size.width, height: 0.056 * screenWidth))
                }
            }
        }
        self.grayView1.backgroundColor = UIColor.init(hexString: "F8FAFA")
        self.scrollView.addSubview(grayView1)
        
        self.accountsLabel = UILabel()
        self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth - 55, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth - 75, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth - 75, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth - 75, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth - 75, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
        } else {
            self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth - 75, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.accountsLabel.frame = CGRect(x: 0.053333333 * screenWidth, y: 1.00533333 * screenWidth, width: 0.264 * screenWidth, height: 0.04266666 * screenWidth)
                }
            }
        }
        self.accountsLabel.text = Localized.string(forKey: .SettingsViewEditAccountsTitle)
        self.accountsLabel.font = SettingsViewController.editAccountsLabelFont
        self.accountsLabel.textColor = UIColor.init(hexString: "#404040")
        self.scrollView.addSubview(accountsLabel)
        
        self.editButton = UIButton()
        self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth - 55, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth - 75, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth - 75, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth - 75, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth - 75, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
        } else {
            self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth - 75, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.editButton.frame = CGRect(x: 0.8106666666 * screenWidth, y: 0.98666666 * screenWidth, width: 0.1653333333 * screenWidth, height: 0.085333333 * screenWidth)
                }
            }
        }
        self.editButton.layer.cornerRadius = self.editButton.frame.size.height / 2
        self.editButton.layer.borderColor = (UIColor.init(hexString: "#CBCECE").cgColor)
        self.editButton.layer.borderWidth = 1.5
        self.editButton.setTitle(Localized.string(forKey: .SettingsViewEditButtonTitle), for: .normal)
        self.editButton.setTitleColor(UIColor.init(hexString: "#404040"), for: .normal)
        self.editButton.titleLabel?.font = SettingsViewController.editDoneButtonFont
        self.editButton.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15)
        self.editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        self.scrollView.addSubview(editButton)
        
        let plusIcon = UIImageView()
        plusIcon.image = #imageLiteral(resourceName: "add_icon")
        plusIcon.frame = CGRect(x: 0.290666666 * screenWidth, y: 0.01333333333 * screenWidth, width: 0.0586666666 * screenWidth, height: 0.0586666666 * screenWidth)
        
        self.addAccountButton = UIButton()
        self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 383, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 403, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 403, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 403, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 403, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
        } else {
            self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 403, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.addAccountButton.frame = CGRect(x: 0.592 * screenWidth, y: 438, width: 0.370666666 * screenWidth, height: 0.0853333333 * screenWidth)
                }
            }
        }
        self.addAccountButton.layer.borderColor = (UIColor.init(hexString: "CBCECE").cgColor)
        self.addAccountButton.layer.borderWidth = 1
        self.addAccountButton.layer.cornerRadius = self.addAccountButton.frame.height / 2
        self.addAccountButton.setTitleColor(UIColor.init(hexString: "#404040"), for: .normal)
        self.addAccountButton.titleLabel?.font = SettingsViewController.addAccountButtonFont
        self.addAccountButton.setTitle(Localized.string(forKey: .SettingsViewAddAccountButtonTitle), for: .normal)
        self.addAccountButton.contentEdgeInsets = UIEdgeInsetsMake(8, 22, 8, 31)
        self.addAccountButton.addTarget(self, action: #selector(addAccountButtonClicked), for: .touchUpInside)
        self.scrollView.addSubview(addAccountButton)
        self.addAccountButton.addSubview(plusIcon)
        
        addBottomSubviews()
        
        if self.fullName != nil {
            if !self.fullName.isEmpty {
                let boundsWidth:CGFloat = 0.02933333 * self.view.frame.size.width
                let boundsHeight:CGFloat = boundsWidth
                self.userFullNameLabel.addIconToLabel(imageName: "june_edit_name_icon", labelText: self.fullName + "  ", bounds_x: 0, bounds_y: 0, boundsWidth: Double(boundsWidth), boundsHeight: Double(boundsHeight))
            }
        }
        
        if self.profilePictureImage != nil {
            self.editPictureButton.setImage(self.profilePictureImage, for: .normal)
        }
        
        if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
            if userObject["username"] != nil {
                self.userName = userObject["username"] as! String
                self.userNameLabel.text = "@" + self.userName
            }
        }
    }
    
    @objc func info1AutoRespondClicked() {
        self.uiInitializerForInfoAlert.layoutSubviewsAutoRespond()
        
    }
    
    @objc func info2SettingsForFeedClicked() {
        self.uiInitializerForInfoAlert.layoutSubviewsSettingsForFeed()
    }
    
//    Add Account BUtton Action
    @objc func addAccountButtonClicked() {
        let addAccountAlertVC = AddAccountAlertViewController()
        let navigationController = UINavigationController(rootViewController: addAccountAlertVC)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
    
// Top Edit Button Action
    @objc func editButtonClicked() {
        print("edit active: \(editButtonActive)")
        if self.editButtonActive == false {
            self.editButtonActive = true
            
            self.editButton.setTitle(Localized.string(forKey: .SettingsViewEditButtonDoneTitle), for: .normal)
            self.editButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 14)
            self.editButton.layer.borderColor = (UIColor.init(hexString: "#006AFF").cgColor)
            self.editButton.setTitleColor(UIColor.init(hexString: "#2548FF"), for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomSubviews.frame.origin.y += 71
                self.scrollView.frame.size.height += 71
                self.scrollView.contentInset.bottom += 71
                
            })
            
            if self.editButtonActive == true {
                self.accountsTableView.reloadData()
            }
      
             self.accountsTableView.reloadData()
        } else {
            self.editButton.setTitle(Localized.string(forKey: .SettingsViewEditButtonTitle), for: .normal)
            self.editButton.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15)
            self.editButton.layer.borderColor = (UIColor.init(hexString: "#CBCECE").cgColor)
            self.editButton.setTitleColor(UIColor.init(hexString: "#404040"), for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomSubviews.frame.origin.y -= 71
                self.scrollView.frame.size.height -= 71
                self.scrollView.contentInset.bottom -= 71
            })
            
            self.editButtonActive = false
            self.accountsTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

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
                        
                        self.dataRepository.clear()
                        let primaryAccount = userObject["primary_email"] as? String
                        let jsonObject = JSON(response.data.value)
                        let accounts = jsonObject["accounts"].arrayValue
                        for account in accounts {
                            let userAccount = AccountModel(withJson: account)
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

}
