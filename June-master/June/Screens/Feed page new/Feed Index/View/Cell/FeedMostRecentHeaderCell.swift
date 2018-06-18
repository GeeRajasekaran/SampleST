//
//  FeedTodayHeaderCell.swift
//  June
//
//  Created by Ostap Holub on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedMostRecentHeaderCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private var titleLabel: UILabel?
    private var switchButton: UISwitch?
    
    private var customSwitch: SevenSwitch?
    
    var onSwitchValueChanged: ((Bool) -> Void)?
    
    // MARK: - Reuse logic
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.removeFromSuperview()
        titleLabel = nil
        switchButton?.removeFromSuperview()
        switchButton = nil
    }
 
    // MARK: - Public view setup
    
    func setupSubviews(for model: BaseTableModel) {
        guard let castedModel = model as? FeedHeaderInfo else { return }
        backgroundColor = .clear
        selectionStyle = .none
        addTitleLabel(castedModel.title)
        addSwitchButton(isOn: castedModel.buttonValue)
    }
    
    // MARK: - Build the title label logic
    
    private func addTitleLabel(_ title: String) {
        guard titleLabel == nil else { return }
        
        let origin = CGPoint(x: 0.053 * screenWidth, y: 0.071 * screenWidth)
        let size = CGSize(width: 0.44 * screenWidth, height: 0.085 * screenWidth)
        
        titleLabel = UILabel(frame: CGRect(origin: origin, size: size))
        titleLabel?.text = title
        titleLabel?.font = UIFont(name: LocalizedFontNameKey.FeedViewHelper.TodayHeaderTitleFont, size: 26)
        titleLabel?.textColor = UIColor.todayFeedHeaderBlack
        
        if titleLabel != nil {
            addSubview(titleLabel!)
        }
    }
    
    // MARK: - Build the switch button logic
    
    private func addSwitchButton(isOn: Bool) {
        guard customSwitch == nil else { return }
        
        let origin = CGPoint(x: 0.83 * screenWidth, y: 0.075 * screenWidth)
        let size = CGSize(width: 0.136 * screenWidth, height: 0.082 * screenWidth)
        
        customSwitch = SevenSwitch(frame: CGRect(origin: origin, size: size))
        customSwitch?.onTintColor = UIColor.bookmarkedSwitchRed
        customSwitch?.backgroundColor = UIColor(hexString: "C6C6CF")
        customSwitch?.layer.cornerRadius = (customSwitch?.frame.height ?? 0) / 2
        customSwitch?.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        customSwitch?.setOn(isOn, animated: false)
        
        customSwitch?.thumbImageView.image = switchButtonImage(for: isOn)
        
        if customSwitch != nil {
            addSubview(customSwitch!)
        }
    }
    
    @objc private func switchValueChanged() {
        if let action = onSwitchValueChanged, let value = customSwitch?.isOn() {
            customSwitch?.thumbImageView.image = switchButtonImage(for: value)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2, execute: {
                action(value)
            })
        }
    }
    
    private func switchButtonImage(for value: Bool) -> UIImage? {
        let imageName = value ? LocalizedImageNameKey.FeedViewHelper.SwitchOnImage : LocalizedImageNameKey.FeedViewHelper.SwitchOffImage
        return UIImage(named: imageName)
    }
}
