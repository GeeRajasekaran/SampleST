//
//  StarredHeaderViewCell.swift
//  June
//
//  Created by Tatia Chachua on 05/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit

protocol StarredHeaderViewCellDelegate {
    func showMessages()
    func showStarredFeeds()
}

class StarredHeaderViewCell: UITableViewCell {
    
    var delegate: StarredHeaderViewCellDelegate?
    
    var topShadowImageView: UIImageView?
    var messagesButton: UIButton?
    var feedButton: UIButton?
    var containerView: UIView!
    
    var whiteStar: UIImageView!
    var grayStar: UIImageView!
    
    static let messagesAndFeedButtonsFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        
        print(self.tag)
        
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
        
        whiteStar = UIImageView(frame: CGRect(x: 28, y: 11, width: 12, height: 11.44))
        whiteStar.image = #imageLiteral(resourceName: "white_star")
        grayStar = UIImageView(frame: CGRect(x: 28, y: 11, width: 12, height: 11.44))
        grayStar.image = #imageLiteral(resourceName: "gray_star_feed")
        
        messagesButton = UIButton.init(type: .custom)
        messagesButton?.frame = CGRect(x: 0.138666666666 * UIScreen.main.bounds.width, y: 85-66, width: 0.386666666 * UIScreen.main.bounds.width, height: 33)
        messagesButton?.layer.cornerRadius = 33/2
        messagesButton?.setTitle(Localized.string(forKey: LocalizedString.StarredViewMessageButtonTitle), for: .normal)
        messagesButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0)
        
        if self.tag == 0 {
            messagesButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            messagesButton?.setTitleColor(.white, for: .normal)
            messagesButton?.addSubview(whiteStar)
        }
        messagesButton?.titleLabel?.font = StarredHeaderViewCell.messagesAndFeedButtonsFont
        messagesButton?.addTarget(self, action: #selector(self.messagesButtonPressed), for: .touchUpInside)
        containerView.addSubview(messagesButton!)
        
        feedButton = UIButton.init(type: .custom)
        feedButton?.frame = CGRect(x: 0.544 * UIScreen.main.bounds.width, y: 85-66, width: 0.3013333333 * UIScreen.main.bounds.width, height: 33)
        feedButton?.layer.cornerRadius = 33/2
        feedButton?.setTitle(Localized.string(forKey: LocalizedString.StarredViewFeedButtonTitle), for: .normal)
        feedButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0)
        if self.tag == 0 {
            feedButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            feedButton?.setTitleColor(#colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            feedButton?.addSubview(grayStar)
        }
        feedButton?.titleLabel?.font = StarredHeaderViewCell.messagesAndFeedButtonsFont
        feedButton?.addTarget(self, action: #selector(self.feedButtonPressed), for: .touchUpInside)
        containerView.addSubview(feedButton!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func reuseIdentifier() -> String {
        return "StarredHeaderViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func messagesButtonPressed() {
        self.delegate?.showMessages()
    }
    
    @objc func feedButtonPressed() {
        self.delegate?.showStarredFeeds()
    }
    
    func updateViews(withTag: Int) {
        
        if withTag == 10 {
            self.messagesButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            self.feedButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.messagesButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.feedButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.messagesButton?.willRemoveSubview(grayStar)
            self.messagesButton?.addSubview(whiteStar)
            self.feedButton?.willRemoveSubview(whiteStar)
            self.feedButton?.addSubview(grayStar)
            
        } else if withTag == 20 {
            self.messagesButton?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.feedButton?.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4117647059, blue: 0.9490196078, alpha: 1)
            self.messagesButton?.setTitleColor( #colorLiteral(red: 0.4745098039, green: 0.4784313725, blue: 0.5137254902, alpha: 1), for: .normal)
            self.feedButton?.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.feedButton?.willRemoveSubview(grayStar)
            self.feedButton?.addSubview(whiteStar)
            self.messagesButton?.willRemoveSubview(whiteStar)
            self.messagesButton?.addSubview(grayStar)
        }
    }
    
}
