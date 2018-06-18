//
//  AddAccountViewController.swift
//  June
//
//  Created by Tatia Chachua on 17/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {

    var closeButton: UIButton!
    var titleLabel : UILabel!
    var gradientLine : UIImageView!
    var topShadow : UIImageView!
    var grayBackground : UIImageView!
    var shadow2 : UIImageView!
    var whiteBackground : UIView!
    var shadow3 : UIImageView!
    
    var diverLine1 : UIImageView!
    var diverLine2 : UIImageView!
    var diverLine3 : UIImageView!
    var diverLine4 : UIImageView!
    var diverLine5 : UIImageView!
    var diverLine6 : UIImageView!
    
    var iCloudBtn : UIButton!
    var exchangeBtn : UIButton!
    var googleBtn : UIButton!
    var yahooBtn : UIButton!
    var aiBtn : UIButton!
    var outlookBtn : UIButton!
    var otherBtn : UIButton!
    
    var onPasswordAction: ((String) -> Void)?
    var isReauthenticate = false
    
    static let titleLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isReauthenticate {
            addPasswordAlertView()
        }
    }
    
    func setupView() {
        let closeButtonImage = UIImage.init(named: "x_icon")
        self.closeButton = UIButton.init(type: .custom)
        self.closeButton.frame = CGRect(x: 0.05333333 * self.view.frame.size.width, y: 0.104 * self.view.frame.size.width, width: 0.04533333 * self.view.frame.size.width, height: 0.04533333 * self.view.frame.size.width)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        self.closeButton.setImage(closeButtonImage, for: .normal)
        self.view.addSubview(self.closeButton)
        
        self.titleLabel = UILabel.init()
        self.titleLabel.frame = CGRect(x: 0.25066667 * self.view.frame.size.width, y: 0.104 * self.view.frame.size.width, width: 0.50666667 * self.view.frame.size.width, height: 0.05333333 * self.view.frame.size.width)
        self.titleLabel.textColor = UIColor.init(hexString:"#404040") 
        self.titleLabel.font = AddAccountViewController.titleLabelFont
        self.titleLabel.text = Localized.string(forKey: LocalizedString.AddAccountViewTitleLabel)
        self.titleLabel.textAlignment = .center
        self.view.addSubview(self.titleLabel)
        
        self.gradientLine = UIImageView.init()
        self.gradientLine.frame = CGRect(x: 0, y: 0.18933333 * self.view.frame.size.width, width: self.view.frame.size.width, height: 0.01066667 * self.view.frame.size.width)
        self.gradientLine.image = UIImage.init(named: "june_gradient_line")
        self.view.addSubview(self.gradientLine)
        
        self.topShadow = UIImageView.init()
        self.topShadow.frame = CGRect(x: 0, y: 0.19733333333333 * self.view.frame.size.width, width: self.view.frame.size.width, height: 0.0613333333333 * self.view.frame.size.width)
        self.topShadow.image = UIImage.init(named: "june_shadow_inverted")
        self.view.addSubview(self.topShadow)
        
        self.shadow2 = UIImageView.init()
        self.shadow2.frame = CGRect(x: 0, y: 0.234666666666667 * self.view.frame.size.width, width: self.view.frame.size.width, height: 0.0613333333333 * self.view.frame.size.width)
        self.shadow2.image = UIImage.init(named: "june_shadow")
        self.view.addSubview(self.shadow2)

        self.shadow3 = UIImageView.init()
        self.shadow3.frame = CGRect(x: 0, y: 1.66133333333 * self.view.frame.size.width, width: self.view.frame.size.width, height: 0.0613333333333 * self.view.frame.size.width)
        self.shadow3.image = UIImage.init(named: "june_shadow_inverted")
        self.view.addSubview(self.shadow3)
        
        self.grayBackground = UIImageView.init()
        self.grayBackground.frame = CGRect(x: 0, y: 0.19733333333 * self.view.frame.size.width, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.grayBackground.image = #imageLiteral(resourceName: "add_account_background_")
        self.view.addSubview(grayBackground)
       
        self.whiteBackground = UIView()
        self.whiteBackground.frame = CGRect(x: 0, y: 0.296 * self.view.frame.size.width, width: self.view.frame.size.width, height: 1.3653333333 * self.view.frame.size.width)
        self.whiteBackground.backgroundColor = .white
        self.view.addSubview(whiteBackground)
       
        self.diverLine1 = UIImageView.init()
        self.diverLine1.frame = CGRect(x: 27, y: 0.49466666666 * self.view.frame.size.width, width: self.view.frame.size.width - 54, height: 2.5)
        self.diverLine1.image = #imageLiteral(resourceName: "divider_line")
        self.view.addSubview(diverLine1)
        
        self.diverLine2 = UIImageView.init()
        self.diverLine2.frame = CGRect(x: 27, y: 0.67866666666 * self.view.frame.size.width, width: self.view.frame.size.width - 54, height: 2.5)
        self.diverLine2.image = #imageLiteral(resourceName: "divider_line")
        self.view.addSubview(diverLine2)
        
        self.diverLine3 = UIImageView.init()
        self.diverLine3.frame = CGRect(x: 27, y: 0.87866666666 * self.view.frame.size.width, width: self.view.frame.size.width - 54, height: 2.5)
        self.diverLine3.image = #imageLiteral(resourceName: "divider_line")
        self.view.addSubview(diverLine3)
        
        self.diverLine4 = UIImageView.init()
        self.diverLine4.frame = CGRect(x: 27, y: 1.076 * self.view.frame.size.width, width: self.view.frame.size.width - 54, height: 2.5)
        self.diverLine4.image = #imageLiteral(resourceName: "divider_line")
        self.view.addSubview(diverLine4)
        
        self.diverLine5 = UIImageView.init()
        self.diverLine5.frame = CGRect(x: 27, y: 1.276 * self.view.frame.size.width, width: self.view.frame.size.width - 54, height: 2.5)
        self.diverLine5.image = #imageLiteral(resourceName: "divider_line")
        self.view.addSubview(diverLine5)
        
        self.diverLine6 = UIImageView.init()
        self.diverLine6.frame = CGRect(x: 27, y: 1.4733333333 * self.view.frame.size.width, width: self.view.frame.size.width - 54, height: 2.5)
        self.diverLine6.image = #imageLiteral(resourceName: "divider_line")
        self.view.addSubview(diverLine6)
        
        self.iCloudBtn = UIButton.init()
        self.iCloudBtn.setImage(UIImage.init(named: "iCloud_logo"), for: .normal)
        self.iCloudBtn.frame = CGRect(x: 0.3146666666 * self.view.frame.size.width, y: 0.352 * self.view.frame.size.width, width: 0.322666666 * self.view.frame.size.width, height: 0.098666666 * self.view.frame.size.width)
        self.view.addSubview(iCloudBtn)
        iCloudBtn.addTap { [weak self] ( _) in
            self?.addPasswordAlertView()
        }
        
        self.exchangeBtn = UIButton.init()
        self.exchangeBtn.setImage(UIImage.init(named: "exchange_logo"), for: .normal)
        self.exchangeBtn.frame = CGRect(x: 0.312 * self.view.frame.size.width, y: 0.5386666666 * self.view.frame.size.width, width: 0.373333333 * self.view.frame.size.width, height: 0.08266666666 * self.view.frame.size.width)
        self.view.addSubview(exchangeBtn)
        exchangeBtn.addTap { [weak self] ( _) in
            self?.addPasswordAlertView()
        }
        
        self.googleBtn = UIButton.init()
        self.googleBtn.setImage(UIImage.init(named: "google_logo"), for: .normal)
        self.googleBtn.frame = CGRect(x: 0.36266666666 * self.view.frame.size.width, y: 0.741333333333 * self.view.frame.size.width, width: 0.2773333333 * self.view.frame.size.width, height: 0.09066666666 * self.view.frame.size.width)
        self.view.addSubview(googleBtn)
        
        self.yahooBtn = UIButton.init()
        self.yahooBtn.setImage(UIImage.init(named: "yahoo_logo"), for: .normal)
        self.yahooBtn.frame = CGRect(x: 0.33066666666 * self.view.frame.size.width, y: 0.8826666666 * self.view.frame.size.width, width: 0.3386666666 * self.view.frame.size.width, height: 0.18933333333 * self.view.frame.size.width)
        self.view.addSubview(yahooBtn)
        yahooBtn.addTap { [weak self] ( _) in
            self?.addPasswordAlertView()
        }
        
        self.aiBtn = UIButton.init()
        self.aiBtn.setImage(UIImage.init(named: "aoi_logo"), for: .normal)
        self.aiBtn.frame = CGRect(x: 0.4 * self.view.frame.size.width, y: 1.12266666666 * self.view.frame.size.width, width: 0.1973333333 * self.view.frame.size.width, height: 0.08 * self.view.frame.size.width)
        self.view.addSubview(aiBtn)
        aiBtn.addTap { [weak self] ( _) in
            self?.addPasswordAlertView()
        }
        
        self.outlookBtn = UIButton.init()
        self.outlookBtn.setImage(UIImage.init(named: "outlook"), for: .normal)
        self.outlookBtn.frame = CGRect(x: 0.3226666666 * self.view.frame.size.width, y: 1.28533333333 * self.view.frame.size.width, width: 0.3573333333 * self.view.frame.size.width, height: 0.1813333333 * self.view.frame.size.width)
        self.view.addSubview(outlookBtn)
        
        self.otherBtn = UIButton.init()
        self.otherBtn.setImage(UIImage.init(named: "other_btn"), for: .normal)
        self.otherBtn.frame = CGRect(x: 0.36533333333 * self.view.frame.size.width, y: 1.544 * self.view.frame.size.width, width: 0.266666666 * self.view.frame.size.width, height: 0.05006666666 * self.view.frame.size.width)
        self.view.addSubview(otherBtn)
    }
    
    func addPasswordAlertView() {

        let alert = UIAlertController(title: Localized.string(forKey: LocalizedString.AddAccountViewAlertPasswordTitle), message: Localized.string(forKey: LocalizedString.AddAccountViewAlertPasswordMessageTitle), preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: Localized.string(forKey: LocalizedString.AddAccountViewAlertActionContinueTitle), style: .default) { (alertAction) in
            guard let textFields = alert.textFields else { return }
            if let passwordTextField = textFields.first {
                if let text = passwordTextField.text {
                    if text != "" {
                        self.onPasswordAction?(text)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        

        let cancelAction = UIAlertAction(title: Localized.string(forKey: LocalizedString.AddAccountViewAlertActionContinueTitle), style: .cancel, handler: nil)
        
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = Localized.string(forKey: LocalizedString.AddAccountViewAlertTextFieldPlaceholderTitle)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated:true, completion: nil)
    }
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
