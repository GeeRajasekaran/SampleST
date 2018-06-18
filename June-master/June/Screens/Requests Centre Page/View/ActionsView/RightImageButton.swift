//
//  RightImageButton.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class RightImageButton: UIButton {

    private let screenWidth = UIScreen.main.bounds.width
    private let buttonFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    
    private var title: String?
    private var imageName:  String
    
    private var nameLabel: UILabel?
    private var circleImageView: CircleImageView?
    
    var tapButton: ((RightImageButton) -> Void)?
    
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        title = ""
        imageName = ""
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        title = ""
        imageName = ""
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String, image named: String) {
        self.init(frame: frame)
        self.title = title
        imageName = named
        setupUI()
        updateFrame()
        circleImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    convenience init(frame: CGRect, image named: String) {
        self.init(frame: frame)
        imageName = named
        setupUI()
        updateFrame()
        circleImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    func changeImage(with name: String) {
        circleImageView?.changeImage(with: name)
    }
        
    private func setupUI() {
        if title != nil {
            addNameLabel()
        }
        addCircleImageView(imageName: imageName)
    }
    
    private func setupImageView(imageName: String) {
        setImage(UIImage(named: imageName), for: .normal)
        imageView?.layer.cornerRadius = (imageView?.frame.width)!/2
        imageView?.backgroundColor = .orange
    }
    
    private func addNameLabel() {
        if nameLabel != nil { return }
        guard let width = title?.width(usingFont: buttonFont) else { return }
        let height = 0.04 * screenWidth
        nameLabel = UILabel(frame: CGRect(x: 0, y: frame.height/2 - height/2, width: width, height: height))
        nameLabel?.font = buttonFont
        nameLabel?.textColor = UIColor.requestsActionButtonColor
        nameLabel?.text = title
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
    
    private func addCircleImageView(imageName: String) {
        if circleImageView != nil { return }
        var originX: CGFloat = 0
        if let nameLabelFrame = nameLabel?.frame {
             originX = nameLabelFrame.origin.x + nameLabelFrame.size.width + 0.024 * screenWidth
        }
        let height = 0.12 * screenWidth
        let width = height
        circleImageView = CircleImageView(frame: CGRect(x: originX, y: frame.height/2 - height/2, width: width, height: height), image: imageName)
        
        if circleImageView != nil {
            addSubview(circleImageView!)
        }
    }
    
    private func updateFrame() {
        var labelWidth: CGFloat = 0
        if let nameFrame = nameLabel?.frame {
            labelWidth = nameFrame.width
        }
        frame.size.width = 0.142 * screenWidth + labelWidth
    }
    
    @objc func tapAction() {
        tapButton?(self)
    }
}

class CircleImageView: UIView {
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private var imageName:  String
    private var imageView: UIImageView?
    
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        imageName = ""
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        imageName = ""
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image named: String) {
        self.init(frame: frame)
        imageName = named
        setupUI()
    }
    
    func changeImage(with name: String) {
        self.imageName = name
        imageView?.image = UIImage(named: imageName)
    }
    
    private func setupUI() {
        addImageView(imageName: imageName)
        self.backgroundColor = .white
        layer.cornerRadius = frame.height/2
        drawShadow()
    }
    
    //MARK - setup elements
    private func addImageView(imageName: String) {
        if imageView != nil { return }
        imageView = UIImageView()
        imageView?.image = UIImage(named: imageName)
        imageView?.contentMode = .scaleAspectFit
        drawShadow()
        
        if imageView != nil {
            addSubview(imageView!)
        }
        addImageViewConstraints()
    }
    
    //MARK: - constraints
    private func addImageViewConstraints() {
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0.016 * screenWidth).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.016 * screenWidth).isActive = true
        imageView?.topAnchor.constraint(equalTo: topAnchor, constant: 0.03 * screenWidth).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.03 * screenWidth).isActive = true
    }
    
    //MARK: - shadow
    private func drawShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.27).cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
}
