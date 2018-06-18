//
//  SpoolOlderMessageTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 4/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolOlderMessageTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var viewOlderButton: UIButton?
    
    var onViewOlderAction: (() -> Void)?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewOlderButton?.removeFromSuperview()
        viewOlderButton = nil
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        selectionStyle = .none
        backgroundColor = .white
        addViewOlderButton()
    }
    
    func load(_ model: BaseTableModel) {
        guard let viewOlderModel = model as? SpoolShowOlderMessagesInfo else {
            return
        }
        viewOlderButton?.setTitle(viewOlderModel.title, for: .normal)
        let image = UIImage(named: LocalizedImageNameKey.SpoolDetailsHelper.ViewOlderMessage)?.imageResize(sizeChange: CGSize(width: 0.021 * screenWidth, height: 0.016 * screenWidth))
        viewOlderButton?.setImage(image, for: .normal)
        viewOlderButton?.imageEdgeInsets = UIEdgeInsets(top: 0.009 * screenWidth, left: 0, bottom: 0, right: 0.013 * screenWidth)
        
        viewOlderButton?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        viewOlderButton?.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        viewOlderButton?.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    // MARK: - Private view older button setup
    
    private func addViewOlderButton() {
        guard viewOlderButton == nil else { return }
        
        viewOlderButton = UIButton()
        viewOlderButton?.translatesAutoresizingMaskIntoConstraints = false
        viewOlderButton?.backgroundColor = UIColor.spoolViewOlderMessagesColor
        viewOlderButton?.titleLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .midSmall)
        viewOlderButton?.setTitleColor(.black, for: .normal)
        viewOlderButton?.addTarget(self, action: #selector(handleViewOlderClick), for: .touchUpInside)
        
        viewOlderButton?.layer.cornerRadius = 0.032 * screenWidth
        
        if viewOlderButton != nil {
            addSubview(viewOlderButton!)
            viewOlderButton?.snp.makeConstraints { make in
                make.height.equalTo(0.072 * screenWidth)
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(0.037 * screenWidth)
                make.trailing.equalToSuperview().offset(-0.037 * screenWidth)
            }
        }
    }
    
    @objc private func handleViewOlderClick() {
        onViewOlderAction?()
    }
}
