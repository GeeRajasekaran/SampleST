//
//  TodaySectionHeaderView.swift
//  June
//
//  Created by Ostap Holub on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class TodaySectionHeaderView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private var titleLabel: UILabel?
    private var switchButton: UISwitch?
    
    var onSwitchValueChanged: ((Bool) -> Void)?
    
    // MARK: - Public view setup
    
    func setupSubviews(with title: String, isSwitchOn: Bool) {
        titleLabel?.removeFromSuperview()
        titleLabel = nil
        switchButton?.removeFromSuperview()
        switchButton = nil
        addTitleLabel(title)
        addSwitchButton(isOn: isSwitchOn)
    }
    
    // MARK: - Build the title label logic
    
    private func addTitleLabel(_ title: String) {
        guard titleLabel == nil else { return }
        
        let origin = CGPoint(x: 0.053 * screenWidth, y: 0.077 * screenWidth)
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
        guard switchButton == nil else { return }
        
        switchButton = UISwitch()
        let origin = CGPoint(x: 0.83 * screenWidth, y: 0.077 * screenWidth)
        switchButton?.frame.origin = origin
        switchButton?.onTintColor = UIColor.bookmarkedSwitchRed
        switchButton?.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchButton?.setOn(isOn, animated: false)
        
        if switchButton != nil {
            addSubview(switchButton!)
        }
    }
    
    @objc private func switchValueChanged() {
        if let action = onSwitchValueChanged, let value = switchButton?.isOn {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2, execute: {
                action(value)
            })
        }
    }
}
