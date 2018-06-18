//
//  ThreadsStarUnstarTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 9/29/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreText
import QuartzCore

protocol ThreadsStarUnstarSwipeAction {
    var color: UIColor { get }
    var title: String { get }
}

protocol ThreadsStarUnstarTableViewCellDelegate {
    func cellSwipedToStar2(indexPath: IndexPath)
    func cellSwipedToUnstar2(indexPath: IndexPath)
    func cellSwipedToStar3(indexPath: IndexPath)
    func cellSwipedToUnstar3(indexPath: IndexPath)
    func cellSwipedToStar4(indexPath: IndexPath)
    func cellSwipedToUnstar4(indexPath: IndexPath)
}

class ThreadsStarUnstarTableViewCell: UITableViewCell {
    
    var delegate: ThreadsStarUnstarTableViewCellDelegate?
    
    var scrollView: UIScrollViewSuperTaps!
    var containerView: UIView!
    var actionView: UIView!
    
    let minOffset: CGFloat = 0.133*UIScreen.main.bounds.width
    let scrollOffset: CGFloat = 0.2*UIScreen.main.bounds.width
    
    var indexPath: IndexPath!
    var tableViewTag: Int?
    private var threadData: Threads?
    
    var cellIsStartedScrolling: ((UITableViewCell, IndexPath) -> Void)?
    var cellIsEndedScrolling: ((UITableViewCell, IndexPath) -> Void)?
    
    var isLeftSideVisible:Bool {
        return scrollView.contentOffset.x < 0
    }
    var isRightSideVisible:Bool {
        return scrollView.contentOffset.x > 0
    }
    
    var actionLabel: UILabel!
    var starredImageViewLeft: UIImageView!
    var unstarredImageViewLeft: UIImageView!
    var starredImageViewRight: UIImageView!
    var unstarredImageViewRight: UIImageView!
    
    var selectedAction: ThreadsStarUnstarSwipeAction?
    var leftActions: [ThreadsStarUnstarSwipeAction] = []
    var rightActions: [ThreadsStarUnstarSwipeAction] = []
    
    static let authorLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .largeMedium)
    static let subjectLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .medium)
    static let dateLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    
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
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let starImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        iv.clipsToBounds = true
        return iv
    }()
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor(red:0.77, green:0.77, blue:0.79, alpha:1)
        date.font = ThreadsStarUnstarTableViewCell.dateLabelFont 
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
        scrollView.contentInset = UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: bounds.width)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.isUserInteractionEnabled = true
        contentView.addSubview(scrollView)
        
        actionView = UIView(frame: CGRect(origin: .zero, size: bounds.size))
        actionView.backgroundColor = .clear
        actionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(actionView)
        
        actionLabel = UILabel(frame: CGRect(x: 10, y: 0, width: bounds.width - 20, height: bounds.height))
        actionLabel.font = UIFont.systemFont(ofSize: 12)
        actionLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        actionLabel.textColor = .white
//        actionView.addSubview(actionLabel)
        
        starredImageViewLeft = UIImageView(frame: CGRect(x: 35, y: 20, width: 31, height: 42))
        starredImageViewLeft.backgroundColor = .clear
        starredImageViewLeft.clipsToBounds = true
        actionView.addSubview(starredImageViewLeft)
        
        unstarredImageViewLeft = UIImageView(frame: CGRect(x: 30, y: 17, width: 45, height: 45))
        unstarredImageViewLeft.backgroundColor = .clear
        unstarredImageViewLeft.clipsToBounds = true
        actionView.addSubview(unstarredImageViewLeft)
        
        starredImageViewRight = UIImageView(frame: CGRect(x: 325, y: 20, width: 31, height: 42))
        starredImageViewRight.backgroundColor = .clear
        starredImageViewRight.clipsToBounds = true
        actionView.addSubview(starredImageViewRight)
        
        unstarredImageViewRight = UIImageView(frame: CGRect(x: 310, y: 17, width: 45, height: 45))
        unstarredImageViewRight.backgroundColor = .clear
        unstarredImageViewRight.clipsToBounds = true
        actionView.addSubview(unstarredImageViewRight)
        
        containerView = UIView(frame: frame)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = .white
        scrollView.addSubview(containerView)
        
        containerView.addSubview(profileImageview)
        containerView.addSubview(subjectLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(starImageview)
        
        profileImageview.frame = CGRect(x: 15, y: 10, width: 43, height: 43)
        profileImageview.layer.cornerRadius = 43/2
        profileImageview.image = #imageLiteral(resourceName: "june_profile_pic_bg")
        
         attachmentButton.frame = CGRect(x: 359, y: 50, width: 7, height: 13)
        attachmentButton.setImage(#imageLiteral(resourceName: "has_attachment_icon"), for: .normal)
        attachmentButton.isHidden = true
        
        starImageview.frame = CGRect(x: 288, y: 10, width: 12, height: 12)
        starImageview.image = #imageLiteral(resourceName: "BT_Starred")
        starImageview.isHidden = true
        
        authorLabel.frame = CGRect(x: 73, y: 10, width: self.frame.size.width - 73 - 35, height: 16)
        authorLabel.font = ThreadsStarUnstarTableViewCell.authorLabelFont

        subjectLabel.frame = CGRect(x: 73, y: 20, width: self.frame.size.width - 25, height: 55)
        subjectLabel.font = ThreadsStarUnstarTableViewCell.subjectLabelFont

        dateLabel.frame = CGRect(x: 300, y: 4, width: 62, height: 22)
        dateLabel.text = ""
        containerView.addSubview(dateLabel)
    }
    
    class func reuseIdentifier() -> String {
        return "ThreadsStarUnstarTableViewCell"
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
        
        self.threadData = thread
        
        self.authorLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.authorLabel.font = ThreadsStarUnstarTableViewCell.authorLabelFont // UIFont(name: "ProximaNova-Regular", size: 16)
        self.subjectLabel.font = ThreadsStarUnstarTableViewCell.subjectLabelFont // UIFont(name: "ProximaNova-Regular", size: 15)
        
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
        
        if thread.starred {
            self.starImageview.isHidden = false
        } else {
            self.starImageview.isHidden = true
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
        } else if components.day! > 1 && components.day! < 3 {
            
            let labelDate =  "Yesterday" // localDate
            return labelDate
        } else if components.day! > 2 && components.day! < 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE"
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
        } else  {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "d/MM/yy"
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
            
        }
    }
    
    @objc func selectionButtonPressed() {
        print("Selection button pressed")
    }
    
    @objc func attachmentButtonPressed() {
        print("attachment button pressed")
    }
    
    func findVisibleAction() -> ThreadsStarUnstarSwipeAction? {
        let offsetX = abs(scrollView.contentOffset.x)
        let actionsWidth = scrollView.contentSize.width - minOffset
        
        //        if offsetX < minOffset {
        //            return nil
        //        }
        
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
    
    func performStarAction() {
        //  self.dismissAction()
        selectedAction = nil
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.scrollView.contentOffset.x = 0
        }, completion: { _ in
            if self.tableViewTag == 20 {
                self.delegate?.cellSwipedToStar2(indexPath: self.indexPath)
            } else if self.tableViewTag == 30 {
                self.delegate?.cellSwipedToStar3(indexPath: self.indexPath)
            } else if self.self.tableViewTag == 40 {
                self.delegate?.cellSwipedToStar4(indexPath: self.indexPath)
            }
            self.starImageview.isHidden = false
        })
    }
    
    func performUnStarAction() {
        // self.dismissAction()
        selectedAction = nil
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.scrollView.contentOffset.x = 0
        }, completion: { _ in
            if self.tableViewTag == 20 {
                self.delegate?.cellSwipedToUnstar2(indexPath: self.indexPath)
            } else if self.tableViewTag == 30 {
                self.delegate?.cellSwipedToUnstar3(indexPath: self.indexPath)
            } else if self.tableViewTag == 40 {
                self.delegate?.cellSwipedToUnstar4(indexPath: self.indexPath)
            }
            self.starImageview.isHidden = true
        })
    }
    
    func dismissAction() {
        selectedAction = nil
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.scrollView.contentOffset.x = 0
        }, completion: { _ in
            
        })
    }
}

