//
//  BreifHeaderCell.swift
//  June
//
//  Created by Ostap Holub on 1/26/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefHeaderCell: BaseBriefTableViewCell {
    
    // MARK: - Variables & Constants
    
    private var titleLabel: UILabel?
    private var subtitleLabel: UILabel?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.removeFromSuperview()
        titleLabel = nil
        subtitleLabel?.removeFromSuperview()
        subtitleLabel = nil
    }
    
    // MARK: - Primary view setup
    
    func load(model: BaseTableModel?) {
        guard let info = model as? BriefHeaderInfo else { return }
        titleLabel?.text = info.title
        subtitleLabel?.text = info.subtitle
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addTitleLabel()
        addSubtitleLabel()
    }
    
    override func addContainerView() {
        super.addContainerView()
        containerView?.roundCorners([.topLeft, .topRight], radius: LayoutConstant.cornerRadius)
        containerView?.bottomlessBorder(radius: LayoutConstant.cornerRadius, color: UIColor.briefCellBorderColor)
        addSeparatorView()
    }
    
    // MARK: - Title label setup
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        
        let rect = CGRect(x: 0.056 * screenWidth, y: 0.074 * screenWidth, width: 0.749 * screenWidth, height: 0.072 * screenWidth)
        titleLabel = UILabel(frame: rect)
        titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .extraMid)
        titleLabel?.textColor = UIColor.briefHeaderTextColor
        
        if titleLabel != nil {
            containerView?.addSubview(titleLabel!)
        }
    }
    
    private func addSubtitleLabel() {
        guard subtitleLabel == nil else { return }
        guard let titleFrame = titleLabel?.frame else { return }
        
        let rect = CGRect(x: 0.055 * screenWidth, y: titleFrame.origin.y + titleFrame.height, width: 0.69 * screenWidth, height: 0.045 * screenWidth)
        subtitleLabel = UILabel(frame: rect)
        subtitleLabel?.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        subtitleLabel?.textColor = UIColor.briefSutitleTextColor
        
        if subtitleLabel != nil {
            containerView?.addSubview(subtitleLabel!)
        }
    }
}
