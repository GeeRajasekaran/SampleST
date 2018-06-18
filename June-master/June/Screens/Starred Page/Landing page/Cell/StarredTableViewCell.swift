//
//  StarredTableViewCell.swift
//  June
//
//  Created by Tatia Chachua on 05/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit
import CoreText
import QuartzCore

protocol StarredTableViewCellDelegate {
    func cellSwipedRight(indexPath: IndexPath)
    func cellSwipedLeft(indexPath: IndexPath)
}

protocol StarredSwipeAction {
    var color: UIColor { get }
    var title: String { get }
}

class StarredTableViewCell: UITableViewCell {
    
    var delegate: StarredTableViewCellDelegate?
    
    var scrollView: UIScrollViewSuperTaps! // UIScrollView!
    var containerView: UIView!
    var actionView: UIView!
    
    let minOffset: CGFloat = 30
    var indexPath: IndexPath!
    
    var isLeftSideVisible:Bool {
        return scrollView.contentOffset.x < 0
    }
    var isRightSideVisible:Bool {
        return scrollView.contentOffset.x > 0
    }
    
    var actionLabel: UILabel!
    var unstarLabel: UILabel!
    var actionImageView: UIImageView!
    var starredImageView: UIImageView!
    var unstarLineImage1: UIImageView!
    var unstarLineImage2: UIImageView!
    
    var selectedAction: StarredSwipeAction?
    var leftActions: [StarredSwipeAction] = []
    var rightActions: [StarredSwipeAction] = []
    
