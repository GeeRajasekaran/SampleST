//
//  PendingRequestTableViewCell.swift
//  June
//
//  Created by Ostap Holub on 3/27/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class PendingRequestTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    
    private var requestView: RequestNotificationView?
    var onClose: (() -> Void)?
    
    // MARK: - Reuse logic
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        requestView?.removeFromSuperview()
        requestView = nil
    }
    
    // MARK: - Primary view setup
    
    func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        addRequestNotificationView()
    }
    
    func loadModel(_ model: PendingRequestItemInfo) {
        requestView?.loadModel(model)
    }
    
    // MARK: - Private request notification view setup
    
    private func addRequestNotificationView() {
        guard requestView == nil else { return }
        
        requestView = RequestNotificationView()
        requestView?.translatesAutoresizingMaskIntoConstraints = false
        requestView?.setupSubviews()
        requestView?.onClose = onClose
        
        if requestView != nil {
            addSubview(requestView!)
            requestView?.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    class func fixedHeight() -> CGFloat {
        return 40
    }
    
}
