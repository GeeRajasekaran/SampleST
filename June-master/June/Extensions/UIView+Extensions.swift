//
//  UIView+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension UIView {
    
    static var largeMargin: CGFloat {
        get {
            return 32.0
        }
    }
    
    static var midLargeMargin: CGFloat {
        get {
            return 24.0
        }
    }
    
    static var midInterMargin: CGFloat {
        get {
            return 20.0
        }
    }
    
    static var midMargin: CGFloat {
        get {
            return 16.0
        }
    }
    
    static var narrowMidMargin: CGFloat {
        get {
            return 12.0
        }
    }
    
    static var narrowMargin: CGFloat {
        get {
            return 8.0
        }
    }
    
    static var slimMargin: CGFloat {
        get {
            return 4.0
        }
    }

    static var singleMargin: CGFloat {
        get {
            return 1.0
        }
    }
    
    static var midStandardMargin: CGFloat {
        return 17.0
    }

    static var extraLargeMargin: CGFloat {
        return 47.0
    }
    
    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.01
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x :self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
    
    func wiggleAnimation(for indexPath: IndexPath) {
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)), NSValue(caTransform3D: CATransform3DMakeRotation(-0.04 , 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = (Double(indexPath.row).truncatingRemainder(dividingBy: 2)) == 0 ?   0.115 : 0.105
        transformAnim.repeatCount = Float.infinity
        self.layer.add(transformAnim, forKey: "transform")
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    public func snapshotView(frame: CGRect? = nil) -> UIView? {
        if let snapshotImage = snapshotImage(frame: frame) {
            let image = UIImageView(image: snapshotImage)
            image.sizeToFit()
            return image
        } else {
            return nil
        }
    }
    
    func snapshotImage(frame: CGRect?) -> UIImage? {
        let scaleFactor = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scaleFactor)
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let frame = frame {
            image = image?.crop(rect: frame)
        }
        return image
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func drawTopShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 1
    }
    
    func drawBottomSeparator() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.romioLightGray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 0
    }
    
    func drawThinBottomShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 1
    }
    
    func drawBottomShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.bottomShadowColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 1
    }
    
    func drawWideBottomShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.bottomShadowColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 1
    }
    
    func drawWhiteBottomShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.whiteShadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
    }
    
    func addSubviewIfNeeded(_ view: UIView) {
        if view.superview == nil {
            addSubview(view)
        }
    }
    
    func addBottomShadowLineView() {
        let shadowFrame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        addSubview(shadowView)
    }
    
    func addStandardBottomShadowLineView() {
        let shadowFrame = CGRect(x: UIView.midMargin, y: frame.height - 1, width: frame.width, height: 1)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = UIColor.newsCardSeparatorGray
        addSubview(shadowView)
    }
    
    // MARK: - Add shadow view for compose
    
    func addComposeShadowView() {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.lineGray.withAlphaComponent(0.16)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(shadowView)
        
        shadowView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func bottomlessBorder(radius: CGFloat, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.path = CGMutablePath.bottomlessRoundedRect(in: bounds, radius: radius)
        self.layer.addSublayer(shapeLayer)
    }
    
    func toplessBorder(radius: CGFloat, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.path = CGMutablePath.toplessRoundedRect(in: bounds, radius: radius)
        self.layer.addSublayer(shapeLayer)
    }
    
    func addSideBorders(color: UIColor) {
        let leftBorderLayer = CAShapeLayer()
        leftBorderLayer.lineWidth = 1
        leftBorderLayer.strokeColor = color.cgColor
        leftBorderLayer.fillColor = nil
        
        let rightBorderColor = CAShapeLayer()
        rightBorderColor.lineWidth = 1
        rightBorderColor.strokeColor = color.cgColor
        rightBorderColor.fillColor = nil
        
        leftBorderLayer.path = CGMutablePath.leftPath(in: bounds)
        rightBorderColor.path = CGMutablePath.rightPath(in: bounds)
        
        self.layer.addSublayer(rightBorderColor)
        self.layer.addSublayer(leftBorderLayer)
    }

    // MARK: - Add shadow for card view
    
    func drawFeedCellShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
    }
}