    let profileImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iv.clipsToBounds = true
        return iv
    }()
    
    let attachmentButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.custom)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(attachmentButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let starImage: UIImageView = {
        let star = UIImageView()
        return star
    }()
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor(red:0.77, green:0.77, blue:0.79, alpha:1)
        date.textAlignment = .right
        return date
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        scrollView = UIScrollViewSuperTaps(frame: bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = bounds.size
        scrollView.contentInset = UIEdgeInsets(
            top: 0, left: bounds.width, bottom: 0, right: bounds.width)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        contentView.addSubview(scrollView)
        
        actionView = UIView(frame: CGRect(origin: .zero, size: bounds.size))
        actionView.backgroundColor = UIColor.clear
        actionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(actionView)
        
        actionLabel = UILabel(frame:
            CGRect(x: 10, y: 0, width: bounds.width - 20, height: bounds.height))
        actionLabel.font = UIFont.systemFont(ofSize: 12)
        actionLabel.textColor = .white
        //actionView.addSubview(actionLabel)
        
        actionImageView = UIImageView(frame: CGRect(x: 43, y: 18, width: 24, height: 23))
        actionImageView.backgroundColor = .clear
        actionImageView.clipsToBounds = true
        actionView.addSubview(actionImageView)
        
        starredImageView = UIImageView(frame: CGRect(x: 314, y: 18, width: 24, height: 23))
        starredImageView.backgroundColor = .clear
        starredImageView.clipsToBounds = true
        actionView.addSubview(starredImageView)
        
        unstarLineImage1 = UIImageView(frame: CGRect(x: 41, y: 16, width: 28, height: 28))
        unstarLineImage1.backgroundColor = .clear
        unstarLineImage1.clipsToBounds = true
        actionView.addSubview(unstarLineImage1)
        
        unstarLineImage2 = UIImageView(frame: CGRect(x: 312, y: 16, width: 28, height: 28))
        unstarLineImage2.backgroundColor = .clear
        unstarLineImage2.clipsToBounds = true
        actionView.addSubview(unstarLineImage2)
        
        unstarLabel = UILabel(frame: CGRect(x: 31, y: 46, width: bounds.width - 3, height: 14))
        unstarLabel.font = UIFont.proximaNovaStyleAndSize(style: .regular, size: .midSmall)
        unstarLabel.textColor = .white
        unstarLabel.text = "UNSTAR"
        actionView.addSubview(unstarLabel)
        
        containerView = UIView(frame: scrollView.bounds)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = UIColor.white
        scrollView.addSubview(containerView)
        
        containerView.addSubview(profileImageview)
        containerView.addSubview(subjectLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(attachmentButton)
        containerView.addSubview(starImage)
        
        starImage.frame = CGRect(x: 288, y: 10, width: 12, height: 12)
        starImage.image = #imageLiteral(resourceName: "BT_Starred")
        
        profileImageview.frame = CGRect(x: 15, y: 10, width: 43, height: 43)
        profileImageview.layer.cornerRadius = 43/2
        profileImageview.image = #imageLiteral(resourceName: "june_profile_pic_bg")
        
        attachmentButton.frame = CGRect(x: 359, y: 50, width: 7, height: 12.57)
        attachmentButton.setImage(#imageLiteral(resourceName: "has_attachment_icon"), for: .normal)
        attachmentButton.isHidden = true
        
        authorLabel.frame = CGRect(x: 73, y: 10, width: self.frame.size.width - 73 - 35, height: 16)
        authorLabel.font = UIFont.proximaNovaStyleAndSize(style: .bold, size: .largeMedium)
        
        subjectLabel.frame = CGRect(x: 73, y: 20, width: self.frame.size.width - 25, height: 55)
        subjectLabel.font = UIFont.proximaNovaStyleAndSize(style: .regular, size: .medium)
        
        dateLabel.frame = CGRect(x: 300, y: 4, width: 62, height: 22)
        dateLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
        dateLabel.text = ""
        containerView.addSubview(dateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: bounds.width)
        scrollView.contentSize = contentView.bounds.size
    }
    
    class func reuseIdentifier() -> String {
        return "StarredTableViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setThreadCellWith(thread: Threads) {
        
        if let profileImageUrl = thread.last_message_from?.profile_pic {
            let url = URL.init(string: profileImageUrl)
            self.profileImageview.hnk_setImageFromURL(url!)
        } else {
            profileImageview.image = #imageLiteral(resourceName: "june_profile_pic_bg")
        }
        
        self.authorLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.authorLabel.font = UIFont.proximaNovaStyleAndSize(style: .regular, size: .largeMedium)
        self.subjectLabel.font = UIFont.proximaNovaStyleAndSize(style: .regular, size: .medium)
        
        self.authorLabel.text = thread.last_message_from?.name
        if self.authorLabel.text?.count == 0 {
            self.authorLabel.text = thread.last_message_from?.email
        }
        let subject = thread.subject
        let summary = thread.summary
        let snippet = thread.snippet
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 0
        paragraph.maximumLineHeight = 20
        
        if  let string = subject, !string.isEmpty, let string2 = summary, !string2.isEmpty  {
            let combined = subject! + " . " + summary!
            let myMutableString = NSMutableAttributedString(
                string: combined,
                attributes: [NSAttributedStringKey.font:self.subjectLabel.font, NSAttributedStringKey.paragraphStyle: paragraph])
            
            myMutableString.addAttribute(NSAttributedStringKey.font,
                                         value: UIFont(
                                            name: "ProximaNova-Regular",
                                            size: 15.0)!,
                                         range: NSRange(
                                            location: 0,
                                            length: (subject?.count)!))
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor,
                                         value: UIColor.black,
                                         range: NSRange(
                                            location:0,
                                            length: (subject?.count)!))
            
            myMutableString.addAttribute(NSAttributedStringKey.font,
                                         value: UIFont(
                                            name: "ProximaNova-Regular",
                                            size: 35.0)!,
                                         range: NSRange(
                                            location: (subject?.count)!,
                                            length: 3))
            
            self.subjectLabel.attributedText = myMutableString
        } else if  let string = subject, !string.isEmpty,  let string2 = snippet, !string2.isEmpty {
            let combined = subject! + " . " + snippet!
            let myMutableString = NSMutableAttributedString(
                string: combined,
                attributes: [NSAttributedStringKey.font:self.subjectLabel.font, NSAttributedStringKey.paragraphStyle: paragraph])
            
            myMutableString.addAttribute(NSAttributedStringKey.font,
                                         value: UIFont(
                                            name: "ProximaNova-Regular",
                                            size: 15.0)!,
                                         range: NSRange(
                                            location: 0,
                                            length: (subject?.count)!))
            
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor,
                                         value: UIColor.black,
                                         range: NSRange(
                                            location:0,
                                            length: (subject?.count)!))
            
            myMutableString.addAttribute(NSAttributedStringKey.font,
                                         value: UIFont(
                                            name: "ProximaNova-Regular",
                                            size: 35.0)!,
                                         range: NSRange(
                                            location: (subject?.count)!,
                                            length: 3))
            
            self.subjectLabel.attributedText = myMutableString
        } else if let string = subject, !string.isEmpty {
            let combined = subject!
            let myMutableString = NSMutableAttributedString(
                string: combined,
                attributes: [NSAttributedStringKey.font:self.subjectLabel.font, NSAttributedStringKey.paragraphStyle: paragraph])
            myMutableString.addAttribute(NSAttributedStringKey.font,
                                         value: UIFont(
                                            name: "ProximaNova-Regular",
                                            size: 15.0)!,
                                         range: NSRange(
                                            location: 0,
                                            length: (subject?.count)!))
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor,
                                         value: UIColor.black,
                                         range: NSRange(
                                            location:0,
                                            length: (subject?.count)!))
            self.subjectLabel.attributedText = myMutableString
            
        } else if let string = summary, !string.isEmpty {
            self.subjectLabel.text = summary
        } else if let string = snippet, !string.isEmpty {
            self.subjectLabel.text = snippet
        }
        
        if thread.has_attachments {
            self.attachmentButton.isHidden = false
        } else {
            self.attachmentButton.isHidden = true
        }

        
        if thread.unread == true {
            self.authorLabel.font = UIFont(name: "ProximaNova-Bold", size: 16)
            self.subjectLabel.font = UIFont(name: "ProximaNova-Bold", size: 15)
        }
        
        let dateInt = thread.last_message_timestamp
        dateLabel.text = FeedDateConverter().timeAgoInWords(from: dateInt)
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
            dateFormatter.dateFormat = "d/MM/yy"
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
            
        }
    }
    
    @objc func attachmentButtonPressed() {
        print("attachment button pressed")
    }
    
    func findVisibleAction() -> StarredSwipeAction? {
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
    
    func performAction() {
        self.delegate?.cellSwipedRight(indexPath: self.indexPath)
        self.dismissAction()
    }
    
    func swipedLeft() {
        self.delegate?.cellSwipedLeft(indexPath: self.indexPath)
        self.dismissAction()
    }
    
    func dismissAction() {
        selectedAction = nil
        scrollView.setContentOffset(.zero, animated: false)
    }
    
}

