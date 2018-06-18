//
//  SettingsForFeedEditAction.swift
//  June
//
//  Created by Tatia Chachua on 25/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsForFeedEditAction: NSObject {

    private unowned var parentVC: SettingsViewController
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Public Part
    init(with controller: SettingsViewController) {
        parentVC = controller
    }
    
    //MARK: - fonts
    static let titleFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .mediumLarge)
    static let descriptionLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
    static let categoriesLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
    static let batchLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
    static let mainListFonts: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .extra)
    static let miniPopupTitleFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .mediumLarge)
    static let miniPopupDescriptionFont : UIFont = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
    
    // MARK: - Variables & Constants
    var backgroundImageView: UIImageView!
    var alertView: UIImageView!
    var closeButton: UIButton!
    
    var title: UILabel!
    var descriptionLabel: UILabel!
    var categoriesLabel: UILabel!
    var batchLabel: UILabel!
    
    private var tapGesture: UITapGestureRecognizer!
    private var tap: UITapGestureRecognizer!
    
    private var newsLabel: UILabel!
    private var promosLabel: UILabel!
    private var socialLabel: UILabel!
    private var tripsLabel: UILabel!
    private var purchasesLabel: UILabel!
    private var financeLabel: UILabel!
    
    private var newsInfoButton: UIButton!
    private var promosInfoButton: UIButton!
    private var socialInfoButton: UIButton!
    private var tripsInfoButton: UIButton!
    private var purchasesInfoButton: UIButton!
    private var financeInfoButton: UIButton!
    
    private var miniPopupView: UIImageView!
    private var miniPopupTitle: UILabel!
    private var miniPopopDescription: UILabel!
    
    let newsDefaults = UserDefaults.standard
    let promosDefaults = UserDefaults.standard
    let socialDefaults = UserDefaults.standard
    let tripsDefaults = UserDefaults.standard
    let purchasesDefaults = UserDefaults.standard
    let financeDefaults = UserDefaults.standard
    
    
    var newsSwitch: UISwitch!
    var promosSwitch: UISwitch!
    var socialSwitch: UISwitch!
    var tripsSwitch: UISwitch!
    var purchasesSwitch: UISwitch!
    var financeSwitch: UISwitch!
    
    func layoutSubviews() {
        addBackgrounds()
        addCloseButtonTopTitles()
        addDeviderLines()
        addIcons()
        addListLabels()
        addInfoButtons()
        addSwitches()
    }
    
    //MARK: - Gray & white background
    func addBackgrounds() {
        
        self.tapGesture = UITapGestureRecognizer()
        self.tapGesture.numberOfTapsRequired = 1
        self.tapGesture.addTarget(self, action: #selector(self.tappedToClose))
        
        self.backgroundImageView = UIImageView.init()
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: parentVC.view.frame.size.height)
        self.backgroundImageView.backgroundColor = UIColor.clear
        self.backgroundImageView.image = UIImage(named: "blur_black.png")
        self.backgroundImageView.isUserInteractionEnabled = true
        parentVC.view.addSubview(self.backgroundImageView)
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 144)
        backgroundImageView.addSubview(v)
        v.addGestureRecognizer(tapGesture)

        tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(self.tapped))
        
        self.alertView = UIImageView.init()
        self.alertView.frame = CGRect(x: 27, y: 0.384 * screenWidth - 55, width: screenWidth - 54, height: 534)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.alertView.frame = CGRect(x: 27, y: 0.384 * screenWidth, width: 326, height: 534)
                }
            }
        }
        self.alertView.backgroundColor = .white
        self.alertView.layer.cornerRadius = 12
        self.alertView.addGestureRecognizer(tap)
        self.backgroundImageView.addSubview(self.alertView)
    }
    
    @objc func tapped() {
        self.miniPopupView.isHidden = true
    }
    
    //MARK: - close button & top titles
    func addCloseButtonTopTitles() {
        self.closeButton = UIButton.init(type: .custom)
        closeButton.frame = CGRect(x: 0.12 * screenWidth, y: 167 - 55, width: 0.0426666666 * screenWidth, height: 0.0426666666 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    closeButton.frame = CGRect(x: 0.12 * screenWidth, y: 167, width: 0.0426666666 * screenWidth, height: 0.0426666666 * screenWidth)
                }
            }
        }
        closeButton.setImage(UIImage.init(named: "cross_icon"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        self.backgroundImageView.addSubview(closeButton)
        
        self.title = UILabel()
        title.frame = CGRect(x: 97, y: 36, width: 131, height: 21)
        title.textColor = UIColor.init(hexString: "000000")
        title.font = SettingsForFeedEditAction.titleFont
        title.text = Localized.string(forKey: LocalizedString.SettingsForFeedTitle)
        self.alertView.addSubview(title)
        
        self.descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 31, y: 69, width: 256, height: 51)
        descriptionLabel.textColor = UIColor.init(hexString: "000000")
        descriptionLabel.font = SettingsForFeedEditAction.descriptionLabelFont
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionTitle)
        self.alertView.addSubview(descriptionLabel)
        
        self.categoriesLabel = UILabel()
        categoriesLabel.frame = CGRect(x: 28, y: 141, width: 87, height: 15)
        categoriesLabel.textColor = UIColor.init(hexString: "000000")
        categoriesLabel.font = SettingsForFeedEditAction.categoriesLabelFont
        categoriesLabel.text = Localized.string(forKey: .SettingsViewEditPopupCategoriesTitle)
        self.alertView.addSubview(categoriesLabel)
        
        self.batchLabel = UILabel()
        batchLabel.frame = CGRect(x: 263, y: 142, width: 32, height: 15)
        batchLabel.textColor = UIColor.init(hexString: "000000")
        batchLabel.font = SettingsForFeedEditAction.batchLabelFont
        batchLabel.text = Localized.string(forKey: .SettingsViewEditPopupBatchTitle)
        self.alertView.addSubview(batchLabel)
        
    }
    
    //MARK: - Devider lines
    func addDeviderLines() {
        let line1 = UIView()
        line1.frame = CGRect(x: 0, y: Int(166.5), width: Int(self.alertView.frame.size.width), height: 1)
        line1.backgroundColor = UIColor.init(hexString: "979797").withAlphaComponent(0.2)
        alertView.addSubview(line1)
        
        let line2 = UIView()
        line2.frame = CGRect(x: 0, y: Int(229.5), width: Int(self.alertView.frame.size.width), height: 1)
        line2.backgroundColor = UIColor.init(hexString: "979797").withAlphaComponent(0.2)
        alertView.addSubview(line2)
        
        let line3 = UIView()
        line3.frame = CGRect(x: 0, y: Int(288.5), width: Int(self.alertView.frame.size.width), height: 1)
        line3.backgroundColor = UIColor.init(hexString: "979797").withAlphaComponent(0.2)
        alertView.addSubview(line3)
        
        let line4 = UIView()
        line4.frame = CGRect(x: 0, y: Int(347.5), width: Int(self.alertView.frame.size.width), height: 1)
        line4.backgroundColor = UIColor.init(hexString: "979797").withAlphaComponent(0.2)
        alertView.addSubview(line4)
        
        let line5 = UIView()
        line5.frame = CGRect(x: 0, y: Int(406.5), width: Int(self.alertView.frame.size.width), height: 1)
        line5.backgroundColor = UIColor.init(hexString: "979797").withAlphaComponent(0.2)
        alertView.addSubview(line5)
        
        let line6 = UIView()
        line6.frame = CGRect(x: 0, y: Int(466.5), width: Int(self.alertView.frame.size.width), height: 1)
        line6.backgroundColor = UIColor.init(hexString: "979797").withAlphaComponent(0.2)
        alertView.addSubview(line6)
    }
    
    //MARK: - Icons
    func addIcons() {
        let newsIcon = UIImageView()
        newsIcon.frame = CGRect(x: 28, y: 192, width: 20, height: 16)
        newsIcon.image = #imageLiteral(resourceName: "news_icon")
        alertView.addSubview(newsIcon)
        
        let promosIcon = UIImageView()
        promosIcon.frame = CGRect(x: 29, y: 250, width: 21, height: 17)
        promosIcon.image = #imageLiteral(resourceName: "tag")
        alertView.addSubview(promosIcon)
    
        let socialIcon = UIImageView()
        socialIcon.frame = CGRect(x: 28, y: 310, width: 16, height: 17)
        socialIcon.image = #imageLiteral(resourceName: "social_icon")
        alertView.addSubview(socialIcon)
        
        let tripsIcon = UIImageView()
        tripsIcon.frame = CGRect(x: 28, y: 371, width: 17, height: 16)
        tripsIcon.image = #imageLiteral(resourceName: "transport")
        alertView.addSubview(tripsIcon)
        
        let purchasesIcon = UIImageView()
        purchasesIcon.frame = CGRect(x: 28, y: 430, width: 16, height: 18)
        purchasesIcon.image = #imageLiteral(resourceName: "receipt")
        alertView.addSubview(purchasesIcon)
        
        let financeIcon = UIImageView()
        financeIcon.frame = CGRect(x: 26, y: 490, width: 22, height: 14)
        financeIcon.image = #imageLiteral(resourceName: "piggy-bank")
        alertView.addSubview(financeIcon)
    }
    
    //MARK: - Main list labels
    func addListLabels() {
        
        newsLabel = UILabel()
        newsLabel.frame = CGRect(x: 61, y: 188, width: 51, height: 24)
        newsLabel.font = SettingsForFeedEditAction.mainListFonts
        newsLabel.textColor = UIColor.init(hexString: "000000")
        newsLabel.text = Localized.string(forKey: .SettingsViewEditPopupNewsTitle)
        alertView.addSubview(newsLabel)
        
        promosLabel = UILabel()
        promosLabel.frame = CGRect(x: 61, y: 246, width: 69, height: 24)
        promosLabel.font = SettingsForFeedEditAction.mainListFonts
        promosLabel.textColor = UIColor.init(hexString: "000000")
        promosLabel.text = Localized.string(forKey: .SettingsViewEditPopupPromosTitle)
        alertView.addSubview(promosLabel)
        
        socialLabel = UILabel()
        socialLabel.frame = CGRect(x: 61, y: 307, width: 53, height: 24)
        socialLabel.font = SettingsForFeedEditAction.mainListFonts
        socialLabel.textColor = UIColor.init(hexString: "000000")
        socialLabel.text = Localized.string(forKey: .SettingsViewEditPopupSocialTitle)
        alertView.addSubview(socialLabel)
       
        tripsLabel = UILabel()
        tripsLabel.frame = CGRect(x: 62, y: 368, width: 44, height: 24)
        tripsLabel.font = SettingsForFeedEditAction.mainListFonts
        tripsLabel.textColor = UIColor.init(hexString: "000000")
        tripsLabel.text = Localized.string(forKey: .SettingsViewEditPopupTripsTitle)
        alertView.addSubview(tripsLabel)
        
        purchasesLabel = UILabel()
        purchasesLabel.frame = CGRect(x: 61, y: 426, width: 92, height: 24)
        purchasesLabel.font = SettingsForFeedEditAction.mainListFonts
        purchasesLabel.textColor = UIColor.init(hexString: "000000")
        purchasesLabel.text = Localized.string(forKey: .SettingsViewEditPopupPurchasesTitle)
        alertView.addSubview(purchasesLabel)
        
        financeLabel = UILabel()
        financeLabel.frame = CGRect(x: 61, y: 486, width: 71, height: 24)
        financeLabel.font = SettingsForFeedEditAction.mainListFonts
        financeLabel.textColor = UIColor.init(hexString: "000000")
        financeLabel.text = Localized.string(forKey: .SettingsViewEditPopupFinanceTitle)
        alertView.addSubview(financeLabel)

    }
    
    //MARK: - Info buttons
    func addInfoButtons() {
        
        newsInfoButton = UIButton()
        newsInfoButton.frame = CGRect(x: 145, y: 338 - 55, width: 15, height: 15)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                  newsInfoButton.frame = CGRect(x: 145, y: 338, width: 15, height: 15)
                }
            }
        }
        newsInfoButton.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        newsInfoButton.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        newsInfoButton.addTarget(self, action: #selector(self.newsButtonClicked), for: .touchUpInside)
        backgroundImageView.addSubview(newsInfoButton)
        
        promosInfoButton = UIButton()
        promosInfoButton.frame = CGRect(x: 165, y: 396 - 55, width: 15, height: 15)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    promosInfoButton.frame = CGRect(x: 165, y: 396, width: 15, height: 15)
                }
            }
        }
        promosInfoButton.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        promosInfoButton.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        promosInfoButton.addTarget(self, action: #selector(self.promosButtonClicked), for: .touchUpInside)
        backgroundImageView.addSubview(promosInfoButton)
        
        socialInfoButton = UIButton()
        socialInfoButton.frame = CGRect(x: 146, y: 456 - 55, width: 15, height: 15)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    socialInfoButton.frame = CGRect(x: 146, y: 456, width: 15, height: 15)
                }
            }
        }
        socialInfoButton.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        socialInfoButton.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        socialInfoButton.addTarget(self, action: #selector(self.socialButtonClicked), for: .touchUpInside)
        backgroundImageView.addSubview(socialInfoButton)
        
        tripsInfoButton = UIButton()
        tripsInfoButton.frame = CGRect(x: 142, y: 518 - 55, width: 15, height: 15)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    tripsInfoButton.frame = CGRect(x: 142, y: 518, width: 15, height: 15)
                }
            }
        }
        tripsInfoButton.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        tripsInfoButton.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        tripsInfoButton.addTarget(self, action: #selector(self.tripsButtonClicked), for: .touchUpInside)
        backgroundImageView.addSubview(tripsInfoButton)
        
        purchasesInfoButton = UIButton()
        purchasesInfoButton.frame = CGRect(x: 188, y: 577 - 55, width: 15, height: 15)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    purchasesInfoButton.frame = CGRect(x: 188, y: 577, width: 15, height: 15)
                }
            }
        }
        purchasesInfoButton.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        purchasesInfoButton.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        purchasesInfoButton.addTarget(self, action: #selector(self.purchasesButtonClicked), for: .touchUpInside)
        backgroundImageView.addSubview(purchasesInfoButton)
        
        financeInfoButton = UIButton()
        financeInfoButton.frame = CGRect(x: 165, y: 636 - 55, width: 15, height: 15)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    financeInfoButton.frame = CGRect(x: 165, y: 636, width: 15, height: 15)
                }
            }
        }
        financeInfoButton.setImage(UIImage(named: "rounded-info-button"), for: .normal)
        financeInfoButton.setImage(UIImage(named: "dark_info_button"), for: .highlighted)
        financeInfoButton.addTarget(self, action: #selector(self.financeButtonClicked), for: .touchUpInside)
        backgroundImageView.addSubview(financeInfoButton)
        
        // mini pop up view
        miniPopupView = UIImageView()
        miniPopupView.image = #imageLiteral(resourceName: "mini_popup_rectangle")
        miniPopupView.frame = CGRect(x: 35, y: Int(self.newsInfoButton.frame.origin.y - 119) - 55, width: 219, height: 113)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                     miniPopupView.frame = CGRect(x: 35, y: self.newsInfoButton.frame.origin.y - 119, width: 219, height: 113)
                }
            }
        }
        miniPopupView.isHidden = true
        self.backgroundImageView.addSubview(miniPopupView)
        
        miniPopupTitle = UILabel()
        miniPopupTitle.frame = CGRect(x: 44, y: 29, width: 131, height: 21)
        miniPopupTitle.font = SettingsForFeedEditAction.miniPopupTitleFont
        miniPopupTitle.text = Localized.string(forKey: .SettingsViewEditPopupMiniPopupTitle)
        miniPopupView.addSubview(miniPopupTitle)
        
        miniPopopDescription = UILabel()
        miniPopopDescription.frame = CGRect(x: 16, y: 52, width: 187, height: 34)
        miniPopopDescription.font = SettingsForFeedEditAction.miniPopupDescriptionFont
        miniPopopDescription.textColor = UIColor.init(hexString: "000000")
        miniPopopDescription.numberOfLines = 0
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForNewsInfo)
        miniPopopDescription.textAlignment = .center
        miniPopupView.addSubview(miniPopopDescription)
    }
    
    //MARK: - Info button actions
    @objc func newsButtonClicked() {
        
        miniPopupView.frame = CGRect(x: 35, y: self.newsInfoButton.frame.origin.y - 119, width: 219, height: 113)
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForNewsInfo)
        
        if self.miniPopupView.isHidden == true {
            self.miniPopupView.isHidden = false
        } else {
            self.miniPopupView.isHidden = true
        }
    }
    
    @objc func promosButtonClicked() {
      
        miniPopupView.frame = CGRect(x: 35, y: self.promosInfoButton.frame.origin.y - 119, width: 219, height: 113)
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForPromosInfo)
        
        if self.miniPopupView.isHidden == true {
            self.miniPopupView.isHidden = false
        } else {
            self.miniPopupView.isHidden = true
        }
    }
    
    @objc func socialButtonClicked() {
        
        miniPopupView.frame = CGRect(x: 35, y: self.socialInfoButton.frame.origin.y - 119, width: 219, height: 113)
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForSocialInfo) // "Includes messages about your social media accounts."
        
        if self.miniPopupView.isHidden == true {
            self.miniPopupView.isHidden = false
        } else {
            self.miniPopupView.isHidden = true
        }
    }
    
    @objc func tripsButtonClicked() {
        
        miniPopupView.frame = CGRect(x: 35, y: self.tripsInfoButton.frame.origin.y - 119, width: 219, height: 113)
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForTripsInfo)
        
        if self.miniPopupView.isHidden == true {
            self.miniPopupView.isHidden = false
        } else {
            self.miniPopupView.isHidden = true
        }
    }
    
    @objc func purchasesButtonClicked() {
        
        miniPopupView.frame = CGRect(x: 35, y: self.purchasesInfoButton.frame.origin.y - 119, width: 219, height: 113)
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForPurchasesInfo)
        
        if self.miniPopupView.isHidden == true {
            self.miniPopupView.isHidden = false
        } else {
            self.miniPopupView.isHidden = true
        }
    }
    
    @objc func financeButtonClicked() {
        
        miniPopupView.frame = CGRect(x: 35, y: self.financeInfoButton.frame.origin.y - 119, width: 219, height: 113)
        miniPopopDescription.text = Localized.string(forKey: .SettingsViewEditPopupDescriptionForFinanceInfo)
        
        if self.miniPopupView.isHidden == true {
            self.miniPopupView.isHidden = false
        } else {
            self.miniPopupView.isHidden = true
        }
    }
  
    //MARK: - Switches
    func addSwitches() {
        
        newsSwitch = UISwitch()
        newsSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 328 - 55, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    newsSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 328, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
                }
            }
        }
        newsSwitch.addTarget(self, action: #selector(self.newsSwitchChanged), for: .valueChanged)
        newsSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        newsSwitch.isOn = self.newsDefaults.bool(forKey: "newsSwitch")
        backgroundImageView.addSubview(self.newsSwitch)
        
        promosSwitch = UISwitch()
        promosSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 387 - 55, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    promosSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 387, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
                }
            }
        }
        promosSwitch.addTarget(self, action: #selector(self.promosSwitchChanged), for: .valueChanged)
        promosSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        promosSwitch.isOn = self.promosDefaults.bool(forKey: "promosSwitch")
        backgroundImageView.addSubview(self.promosSwitch)
        
        socialSwitch = UISwitch()
        socialSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 447 - 55, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    socialSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 447, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
                }
            }
        }
        socialSwitch.addTarget(self, action: #selector(self.socialSwitchChanged), for: .valueChanged)
        socialSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        socialSwitch.isOn = self.socialDefaults.bool(forKey: "socialSwitch")
        backgroundImageView.addSubview(self.socialSwitch)
        
        tripsSwitch = UISwitch()
        tripsSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 507 - 55, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    tripsSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 507, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
                }
            }
        }
        tripsSwitch.addTarget(self, action: #selector(self.tripsSwitchChanged), for: .valueChanged)
        tripsSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        tripsSwitch.isOn = self.tripsDefaults.bool(forKey: "tripsSwitch")
        backgroundImageView.addSubview(self.tripsSwitch)
        
        purchasesSwitch = UISwitch()
        purchasesSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 567 - 55, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    purchasesSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 567, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
                }
            }
        }
        purchasesSwitch.addTarget(self, action: #selector(self.purchasesSwitchChanged), for: .valueChanged)
        purchasesSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        purchasesSwitch.isOn = self.purchasesDefaults.bool(forKey: "purchasesSwitch")
        backgroundImageView.addSubview(self.purchasesSwitch)
        
        financeSwitch = UISwitch()
        financeSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 627 - 55, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    financeSwitch.frame = CGRect(x: 0.7546666666 * screenWidth, y: 627, width: 0.136 * screenWidth, height: 0.08266667 * screenWidth)
                }
            }
        }
        financeSwitch.addTarget(self, action: #selector(self.financeSwitchChanged), for: .valueChanged)
        financeSwitch.onTintColor = UIColor.init(hexString: "3AF5C0")
        financeSwitch.isOn = self.financeDefaults.bool(forKey: "financeSwitch")
        backgroundImageView.addSubview(self.financeSwitch)
   
    }
    
    //MARK: - Switch actions
    @objc func newsSwitchChanged() {
        
        self.newsDefaults.set(newsSwitch.isOn, forKey: "newsSwitch")
        self.miniPopupView.isHidden = true
        
        if newsSwitch.isOn == true {
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.news.show": true
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        } else {
           
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.news.show": false
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
    
    @objc func promosSwitchChanged() {
        print("switch")
        self.promosDefaults.set(promosSwitch.isOn, forKey: "promosSwitch")
        self.miniPopupView.isHidden = true

        if promosSwitch.isOn == true {
            print("Promos Switch Is On")
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.promotions.show": true
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        } else {
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.promotions.show": false
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
    
    @objc func socialSwitchChanged() {
     
        self.socialDefaults.set(socialSwitch.isOn, forKey: "socialSwitch")
        self.miniPopupView.isHidden = true
        
        if socialSwitch.isOn == true {
          
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.social.show": true
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        } else {
           
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.social.show": false
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
    
    @objc func tripsSwitchChanged() {
        print("switch")
        self.tripsDefaults.set(tripsSwitch.isOn, forKey: "tripsSwitch")
        self.miniPopupView.isHidden = true
        
        if tripsSwitch.isOn == true {
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.trips.show": true
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        } else {
           
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.trips.show": false
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
    
    @objc func purchasesSwitchChanged() {
        self.purchasesDefaults.set(purchasesSwitch.isOn, forKey: "purchasesSwitch")
        self.miniPopupView.isHidden = true
        
        if purchasesSwitch.isOn == true {
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.purchases.show": true
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        } else {
            
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.purchases.show": false
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
    
    @objc func financeSwitchChanged() {
      
        self.financeDefaults.set(financeSwitch.isOn, forKey: "financeSwitch")
        self.miniPopupView.isHidden = true
        
        if financeSwitch.isOn == true {
           
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.finance.show": true
                        ], query: nil))
                        
                        .on(value: { response in
                            print(response)
                            
                        }).startWithFailed { (error) in
                            print(error)
                    }
                }
            }
        } else {
           
            if let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
                var userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
                if userObject["_id"] != nil {
                    let userID = userObject["_id"] as! String
                    FeathersManager.Services.users.request(.patch(id: userID, data: [
                        "preferences.feed.finance.show": false
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
    
    //MARK: - Close action
    @objc func closeButtonPressed() {
        backgroundImageView.removeFromSuperview()
    }
    
    @objc func tappedToClose() {
        backgroundImageView.removeFromSuperview()

    }
}