extension ThreadsStarUnstarTableViewCell : UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        actionView.frame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: actionView.frame.size)
        let action = selectedAction ?? findVisibleAction()
        let color = #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1)
        actionView.backgroundColor = action?.color ?? color
        contentView.backgroundColor = action?.color ?? .white
        actionLabel.textAlignment = isRightSideVisible ? .right : .left
        actionLabel.text = action?.title
        if (self.threadData?.starred)! {
            starredImageViewLeft.isHidden = true
            starredImageViewRight.isHidden = true
            unstarredImageViewLeft.isHidden = false
            unstarredImageViewRight.isHidden = false
            unstarredImageViewLeft.image = #imageLiteral(resourceName: "unstarred_icon")
            unstarredImageViewRight.image = #imageLiteral(resourceName: "unstarred_icon")
            // unstarredImageViewLeft.image = isLeftSideVisible ? #imageLiteral(resourceName: "unstarred_icon") : nil
            // unstarredImageViewRight.image = isRightSideVisible ? #imageLiteral(resourceName: "unstarred_icon") : nil
        } else {
            starredImageViewLeft.isHidden = false
            starredImageViewRight.isHidden = false
            unstarredImageViewLeft.isHidden = true
            unstarredImageViewRight.isHidden = true
            starredImageViewLeft.image = #imageLiteral(resourceName: "starred_icon")
            starredImageViewRight.image = #imageLiteral(resourceName: "starred_icon")
            // starredImageViewLeft.image = isLeftSideVisible ? #imageLiteral(resourceName: "starred_icon") : nil
            // starredImageViewRight.image = isRightSideVisible ? #imageLiteral(resourceName: "starred_icon") : nil
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //  targetContentOffset.pointee = .zero
        selectedAction = findVisibleAction()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let offsetX = scrollView.contentOffset.x
            if abs(offsetX) < scrollOffset {
                dismissAction()
            } else if selectedAction != nil {
                if (self.threadData?.starred)! {
                    performUnStarAction()
                } else {
                    performStarAction()
                }
            } else {
                dismissAction()
            }
            cellIsEndedScrolling?(self, indexPath)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if abs(offsetX) < scrollOffset {
            dismissAction()
        } else if selectedAction != nil {
            if (self.threadData?.starred)! {
                performUnStarAction()
            } else {
                performStarAction()
            }
        } else {
            dismissAction()
        }
        cellIsEndedScrolling?(self, indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cellIsStartedScrolling?(self, indexPath)
        selectedAction = nil
    }
}

class UIScrollViewSuperTaps: UIScrollView {
    
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

extension ThreadsStarUnstarTableViewCell: IThreadCell {
    func enableCellSwiping() {
        // scrollView.setContentOffset(.zero, animated: true)
        // scrollView.isScrollEnabled = true
    }
    
    func disableCellSwiping() {
        //scrollView.isScrollEnabled = false
        // scrollView.isScrollEnabled = true
    }
}

