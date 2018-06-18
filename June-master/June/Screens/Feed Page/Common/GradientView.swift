//
//  GradientView.swift
//  June
//
//  Created by Ostap Holub on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    func drawHorizontalGradient(with color: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        let startColor = UIColor.white.withAlphaComponent(0.1).cgColor
        gradientLayer.colors = [startColor, color.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.addSublayer(gradientLayer)
    }
    
    func drawHorizontalGradient(with startColor: UIColor, and endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = frame.size.height/2
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func drawVerticalGradient(with color: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        let startColor = UIColor.white.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [startColor, color.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.addSublayer(gradientLayer)
    }
    
    func drawVerticalGradient(with startColor: UIColor, and endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.2)
        
        layer.addSublayer(gradientLayer)
    }
}
