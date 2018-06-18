//
//  ThreadsHeaderViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 8/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ThreadsHeaderViewCellDelegate {
    func showNewMessages()
    func showReadAndSentMessages()
    func showMoreButton()
}

class ThreadsHeaderViewCell: UITableViewCell {

    var delegate: ThreadsHeaderViewCellDelegate?
    var topShadowImageView: UIImageView?
    var newMessagesButton: UIButton?
    var readSentButton: UIButton?
    var moreButton: UIButton?
    var containerView: UIView!
    
    static let newMessagesButtonFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let readSentButtonFont: UIFont =  UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let moreBUttonFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .midExtraLarge)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = UIColor.white
        self.addSubview(containerView)
        
        let imageName = LocalizedImageNameKey.HomeViewHelper.NavigationBarBottomImageName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 4)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        containerView.addSubview(imageView)
        
        topShadowImageView = UIImageView(frame: CGRect(x: 0, y: 105-66, width: UIScreen.main.bounds.size.width, height: 27))
        topShadowImageView?.image = #imageLiteral(resourceName: "topshadow")
        topShadowImageView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        containerView.addSubview(topShadowImageView!)
        
        newMessagesButton = UIButton.init(type: .custom)
        newMessagesButton?.frame = CGRect(x: 0.04 * UIScreen.main.bounds.size.width, y: 85-66, width: 0.4 * UIScreen.main.bounds.width, height: 33)
        newMessagesButton?.layer.cornerRadius = 0.044 * UIScreen.main.bounds.width
        newMessagesButton?.setTitle(Localized.string(forKey: LocalizedString.ThreadsViewNewConversationsButtonTitle), for: .normal)
        if self.tag == 0 {
            newMessagesButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            newMessagesButton?.setTitleColor(.white, for: .normal)
        }
        newMessagesButton?.titleLabel?.font = ThreadsHeaderViewCell.newMessagesButtonFont
        newMessagesButton?.addTarget(self, action: #selector(self.newMessagesButtonPressed), for: .touchUpInside)
        containerView.addSubview(newMessagesButton!)
        
        readSentButton = UIButton.init(type: .custom)
        readSentButton?.frame = CGRect(x: 0.453333333 * UIScreen.main.bounds.width, y: 85-66, width: 0.376 * UIScreen.main.bounds.width, height: 33)
        readSentButton?.layer.cornerRadius = 0.044 * UIScreen.main.bounds.width //  33/2
        readSentButton?.setTitle(Localized.string(forKey: LocalizedString.ThreadsViewConversationsButtonTitle), for: .normal)
        if self.tag == 0 {
            readSentButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            readSentButton?.setTitleColor(#colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        }
        readSentButton?.titleLabel?.font = ThreadsHeaderViewCell.readSentButtonFont
        readSentButton?.addTarget(self, action: #selector(self.readSentButtonPressed), for: .touchUpInside)
        containerView.addSubview(readSentButton!)
        
        moreButton = UIButton.init(type: .custom)
        moreButton?.frame = CGRect(x: 0.8533333333 * UIScreen.main.bounds.width, y: 85-66, width: 0.088 * UIScreen.main.bounds.width, height: 0.088 * UIScreen.main.bounds.width)  //
        moreButton?.layer.cornerRadius = 0.044 * UIScreen.main.bounds.width
        moreButton?.setTitle("...", for: .normal)
        if self.tag == 0 {
            moreButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            moreButton?.setTitleColor(#colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        }
        moreButton?.titleLabel?.font = ThreadsHeaderViewCell.moreBUttonFont
        moreButton?.contentHorizontalAlignment = .left
        moreButton?.contentVerticalAlignment = .top
        moreButton?.titleEdgeInsets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0)
        moreButton?.addTarget(self, action: #selector(self.moreButtonPressed), for: .touchUpInside)
        containerView.addSubview(moreButton!)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func reuseIdentifier() -> String {
        return "ThreadsHeaderViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func newMessagesButtonPressed() {
        self.newMessagesButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
        self.readSentButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.moreButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.newMessagesButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.readSentButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        self.moreButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        self.delegate?.showNewMessages()
    }
    
    @objc func readSentButtonPressed() {
        self.newMessagesButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.readSentButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
        self.moreButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.newMessagesButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        self.readSentButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.moreButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        self.delegate?.showReadAndSentMessages()
    }
    
    @objc func moreButtonPressed() {
        self.newMessagesButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.readSentButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.moreButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
        self.newMessagesButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        self.readSentButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        self.moreButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.delegate?.showMoreButton()
    }
    
    func updateViews(withTag: Int) {
        if withTag == 10 || withTag == 0 {
            self.newMessagesButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            self.readSentButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.moreButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.newMessagesButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.readSentButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.moreButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        } else if withTag == 20 {
            self.newMessagesButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.readSentButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            self.moreButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.newMessagesButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.readSentButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.moreButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
        } else if withTag == 30 {
            self.newMessagesButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.readSentButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.moreButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            self.newMessagesButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.readSentButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.moreButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else if withTag == 40 {
            self.newMessagesButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.readSentButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.moreButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            self.newMessagesButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.readSentButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.moreButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }

    }

}
