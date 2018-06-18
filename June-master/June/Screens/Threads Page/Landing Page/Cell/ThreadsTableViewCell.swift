//
//  ThreadsTableViewCell.swift
//  June
//
//  Created by Joshua Cleetus on 8/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreText
import QuartzCore

protocol ThreadsSwipeAction {
    var color: UIColor { get }
    var title: String { get }
}

protocol ThreadsTableViewCellDelegate {
    func cellSwipedRight(thread: Threads)
    func cellSwipedLeft(thread: Threads)
}

class ThreadsTableViewCell: SwipyCell {
    
    private weak var thread: Threads?
    var screenWidth = UIScreen.main.bounds.width
    var delegate1: ThreadsTableViewCellDelegate?
    var scrollView: UIScrollViewSuperTaps!
    var containerView: UIView!
    var actionView: UIView!
    
    let minOffset: CGFloat = 0.133*UIScreen.main.bounds.width
    
    var isLeftSideVisible:Bool {
        return scrollView.contentOffset.x < 0
    }
    var isRightSideVisible:Bool {
        return scrollView.contentOffset.x > 0
    }
    
    var actionLabel: UILabel!
    var actionImageView: UIImageView!
    var starredImageView: UIImageView!
    
    var selectedAction: ThreadsSwipeAction?
    var leftActions: [ThreadsSwipeAction] = []
    var rightActions: [ThreadsSwipeAction] = []
    
    static let authorLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .largeMedium)
    static let subjectLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .regular, size: .medium)
    static let unreadCountLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .smallMedium)
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
        label.font = ThreadsTableViewCell.authorLabelFont
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = ThreadsTableViewCell.subjectLabelFont
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let unreadCountLabel: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = UIColor(red:0.38, green:0.41, blue:0.95, alpha:1)
        lab.textColor = UIColor.white
        lab.font = ThreadsTableViewCell.unreadCountLabelFont
        lab.textAlignment = .center
        return lab
    }()
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor(red:0.77, green:0.77, blue:0.79, alpha:1)
        date.font = ThreadsTableViewCell.dateLabelFont 
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
        scrollView.isUserInteractionEnabled = false
        //MARK: - diasble scrolling of scroll view
        scrollView.isScrollEnabled = false
        
        actionView = UIView(frame: CGRect(origin: .zero, size: bounds.size))
        actionView.backgroundColor = UIColor.clear
        actionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        actionView.isUserInteractionEnabled = true
        scrollView.addSubview(actionView)
        
        actionLabel = UILabel(frame:
            CGRect(x: 10, y: 0, width: bounds.width - 20, height: bounds.height))
        actionLabel.font = UIFont.systemFont(ofSize: 12)
        actionLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        actionLabel.textColor = .white
        
        actionImageView = UIImageView(frame: CGRect(x: 35, y: 20, width: 34, height: 39))
        actionImageView.backgroundColor = .clear
        actionImageView.clipsToBounds = true
        actionImageView.isUserInteractionEnabled = true
        actionView.addSubview(actionImageView)
        
        starredImageView = UIImageView(frame: CGRect(x: 308, y: 20, width: 31, height: 42))
        starredImageView.backgroundColor = .clear
        starredImageView.clipsToBounds = true
        starredImageView.isUserInteractionEnabled = true
        actionView.addSubview(starredImageView)
        
        containerView = UIView(frame: scrollView.bounds)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = .white
        containerView.isUserInteractionEnabled = true
        contentView.addSubview(containerView)
        
        containerView.addSubview(profileImageview)
        containerView.addSubview(subjectLabel)
        containerView.addSubview(authorLabel)
        
        profileImageview.frame = CGRect(x: 15, y: 10, width: 43, height: 43)
        profileImageview.layer.cornerRadius = 43/2
        
        attachmentButton.frame = CGRect(x: 359, y: 50, width: 7, height: 13)
        attachmentButton.setImage(#imageLiteral(resourceName: "has_attachment_icon"), for: .normal)
        attachmentButton.isHidden = true
        
        authorLabel.frame = CGRect(x: 73, y: 10, width: self.frame.size.width - 73 - 35, height: 16)
        authorLabel.font = UIFont(name: "ProximaNova-Bold", size: 16)

        subjectLabel.frame = CGRect(x: 73, y: 20, width: self.frame.size.width - 25, height: 55)
        subjectLabel.font = UIFont(name: "ProximaNova-Regular", size: 15)
        
        unreadCountLabel.frame = CGRect(x: 45, y: 41, width: 19, height: 19)
        unreadCountLabel.isHidden = true
        unreadCountLabel.layer.cornerRadius = 10
        unreadCountLabel.clipsToBounds = true
        containerView.addSubview(unreadCountLabel)

        dateLabel.frame = CGRect(x: 300, y: 4, width: 62, height: 22)
        dateLabel.text = ""
        containerView.addSubview(dateLabel)
    }
    
    class func reuseIdentifier() -> String {
        return "ThreadsTableViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setThreadCellWith(thread: Threads) {
        self.thread = thread
        
        self.authorLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.authorLabel.font = ThreadsTableViewCell.authorLabelFont
        self.subjectLabel.font = ThreadsTableViewCell.subjectLabelFont
        
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
                                            name: "ProximaNova-Semibold",
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
                                            name: "ProximaNova-Semibold",
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
                                            name: "ProximaNova-Semibold",
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
                                            name: "ProximaNova-Semibold",
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
                                            name: "ProximaNova-Semibold",
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
        } else {
            self.subjectLabel.text = ""
        }

        if thread.has_attachments {
            self.attachmentButton.isHidden = false
        } else {
            self.attachmentButton.isHidden = true
        }

        let dateInt = thread.last_message_sent_timestamp
        if dateInt == 0 {
            dateLabel.isHidden = true
        } else {
            dateLabel.isHidden = false
            dateLabel.text = self.relativePast(for: dateInt)
        }
    }
    
    func getCountOfUnreadMessages(threadId: String) -> Void {
        let service = ThreadsDetailAPIBridge()
        service.getUnreadMessagesForTheThread(threadId: threadId) { [weak self] (result) in
            switch result {
            case .Success(let data):
                print(data as Any)
                if data.count > 0 {
                    if service.totalUnreadMessagesCount >= 2 {
                        self?.unreadCountLabel.text = "\(service.totalUnreadMessagesCount)"
                        self?.unreadCountLabel.isHidden = false
                    } else {
                        self?.unreadCountLabel.text = ""
                        self?.unreadCountLabel.isHidden = true
                    }
                }
            case .Error(let message):
                print(message)
            }
        }
        
    }

    func relativePast(for dateInt : Int32) -> String {
        return FeedDateConverter().timeAgoInWords(from: dateInt)
    }
    
    @objc func selectionButtonPressed() {
        print("Selection button pressed")
    }
    
    @objc func attachmentButtonPressed() {
        print("attachment button pressed")
    }
    
    func findVisibleAction() -> ThreadsSwipeAction? {
        let offsetX = abs(scrollView.contentOffset.x)
        
        let actionsWidth = scrollView.contentSize.width - minOffset

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
    
    func swipeRightAnimation(completion: ((Bool) -> Void)?) {
        swipeToRight {
            completion?(true)
        }
    }
    
    func swipeLeftAnimation(completion: ((Bool) -> Void)?) {
        swipeToLeft {
            completion?(true)
        }
    }

    func performAction() {
        guard let unwrappedThread = thread else { return }
        self.delegate1?.cellSwipedRight(thread: unwrappedThread)
        selectedAction = nil
    }
    
    func swipedLeft() {
        guard let unwrappedThread = thread else { return }
        self.delegate1?.cellSwipedLeft(thread: unwrappedThread)
        selectedAction = nil
    }
    
    func dismissAction() {
        selectedAction = nil
        scrollView.setContentOffset(.zero, animated: true)
    }

}

