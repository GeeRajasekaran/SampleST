//
//  ThreadsDetailViewTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Down
import CoreText
import QuartzCore
import Kingfisher
import SnapKit

protocol ThreadsDetailViewTableViewCellSwipeAction {
    var color: UIColor { get }
    var title: String { get }
}

protocol ThreadsDetailViewTableViewCellDelegate {
    func replyButtonPressedActionView(indexPath: IndexPath)
    func replyAllButtonPressedActionView(indexPath: IndexPath)
    func forwardButtonPressedActionView(indexPath: IndexPath)
    func reportButtonPressedActionView(indexPath: IndexPath)
    func fullEmailButtonPressedActionView(indexPath: IndexPath)
    func viewAllButtonPressedActionView(indexPath: IndexPath)
    func undoButtonPressedAction(indexPath: IndexPath)
    func markFromReplierAsFalse(indexPath: IndexPath)
    func showActionSheet(indexPath: IndexPath)
    func markErrorAppearedAsTrue()
}

class ThreadsDetailViewTableViewCell: UITableViewCell {
    
    var delegate: ThreadsDetailViewTableViewCellDelegate?
    let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    var message: Messages?
    var scrollView: UIScrollViewSuperTaps!
    var containerView: UIView!
    var actionView: UIView!
    var attachmentsView: AttachmentsView?
    var onOpenAttachment: ((Attachment) -> Void)?
    var onWebViewClicked: (() -> Void)?

    let minOffset: CGFloat = 50
    var webViewHeight: CGFloat = 0
    var forwardedWebViewHeight: CGFloat = 0
    var cellVisible:Bool?
    var cellVisibleHeight: CGFloat = 0
    var isLeftSideVisible:Bool {
        return scrollView.contentOffset.x < 0
    }
    var isRightSideVisible:Bool {
        return scrollView.contentOffset.x > 0
    }
    var selectedAction: ThreadsDetailViewTableViewCellSwipeAction?
    var leftActions: [ThreadsDetailViewTableViewCellSwipeAction] = []
    var rightActions: [ThreadsDetailViewTableViewCellSwipeAction] = []
    var marginGuide = UILayoutGuide()
    let nameLabel = UILabel()
    var contentHeights : [CGFloat] = []
    var indexPath: IndexPath!
    let dateLabel = UILabel()
    var containsForwardedMessage:Bool?
    var viewAll:Bool?
    var unreadBeginning:Bool = false
    var loadedOnce:Bool?
    var receivers: [EmailReceiver] = []
    var replierSuccess : Bool?
    var fromReplier: Bool = false

