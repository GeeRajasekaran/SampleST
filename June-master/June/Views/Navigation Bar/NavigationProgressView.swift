//
//  NavigationProgressView.swift
//  June
//
//  Created by Joshua Cleetus on 12/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class NavigationProgressView: UIView {

    let path: UIBezierPath = UIBezierPath()
    static let lineHeight: CGFloat = 4
    static let fillColor: UIColor = UIColor.romioGreen
    weak var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        backgroundColor = .clear
        shapeLayer?.removeFromSuperlayer()
    }
    
    let width = UIScreen.size.width
    
    func setProgress(position: CGFloat) {
        setupView()
        
        path.move(to: CGPoint(x: 0, y: 0))
        let xPosition = width*position
        path.addLine(to: CGPoint(x: xPosition, y: 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = NavigationProgressView.fillColor.cgColor
        shapeLayer.lineWidth = NavigationProgressView.lineHeight
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
    }
    
    static func progressView(frame: CGRect) -> NavigationProgressView {
        let view = NavigationProgressView(frame: frame)
        view.backgroundColor = NavigationProgressView.fillColor
        return view
    }
}

