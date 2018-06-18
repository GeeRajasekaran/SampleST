//
//  RequestsTopButton.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsTopButton: UIButton {

    // MARK: - Variables & Constants
    private let screenWidth = UIScreen.main.bounds.width
    
    private var titleFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
  
    private var selectedColor = UIColor.requestsSelectedTitleColor
    private var unSelectedColor = UIColor.requestsUnSelectedTitleColor
    private var leftColor = UIColor.requestsLeftGradienColor
    private var rightColor = UIColor.requestsRightGradienColor
    
    private var gradientViewOffset = 0.059 * UIScreen.main.bounds.width
    
    private var title: String
    private var titleWithoutCount: String
    private var totalCount: Int
    
    // MARK: - Views
    private var nameLabel: UILabel?
    private var gradientBottomView: GradientView?
    
    var isTapped: Bool = true {
        didSet {
            nameLabel?.textColor = isTapped ? selectedColor : unSelectedColor
            if isTapped {
                addGradientView()
            } else {
                gradientBottomView?.removeFromSuperview()
                gradientBottomView = nil
            }
        }
    }
    
    //MARK: - initializer
    required init?(coder aDecoder: NSCoder) {
        title = ""
        titleWithoutCount = ""
        totalCount = 0
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        title = ""
        titleWithoutCount = ""
        totalCount = 0
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String, count: Int = 0) {
        self.init(frame: frame)
        self.titleWithoutCount = title
        updateView(with: count)
        setupView()
    }
    
    // MARK: - UI setup
    func setupView() {
        // any UI setup goes here
        addTitleLabel()
        addGradientView()
    }
    
    //MARK: - update view
    func update(with count: Int, shouldAdd: Bool) {
        if shouldAdd {
            totalCount += count
        } else {
            var result = totalCount - count
            if result < 0 {
                result = 0
            }
            totalCount = result
        }
        updateView(with: totalCount)
    }
    
    func updateView(with count: Int) {
        self.totalCount = count
        if count > 0 {
            title = "\(titleWithoutCount) (\(count))"
        } else {
            title = titleWithoutCount
        }
        nameLabel?.text = title
        updateViewWidth()
    }
    
    //MARK: - private part
    private func addTitleLabel() {
        if nameLabel != nil { return }
        let labelHeight = 0.045 * screenWidth
        let labelWidth = calculateLabelWidth()
        nameLabel = UILabel(frame: CGRect(x: frame.width/2 - labelWidth/2, y: frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight))
        nameLabel?.font = titleFont
        nameLabel?.textColor = selectedColor
        nameLabel?.text = title
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
    
    private func addGradientView() {
        if gradientBottomView != nil { return }
        let viewHeight = 0.008 * screenWidth
        gradientBottomView = GradientView(frame: CGRect(x: 0, y: frame.height - viewHeight, width: frame.width, height: viewHeight))
        gradientBottomView?.drawHorizontalGradient(with: rightColor, and: leftColor)
        if gradientBottomView != nil {
            addSubview(gradientBottomView!)
        }
        addBottomViewConstraint()
    }
    
    //MARK: - calculate sizes
    private func calculateLabelWidth() -> CGFloat {
        let titleWidth = title.width(usingFont: titleFont)
        return titleWidth
    }
    
    private func updateViewWidth() {
        let labelWidth = calculateLabelWidth()
        let totalWidth = labelWidth + gradientViewOffset
        frame.size.width = totalWidth
        
        nameLabel?.frame.size.width = labelWidth
        nameLabel?.frame.origin.x = frame.width/2 - labelWidth/2
    }
    
    //MARK: - constraints
    private func addBottomViewConstraint() {
        gradientBottomView?.translatesAutoresizingMaskIntoConstraints = false
        gradientBottomView?.heightAnchor.constraint(equalToConstant: 0.008 * screenWidth).isActive = true
        gradientBottomView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradientBottomView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gradientBottomView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
