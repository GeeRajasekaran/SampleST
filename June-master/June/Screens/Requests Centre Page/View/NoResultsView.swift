//
//  NoResultsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/19/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class NoResultsView: UIView {

    private let screenWidth = UIScreen.main.bounds.width
    private let font = UIFont.latoStyleAndSize(style: .regular, size: .midLarge)
    private var label: UILabel?
    private var imageView: UIImageView?
    
    private var title: String
    
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        title = ""
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        title = ""
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        self.title = title
        //let titleWidth = title.width(usingFont: font)
       // self.frame.size = CGSize(width: titleWidth, height: 0.36 * screenWidth)
        self.frame.size = CGSize(width: screenWidth, height: 1.152 * screenWidth)
        setupSubViews()
    }

    //MARK: - private part
    private func setupSubViews() {
        addImageView()
        addLabel()
    }
    
    private func addLabel() {
        if label != nil { return }
        guard let imageFrame = imageView?.frame else { return }
        let labelWidth = frame.width
        let labelHeight = 0.076 * screenWidth
        label = UILabel(frame: CGRect(x: 0, y: imageFrame.origin.y + imageFrame.height + 0.04 * screenWidth, width: labelWidth, height: labelHeight))
        label?.font = font
        label?.textAlignment = .center
        label?.textColor = UIColor.requestsNoResultColor
        label?.text = title
        if label != nil {
            addSubview(label!)
        }
        
    }
    
    private func addImageView() {
        if imageView != nil { return }
        let imageWidth = 0.232 * screenWidth
        let imageHeight = imageWidth
        
        imageView = UIImageView(frame: CGRect(x: frame.width/2 - imageWidth/2, y: 0.568 * screenWidth, width: imageWidth, height: imageHeight))
        imageView?.image = UIImage(named: LocalizedImageNameKey.RequestsViewHelper.NoResultsImageName)
        
        if imageView != nil {
            addSubview(imageView!)
        }
    }
    
}
