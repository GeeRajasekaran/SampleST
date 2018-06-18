//
//  SettingsChangePasswordUIAction.swift
//  June
//
//  Created by Tatia Chachua on 17/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsChangePasswordUIAction: NSObject {

    private unowned var parentVC: SettingsViewController
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Public part
    init(with controller: SettingsViewController) {
        parentVC = controller
    }
    
    func layoutSubviews() {
        addBackground()
        addTitle()
        addOriginalPasswordField()
        addChangePasswordField()
        addNewPasswordField()
        addGrayView()
    }
    
    // MARk: - background
    private func addBackground() {
        
        let changePasswordBackgroundImageView = UIImageView.init()
        changePasswordBackgroundImageView.frame = CGRect(x: 0, y: 0, width: parentVC.view.frame.size.width, height: parentVC.view.frame.size.height)
        changePasswordBackgroundImageView.backgroundColor = UIColor.black.withAlphaComponent(0.21)
        changePasswordBackgroundImageView.isUserInteractionEnabled = true
        parentVC.view.addSubview(changePasswordBackgroundImageView)
        parentVC.changePasswordBackgroundImageView = changePasswordBackgroundImageView
        changePasswordBackgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: parentVC, action: #selector(parentVC.closeAlertButtonPressed)))
        changePasswordBackgroundImageView.alpha = 0
        
        UIView.transition(with: parentVC.changePasswordBackgroundImageView,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.parentVC.changePasswordBackgroundImageView.alpha = 1.0 },
                          completion: nil)
        
        // White squer
        let whiteAlertBackground = UIImageView.init()
        whiteAlertBackground.frame = CGRect(x: 0.09866667 * parentVC.view.frame.size.width, y: 0.286373333333 * parentVC.view.frame.size.width, width: 0.80533333 * parentVC.view.frame.size.width, height: 1.08352 * parentVC.view.frame.size.width)
        whiteAlertBackground.backgroundColor = .white
        whiteAlertBackground.alpha = 1.0
        parentVC.changePasswordBackgroundImageView.addSubview(whiteAlertBackground)

    }
    
    // MARK: - title
    private func addTitle() {
        let titleLabel = UILabel.init()
        titleLabel.frame = CGRect(x: 0.20266667 * parentVC.view.frame.size.width, y: 0.496 * parentVC.view.frame.size.width, width: 0.59466667 * parentVC.view.frame.size.width, height: 0.05333333 * parentVC.view.frame.size.width)
        titleLabel.textColor = UIColor.init(hexString:"797A83").withAlphaComponent(0.44)
        titleLabel.textAlignment = .center
        titleLabel.font = SettingsViewController.titleLabelFont
        titleLabel.text = Localized.string(forKey: LocalizedString.SettingsViewTitleLabel)
        parentVC.changePasswordBackgroundImageView.addSubview(titleLabel)
    }
    
    // MARK: - original password text field
    private func addOriginalPasswordField() {
        
        let originalPasswordTextField = UITextField.init()
        originalPasswordTextField.frame = CGRect(x: 0.15733333 * parentVC.view.frame.size.width, y: 0.64 * parentVC.view.frame.size.width, width: 0.68 * parentVC.view.frame.size.width, height: 0.13866667 * parentVC.view.frame.size.width)
        originalPasswordTextField.borderStyle = .none
        originalPasswordTextField.keyboardType = .default
        originalPasswordTextField.returnKeyType = .next
        originalPasswordTextField.backgroundColor = UIColor.init(hexString:"#C0B8E9").withAlphaComponent(0.13)
        originalPasswordTextField.font = SettingsViewController.originalPasswordTextFieldFont
        originalPasswordTextField.placeholder = Localized.string(forKey: LocalizedString.SettingsViewOriginalPasswordPlaceholderTitle)
        originalPasswordTextField.textColor = UIColor.init(hexString:"797A83").withAlphaComponent(0.48)
        originalPasswordTextField.textAlignment = .left
        originalPasswordTextField.autocapitalizationType = .none
        originalPasswordTextField.autocorrectionType = .no
        originalPasswordTextField.delegate = parentVC.delegate
        parentVC.changePasswordBackgroundImageView.addSubview(originalPasswordTextField)
        parentVC.originalPasswordTextField = originalPasswordTextField
        
        var indentViewFirst = UIView()
        indentViewFirst = UIView(frame: CGRect(x: 0, y: 0, width: 0.048 * parentVC.view.frame.size.width, height: 0.13866667 * parentVC.view.frame.size.width))
        originalPasswordTextField.leftView = indentViewFirst
        originalPasswordTextField.leftViewMode = .always
    }
    
    // MARK: - change password text field
    private func addChangePasswordField() {
        
        let changePasswordTextField = UITextField.init()
        changePasswordTextField.frame = CGRect(x: 0.15733333 * parentVC.view.frame.size.width, y: 0.8026666666 * parentVC.view.frame.size.width, width: 0.68 * parentVC.view.frame.size.width, height: 0.13866667 * parentVC.view.frame.size.width)
        changePasswordTextField.borderStyle = .none
        changePasswordTextField.keyboardType = .emailAddress
        changePasswordTextField.returnKeyType = .done
        changePasswordTextField.backgroundColor = UIColor.init(hexString:"#C0B8E9").withAlphaComponent(0.13)
        changePasswordTextField.font = SettingsViewController.changePasswordTextFieldFont
        changePasswordTextField.placeholder = Localized.string(forKey: LocalizedString.SettingsViewChangePasswordFieldPlaceholderTitle)
        changePasswordTextField.textColor = UIColor.init(hexString:"#797A83").withAlphaComponent(0.48)
        changePasswordTextField.textAlignment = .left
        changePasswordTextField.autocapitalizationType = .none
        changePasswordTextField.autocorrectionType = .no
        changePasswordTextField.delegate = parentVC.delegate
        changePasswordTextField.isSecureTextEntry = true
        parentVC.changePasswordBackgroundImageView.addSubview(changePasswordTextField)
        parentVC.changePasswordTextField = changePasswordTextField
        
        var indentView = UIView()
        indentView = UIView(frame: CGRect(x: 0, y: 0, width: 0.048 * parentVC.view.frame.size.width, height: 0.13866667 * parentVC.view.frame.size.width))
        changePasswordTextField.leftView = indentView
        changePasswordTextField.leftViewMode = .always
    }
   
    // MARK: - new password text field
    private func addNewPasswordField() {
  
        let newPasswordTextField = UITextField.init()
        newPasswordTextField.frame = CGRect(x: 0.15733333 * parentVC.view.frame.size.width, y: 0.9653333333 * parentVC.view.frame.width , width: 0.68 * parentVC.view.frame.size.width, height: 0.13866667 * parentVC.view.frame.size.width)
        newPasswordTextField.borderStyle = .none
        newPasswordTextField.keyboardType = .emailAddress
        newPasswordTextField.returnKeyType = .done
        newPasswordTextField.backgroundColor = UIColor.init(hexString:"#C0B8E9").withAlphaComponent(0.13)
        newPasswordTextField.font = SettingsViewController.newPasswordTextFieldFont
        newPasswordTextField.placeholder = Localized.string(forKey: LocalizedString.SettingsViewNewPasswordTextFieldTitle)
        newPasswordTextField.textColor = UIColor.init(hexString:"#797A83").withAlphaComponent(0.48)
        newPasswordTextField.textAlignment = .left
        newPasswordTextField.autocapitalizationType = .none
        newPasswordTextField.autocorrectionType = .no
        newPasswordTextField.delegate = parentVC.delegate
        newPasswordTextField.isSecureTextEntry = true
        parentVC.changePasswordBackgroundImageView.addSubview(newPasswordTextField)
        parentVC.newPasswordTextField = newPasswordTextField
    
        var indentView2 = UIView()
        indentView2 = UIView(frame: CGRect(x: 0, y: 0, width: 0.048 * parentVC.view.frame.size.width, height: 0.13866667 * parentVC.view.frame.size.width))
        newPasswordTextField.leftView = indentView2
        newPasswordTextField.leftViewMode = .always
    }
    
    // MARK: - gray view
    private func addGrayView() {
        let grayLine = UIImageView.init()
        grayLine.frame = CGRect(x: 0.09866667 * parentVC.view.frame.size.width, y: 1.186666666666 * parentVC.view.frame.size.width, width: 0.80533333 * parentVC.view.frame.size.width, height: 0.00533333 * parentVC.view.frame.size.width)
        grayLine.image = #imageLiteral(resourceName: "june_grey_line")
        grayLine.contentMode = .scaleToFill
        grayLine.clipsToBounds = true
        parentVC.changePasswordBackgroundImageView.addSubview(grayLine)
    }
 
}
