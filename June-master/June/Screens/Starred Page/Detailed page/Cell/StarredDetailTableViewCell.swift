//
//  StarDetailTableViewCell.swift
//  June
//
//  Created by Tatia Chachua on 19/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit
import CoreText
import QuartzCore

protocol StarDetailTableViewCellDelegate {
}

class StarredDetailTableViewCell: UITableViewCell {
    
    var delegate: StarDetailTableViewCellDelegate?
    
    var scrollView: UIScrollViewSuperTaps!
    var containerView: UIView!
    var actionView: UIView!
    var btnsHolderView: UIView!
    
    let profileImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.textColor = .darkGray
        label.text = "John Jung"
        return label
    }()
    
    let toLabel: UILabel = {
        let to = UILabel()
        to.numberOfLines = 0
        to.textAlignment = .left
        to.lineBreakMode = .byCharWrapping
        to.textColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1)
        to.text = "to: me, John, And others"
        return to
    }()
    
    let timeLabel: UILabel = {
        let time = UILabel()
        time.numberOfLines = 0
        time.textAlignment = .right
        time.lineBreakMode = .byCharWrapping
        time.textColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1)
        time.text = "10:19PM"
        return time
    }()
    
    let replyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "purple_oval"), for: .normal)
        return button
    }()
    
    let replyAllButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "purple_oval"), for: .normal)
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "purple_oval_2"), for: .normal)
        return button
    }()
    
    let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "white_oval"), for: .normal)
        return button
    }()
    
    let fulEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "white_oval_2"), for: .normal)
        return button
    }()
    
    let fullEmailImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "full_email_image")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let reportImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "report_img")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let replyImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "reply_1")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let reply3Img: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "reply3")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let replyCopyImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "reply2_full")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let reply2CopyImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "reply2_front_half")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func reuseIdentifier() -> String {
        return "StarDetailTableViewCell"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        
        scrollView = UIScrollViewSuperTaps(frame: frame)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = bounds.size
        scrollView.contentInset = UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: bounds.width)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        contentView.addSubview(scrollView)
        
        actionView = UIView(frame: CGRect(origin: .zero, size: bounds.size))
        actionView.backgroundColor = UIColor(red:0.95, green:0.94, blue:0.98, alpha:1)
        actionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(actionView)
        
        let centerY = Int(self.actionView.center.y) + 63
        btnsHolderView = UIView(frame: CGRect(x: 163, y: centerY, width: 199, height: 126))
        btnsHolderView.backgroundColor = UIColor.clear
        actionView.addSubview(btnsHolderView)
        
        containerView = UIView(frame: scrollView.bounds)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = UIColor.white
        
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 8
        
        scrollView.addSubview(containerView)
        
        print("it's: \(bounds.maxX)")
        
        timeLabel.font = UIFont.proximaNovaStyleAndSize(style: .regular, size: .midSmall)
        timeLabel.frame = CGRect(x: 260, y: 15, width: 90, height: 19)
        
        profileImageview.frame = CGRect(x: 24, y: 20, width: 43, height: 43)
        profileImageview.layer.cornerRadius = 43/2
        profileImageview.image = #imageLiteral(resourceName: "june_profile_pic_bg")
        
        nameLabel.font = UIFont.proximaNovaStyleAndSize(style: .bold, size: .largeMedium)
        nameLabel.frame = CGRect(x: 81, y: 20, width: 140, height: 22)
        
        toLabel.font = UIFont.proximaNovaStyleAndSize(style: .regular, size: .midSmall)
        toLabel.frame = CGRect(x: 81, y: 43.5, width: 140, height: 16)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(profileImageview)
        containerView.addSubview(nameLabel)
        containerView.addSubview(toLabel)
        
        replyButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        replyAllButton.frame = CGRect(x: 69, y: 0, width: 60, height: 60)
        forwardButton.frame = CGRect(x: 139, y: 0, width: 60, height: 60)
        reportButton.frame = CGRect(x: 39, y: 64, width: 60, height: 60)
        fulEmailButton.frame = CGRect(x: 103, y: 64, width: 60, height: 60)
        
        btnsHolderView.addSubview(replyButton)
        btnsHolderView.addSubview(replyAllButton)
        btnsHolderView.addSubview(forwardButton)
        btnsHolderView.addSubview(reportButton)
        btnsHolderView.addSubview(fulEmailButton)
        
        fullEmailImg.frame = CGRect(x: 4, y: 18, width: 52, height: 20)
        reportImg.frame = CGRect(x: 10, y: 25, width: 40, height: 8)
        replyImg.frame = CGRect(x: 22, y: 23, width: 18, height: 14)
        reply3Img.frame = CGRect(x: 22, y: 23, width: 18, height: 14)
        replyCopyImg.frame = CGRect(x: 22, y: 22, width: 20, height: 16)
        reply2CopyImg.frame = CGRect(x: 18, y: 23, width: 12.28, height: 14)
        fulEmailButton.addSubview(fullEmailImg)
        reportButton.addSubview(reportImg)
        forwardButton.addSubview(reply3Img)
        replyAllButton.addSubview(reply2CopyImg)
        replyAllButton.addSubview(replyCopyImg)
        replyButton.addSubview(replyImg)
    }
    
}

extension StarredDetailTableViewCell : UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    }
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let offsetX = abs(scrollView.contentOffset.x)
//        let width = scrollView.contentSize.width
//
//        if offsetX > 350  {
//            targetContentOffset.pointee.x = width +   220
//
//        }  else {
//            targetContentOffset.pointee = .zero
//        }
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        actionView.frame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: actionView.frame.size)
        
 //       let action = selectedAction ?? findVisibleAction()
        
 //       actionView.backgroundColor = action?.color ?? UIColor.white
   //     contentView.backgroundColor = action?.color ?? .white
        //        actionLabel.textAlignment = isRightSideVisible ? .right : .left
        //        actionLabel.text = action?.title
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetX = abs(scrollView.contentOffset.x)
        let width = scrollView.contentSize.width
        print("offset x = ", offsetX)
        print("width ", width)
        print("targetContentOffset.pointee.x ", targetContentOffset.pointee.x)
        
        if offsetX > 139  {
            targetContentOffset.pointee.x = self.frame.size.width - 139
        }  else {
            targetContentOffset.pointee = .zero
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
}
