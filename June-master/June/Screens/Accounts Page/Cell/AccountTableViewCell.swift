//
//  AccountTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    private let screenWidth = UIScreen.main.bounds.width
    private let currentFont = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
    
    private var blueOvalImage: UIImageView?
    private var oval: UIImageView?
    private var accountEmailLabel: UILabel?
    private var reauthentacateLabel: UILabel?
    private var primaryEmailBackground: UIImageView?
    
    private var account: Account?
    
    //MARK: - reuse logic
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accountEmailLabel?.removeFromSuperview()
        blueOvalImage?.removeFromSuperview()
        reauthentacateLabel?.removeFromSuperview()
        primaryEmailBackground?.removeFromSuperview()
        
        blueOvalImage = nil
        accountEmailLabel = nil
        reauthentacateLabel = nil
        primaryEmailBackground = nil
        
    }

    //MARK: - data loading
    func loadData(_ account: Account, shouldShowPrimary isPrimaryShow: Bool) {
        self.account = account
        accountEmailLabel?.text = account.email
        
        if account.isPrimary && isPrimaryShow {
            primaryEmailBackground?.isHidden = false
            reauthentacateLabel?.isHidden = true
        }
        
        if account.shouldReauthenticate() {
            primaryEmailBackground?.isHidden = true
            reauthentacateLabel?.isHidden = false
        }
        
        changeWidthOfEmailLabelIfNeeded()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        
        addReauthentacateLabel()
        addPrimaryEmailUI()
        addLabel()
        addOval()
    }
    
    //MARK: - UI
    func addLabel() {
        if accountEmailLabel != nil { return }
    
        let labelHeight = 0.048 * screenWidth
        
        accountEmailLabel = UILabel(frame: CGRect(x: 26, y: frame.height/2 - labelHeight/2, width: 212, height: labelHeight))
        accountEmailLabel?.textAlignment = .left
        accountEmailLabel?.font = currentFont
        accountEmailLabel?.textColor = UIColor.init(hexString:"#7B8285")
        addSubview(accountEmailLabel!)
    }
    
    func addOval() {
        oval = UIImageView()
        oval?.frame = CGRect(x: 267, y: 18, width: 15, height: 15)
        oval?.image = #imageLiteral(resourceName: "empty_oval")
        addSubview(oval!)
        oval?.isHidden = false
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
//        addSubview(reauthentacateLabel!)
    }
    
    func addPrimaryEmailUI() {
        if primaryEmailBackground != nil { return }
        
        primaryEmailBackground = UIImageView()
        primaryEmailBackground?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.contentView.frame.height)
        primaryEmailBackground?.image = #imageLiteral(resourceName: "cell_background")
        addSubview(primaryEmailBackground!)
        
        blueOvalImage = UIImageView()
        blueOvalImage?.frame = CGRect(x: 267, y: 18, width: 15, height: 15)
        blueOvalImage?.image = #imageLiteral(resourceName: "blue_oval")
        primaryEmailBackground?.addSubview(blueOvalImage!)
        primaryEmailBackground?.isHidden = true
        
    }
    
    func showSingleAccount() {
        primaryEmailBackground?.removeFromSuperview()
        oval?.removeFromSuperview()
    }
    
    func changeWidthOfEmailLabelIfNeeded() {
        guard let unwrappedPrimaryEmailLabel = primaryEmailBackground, let unwrappedReauthentacateLabel = reauthentacateLabel, let unwrappedAccountEmailLabel = accountEmailLabel else { return }
        if unwrappedPrimaryEmailLabel.isHidden && unwrappedReauthentacateLabel.isHidden {
            guard let email = account?.email else { return }
            let emailLabelWidth = email.width(usingFont: currentFont)
            unwrappedAccountEmailLabel.frame.size.width = emailLabelWidth
        }
    }
    
}
