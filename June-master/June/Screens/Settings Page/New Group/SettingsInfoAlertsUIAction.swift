//
//  SettingsInfoAlertsUIAction.swift
//  June
//
//  Created by Tatia Chachua on 18/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsInfoAlertsUIAction: NSObject {
    
    unowned var parentVC: SettingsViewController
    private let screenWidth = UIScreen.main.bounds.width
    
     init(with parent: SettingsViewController) {
        parentVC = parent
    }
    
    private var backgroundImageView: UIImageView!
    private var alertView: UIImageView!
    private var closeButton: UIButton!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    var line: UIImageView!
    var mainTextlabel: UILabel!
    var PSLabel: UILabel!
    
    // MARK: - add subviews for auto respond to requests
    func layoutSubviewsAutoRespond() {
        let screenWidth = parentVC.view.frame.size.width
        
        self.backgroundImageView = UIImageView.init()
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: parentVC.view.frame.size.height)
        self.backgroundImageView.backgroundColor = UIColor.clear
        self.backgroundImageView.image = UIImage(named: "blur_black.png")
        self.backgroundImageView.isUserInteractionEnabled = true
        parentVC.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeButtonPressed)))
        
        self.alertView = UIImageView.init()
        self.alertView.frame = CGRect(x: 28, y: Int(0.384 * screenWidth) - 55, width: Int(screenWidth - 56), height: 520)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.alertView.frame = CGRect(x: 28, y: 109, width: Int(screenWidth - 56), height: 520)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.alertView.frame = CGRect(x: 28, y: 109, width: Int(screenWidth - 56), height: 520)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.alertView.frame = CGRect(x: 28, y: 109, width: Int(screenWidth - 56), height: 520)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.alertView.frame = CGRect(x: 28, y: 109, width: Int(screenWidth - 56), height: 520)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.alertView.frame = CGRect(x: 28, y: 0.384 * screenWidth, width: 323, height: 520)
                }
            }
        }
        self.alertView.backgroundColor = .white
        self.alertView.layer.cornerRadius = 10
        self.backgroundImageView.addSubview(self.alertView)
        
        self.closeButton = UIButton.init(type: .custom)
        self.closeButton.frame = CGRect(x: 52, y: 112, width: 13, height: 13)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.closeButton.frame = CGRect(x: 52, y: 132, width: 13, height: 13)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.closeButton.frame = CGRect(x: 52, y: 132, width: 13, height: 13)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.closeButton.frame = CGRect(x: 52, y: 132, width: 13, height: 13)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.closeButton.frame = CGRect(x: 52, y: 132, width: 13, height: 13)
        } else {
            self.closeButton.frame = CGRect(x: 52, y: 132, width: 13, height: 13)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                   self.closeButton.frame = CGRect(x: 52, y: 167, width: 13, height: 13)
                }
            }
        }
        self.closeButton.setImage(UIImage.init(named: "cross_icon"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        self.backgroundImageView.addSubview(self.closeButton)
        
        self.titleLabel = UILabel.init()
        self.titleLabel.frame = CGRect(x: 68, y: 141, width: 197, height: 21)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.titleLabel.frame = CGRect(x: 68, y: 161, width: 197, height: 21)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.titleLabel.frame = CGRect(x: 68, y: 161, width: 197, height: 21)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.titleLabel.frame = CGRect(x: 68, y: 161, width: 197, height: 21)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.titleLabel.frame = CGRect(x: 68, y: 161, width: 197, height: 21)
        } else {
            self.titleLabel.frame = CGRect(x: 68, y: 161, width: 197, height: 21)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.titleLabel.frame = CGRect(x: 68, y: 196, width: 197, height: 21)
                }
            }
        }
        self.titleLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
        self.titleLabel.textColor = UIColor.init(hexString:"#404040")
        self.titleLabel.textAlignment = .center
        self.backgroundImageView.addSubview(self.titleLabel)
        self.titleLabel.text = Localized.string(forKey: .SettingsViewInfoAlertAutoRespondTitle)
        
        let textStr =  "When you block a contact in your Request Center, I will send this response to that person to let them know you're not interested."
        let color = UIColor.init(hexString: "#2274FF")
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: textStr, attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location:66,length:8))
        
        self.descriptionLabel = UILabel.init()
        self.descriptionLabel.frame = CGRect(x: 68, y: 174, width: 256, height: 68)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.descriptionLabel.frame = CGRect(x: 68, y: 194, width: 256, height: 68)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.descriptionLabel.frame = CGRect(x: 68, y: 194, width: 256, height: 68)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.descriptionLabel.frame = CGRect(x: 68, y: 194, width: 256, height: 68)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.descriptionLabel.frame = CGRect(x: 68, y: 194, width: 256, height: 68)
        } else {
            self.descriptionLabel.frame = CGRect(x: 68, y: 194, width: 256, height: 68)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                   self.descriptionLabel.frame = CGRect(x: 68, y: 229, width: 256, height: 68)
                }
            }
        }
        self.descriptionLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        self.descriptionLabel.textColor = UIColor.init(hexString:"#404040")
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.attributedText = myMutableString
        self.backgroundImageView.addSubview(self.descriptionLabel)

        self.line = UIImageView()
        self.line.frame = CGRect(x: 66.5, y: 325.5 - 55, width: 237, height: 1)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.line.frame = CGRect(x: 66.5, y: 325.5, width: 237, height: 1)
                }
            }
        }
        self.line.image = #imageLiteral(resourceName: "devider")
        self.backgroundImageView.addSubview(line)
        
        var placeHolder = ""
        let mainText = "Hi \(placeHolder). \n \n I'm June, Johns personal assistant. I help organize new people contacting him. He usually checks new contacts every few days and responds if interested. He appreciates your patience. \n \n P.S. I am a robot and won’t respond to you just yet ;) \n \n                                                                 -June \n \n "
        
        self.mainTextlabel = UILabel.init()
        self.mainTextlabel.frame = CGRect(x: 68, y: 291, width: 244, height: 295)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            self.mainTextlabel.frame = CGRect(x: 68, y: 311, width: 244, height: 295)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            self.mainTextlabel.frame = CGRect(x: 68, y: 311, width: 244, height: 295)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            self.mainTextlabel.frame = CGRect(x: 68, y: 311, width: 244, height: 295)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            self.mainTextlabel.frame = CGRect(x: 68, y: 311, width: 244, height: 295)
        } else {
            self.mainTextlabel.frame = CGRect(x: 68, y: 311, width: 244, height: 295)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.mainTextlabel.frame = CGRect(x: 68, y: 346, width: 244, height: 295)
                }
            }
        }
        self.mainTextlabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        self.mainTextlabel.textColor = UIColor.init(hexString:"#404040")
        self.mainTextlabel.textAlignment = .left
        self.mainTextlabel.numberOfLines = 0
        self.mainTextlabel.text = mainText
        self.backgroundImageView.addSubview(mainTextlabel)
        
        guard let name = parentVC.fullName else {return}
        placeHolder += name
    }

    // MARK: - add subviews for settings for feed action
    func layoutSubviewsSettingsForFeed() {
        
        self.backgroundImageView = UIImageView.init()
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: parentVC.view.frame.size.height)
        self.backgroundImageView.backgroundColor = UIColor.clear
        self.backgroundImageView.image = UIImage(named: "blur_black.png")
        self.backgroundImageView.isUserInteractionEnabled = true
        parentVC.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeButtonPressed)))

        self.alertView = UIImageView.init()
        self.alertView.frame = CGRect(x: 28, y: 387 - 55, width: screenWidth - 56, height: 195)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.alertView.frame = CGRect(x: 28, y: 387, width: 323, height: 195)
                }
            }
        }
        self.alertView.backgroundColor = .white
        self.alertView.layer.cornerRadius = 10
        self.backgroundImageView.addSubview(self.alertView)
        
        self.closeButton = UIButton.init(type: .custom)
        self.closeButton.frame = CGRect(x: 52, y: 410 - 55, width: 13, height: 13)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.closeButton.frame = CGRect(x: 52, y: 410, width: 13, height: 13)
                }
            }
        }
        self.closeButton.setImage(UIImage.init(named: "cross_icon"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        self.backgroundImageView.addSubview(self.closeButton)
        
        self.titleLabel = UILabel.init()
        self.titleLabel.frame = CGRect(x: 68, y: 448 - 55, width: 127, height: 21)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.titleLabel.frame = CGRect(x: 68, y: 448, width: 127, height: 21)
                }
            }
        }
        self.titleLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .mediumLarge)
        self.titleLabel.textColor = UIColor.init(hexString:"#404040")
        self.titleLabel.textAlignment = .center
        self.backgroundImageView.addSubview(self.titleLabel)
        self.titleLabel.text = Localized.string(forKey: .SettingsViewInfoAlertTitle)
        
        self.descriptionLabel = UILabel.init()
        self.descriptionLabel.frame = CGRect(x: 68, y: 481 - 55, width: 256, height: 51)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    self.descriptionLabel.frame = CGRect(x: 68, y: 481, width: 256, height: 51)
                }
            }
        }
        self.descriptionLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        self.descriptionLabel.textColor = UIColor.init(hexString:"#404040")
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.text = Localized.string(forKey: .SettingsViewInfoAlertDescriptionLabelTitle)
        self.backgroundImageView.addSubview(self.descriptionLabel)
        
    }
    
    @objc func closeButtonPressed() {
        backgroundImageView.removeFromSuperview()
    }
    
}
