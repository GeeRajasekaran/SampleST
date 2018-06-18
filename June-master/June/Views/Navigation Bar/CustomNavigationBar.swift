//
//  CustomNavigationBar.swift
//  June
//
//  Created by Joshua Cleetus on 12/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class NavTitleView: UIView {
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
}

class CustomNavigationBar: UINavigationBar {
    
    let iPhoneXSafeAreaInset: CGFloat = 145.0
    let navBarHeight: CGFloat = 64.0
    var navBarTitleMaxWidth: CGFloat = 200.0
    let buttonWidth: CGFloat = 50.0
    var navBarButtonRect = CGRect.zero
    let smallButtonSize = CGSize(width: 20, height: 20)
    let navBarButtonEdgeInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 22.0, 0.0)
    let standardTitleFontSize: CGFloat = 24
    
    var titleView: UIView? {
        get {
            return getOrCreateItem().titleView
        }
    }
    
    var rightItem: UIView? {
        get {
            return items?.first?.rightBarButtonItem?.customView
        }
    }
    
    var leftItem: UIView? {
        get {
            return items?.first?.leftBarButtonItem?.customView
        }
    }
    
    init(){
        super.init(frame: CGRect.zero)
        setupNavBarElements()
    }
    
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavBarElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavBarElements()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackground") {
                subview.frame.origin.y = 0
                subview.frame.size.height = navBarHeight
            }
            if stringFromClass.contains("BarContentView") {
                subview.frame.origin.y = 20
                subview.frame.size.height = navBarHeight
            }
        }
    }
    
    //MARK: Setup Elements
    
    func setupNavBarElements(){
        clipsToBounds = true
        barTintColor = UIColor.white
        backgroundColor = UIColor.white
        isTranslucent = false
        self.navBarButtonRect = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: navBarHeight)
        self.sizeToFit()
        if #available(iOS 11.0, *) {
            insetsLayoutMarginsFromSafeArea = true
        }
    }
    
    //MARK: Navigation Title Setup
    @discardableResult
    func setNavBarTitle(ofType type: NavigationBarTitleType = .title, position: NavigationElementPosition = .center, customView: UIView? = nil, title: String = "", titleColor: UIColor = .black, fontSize: FontSize = .largeMedium,font: UIFont = UIFont.sfDisplayOfStyleAndSize(style: .bold, size: .largeMedium), navBarColor: UIColor = UIColor.white, includeSingleBarButton: Bool = false, isTransparent: Bool = false, leadingOffset: CGFloat = UIView.narrowMidMargin, maxNumberOfLines: Int = 1) -> UISearchBar {
        barTintColor = navBarColor
        if isTransparent {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            isTranslucent = true
        }
        var titleView = createTitleView(position: position)
        let searchBar: UISearchBar = UISearchBar(frame: CGRect.zero)
        switch type {
        case .title:
            addTitleToNavBar(title, titleColor: titleColor, fontSize: fontSize,font: font, titleView: &titleView, position: position, includeSingleBarButton: includeSingleBarButton, leadingOffset: leadingOffset, maxNumberOflines: maxNumberOfLines)
            break
            
        case .custom:
            titleView = createTitleView(position: position, initialView: customView)
            break
            
        case .search:
            searchBar.searchBarStyle = .minimal
            searchBar.backgroundImage = UIImage()
            searchBar.placeholder = title
            searchBar.backgroundColor = .clear
            searchBar.barTintColor = .white
            searchBar.setTextFieldColor(color: UIColor.white.withAlphaComponent(0.5))
            
            if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
                let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                
                textFieldInsideSearchBar.textColor = .black
                //Magnifying glass
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = UIColor.romioGray
                
                if let clearButton = textFieldInsideSearchBar.value(forKey: "_clearButton") as? UIButton {
                    clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
                    clearButton.tintColor = .romioGreen
                }
                textFieldInsideSearchBar.layer.cornerRadius = 14
                textFieldInsideSearchBar.clipsToBounds = true
            }
            
            titleView.addSubview(searchBar)
            
            searchBar.snp.remakeConstraints { (make) in
                let offset: CGFloat = 10
                make.width.equalTo(titleView).offset(-offset)
                make.height.equalTo(titleView)
                make.centerY.equalTo(titleView)
                make.leading.equalTo(titleView).offset(offset/2)
            }
            break
            
        case .logo:
            let logoImageView: UIImageView = UIImageView()
            let logoImageName = "romio-logo-nav"
            logoImageView.image = UIImage(named: logoImageName)
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.sizeToFit()
            titleView.addSubview(logoImageView)
            
            logoImageView.snp.remakeConstraints { (make) in
                make.leading.equalTo(titleView).offset(UIView.narrowMargin)
                make.width.equalTo(logoImageView)
                make.height.equalTo(logoImageView)
                make.centerY.equalTo(titleView)
            }
            break
        }
        
        setTitleVerticalPositionAdjustment(0, for: .defaultPrompt)
        let item = getOrCreateItem()
        titleView.translatesAutoresizingMaskIntoConstraints = true
        item.titleView = titleView
        setItems([item], animated: false)
        return searchBar
    }
    
    //MARK: Create Item
    
    fileprivate func getOrCreateItem() -> UINavigationItem {
        if let items = items {
            if let firstItem = items.first {
                return firstItem
            }
        }
        return UINavigationItem()
    }
    
    fileprivate func createTitleView(position: NavigationElementPosition, initialView: UIView? = nil) -> NavTitleView {
        switch position {
        case .center:
            navBarTitleMaxWidth = max(frame.size.width / 1.5, navBarTitleMaxWidth)
            
        case .left, .right:
            navBarTitleMaxWidth = frame.size.width
            
        }
        
        guard let initialView = initialView else {
            let titleView = NavTitleView(frame: CGRect(x: 0.0, y: 0.0, width: navBarTitleMaxWidth, height: sizeThatFits(CGSize.zero).height))
            titleView.clipsToBounds = true
            titleView.isUserInteractionEnabled = true
            return titleView
        }
        
        let titleView = NavTitleView(frame: CGRect(x: 0.0, y: 0.0, width: navBarTitleMaxWidth, height: sizeThatFits(initialView.frame.size).height))
        titleView.clipsToBounds = true
        titleView.isUserInteractionEnabled = true
        
        titleView.addSubview(initialView)
        initialView.snp.remakeConstraints {
            make in
            make.top.equalTo(titleView)
            make.leading.equalTo(titleView)
            make.bottom.equalTo(titleView)
        }
        initialView.layoutIfNeeded()
        titleView.clipsToBounds = true
        titleView.isUserInteractionEnabled = true
        return titleView
    }
    
    fileprivate func addTitleToNavBar(_ title : String, titleColor: UIColor = .darkGray, fontSize: FontSize, font: UIFont, titleView : inout NavTitleView, position: NavigationElementPosition, includeSingleBarButton: Bool = false, leadingOffset: CGFloat = narrowMidMargin, maxNumberOflines: Int = 1) {
        navBarTitleMaxWidth = max(frame.size.width / 2, navBarTitleMaxWidth)
        let fontInfo = font
        
        let titleLabel = UILabel(frame: CGRect.zero)
        switch position {
        case .center:
            titleLabel.textAlignment = NSTextAlignment.center
            
        case .left:
            titleLabel.textAlignment = NSTextAlignment.left
            
        case .right:
            titleLabel.textAlignment = NSTextAlignment.right
        }
        
        titleLabel.numberOfLines = maxNumberOflines
        titleLabel.font = fontInfo
        titleLabel.textColor = titleColor
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleView.addSubview(titleLabel)
        titleView.sizeToFit()
        
        titleLabel.snp.remakeConstraints { (make) in
            switch position {
            case .center:
                make.leading.equalTo(titleView)
                
            case .left:
                make.leading.equalTo(titleView).offset(leadingOffset)
                
            case .right:
                make.trailing.equalTo(titleView).offset(-UIView.narrowMidMargin)
                
            }
            let sideOffset: CGFloat = includeSingleBarButton ? UIView.extraLargeMargin : 0
            make.trailing.equalTo(titleView).offset(-sideOffset)
            make.height.equalTo(titleView)
            make.centerY.equalTo(titleView)
        }
        titleLabel.layoutIfNeeded()
    }
    
    //MARK: Bar Button Items
    
    @discardableResult
    func addNavBarButton(ofType type: NavigationButtonType, position: NavigationElementPosition, target: AnyObject?, action: Selector, color: UIColor = .white, shouldTint: Bool = true) -> UIBarButtonItem {
        var buttonBarItem: UIBarButtonItem
        
        switch type.style {
        case .icon:
            let button = UIButton()
            var buttonImage = UIImage(named: type.typeValue)
            if shouldTint {
                buttonImage = buttonImage?.withRenderingMode(.alwaysTemplate)
                button.imageView?.tintColor = color
            }
            button.setImage(buttonImage, for: UIControlState())
            button.sizeToFit()
            button.frame = self.navBarButtonRect
            button.contentEdgeInsets = self.navBarButtonEdgeInsets
            switch position {
            case .left:
                button.contentHorizontalAlignment = .left
                
            case .right:
                button.contentHorizontalAlignment = .right
                
            default:
                button.contentHorizontalAlignment = .right
                
            }
            button.addTarget(target, action: action, for: .touchUpInside)
            let buttonView = UIView(frame: self.navBarButtonRect)
            buttonView.addSubview(button)
            buttonBarItem = UIBarButtonItem(customView: buttonView)
            break
            
        case .title:
            let fontInfo = UIFont.sfTextOfStyleAndSize(style: .semiBold, size: .largeMedium)
            let item = UIBarButtonItem(title: type.typeValue, style: UIBarButtonItemStyle.plain, target: target, action: action)
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font: fontInfo], for: .normal)
            buttonBarItem = item
            break
            
        }
        
        if let items = items {
            if let firstItem = items.first {
                switch position {
                case .left, .center:
                    firstItem.leftBarButtonItem = buttonBarItem
                    
                case .right:
                    firstItem.rightBarButtonItem = buttonBarItem
                    
                }
            } else {
                let item: UINavigationItem = UINavigationItem()
                switch position {
                case .left, .center:
                    item.leftBarButtonItem = buttonBarItem
                    
                case .right:
                    item.rightBarButtonItem = buttonBarItem
                    
                }
            }
        }
        
        return buttonBarItem
    }
    
    var gradient: CAGradientLayer?
    
    func addGradientLayer(with colors: [UIColor], point: GradientPoint = .topBottom(offset: CGFloat.topBottomGradiantXOffset)) {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = .clear
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        
        gradient = CAGradientLayer()
        let yOfsset = UIScreen.isPhoneX ? iPhoneXSafeAreaInset - navBarHeight: 0
        gradient?.frame = CGRect(x: 0, y: -yOfsset, width: statusBarFrame.width, height: statusBarFrame.height + frame.height)
        gradient?.startPoint = point.draw.x
        gradient?.endPoint = point.draw.y
        gradient?.colors = colors.map({$0.cgColor})
        layer.addSublayer(gradient!)
        backgroundColor = .clear
    }
    
    func removeGradientLayer() {
        isTranslucent = false
        backgroundColor = .white
        gradient?.removeFromSuperlayer()
    }
}
