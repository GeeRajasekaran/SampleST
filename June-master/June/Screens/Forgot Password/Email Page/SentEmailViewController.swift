//
//  SentEmailViewController.swift
//  June
//
//  Created by Tatia Chachua on 11/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import QuartzCore
import NVActivityIndicatorView
import AlertBar
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import Alamofire
import KeychainSwift

class SentEmailViewController: UIViewController {
    
    var logoImageView: UIImageView!
    var sentLinkLabel: UILabel!
    var emailLabel: UILabel!
    var expireLabel: UILabel!
    var openEmailButton: UIButton!
    var openEmailLabel: UILabel!
    var deleyTimeLabel: UILabel!
    var resendEmailButton: UIButton!
    var resendEmailLabel: UILabel!
    var backToButton: UIButton!
    
    var emailStr: String!
    var usernameStr: String!
    
    static let sentLinkFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)
    static let emailLabelFont: UIFont = UIFont.avenirStyleAndSize(style: .heavy, size: .regMid)
    static let expairLabFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)
    static let openEmailLabelFont: UIFont = UIFont.robotoStyleAndSize(style: .regular, size: .largeMedium)
    static let deleyTimeLabelFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)
    static let resendEmailLabelFont: UIFont = UIFont.robotoStyleAndSize(style: .regular, size: .largeMedium)
    static let backToButtonFont: UIFont = UIFont.avenirStyleAndSize(style: .book, size: .regMid)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
        self.logoImageView = UIImageView(frame: CGRect(x: Int(self.view.center.x - 78), y: 134, width: 156, height: 36))
        self.logoImageView.image = #imageLiteral(resourceName: "lucy_logo")
        self.view.addSubview(logoImageView)
        
        self.sentLinkLabel = UILabel(frame: CGRect(x: Int(self.view.center.x - 155), y: 206, width: 310, height: 21))
        self.sentLinkLabel.textAlignment = .center
        self.sentLinkLabel.font = SentEmailViewController.sentLinkFont
        self.sentLinkLabel.textColor = .black
        self.sentLinkLabel.text = Localized.string(forKey: LocalizedString.SentEmailViewSentLinkLabelTitle)
        self.view.addSubview(sentLinkLabel)
        
        self.emailLabel = UILabel(frame: CGRect(x: Int(self.view.center.x - 110), y: 249, width: 220, height: 21))
        self.emailLabel.textColor = UIColor.black
        self.emailLabel.font = SentEmailViewController.emailLabelFont
        self.emailLabel.textAlignment = .center
        self.emailLabel.text = self.emailStr
        self.view.addSubview(emailLabel)
        
        self.expireLabel = UILabel(frame: CGRect(x: Int(self.view.center.x - 143), y: 291, width: 286, height: 44))
        self.expireLabel.text = "The link expires in 2 hours, so be sure to use \n it soon."
        self.expireLabel.font = SentEmailViewController.expairLabFont
        self.expireLabel.text = Localized.string(forKey: LocalizedString.SentEmailViewExpireLabelTitle)
        self.expireLabel.font = UIFont(name: "Avenir-Book", size: 14)
        self.expireLabel.numberOfLines = 0
        self.expireLabel.textColor = .black
        self.expireLabel.textAlignment = .center
        self.view.addSubview(expireLabel)
        
        self.openEmailButton = UIButton()
        self.openEmailButton.backgroundColor = UIColor(red:0.52, green:0.6, blue:0.97, alpha:1)
        self.openEmailButton.frame = CGRect(x: 20, y: 347, width: self.view.frame.size.width - 40, height: 60)
        self.openEmailButton.layer.cornerRadius = 5
        self.openEmailButton.addTarget(self, action: #selector(openEmailApp), for: .touchUpInside)
        self.view.addSubview(openEmailButton)
        
        self.openEmailLabel = UILabel(frame: CGRect(x: 70, y: 20, width: Int(self.openEmailButton.frame.width - 140), height: 20))
        self.openEmailLabel.textAlignment = .center
        self.openEmailLabel.textColor = .white
        self.openEmailLabel.font = SentEmailViewController.openEmailLabelFont
        self.openEmailLabel.text = "Open your email"
        self.openEmailLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        self.openEmailLabel.text = Localized.string(forKey: LocalizedString.SentEmailViewOpenEmailLabel)
        self.openEmailButton.addSubview(openEmailLabel)
        
        self.deleyTimeLabel = UILabel(frame: CGRect(x: 30, y: 453, width: self.view.frame.size.width - 60, height: 44))
        self.deleyTimeLabel.textAlignment = .center
        self.deleyTimeLabel.textColor = .black
        self.deleyTimeLabel.numberOfLines = 0
        self.deleyTimeLabel.text = "Didn’t get a link? It may take 2-5 min. Or try  resending the magic link:"
        self.deleyTimeLabel.font = SentEmailViewController.deleyTimeLabelFont
        self.deleyTimeLabel.text = Localized.string(forKey: LocalizedString.SentEmailViewDeleyTimeLabel)
        self.deleyTimeLabel.font = UIFont(name: "Avenir-Book", size: 14)
        self.view.addSubview(deleyTimeLabel)
        
        self.resendEmailButton = UIButton(frame: CGRect(x: 20, y: 509, width: self.view.frame.size.width - 40, height: 60))
        self.resendEmailButton.backgroundColor = .white
        self.resendEmailButton.layer.cornerRadius = 5
        self.resendEmailButton.layer.borderWidth = 2
        self.resendEmailButton.layer.borderColor = UIColor(red:0.52, green:0.6, blue:0.97, alpha:1).cgColor
        self.resendEmailButton.addTarget(self, action: #selector(resendEmailButtonClicked), for: .touchUpInside)
        self.view.addSubview(resendEmailButton)
        
        self.resendEmailLabel = UILabel(frame: CGRect(x: 0, y: 20, width: self.resendEmailButton.frame.width, height: 20))
        self.resendEmailLabel.text = Localized.string(forKey: LocalizedString.SentEmailViewResendEmailLabel)
        self.resendEmailLabel.textColor = UIColor(red:0.52, green:0.6, blue:0.97, alpha:1)
        self.resendEmailLabel.font = SentEmailViewController.resendEmailLabelFont
        self.resendEmailLabel.textAlignment = .center
        self.resendEmailButton.addSubview(resendEmailLabel)
        
        self.backToButton = UIButton(frame: CGRect(x: Int(self.view.center.x - 50), y: 604, width: 100, height: 30))
        self.backToButton.setTitle(Localized.string(forKey: LocalizedString.SentEmailViewBackToButtonTitle), for: .normal)
        self.backToButton.addTarget(self, action: #selector(bsckButtonClicked), for: .touchUpInside)
        self.backToButton.setTitleColor(UIColor.black, for: .normal)
        self.backToButton.titleLabel?.font = SentEmailViewController.backToButtonFont
        self.backToButton.titleLabel?.textAlignment = .center
        self.view.addSubview(backToButton)
    }
    
    @objc func openEmailApp() {
        let messageHooks = "message://"
        let emailUrl = NSURL(string: messageHooks)
        if UIApplication.shared.canOpenURL(emailUrl! as URL)
        {
            UIApplication.shared.open(emailUrl! as URL, options: [:], completionHandler: { (result) in
                
            })
        }
    }
    
    @objc func resendEmailButtonClicked() {
        
        if self.usernameStr == nil {
            emailRequest()
        }
        if self.emailStr == nil {
            usernameRequest()
        }
        
    }
  
    func usernameRequest() {
        FeathersManager.Services.tokens.request(.create(data: [
            "username": self.usernameStr,
            ], query: nil))
            
            .on(value: { response in
                print("this is response: \(response)")
            })
            .startWithFailed { (error) in
                print(error)
        }
        
    }
    
    func emailRequest() {
        FeathersManager.Services.tokens.request(.create(data: [
            "email": self.emailStr,
            ], query: nil))
            
            .on(value: { response in
                print(response)
            })
            .startWithFailed { (error) in
                print(error)
        }
    
    }
    
    @objc func bsckButtonClicked() {
        let loginPage = LoginViewController()
        self.navigationController?.pushViewController(loginPage, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
