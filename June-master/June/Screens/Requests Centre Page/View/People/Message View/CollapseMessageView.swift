//
//  CollapseMessageView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/16/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class CollapseMessageView: UIView {

    // MARK: - Variables & constants
    private let screenWidth = UIScreen.main.bounds.width
    private let subjectFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private var subject: String?
    
    var messageHeight: CGFloat {
        get {
            return 0.112 * screenWidth
        }
    }
    
    //MARK: - subviewsbounds
    private var subjectLabel: UILabel?
    private var topSeparatorView: UIView?
    private var expandButton: UIButton?
    
    var onExpand: (() -> Void)?
    
    // MARK: - Layout setup logic
    func setupSubviews() {
        addTopSeperatorView()
        addSubjectLabel()
        addExpandButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onExpandeButtonTapped))
        addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Data loading
    func loadData(info: String?) {
        self.subject = info
        addAttributedString(messageSubject: info)
    }
    
    //MARK: - Private part
    private func addSubjectLabel() {
        if subjectLabel != nil { return }
        subjectLabel = UILabel()
        if subjectLabel != nil {
            addSubview(subjectLabel!)
            subjectLabel?.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0.029 * screenWidth)
                make.bottom.equalToSuperview().offset(-0.029 * screenWidth)
                make.trailing.equalToSuperview().offset(-0.106 * screenWidth)
                make.leading.equalToSuperview().offset(0.02 * screenWidth)
            }
        }
    }
    
    private func addTopSeperatorView() {
        if topSeparatorView != nil { return }
        topSeparatorView = UIView()
        topSeparatorView?.backgroundColor = UIColor.separatorGrayColor
        if topSeparatorView != nil {
            addSubview(topSeparatorView!)
            topSeparatorView?.snp.makeConstraints { make in
                make.height.equalTo(0.002 * screenWidth)
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    private func addExpandButton() {
        if expandButton != nil { return }
        expandButton = UIButton()
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.ArrowRight), for: .normal)
        expandButton?.addAction {
            self.onExpandeButtonTapped()
        }
        if expandButton != nil {
            addSubview(expandButton!)
            expandButton?.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0.029 * screenWidth)
                make.bottom.equalToSuperview().offset(-0.029 * screenWidth)
                make.leading.equalToSuperview().offset(0.738 * screenWidth)
                make.trailing.equalToSuperview().offset(-0.048 * screenWidth)
            }
        }
    }
    
    //MARK: - attributted string
    private func addAttributedString(messageSubject: String?) {
        let dotAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsDotColor, NSAttributedStringKey.font: subjectFont]
        let subjectAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsSubjectColor, NSAttributedStringKey.font: subjectFont]
        
        guard let subject = messageSubject else { return }
        let partOne = NSAttributedString(string: "• ", attributes: dotAttribute)
        let partTwo = NSAttributedString(string: subject, attributes: subjectAttribute)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        subjectLabel?.attributedText = combination
    }
    
    //MARK: - actions
    @objc private func onExpandeButtonTapped() {
        onExpand?()
    }
}
