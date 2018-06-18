//
//  SettingsUIInitializer.swift
//  June
//
//  Created by Tatia Chachua on 15/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class SettingsUIInitializer: NSObject {

    private unowned var parentVC: SettingsViewController
    private let screenWidth = UIScreen.main.bounds.width
    
    init(with controller: SettingsViewController) {
        parentVC = controller
    }
    
    func layoutSubviews() {
        addCloseButton()
        addTitleLabel()
        addEditProfilePictureButton()
        addTableView()
        addLine()
    }
    
    // MARK: - title label
    private func addTitleLabel() {
        let screenWidth = parentVC.view.frame.size.width
        
        let titleLabel = UILabel.init()
        titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 0.0426666666 * screenWidth, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 36, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 36, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 36, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 36, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
        } else {
            titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 36, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
        }
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    titleLabel.frame = CGRect(x: 0.25066667 * screenWidth, y: 71, width: 0.50666667 * screenWidth, height: 0.05333333 * screenWidth)
                }
            }
        }
        
        titleLabel.textColor = UIColor.init(hexString:"#2B3348")
        titleLabel.text = Localized.string(forKey: .SettingsViewTitleLabel)
        titleLabel.font = SettingsViewController.titleLabelFont
        titleLabel.textAlignment = .center
        parentVC.scrollView.addSubview(titleLabel)
        parentVC.titleLabel = titleLabel
    }
    
    // MARK: - close button
    private func addCloseButton() {
        let closeButtonImage = UIImage.init(named: "x_icon_darker")
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.frame = CGRect(x: 0, y: 45 - 55, width: 0.16 * screenWidth, height: 0.16 * screenWidth)
        
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            closeButton.frame = CGRect(x: 0, y: 10, width: 0.144927536 * screenWidth, height: 0.144927536 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            closeButton.frame = CGRect(x: 0, y: 10, width: 0.144927536 * screenWidth, height: 0.144927536 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            closeButton.frame = CGRect(x: 0, y: 10, width: 0.144927536 * screenWidth, height: 0.144927536 * screenWidth)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            closeButton.frame = CGRect(x: 0, y: 10, width: 0.144927536 * screenWidth, height: 0.144927536 * screenWidth)
        } else {
            closeButton.frame = CGRect(x: 0, y: 10, width: 0.144927536 * screenWidth, height: 0.144927536 * screenWidth)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    closeButton.frame = CGRect(x: 0, y: 45, width: 0.16 * screenWidth, height: 0.16 * screenWidth)
                }
            }
        }
        closeButton.addTarget(parentVC, action: #selector(parentVC.closeButtonPressed), for: .touchUpInside)
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 26, left: 16, bottom: 18, right: 28)
        parentVC.scrollView.addSubview(closeButton)
        parentVC.closeButton = closeButton
    }
    
    // MARK: - profile picture button
    private func addEditProfilePictureButton() {
        let editPictureBackgroundImage = UIImage.init(named: "june_profile_pic_edit_bg")
        let editPictureButton = UIButton.init(type: .custom)
        editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 70, width: 113, height: 113)
        
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 90, width: 113, height: 113)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 90, width: 113, height: 113)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 90, width: 113, height: 113)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 90, width: 113, height: 113)
        } else {
            editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 90, width: 113, height: 113)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    editPictureButton.frame = CGRect(x: 0.352 * screenWidth, y: 125, width: 113, height: 113)
                }
            }
        }
        editPictureButton.layer.cornerRadius = editPictureButton.frame.size.width/2
        editPictureButton.clipsToBounds = true
        editPictureButton.contentMode = .scaleAspectFit
        editPictureButton.setImage(editPictureBackgroundImage, for: .normal)
        editPictureButton.addTarget(parentVC, action: #selector(parentVC.editPictureButtonPressed), for: .touchUpInside)
        parentVC.scrollView.addSubview(editPictureButton)
        parentVC.editPictureButton = editPictureButton
        
        let profFilter = UIImageView()
        profFilter.image = #imageLiteral(resourceName: "pofile_filter")
        profFilter.frame = CGRect(x: 0, y: 0, width: editPictureButton.frame.size.width, height: editPictureButton.frame.size.height)
        editPictureButton.addSubview(profFilter)
        
        let penIcon = UIImageView()
        penIcon.image = #imageLiteral(resourceName: "bt_edit")
        penIcon.frame = CGRect(x: 46, y: 44, width: 25, height: 25)
        profFilter.addSubview(penIcon)
        
    }
    
    // MARK: - table view
    private func addTableView() {
        guard let tableView = buildTableView() else { return }
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier())
        tableView.dataSource = parentVC.settingsDataSource
        tableView.delegate = parentVC.accountsDelegate
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        parentVC.scrollView.addSubview(tableView)
        parentVC.accountsTableView = tableView
    }
 
    private func buildTableView() -> UITableView? {
        let screenWidth = parentVC.view.frame.size.width
        var tableViewFrame = CGRect(x: 0, y: 363, width: screenWidth, height: 71)
        
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            tableViewFrame = CGRect(x: 0, y: 383, width: screenWidth, height: 71)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            tableViewFrame = CGRect(x: 0, y: 383, width: screenWidth, height: 71)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            tableViewFrame = CGRect(x: 0, y: 383, width: screenWidth, height: 71)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            tableViewFrame = CGRect(x: 0, y: 383, width: screenWidth, height: 71)
        } else {
            tableViewFrame = CGRect(x: 0, y: 383, width: screenWidth, height: 71)
        }
        if #available(iOS 11.0, *) {
            
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    tableViewFrame = CGRect(x: 0, y: 418, width: screenWidth, height: 71)
                }
            }
        }
       
        return UITableView(frame: tableViewFrame, style: .plain)
    }
    
    func addLine() {
        let line = UIImageView()
        line.frame = CGRect(x: 12, y: 363, width: 355, height: 2)
        
        if UIDevice.current.modelName == "iPhone 8 Plus" {
            line.frame = CGRect(x: 12, y: 383, width: 394, height: 2)
        } else if UIDevice.current.modelName == "iPhone 7 Plus" {
            line.frame = CGRect(x: 12, y: 383, width: 394, height: 2)
        } else if UIDevice.current.modelName == "iPhone 6 Plus"{
            line.frame = CGRect(x: 12, y: 383, width: 394, height: 2)
        } else if UIDevice.current.modelName == "iPhone 6s Plus" {
            line.frame = CGRect(x: 12, y: 383, width: 394, height: 2)
        } else {
            line.frame = CGRect(x: 12, y: 383, width: 394, height: 2)
        }
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    // It's iPhone X
                    line.frame = CGRect(x: 12, y: 418, width: 355, height: 2)
                }
            }
        }
        
        line.image = UIImage(named: "devider")
        parentVC.scrollView.addSubview(line)
        parentVC.nerrowLine = line
    }
    
    //MARK: - update UI elements height
    func updateTableViewHeightIFNeeded() {
        let tableView = parentVC.accountsTableView
        let dataCount = parentVC.dataRepository.count
        if dataCount > 0 {
            let oneCellHeight = parentVC.accountsDelegate.oneCellHeight
            let totalCellHeight = oneCellHeight*CGFloat(dataCount)
           
            tableView.frame.size.height = totalCellHeight
            parentVC.bottomSubviews.frame.origin.y += totalCellHeight
            parentVC.addAccountButton.frame.origin.y += totalCellHeight
            parentVC.scrollView.contentInset.bottom += totalCellHeight
            parentVC.nerrowLine.frame.origin.y += totalCellHeight
           
        } else {
            tableView.frame.size.height = 0
        }
        
    }
}