extension ThreadsTableViewCell : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        actionView.frame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: actionView.frame.size)
        
        let action = selectedAction ?? findVisibleAction()
        let color = self.isLeftSideVisible ? #colorLiteral(red: 0.5529411765, green: 0.8431372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1)
        actionView.backgroundColor = color //action?.color ?? UIColor.white
        contentView.backgroundColor = color //action?.color ?? .white
        actionLabel.textAlignment = isRightSideVisible ? .right : .left
        actionLabel.text = action?.title
        actionImageView.image = isLeftSideVisible ? #imageLiteral(resourceName: "read_icon") : nil
        starredImageView.image = isRightSideVisible ? #imageLiteral(resourceName: "starred_icon") : nil
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetX = abs(scrollView.contentOffset.x)
        let width = scrollView.contentSize.width
        
        if offsetX < minOffset {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                scrollView.contentOffset.x = 0
            }, completion: nil)
        } else {
            if isLeftSideVisible {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    scrollView.contentOffset.x = -width
                }, completion: { finished in
                    self.performAction()
                })
            }
            else if isRightSideVisible {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    scrollView.contentOffset.x = width
                }, completion: { finished in
                    self.swipedLeft()
                })
            }
        }
//            targetContentOffset.pointee = .zero
//        }else{
//            if isLeftSideVisible { targetContentOffset.pointee.x = -width }
//            else if isRightSideVisible { targetContentOffset.pointee.x = width }
//        }
//        selectedAction = findVisibleAction()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            dismissAction()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        if selectedAction != nil {
//            if isLeftSideVisible {
//                performAction()
//            } else if isRightSideVisible {
//                swipedLeft()
//            }
//        } else {
            dismissAction()
//        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        selectedAction = nil
    }

}

