//
//  CGMutablePath+RoundedCorners.swift
//  June
//
//  Created by Ostap Holub on 1/29/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

extension CGMutablePath {
    static func bottomlessRoundedRect(in rect: CGRect, radius: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
    
    static func toplessRoundedRect(in rect: CGRect, radius: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
    
    static func leftPath(in rect: CGRect) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
    
    static func rightPath(in rect: CGRect) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}