    let replyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "reply-icon-v1"), for: .normal)
        return button
    }()

    let replyAllButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "reply-all-v1"), for: .normal)
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share-v1"), for: .normal)
        return button
    }()
    
    let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "purple_oval"), for: .normal)
        return button
    }()
    
    let fullEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "purple_oval"), for: .normal)
        return button
    }()
    
    let profileImageView: JuneImageView = {
        let profileImage = JuneImageView(viewType: .circle)
        profileImage.configurePlaceholder()
        profileImage.contentMode = .scaleToFill
        profileImage.isHidden = true
        return profileImage
    }()
    
    let newMessageLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "unread_new_message_line")
        imageView.isHidden = true
        return imageView
    }()
    
    let webView: UIWebView = {
        let webV = UIWebView()
        return webV
    }()
    
    let forwardedWebView: UIWebView = {
        let webV = UIWebView()
        return webV
    }()
    
    let forwardedMessageTitle: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        return label
    }()
    
    let forwardedSideLine: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let viewOrHideMessageTitle: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.4588235294, green: 0.5450980392, blue: 0.9647058824, alpha: 1)
        return label
    }()
    
    let forwardedFrom: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let forwardedTo: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.4588235294, green: 0.5450980392, blue: 0.9647058824, alpha: 1)
        return label
    }()
    
    let viewHideButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return button
    }()
    
    var email: String!
    let emailLabel = UILabel()
    
    let emailImageView: UIImageView = {
        let emailImg = UIImageView()
        emailImg.backgroundColor = UIColor.white
        emailImg.isHidden = true
        return emailImg
    }()
    
    var undoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return button
    }()
    
    let statusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return button
    }()
    
    let statusImageView: UIImageView = {
        let statusImg = UIImageView()
        statusImg.backgroundColor = UIColor.white
        return statusImg
    }()

    let successIcon: UIImageView = {
        let successIcon = UIImageView()
        successIcon.backgroundColor = UIColor.white
        return successIcon
    }()
    
    let errorIcon: UIImageView = {
        let successIcon = UIImageView()
        successIcon.backgroundColor = UIColor.white
        return successIcon
    }()
    
    let errorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return button
    }()
    
    //  for link view
    var containsUrl: Bool!
    var websiteURL = ""
    var youtubeURL: String!
    
    let linkView: UIView = {
        let view = UIView()
        return view
    }()
    
    let linkBoxView: UIView = {
        let view = UIView()
        return view
    }()
    
    let linkBoxShadow: UIView = {
        let view = UIView()
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1)
        label.numberOfLines = 0
        return label
    }()
    
    let urlLabel: UILabel = {
        let url = UILabel()
        url.textColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1)
        url.textAlignment = .left
        return url
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.textColor = UIColor.darkGray
        title.numberOfLines = 0
        return title
    }()
    
    let siteNamelabel: UILabel = {
        let name = UILabel()
        return name
    }()
    
    let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = UIColor.clear
        return icon
    }()
    
    let websiteImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let videoFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.88, green:0.17, blue:0.15, alpha:1)
        return view
    }()
    
    let videoShadowView: UIView = {
        let view = UIView()
        return view
    }()
    
    let videoView: UIWebView = {
        let view = UIWebView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    @objc private func replyButtonPressed() {
        self.delegate?.replyButtonPressedActionView(indexPath: indexPath)
    }
    
    @objc private func replyAllButtonPressed() {
        self.delegate?.replyAllButtonPressedActionView(indexPath: indexPath)
    }
    
    @objc private func forwardButtonPressed() {
        self.delegate?.forwardButtonPressedActionView(indexPath: indexPath)
    }
    
    @objc private func reportButtonPressed() {
        self.delegate?.reportButtonPressedActionView(indexPath: indexPath)
    }
    
    @objc private func fullEmailButtonPressed() {
        self.delegate?.fullEmailButtonPressedActionView(indexPath: indexPath)
    }
    
    @objc private func errorButtonPressed() {
        self.delegate?.showActionSheet(indexPath: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        marginGuide = contentView.layoutMarginsGuide
        self.setupView()
        
    }
    
    @objc private func viewHideButtonPressed () {
        self.viewHideButton.isEnabled = false
        self.loadedOnce = true
        if let longView = self.viewAll {
            if longView {
                self.viewOrHideMessageTitle.text = "HIDE MESSAGE"
            } else {
                self.viewOrHideMessageTitle.text = "VIEW MESSAGE"
            }
        } else {
            self.viewOrHideMessageTitle.text = "VIEW MESSAGE"
        }
        self.delegate?.viewAllButtonPressedActionView(indexPath: self.indexPath)
    }
    
    internal func setupView() {
        self.backgroundColor = .white
        contentView.backgroundColor = .white
      
        scrollView = UIScrollViewSuperTaps(frame: bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = bounds.size
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width)
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.isUserInteractionEnabled = true
        contentView.addSubview(scrollView)

        actionView = UIView(frame: CGRect(origin: .zero, size: bounds.size))
        actionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        actionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        actionView.isUserInteractionEnabled = true
        scrollView.addSubview(actionView)
        
        replyButton.frame = CGRect(x: 189, y: Int(self.bounds.height / 2) - 30, width: 44, height: 60)
        replyButton.setImage(#imageLiteral(resourceName: "reply-icon-v1"), for: .normal)
        replyButton.setImage(#imageLiteral(resourceName: "reply-icon-v1-selected"), for: .highlighted)
        replyButton.imageView?.contentMode = .scaleAspectFit
        replyButton.addTarget(self, action: #selector(replyButtonPressed), for: .touchUpInside)
        actionView.addSubview(replyButton)
        
        replyAllButton.frame = CGRect(x: 243, y: Int(self.bounds.height / 2) - 30, width: 48, height: 60)
        replyAllButton.setImage(#imageLiteral(resourceName: "reply-all-v1"), for: .normal)
        replyAllButton.setImage(#imageLiteral(resourceName: "reply-all-v1-highlighted"), for: .highlighted)
        replyAllButton.imageView?.contentMode = .scaleAspectFit
        replyAllButton.addTarget(self, action: #selector(replyAllButtonPressed), for: .touchUpInside)
        actionView.addSubview(replyAllButton)
        
        forwardButton.frame = CGRect(x: 301, y: Int(self.bounds.height / 2) - 30, width: 44, height: 60)
        forwardButton.setImage(#imageLiteral(resourceName: "share-v1"), for: .normal)
        forwardButton.setImage(#imageLiteral(resourceName: "share-v1-highlighted"), for: .highlighted)
        forwardButton.imageView?.contentMode = .scaleAspectFit
        forwardButton.addTarget(self, action: #selector(forwardButtonPressed), for: .touchUpInside)
        actionView.addSubview(forwardButton)
        
        reportButton.frame = CGRect(x: 197, y: Int(self.bounds.height / 2) - 20, width: 60, height: 60)
        reportButton.setImage(#imageLiteral(resourceName: "reportbutton"), for: .normal)
        reportButton.addTarget(self, action: #selector(reportButtonPressed), for: .touchUpInside)
        
        fullEmailButton.frame = CGRect(x: 266, y: Int(self.bounds.height / 2) - 20, width: 60, height: 60)
        fullEmailButton.setImage(#imageLiteral(resourceName: "fullemailbutton"), for: .normal)
        fullEmailButton.addTarget(self, action: #selector(fullEmailButtonPressed), for: .touchUpInside)
       
        containerView = UIView(frame: bounds)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = UIColor.white
        containerView.isUserInteractionEnabled = true
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 8
        scrollView.addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 7).isActive = true
        profileImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        profileImageView.layer.cornerRadius = 34/2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = false
        
        containerView.addSubview(nameLabel)
        nameLabel.autoresizingMask = .flexibleHeight
        nameLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(profileImageView.snp.top).offset(-3)
            make.trailing.equalTo(self.containerView).offset(-105)
        }
        nameLabel.layoutIfNeeded()
        
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = false
        nameLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        nameLabel.layoutIfNeeded()
        nameLabel.textAlignment = .left
        
        
        containerView.addSubview(dateLabel)
        dateLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.leading.equalTo(nameLabel.snp.trailing).offset(-5)
            make.top.equalTo(profileImageView.snp.top).offset(-3)
            make.width.equalTo(ConvosNewPreviewView.dateLabelWidth)
        }
        dateLabel.layoutIfNeeded()

        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regular)
        dateLabel.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        dateLabel.textAlignment = .right
        dateLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
     
        webView.delegate = self
        containerView.addSubview(self.webView)
        self.webView.scrollView.isScrollEnabled = false
        self.webView.translatesAutoresizingMaskIntoConstraints = true
        self.webView.backgroundColor = .clear
        self.webView.isOpaque = false
        self.webView.isUserInteractionEnabled = false
        
        if self.forwardedWebViewHeight > 0 && self.containsForwardedMessage! {
            containerView.addSubview(self.forwardedMessageTitle)
            self.forwardedMessageTitle.text = "Begin forwarded message:"
            self.forwardedMessageTitle.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)

            self.viewOrHideMessageTitle.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
            containerView.addSubview(self.viewOrHideMessageTitle)
            self.viewOrHideMessageTitle.isHidden = true

            containerView.addSubview(self.forwardedFrom)
            self.forwardedFrom.numberOfLines = 1
            self.forwardedFrom.font = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)

            containerView.addSubview(self.forwardedTo)
            self.forwardedTo.numberOfLines = 1
            self.forwardedTo.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)

            containerView.addSubview(self.forwardedSideLine)
            self.forwardedSideLine.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.5450980392, blue: 0.9647058824, alpha: 1)

            containerView.addSubview(self.viewHideButton)
            self.viewHideButton.addTarget(self, action: #selector(fullEmailButtonPressed), for: .touchUpInside)

            if self.message != nil {
                self.addForwardedMessage(using: self.message!)
            }
            
        }
        
        self.scrollView.addSubview(self.newMessageLineImageView)
        self.newMessageLineImageView.frame = CGRect(x: 10, y: 0, width: self.scrollView.frame.size.width - 20, height: 10)
        self.newMessageLineImageView.contentMode = .scaleToFill
        // temp hide new message line
        self.newMessageLineImageView.isHidden = true

        self.emailLabel.frame = CGRect(x: 2, y: 2, width: 204, height: 20)
        self.emailLabel.font = UIFont.proximaNovaStyleAndSize(style: .bold, size: .regular)
        self.emailLabel.textColor = .black
        self.emailLabel.textAlignment = .center
        
        self.emailImageView.addSubview(emailLabel)
        self.emailImageView.isHidden = true
        self.emailImageView.frame = CGRect(x: 62, y: 42, width: 205, height: 23)
        self.containerView.addSubview(emailImageView)
        self.emailImageView.addSubview(self.emailLabel)
        
        // Temporarily hide link view
        self.linkView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nameTapped))
        tapGesture.numberOfTapsRequired = 1
        self.nameLabel.isUserInteractionEnabled = true
        self.nameLabel.addGestureRecognizer(tapGesture)
    
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func webViewTapped(_ sender: UITapGestureRecognizer) {
        onWebViewClicked?()
    }
    
    @objc func nameTapped() {
        if self.emailImageView.isHidden == true {
            emailImageView.isHidden = false
        } else {
            emailImageView.isHidden = true
        }
    }
    
    //    add link view
    func addLinkView() {
        
        self.linkView.frame = CGRect(x: 48, y: 52 + self.webViewHeight, width: 301, height: 203.26)
        self.linkView.backgroundColor = UIColor.white
        self.containerView.addSubview(linkView)
        
        self.iconImage.frame = CGRect(x: 0, y: 0, width: 16, height: 17)
        self.linkView.addSubview(iconImage)
        
        self.siteNamelabel.frame = CGRect(x: 26, y: 3, width: 150, height: 12)
        self.siteNamelabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        self.siteNamelabel.textColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1)
        self.siteNamelabel.textAlignment = .left
        self.linkView.addSubview(siteNamelabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        tap.numberOfTapsRequired = 1
        self.linkView.isUserInteractionEnabled = true
        self.linkView.addGestureRecognizer(tap)
        self.siteNamelabel.isUserInteractionEnabled = true
        self.siteNamelabel.addGestureRecognizer(tap)
    }
    
    @objc func linkTapped() {
        
        let link = self.websiteURL
        let str = link.replacingOccurrences(of: "</p>", with: "")
        
        if let url = URL(string: str) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    func addLinkBoxWithoutImage() {
        
        self.linkBoxShadow.frame = CGRect(x: 0, y: 60, width: self.linkView.frame.size.width, height: 203.26)
        self.linkBoxShadow.backgroundColor = UIColor.clear
        self.linkBoxShadow.layer.borderWidth = 1
        self.linkBoxShadow.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1).cgColor
        self.linkBoxShadow.layer.cornerRadius = 4
        self.linkBoxShadow.layer.shadowColor = UIColor.lightGray.cgColor
        self.linkBoxShadow.layer.shadowOpacity = 0.3
        self.linkBoxShadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.linkBoxShadow.layer.shadowRadius = 8
        self.linkView.addSubview(linkBoxShadow)
        
        self.linkBoxView.frame = CGRect(x: 0, y: 0, width: self.linkView.frame.size.width, height: 203.26)
        self.linkBoxView.backgroundColor = UIColor.white
        self.linkBoxView.clipsToBounds = true
        self.linkBoxView.layer.borderWidth = 1
        self.linkBoxView.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1).cgColor
        self.linkBoxView.layer.cornerRadius = 4
        self.linkBoxView.layer.shadowColor = UIColor.lightGray.cgColor
        self.linkBoxView.layer.shadowOpacity = 0.3
        self.linkBoxView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.linkBoxView.layer.shadowRadius = 8
        self.linkBoxShadow.addSubview(linkBoxView)
        
        self.urlLabel.frame = CGRect(x: 0, y: 26, width: 290, height: 14)
        self.urlLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        self.linkView.addSubview(urlLabel)
        
        self.titleLabel.frame = CGRect(x: 30, y: 24, width: self.linkBoxView.frame.size.width - 60, height: 66)
        self.titleLabel.font = UIFont.latoStyleAndSize(style: .semibold, size: .largeMedium)
        self.linkBoxView.addSubview(titleLabel)
        
        self.descriptionLabel.frame = CGRect(x: 30, y: 96, width: self.linkBoxView.frame.size.width - 60, height: 68)
        self.descriptionLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        self.linkBoxView.addSubview(descriptionLabel)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 3.63, height: self.linkBoxView.frame.height)
        gradient.colors = [UIColor(red:0.49, green:0.44, blue:1, alpha:1).cgColor,    UIColor(red:0.61, green:0.9, blue:0.99, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1.01, y: 1)
        self.linkBoxView.layer.addSublayer(gradient)
        
    }
    
    func addLinkBoxWithImage() {
        
        self.linkBoxShadow.frame = CGRect(x: 0, y: 60, width: self.linkView.frame.size.width, height: 352)
        self.linkBoxShadow.backgroundColor = UIColor.clear
        self.linkBoxShadow.layer.borderWidth = 1
        self.linkBoxShadow.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1).cgColor
        self.linkBoxShadow.layer.cornerRadius = 4
        self.linkBoxShadow.layer.shadowColor = UIColor.lightGray.cgColor
        self.linkBoxShadow.layer.shadowOpacity = 0.3
        self.linkBoxShadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.linkBoxShadow.layer.shadowRadius = 8
        self.linkView.addSubview(linkBoxShadow)
        
        self.linkBoxView.frame = CGRect(x: 0, y: 0, width: self.linkView.frame.size.width, height: 352)
        self.linkBoxView.backgroundColor = UIColor.white
        self.linkBoxView.clipsToBounds = true
        self.linkBoxView.layer.borderWidth = 1
        self.linkBoxView.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1).cgColor
        self.linkBoxView.layer.cornerRadius = 4
        self.linkBoxView.layer.shadowColor = UIColor.lightGray.cgColor
        self.linkBoxView.layer.shadowOpacity = 0.3
        self.linkBoxView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.linkBoxView.layer.shadowRadius = 8
        self.linkBoxShadow.addSubview(linkBoxView)
        
        self.urlLabel.frame = CGRect(x: 0, y: 26, width: 290, height: 14)
        self.urlLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        self.linkView.addSubview(urlLabel)
        
        self.websiteImage.frame = CGRect(x: 2.63, y: 0, width: self.linkView.frame.size.width, height: 170)
        self.linkBoxView.addSubview(websiteImage)
        
        self.titleLabel.frame = CGRect(x: 30, y: 163 + 22, width: self.linkBoxView.frame.size.width - 60, height: 66)
        self.linkBoxView.addSubview(titleLabel)
        
        self.descriptionLabel.frame = CGRect(x: 30, y: 240 + 22, width: self.linkBoxView.frame.size.width - 60, height: 68)
        self.descriptionLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        self.linkBoxView.addSubview(descriptionLabel)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 4.63, height: self.linkBoxView.frame.height)
        gradient.colors = [UIColor(red:0.49, green:0.44, blue:1, alpha:1).cgColor,    UIColor(red:0.61, green:0.9, blue:0.99, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1.01, y: 1)
        self.linkBoxView.layer.addSublayer(gradient)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        tap.numberOfTapsRequired = 1
        self.websiteImage.isUserInteractionEnabled = true
        self.websiteImage.addGestureRecognizer(tap)
        
    }
    
    func addVideoLink() {
        
        self.titleLabel.frame = CGRect(x: 0, y: 28, width: self.linkView.frame.size.width - 5, height: 17)
        self.titleLabel.font = UIFont(name: "Lato Semibold", size: 14)
        self.linkView.addSubview(titleLabel)
        
        self.urlLabel.frame = CGRect(x: 0, y: 50, width: self.linkView.frame.size.width - 5, height: 14)
        self.urlLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        self.linkView.addSubview(urlLabel)
        
        self.videoShadowView.frame = CGRect(x: 0, y: 82, width: self.linkView.frame.size.width, height: 170)
        self.videoShadowView.backgroundColor = UIColor.clear
        self.videoShadowView.layer.cornerRadius = 4
        self.videoShadowView.layer.shadowColor = UIColor.lightGray.cgColor
        self.videoShadowView.layer.shadowOpacity = 0.3
        self.videoShadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.videoShadowView.layer.shadowRadius = 8
        self.linkView.addSubview(videoShadowView)
        
        self.videoFrameView.frame = CGRect(x: 0, y: 0, width: self.linkView.frame.size.width, height: 170)
        self.videoFrameView.layer.cornerRadius = 4
        self.videoFrameView.clipsToBounds = true
        self.videoShadowView.addSubview(videoFrameView)
        
        self.videoView.frame = CGRect(x: 3.87, y: 0, width: self.linkView.frame.size.width, height: 170)
        self.videoFrameView.addSubview(videoView)
        
        let url = URL(string: self.youtubeURL)
        self.videoView.loadRequest( URLRequest(url: url!))
        
    }
    
    func addForwardedMessage(using message: Messages) {
        if self.containsForwardedMessage == false {
            return
        }
        self.forwardedMessageTitle.isHidden = false
        self.viewOrHideMessageTitle.isHidden = false
        self.forwardedFrom.isHidden = false
        self.forwardedTo.isHidden = false
        self.forwardedSideLine.isHidden = false
        self.viewHideButton.isHidden = false
        self.loadForwardedMessages()
    }
    
    func loadForwardedMessages() {
                
        let fromArray = self.message?.messages_forwarded_from?.allObjects as? Array<Messages_Forwarded_From>
        if fromArray?.count != nil {
            if let from:Messages_Forwarded_From = fromArray?.first {
                if from.name?.count == 0 {
                    self.forwardedFrom.text = from.email
                } else {
                    self.forwardedFrom.text = from.name
                }
            }
        }
        
        let toArray = self.message?.messages_forwarded_to?.allObjects as? Array<Messages_Forwarded_To>
        if toArray?.count != nil {
            var nameArray: [String] = []
            for toData in toArray! {
                let toObject:Messages_Forwarded_To = toData
                if let name = toObject.name {
                    nameArray.append(name)
                } else  if let email = toObject.email {
                    // crash detected
                    nameArray.append(email)
                }
            }
            let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: ", ")
            let toString = "to " + nameConcatenatedString
            self.forwardedTo.text = toString
        }
        
    }
    
    func addAttachmentsView(using message: Messages) {
        guard let files = message.messages_files else { return }
        if files.count == 0 {
            if attachmentsView != nil {
                attachmentsView?.removeFromSuperview()
            }
            return
        }
        
        attachmentsView = AttachmentsView()
        containerView.addSubview(attachmentsView!)
        attachmentsView?.autoresizingMask = .flexibleHeight
        attachmentsView?.snp.remakeConstraints({ (make) in
            make.height.equalTo(attachmentsViewHeight)
            make.top.equalTo(webView.snp.bottom)
            make.leading.equalTo(webView.snp.leading)
            make.trailing.equalTo(webView.snp.trailing)
        })
        attachmentsView?.clipsToBounds = true
        attachmentsView?.backgroundColor = .white
        attachmentsView?.layoutIfNeeded()

        attachmentsView?.onOpenAttachment = onOpenAttachment
        attachmentsView?.setupSubviews(for: message)
    }
    
    
    class func reuseIdentifier() -> String {
        return "ThreadsDetailViewTableViewCell"
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.scrollView.removeFromSuperview()
    }
    
    func loadWebViewsWith(messages: Messages) {
        
        //MARK: - if message have sharing message id should load body
        if messages.sharing_message_id != nil {
            let html = messages.body!
            webView.loadHTMLString(html, baseURL: nil)
            return
        } 
        
        let segmentedHtmlArray = messages.messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
        if ((segmentedHtmlArray?.count) != nil && (segmentedHtmlArray?.count)! > 0) {
            for segmentedHtml in segmentedHtmlArray! {
                if segmentedHtml.order == 1 && segmentedHtml.type == "top_message" {
                    if segmentedHtml.html_markdown != nil {
                        let down = Down(markdownString: segmentedHtml.html_markdown!)
                        // Convert to HTML
                        let html = try? down.toHTML(.HardBreaks)
                        let htmlString = "<span style=\"font-family:Lato; font-size: 15; color:#6699FF\">" + html! + "</span>"
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString(htmlString , baseURL: nil)
                        }
                    } else
                        if segmentedHtml.html != nil {
                            let htmlString = "<span style=\"font-family:Lato; font-size: 15; color:#6699FF\">" + segmentedHtml.html! + "</span>"
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString(htmlString, baseURL: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                            }
                    }
                }
            }
        } else {
            var html = messages.body!
            let string = html
            if let range = string.range(of: "<blockquote") {
                let firstPart = string[string.startIndex..<range.lowerBound]
                html = firstPart + "</html>"
            }
            if !html.isEmpty {
                let htmlString = "<span style=\"font-family:Lato; font-size: 15; color:#6699FF\">" + html + "</span>"
                DispatchQueue.main.async {
                    self.webView.loadHTMLString(htmlString, baseURL: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                }
            }
        }
        
        let fromArray = messages.messages_from?.allObjects as? Array<Messages_From>
        if fromArray?.count != nil {
            if let from:Messages_From = fromArray?.first {
                if let imagePath = from.profile_pic {
                    profileImageView.configureImage(with: imagePath)
                }
            }
        }
        
    }
    
    func setMessagesCellWith(messages: Messages) {
                
        var fromString = String()
        if let from_string = nameLabel.text {
            if from_string.count == 0 {
                fromString = ""
            } else {
                fromString = from_string
            }
        } else {
            fromString = ""
        }
        
        let fromFont = UIFont(name: LocalizedFontNameKey.ThreadsDetailViewHelper.FromParticipantLabelFontRegular, size: 16)
        let fromWidth = 200
        var fromHeight = ThreadsDetailViewHelper.init().heightForLabel(fromString, font: fromFont!, width: CGFloat(fromWidth), lineSpacing: 0.0)
        if fromHeight < 20 {
            fromHeight = 20
        }
        
        if self.webViewHeight > 0  {
            self.webView.frame = CGRect(x: 48 - 8, y: 15 + 22, width: (0.85 * self.frame.size.width) + 8, height: self.webViewHeight)
        }
        
        if self.forwardedWebViewHeight > 0 && self.containsForwardedMessage! {
            
            self.forwardedMessageTitle.frame = CGRect(x: self.nameLabel.frame.origin.x, y: self.webView.frame.origin.x + self.webView.frame.size.height , width: 150, height: 15)

            self.viewOrHideMessageTitle.frame = CGRect(x: self.forwardedMessageTitle.frame.origin.x + self.forwardedMessageTitle.frame.size.width + 7, y: self.forwardedMessageTitle.frame.origin.y, width: 150, height: 15)

            self.forwardedSideLine.frame = CGRect(x: self.forwardedMessageTitle.frame.origin.x, y: self.forwardedMessageTitle.frame.origin.y + self.forwardedMessageTitle.frame.size.height + 5, width: 2, height: 50)

            self.forwardedFrom.frame = CGRect(x: self.forwardedMessageTitle.frame.origin.x + 10, y: self.forwardedSideLine.frame.origin.y, width: 0.83 * self.frame.size.width, height: 20)

            self.forwardedTo.frame = CGRect(x: self.forwardedFrom.frame.origin.x, y: self.forwardedFrom.frame.origin.y + self.forwardedFrom.frame.size.height, width: self.forwardedFrom.frame.size.width, height: 15)
            
            self.viewHideButton.frame = CGRect(x: self.forwardedMessageTitle.frame.origin.x, y: self.forwardedMessageTitle.frame.origin.y, width: (0.83 * self.frame.size.width), height: 60)
        }
        
        let dateInt = messages.date
        dateLabel.text = FeedDateConverter().timeAgoInWords(from: dateInt)
        self.checkIfThereIsATempCell(messagesObject: messages)
        self.showOrHideTheIcons()
        
      
    }
    
    func checkIfThereIsATempCell(messagesObject: Messages) {
        
        if let tempId = messagesObject.messages_id {
            if tempId.isEqualToString(find: "tempId") {
                self.dateLabel.isHidden = true
                self.undoButton.isHidden = false
                
                self.statusImageView.isHidden = false
                self.statusImageView.frame = CGRect(x: 330, y: 10, width: 22, height: 22)
                self.statusImageView.image = #imageLiteral(resourceName: "dual-ring")
                self.containerView.addSubview(self.statusImageView)
                
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.fromValue = 0.0
                rotationAnimation.toValue = Double.pi
                rotationAnimation.duration = 1.0
                rotationAnimation.repeatCount = 100
                self.statusImageView.layer.add(rotationAnimation, forKey: nil)
            } else {
                self.statusImageView.isHidden = true
                self.dateLabel.isHidden = false
            }
        }
        
    }
    
    func showOrHideTheIcons() {
        if self.fromReplier, let replierSuccess = self.replierSuccess, replierSuccess == true {
            self.statusImageView.isHidden = true
            self.dateLabel.isHidden = false
        } else if self.fromReplier, let replierSuccess = self.replierSuccess, !replierSuccess {
            self.dateLabel.isHidden = true
            self.errorIcon.frame = CGRect(x: 330, y: 10, width: 22, height: 22)
            self.errorIcon.image = #imageLiteral(resourceName: "exclamation-mark-replier")
            self.containerView.addSubview(self.errorIcon)
            
            self.errorButton.frame = CGRect(x: self.errorIcon.frame.origin.x - 10, y: self.errorIcon.frame.origin.y - 10, width: 42, height: 42)
            self.errorButton.backgroundColor = .clear
            self.errorButton.addTarget(self, action: #selector(self.errorButtonPressed), for: .touchUpInside)
            self.containerView.addSubview(self.errorButton)
            
            self.delegate?.markErrorAppearedAsTrue()
        }
    }
    
    @objc func undoButtonPressed() {
        self.delegate?.undoButtonPressedAction(indexPath: self.indexPath)
    }
    
    private func username() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        
        if let accounts = serializedUserObject["accounts"] as? [[String: Any]], let firstAccount = accounts.first {
            if let name = firstAccount["name"] as? String {
                return name
            }
        }
        return nil
    }
    
    private func userPrimaryEmail() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        if let primary_email = serializedUserObject["primary_email"] {
            return primary_email as? String
        }
        return nil
    }
    
    private func userProfilePic() -> String? {
        guard let userObjectData = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) else { return nil }
        let serializedUserObject = KeyChainManager.NSDATAtoDictionary(data: userObjectData)
        print(serializedUserObject as Any)
        if let profile_image = serializedUserObject["profile_image"] {
            return profile_image as? String
        }
        return nil
    }

    
    func findVisibleAction() -> ThreadsDetailViewTableViewCellSwipeAction? {
        let offsetX = abs(scrollView.contentOffset.x)
        
        let actionsWidth = scrollView.contentSize.width - minOffset
        
        if offsetX < minOffset {
            return nil
        }
        
        if isLeftSideVisible {
            let actionOffset = actionsWidth / CGFloat(leftActions.count)
            let i = max(0, Int((offsetX - minOffset) / actionOffset))
            return i < leftActions.count ? leftActions[i] : nil
        }
        
        if isRightSideVisible {
            let actionOffset = actionsWidth / CGFloat(rightActions.count)
            let i = max(0, Int((offsetX - minOffset) / actionOffset))
            return i < rightActions.count ? rightActions[i] : nil
        }
        
        return nil
    }
    
    func relativePast(for dateInt : Int32) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        if (components.day! < 1) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            return localDate
        } else if components.day! >= 1 && components.day! <= 2 {
            let labelDate =  "Yesterday" // localDate
            return labelDate
        } else if components.day! > 2 && components.day! <= 6 {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE"
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
            
        }
    }
        
}

extension ThreadsDetailViewTableViewCell : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        if offsetX < 0 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        actionView.frame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: actionView.frame.size)

        let action = selectedAction ?? findVisibleAction()

        actionView.backgroundColor = action?.color ?? UIColor.white
        contentView.backgroundColor = action?.color ?? .white
    }
 
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetX = abs(scrollView.contentOffset.x)
        print("offset x = ", offsetX)
        print("targetContentOffset.pointee.x ", targetContentOffset.pointee.x)
        
        if offsetX > 139  {
            targetContentOffset.pointee.x = self.frame.size.width - 139
        } else {
            targetContentOffset.pointee = .zero
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
}

extension ThreadsDetailViewTableViewCell: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            return true
        }
    }
}
