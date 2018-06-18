//
//  SettingsTableViewCell.swift
//  June
//
//  Created by Tatia Chachua on 15/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    private let screenWidth = UIScreen.main.bounds.width
    private let currentFont = UIFont.latoStyleAndSize(style: .regular, size: .medium)
    private let primaryLabelFont = UIFont.latoStyleAndSize(style: .regular, size: .small)
    
    private var accountImageView: UIImageView?
    private var accountEmailLabel: UILabel?
    private var reauthentacateLabel: UILabel?
    private var primaryEmailLabel: UILabel?
    private var topLineView: UIImageView?
    private var setAsPrimaryButton: UIButton?
    
    private var account: AccountModel?
    
    private var settingsView = SettingsViewController()

    
    //MARK: - reuse logic
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accountEmailLabel?.removeFromSuperview()
        accountImageView?.removeFromSuperview()
        reauthentacateLabel?.removeFromSuperview()
        primaryEmailLabel?.removeFromSuperview()
        topLineView?.removeFromSuperview()
        primaryEmailLabel?.removeFromSuperview()
        setAsPrimaryButton?.removeFromSuperview()
        
        accountImageView = nil
        accountEmailLabel = nil
        reauthentacateLabel = nil
        primaryEmailLabel = nil
        topLineView = nil
        primaryEmailLabel = nil
        setAsPrimaryButton = nil
       
    }
    
    //MARK: - data loading
    func loadData(_ account: AccountModel, shouldShowPrimary isPrimaryShow: Bool) {
        self.account = account
        accountEmailLabel?.text = account.email
        
        if account.isPrimary && isPrimaryShow {
            primaryEmailLabel?.isHidden = false
            setAsPrimaryButton?.isHidden = true
            reauthentacateLabel?.isHidden = true
        }
        
        print(settingsView.editButtonActive)
      
        if settingsView.editButtonActive == true {
            setAsPrimaryButton?.isHidden = false
        }

        changeWidthOfEmailLabelIfNeeded()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        addImageView()
        addLabel()
//        addReauthentacateLabel()
        addSetAsPrimaryButton()
        addPrimaryEmailLabel()
        addTopLineView()
    }
    
    //MARK: - UI
    func addImageView() {
        if accountImageView != nil { return }
        
        let imageViewHeight = 0.056 * screenWidth
        let imageViewWidth = imageViewHeight
        
        accountImageView = UIImageView(frame: CGRect(x: 0.064 * screenWidth, y: frame.height/2 - imageViewHeight/2, width: imageViewWidth, height: imageViewHeight))
        accountImageView?.image = UIImage(named: "june_profile_pic_bg")
        accountImageView?.layer.cornerRadius = imageViewWidth/2
        accountImageView?.backgroundColor = .clear
        
        addSubview(accountImageView!)
    }
    
    func addLabel() {
        if accountEmailLabel != nil { return }
        let labelHeight = 0.048 * screenWidth
        
        accountEmailLabel = UILabel(frame: CGRect(x: 59, y: frame.height/2 - labelHeight/2, width: 212, height: labelHeight))
        accountEmailLabel?.textAlignment = .left
        accountEmailLabel?.font = currentFont
        accountEmailLabel?.textColor = UIColor.init(hexString:"#2B3348")
        addSubview(accountEmailLabel!)
    }
    
    func addReauthentacateLabel() {
        if reauthentacateLabel != nil { return }
        
        let labelHeight = 0.037 * screenWidth
        let labelWidth = 0.237 * screenWidth
        reauthentacateLabel = UILabel(frame: CGRect(x: 0.533 * screenWidth, y: frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight))
        reauthentacateLabel?.textColor = UIColor(red:0.96, green:0.36, blue:0.56, alpha:1)
        reauthentacateLabel?.textAlignment = .left
        reauthentacateLabel?.font = currentFont
        reauthentacateLabel?.text = "Re-authenticate"
        reauthentacateLabel?.isHidden = true
        addSubview(reauthentacateLabel!)
    }
    
    func addSetAsPrimaryButton() {
        setAsPrimaryButton = UIButton()
        setAsPrimaryButton?.frame = CGRect(x: 285, y: 21, width: 75, height: 15)
        setAsPrimaryButton?.setTitle("Set as primary", for: .normal)
        setAsPrimaryButton?.setTitleColor(UIColor.init(hexString: "BBBED0"), for: .normal)
        setAsPrimaryButton?.titleLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        setAsPrimaryButton?.isHidden = true
        addSubview(setAsPrimaryButton!)
    }
    
    func addPrimaryEmailLabel() {
        if primaryEmailLabel != nil { return }
        
        let labelHeight = 0.04 * screenWidth
        let labelWidth = 0.229333333 * screenWidth
        
        primaryEmailLabel = UILabel(frame: CGRect(x: 0.736 * screenWidth, y: frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight))
        primaryEmailLabel?.textColor = .gray
        primaryEmailLabel?.textAlignment = .left
        primaryEmailLabel?.font = primaryLabelFont
        primaryEmailLabel?.text = "Primary account"
        primaryEmailLabel?.textColor = UIColor.init(hexString: "256CFF")
        primaryEmailLabel?.isHidden = true
        addSubview(primaryEmailLabel!)
    }
    
    func changeWidthOfEmailLabelIfNeeded() {
        guard let unwrappedPrimaryEmailLabel = primaryEmailLabel, let unwrappedReauthentacateLabel = reauthentacateLabel, let unwrappedAccountEmailLabel = accountEmailLabel else { return }
        if unwrappedPrimaryEmailLabel.isHidden && unwrappedReauthentacateLabel.isHidden {
            guard let email = account?.email else { return }
            let emailLabelWidth = email.width(usingFont: currentFont)
            unwrappedAccountEmailLabel.frame.size.width = emailLabelWidth
        }
    }
    
    func addTopLineView() {
      if topLineView != nil { return }
        let lineHeight: CGFloat = 2
        topLineView = UIImageView(frame: CGRect(x: 15, y: 0, width: 346, height: lineHeight))
        topLineView?.image = UIImage(named: "devider")
        addSubview(topLineView!)
    
    }
}