extension StarredTableViewCell : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        actionView.frame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: actionView.frame.size)
        
        let action = selectedAction ?? findVisibleAction()
        
        actionView.backgroundColor = action?.color ?? UIColor.white
        contentView.backgroundColor = action?.color ?? .white
        actionLabel.textAlignment = isRightSideVisible ? .right : .left
        actionLabel.text = action?.title
        actionImageView.image = isLeftSideVisible ? #imageLiteral(resourceName: "unstar_icon") : nil
        unstarLineImage1.image = isLeftSideVisible ? #imageLiteral(resourceName: "line_unstar") : nil
        starredImageView.image = isRightSideVisible ? #imageLiteral(resourceName: "unstar_icon") : nil
        unstarLineImage2.image = isRightSideVisible ? #imageLiteral(resourceName: "line_unstar") : nil
        unstarLabel.textAlignment = isRightSideVisible ? .right : .left
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetX = abs(scrollView.contentOffset.x)
        let width = scrollView.contentSize.width
        
        if offsetX < minOffset {
            targetContentOffset.pointee = .zero
        } else {
            if isLeftSideVisible { targetContentOffset.pointee.x = -width }
            else if isRightSideVisible { targetContentOffset.pointee.x = width }
        }
        selectedAction = findVisibleAction()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if selectedAction != nil {
            if isLeftSideVisible {
                performAction()
            } else if isRightSideVisible {
                swipedLeft()
            }
        } else {
            dismissAction()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        selectedAction = nil
    }
    
}

class UIScrollViewSuper: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging {
            super.touchesBegan(touches, with: event)
        } else {
            self.superview?.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)    {
        if self.isDragging {
            super.touchesCancelled(touches, with: event)
        } else {
            self.superview?.touchesCancelled(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging {
            super.touchesEnded(touches, with: event)
        } else {
            self.superview?.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging {
            super.touchesMoved(touches, with: event)
        } else {
            self.superview?.touchesMoved(touches, with: event)
        }
    }
}

