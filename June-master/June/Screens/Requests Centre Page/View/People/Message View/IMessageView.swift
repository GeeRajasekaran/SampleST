//
//  IMessageView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/31/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol IMessageView {
    
    var iMessageViewHeight: CGFloat { get }
    
    var messageLoaded: ((MessageInfo, CGFloat) -> Void)? { get set }
    var onOpenAttachment: ((Attachment) -> Void)? { get set }
    
    func setupSubviews()
    func updateFrame()
    func loadData(info: MessageInfo)
}
