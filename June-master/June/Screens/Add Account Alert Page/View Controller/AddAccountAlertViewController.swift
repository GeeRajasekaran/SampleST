//
//  AddAccountAlertViewController.swift
//  June
//
//  Created by Joshua Cleetus on 8/7/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlertBar
import SafariServices
import SwiftyJSON
import Feathers
import FeathersSwiftSocketIO
import SocketIO

class AddAccountAlertViewController: UIViewController, NVActivityIndicatorViewable {
    
    var backgroundImageView : UIImageView!
    var alertView : UIImageView!
    var titleLabel : UILabel!
    var emailAddress: UITextField!
    var closeButton : UIButton!
    var addAccountButton : UIButton!
    
    weak var addAccountViewDelegate: AddAccountViewDelegate?
    
    static let titleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
    static let emailAddressFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .medium)
    static let successLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
    static let errorLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
    
    lazy var linkEmailHandler: LinkEmailHandler = {
        let handler = LinkEmailHandler(with: self)
        handler.onSuccessLinkEmail = onSuccessLinkEmail
        handler.onErrorLinkEmail = onErrorLinkEmail
        return handler
    }()
    
    lazy var onSuccessLinkEmail: (() -> Void) = { [weak self] in
        self?.goToHomePage()
    }
    
    lazy var onErrorLinkEmail: (() -> Void) = { [weak self] in
        self?.showErrorAlert()
    }
    
    lazy var delegate: AddAccountAlertViewDelegate = {
        let delegate = AddAccountAlertViewDelegate(parentVC: self)
        return delegate
    }()
    
    let dataProvider = EmailLinkerDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImageView = UIImageView.init()
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.backgroundImageView.backgroundColor = UIColor.clear
        self.backgroundImageView.image = UIImage(named: "blur_black.png")
        self.backgroundImageView.isUserInteractionEnabled = true
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeButtonPressed)))

        self.alertView = UIImageView.init()
        self.alertView.frame = CGRect(x: 29, y: 241, width: 323, height: 202)
        self.alertView.backgroundColor = .white
        self.alertView.layer.cornerRadius = 17
        self.backgroundImageView.addSubview(self.alertView)
        
        self.closeButton = UIButton.init(type: .custom)
        self.closeButton.frame = CGRect(x: 53, y: 267, width: 13, height: 13)
        self.closeButton.setImage(UIImage.init(named: "cross_icon"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        self.backgroundImageView.addSubview(self.closeButton)
        
        self.titleLabel = UILabel.init()
        self.titleLabel.frame = CGRect(x: 85, y: 298, width: 215, height: 18)
        self.titleLabel.font = AddAccountAlertViewController.titleLabelFont
        self.titleLabel.textColor = UIColor.init(hexString:"#404040")
        self.titleLabel.numberOfLines = 2
        self.titleLabel.textAlignment = .center
        self.backgroundImageView.addSubview(self.titleLabel)
        self.titleLabel.text = Localized.string(forKey: LocalizedString.AddAccountAlertViewTitleLabel)
        
        let borderColor = UIColor.init(hexString: "#482727")
        
        self.emailAddress = UITextField.init()
        self.emailAddress.frame = CGRect(x: 56, y: 346, width: 269, height: 54)
        self.emailAddress.delegate = self.delegate
        self.emailAddress.borderStyle = .none
        self.emailAddress.layer.borderColor = (borderColor.withAlphaComponent(0.1).cgColor)
        self.emailAddress.layer.borderWidth = 1
        self.emailAddress.keyboardType = .emailAddress
        self.emailAddress.returnKeyType = .done
        self.emailAddress.placeholder = Localized.string(forKey: LocalizedString.AddAccountAlertViewEmailPlaceholderTitle)
        self.emailAddress.font = AddAccountAlertViewController.emailAddressFont
        self.emailAddress.textColor = UIColor.init(hexString:"#8E9198")
        self.emailAddress.attributedPlaceholder = NSAttributedString(string: "Enter Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(hexString:"#373737")])
        self.emailAddress.autocapitalizationType = .none
        self.emailAddress.autocorrectionType = .no
        self.backgroundImageView.addSubview(self.emailAddress)
        
        var indentView = UIView()
        indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 52.06))
        self.emailAddress.leftView = indentView
        self.emailAddress.leftViewMode = .always
        
        self.addAccountButton = UIButton.init(type: .custom)  // width 323
        self.addAccountButton.frame = CGRect(x: 20, y: 447, width: 323, height: 77)
        self.addAccountButton.addTarget(self, action: #selector(self.addAccountButtonPressed), for: .touchUpInside)
        self.addAccountButton.setImage(UIImage.init(named: "add"), for: .normal)
        self.addAccountButton.backgroundColor = .clear
        self.backgroundImageView.addSubview(self.addAccountButton)
        
        print(self.addAccountButton.frame.size.width)
        
        linkEmailHandler.subscribeForLinkNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - navigation
    func goToHomePage() {
        linkEmailHandler.unsubscribeForLinkNotifications()
        self.addAccountViewDelegate?.alertViewClosed()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - actions
    @objc func closeButtonPressed() {
        goToHomePage()
    }
    
    @objc func addAccountButtonPressed() {
        guard let emailAddressText = emailAddress.text else { return }
        if !emailAddressText.isEmpty && emailAddressText.isValidEmail() {
            linkEmailHandler.discoverEmail(emailAddressText)
        } else {
            showErrorAlert()
        }
    }
    
    //MARK: - error
    func showErrorAlert() {

        self.titleLabel.removeFromSuperview()
        self.emailAddress.removeFromSuperview()
        
        let errorLabel = UILabel()
        errorLabel.frame = CGRect(x: 116, y: 330, width: 148, height: 16)
        errorLabel.font = AddAccountAlertViewController.errorLabelFont
        errorLabel.textColor = UIColor.init(hexString: "#404040")
        errorLabel.text = Localized.string(forKey: LocalizedString.AddAccountAlertViewErrorAlertTitle)
        errorLabel.textAlignment = .center
        self.backgroundImageView.addSubview(errorLabel)
        
        let convertIcon = UIImageView()
        convertIcon.image = #imageLiteral(resourceName: "email")
        convertIcon.frame = CGRect(x: 140, y: 240, width: 105, height: 72)
        self.backgroundImageView.addSubview(convertIcon)
     
        self.addAccountButton.setImage(UIImage.init(named: "retry"), for: .normal)
    }
    
    //MARK: - success
    func showSuccess()  {
    
        self.titleLabel.removeFromSuperview()
        self.emailAddress.removeFromSuperview()
        
        let successLabel = UILabel()
        successLabel.frame = CGRect(x: 79, y: 222, width: 148, height: 16)
        successLabel.font = AddAccountAlertViewController.successLabelFont
        successLabel.textColor = UIColor.init(hexString: "#404040")
        successLabel.text = Localized.string(forKey: LocalizedString.AddAccountAlertViewSuccessLabelTitle)
        successLabel.textAlignment = .center
        self.backgroundImageView.addSubview(successLabel)
        
        let convertIcon = UIImageView()
        convertIcon.image = #imageLiteral(resourceName: "emal_icon")
        convertIcon.frame = CGRect(x: 140, y: 236, width: 105, height: 76)
        self.backgroundImageView.addSubview(convertIcon)
        
        self.addAccountButton.setImage(UIImage.init(named: "close"), for: .normal)
    }
}
