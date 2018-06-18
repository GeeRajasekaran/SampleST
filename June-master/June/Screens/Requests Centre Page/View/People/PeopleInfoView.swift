//
//  PeopleInfoView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/11/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class PeopleInfoView: UIView {

    // MARK: - Variables & constants
    
    let screenWidth = UIScreen.main.bounds.width
    private let nameFont = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
    private let emailFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private let subjectFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    private let moreLabelFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)
    private let snippetFont = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
    private let leftOffset = 0.035 * UIScreen.main.bounds.width
    private let maxSubjectWidth = 0.733 * UIScreen.main.bounds.width
    private let moreLabelWidth = 0.136 * UIScreen.main.bounds.width
    
    private weak var info: PeopleInfo?
    
    // MARK: - Subviews
    private var profilePictureImageView: UIImageView?
    private var nameLabel: UILabel?
    private var moreLabel: UILabel?
    private var snippetLabel: UILabel?
    private var subjectLabel: UILabel?
    private var expandButton: UIButton?
    
    var onViewTappedAction: (() -> Void)?
    
    // MARK: - Layout setup logic
    func setupSubviews() {
        addContactImageView()
        addNameLabel()
        addSubjectLabel()
        addMoreLabel()
        addExpandButton()
        addSnippetLabel()
    }
    
    func loadData(info: PeopleInfo) {
        self.info = info
        if let url = info.pictureURL {
            profilePictureImageView?.hnk_setImageFromURL(url)
        }

        addAttributedString(name: info.name, email: info.email)
        addAttributedString(lastMessageSubject: info.lastMessageSubject)
        configureMoreLabelText()
        snippetLabel?.text = info.lastMessageSnippet
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func expandContent() {
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.Expand), for: .normal)
        moreLabel?.isHidden = true
        snippetLabel?.isHidden = true
    }
    
    func collapseContent() {
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.ArrowRight), for: .normal)
        moreLabel?.isHidden = false
        snippetLabel?.isHidden = false
    }
    
    //MARK: - Private part
    private func addContactImageView() {
        if profilePictureImageView != nil { return }
        let imageViewWidth = 0.112 * screenWidth
        let imageViewHeight = imageViewWidth
        let originX = 0.053 * screenWidth
        let imageViewFrame = CGRect(x: originX, y: 0, width: imageViewWidth, height: imageViewHeight)
        profilePictureImageView = UIImageView(frame: imageViewFrame)
 
        profilePictureImageView?.contentMode = .scaleAspectFill
        profilePictureImageView?.clipsToBounds = true
        profilePictureImageView?.layer.cornerRadius = imageViewHeight/2
        if profilePictureImageView != nil {
            addSubview(profilePictureImageView!)
        }
    }
    
    private func addNameLabel() {
        if nameLabel != nil { return }
        let nameLabelFrame = CGRect(x: 0.2 * screenWidth, y: 0, width: 0.733 * screenWidth, height: 0.058 * screenWidth)
        nameLabel = UILabel(frame: nameLabelFrame)
        if nameLabel != nil {
            addSubview(nameLabel!)
        }
    }
    
    private func addSubjectLabel() {
        if subjectLabel != nil { return }
        let subjectFrame = CGRect(x: 0.2 * screenWidth, y: 0.069 * screenWidth, width: maxSubjectWidth, height: 0.045 * screenWidth)
        subjectLabel = UILabel(frame: subjectFrame)
        if subjectLabel != nil {
            addSubview(subjectLabel!)
        }
    }
    
    private func addMoreLabel() {
        if moreLabel != nil { return }
        let labelFrame = CGRect(x: 0.6 * screenWidth, y: 0.069 * screenWidth, width: moreLabelWidth, height: 0.045 * screenWidth)
        moreLabel = UILabel(frame: labelFrame)
        moreLabel?.font = moreLabelFont
        moreLabel?.textColor = UIColor.requestsMoreLabelColor
        if moreLabel != nil {
            addSubview(moreLabel!)
        }
    }
    
    private func addExpandButton() {
        if expandButton != nil { return }
        let originY = 0.016 * screenWidth
        let originX = 0.954 * screenWidth
        let height = 0.032 * screenWidth
        let width = height
        let expandButtonFrame = CGRect(x: originX, y: originY, width: width, height: height)
        expandButton = UIButton(frame: expandButtonFrame)
        expandButton?.setImage(UIImage(named: LocalizedImageNameKey.RequestsViewHelper.ArrowRight), for: .normal)
        if expandButton != nil {
            addSubview(expandButton!)
        }
    }
    
    private func addSnippetLabel() {
        if snippetLabel != nil { return }
        let snippetFrame = CGRect(x: 0.2 * screenWidth, y: 0.12 * screenWidth, width: 0.784 * screenWidth, height: 0.045 * screenWidth)
        snippetLabel = UILabel(frame: snippetFrame)
        snippetLabel?.font = snippetFont
        snippetLabel?.textColor = UIColor.requestsSnippetColor
        if snippetLabel != nil {
            addSubview(snippetLabel!)
        }
        
    }

    //MARK: - attributted string
    private func addAttributedString(name: String?, email: String?) {
        let nameAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsNameColor, NSAttributedStringKey.font: nameFont]
        let emailAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsEmailColor, NSAttributedStringKey.font: emailFont]
        var unwrappedName = ""
        var unwrappedEmail = ""
        if let uName = name {
            unwrappedName = uName
        }
        
        if let uEmail = email {
            unwrappedEmail = uEmail
        }
        
        let partOne = NSAttributedString(string: unwrappedName, attributes: nameAttribute)
        let partTwo = NSAttributedString(string: "  " + unwrappedEmail, attributes: emailAttribute)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        nameLabel?.attributedText = combination
    }
    
    private func addAttributedString(lastMessageSubject: String?) {
        let dotAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsDotColor, NSAttributedStringKey.font: subjectFont]
        let subjectAttribute: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.foregroundColor: UIColor.requestsSubjectColor, NSAttributedStringKey.font: subjectFont]
        let dotString = "• "
        guard let subject = lastMessageSubject else { return }
        let subjectTextWidth = subject.width(usingFont: subjectFont)
        let dotWidth = dotString.width(usingFont: subjectFont)
        let totalWidth = subjectTextWidth + dotWidth
        updateSubjectWidth(with: totalWidth)
       
        let partOne = NSAttributedString(string: dotString, attributes: dotAttribute)
        let partTwo = NSAttributedString(string: subject, attributes: subjectAttribute)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        subjectLabel?.attributedText = combination
    }
    
    //MARK: - update subject with more label
    private func updateSubjectWidth(with contentWidth: CGFloat) {
        var resultWidth = contentWidth
        if contentWidth > maxSubjectWidth {
            resultWidth = maxSubjectWidth

            if let shouldShowLabel = info?.shouldShowMoreLabel {
                if shouldShowLabel {
                    resultWidth -= moreLabelWidth
                }
            }
        }
        
        subjectLabel?.frame.size.width = resultWidth
    }
    
    private func configureMoreLabelText() {
        if let count = info?.totalMessagesCount {
            if count > 1 {
                let string = String.init(format: LocalizedStringKey.RequestsViewHelper.MoreMessageTitle, count - 1)
                moreLabel?.text = string
                if let subjectFrame = subjectLabel?.frame {
                    moreLabel?.frame.origin.x = subjectFrame.origin.x + subjectFrame.size.width + leftOffset/3
                }
            }
        }
    }
    
    //MARK: - actions
    @objc func onViewTapped() {
        onViewTappedAction?()
    }
}
