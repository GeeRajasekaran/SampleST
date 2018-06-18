//
//  SpoolIndexLeftNavBarView.swift
//  June
//
//  Created by Ostap Holub on 4/6/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit
import Haneke

class SpoolIndexLeftNavBarView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var avatarImageView: UIImageView?
    var nameLabel: UILabel?
    private var viewInfoLabel: UILabel?
    
    private var tapGesture: UITapGestureRecognizer?
    
    var onBackAction: (() -> Void)?
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        addAvatarImageView()
        addNameLabel()
        addViewMoreLabel()
        addTapGesture()
    }
    
    func load(_ model: SpoolIndexHeaderInfo) {
        if let url = model.profileURL {
            avatarImageView?.hnk_setImageFromURL(url)
        }
        nameLabel?.text = model.name
    }
    
    // MARK: - Private avatar image view setup
    
    private func addAvatarImageView() {
        guard avatarImageView == nil else { return }
        
        let dimension: CGFloat = 0.085 * screenWidth
        avatarImageView = UIImageView(frame: CGRect(x: 0, y: frame.height / 2 - dimension / 2, width: dimension, height: dimension))
        avatarImageView?.contentMode = .scaleAspectFit
        avatarImageView?.layer.cornerRadius = dimension / 2
        avatarImageView?.clipsToBounds = true
        
        if avatarImageView != nil {
            addSubview(avatarImageView!)
        }
    }
    
    // MARK: - Private name label setup
    
    private func addNameLabel() {
        guard nameLabel == nil else { return }
        nameLabel = UILabel(frame: CGRect(x: 0.109 * screenWidth, y: 0.025 * screenWidth, width: frame.width - 0.109 * screenWidth, height: 0.057 * screenWidth))
        nameLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
        nameLabel?.textColor = UIColor.spoolNameHeaderColor
        nameLabel?.textAlignment = .left
        
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
    
    // MARK: - Private view more setup
    
    private func addViewMoreLabel() {
        guard viewInfoLabel == nil else { return }
        
        viewInfoLabel = UILabel(frame: CGRect(x: 0.109 * screenWidth, y: 0.048 * screenWidth, width: frame.width - 0.109 * screenWidth, height: 0.053 * screenWidth))
        viewInfoLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        viewInfoLabel?.textColor = UIColor.spoolViewInfoHeaderColor
        viewInfoLabel?.textAlignment = .left
        
        if viewInfoLabel != nil {
            addSubview(viewInfoLabel!)
        }
    }
    
    // MARK: - Private gesture setup
    
    private func addTapGesture() {
        guard tapGesture == nil else { return }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture?.delegate = self
        
        if tapGesture != nil {
            addGestureRecognizer(tapGesture!)
        }
    }
    
    @objc private func handleTapGesture() {
        print("Tap detected")
    }
}
