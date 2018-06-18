//
//  FeedCalendarInviteView.swift
//  June
//
//  Created by Ostap Holub on 11/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Haneke

class FeedCalendarInviteView: UIView, IFeedCardView {
    
    // MARK: - Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Variables
    
    var indexPath: IndexPath?
    var itemInfo: FeedGenericItemInfo?
    var onRemoveBookmarkAction: RemoveBookmarkClosure?
    var view: UIView {
        get { return self }
    }
    
    // MARK: - Subviews
    
    private var leftSideImageView: UIImageView?
    private var initiatorImageView: UIImageView?
    private var eventTitleLabel: UILabel?
    private var eventOrganizerLabel: UILabel?
    private var eventTimeLabel: UILabel?
    
    private var actionsContainerView: UIView?
    private var actionButtons = [UIButton]()
    
    // MARK: - Data loading
    
    func loadItemData() {
//        guard let calendarInviteItem = item as? CalendarInviteFeedItem else { return }
//        if let url = calendarInviteItem.ownerProfilePicURL {
//            initiatorImageView?.hnk_setImageFromURL(url)
//        }
//        eventTitleLabel?.text = calendarInviteItem.title
//        eventOrganizerLabel?.text = calendarInviteItem.owner
//        eventTimeLabel?.text = calendarInviteItem.when
    }
    
    func changeStarState() {
        // TODO: Add star icon for calendar invite
    }
    
    // MARK: - Layout setup
    
    func setupSubviews() {
        performBasicUISetup()
        addLeftSideImageView()
        addInitiatorImageView()
        addEventTitleLabel()
        addEventOrganizerLabel()
        addEventTimeLabel()
        addActionsPanel()
    }
    
    func performBasicUISetup() {
        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = FeedGenericCardLayoutConstants.cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.newsCardBorderGray.cgColor
        drawFeedCellShadow()
    }
    
    // MARK: - Left side image view setup
    
    private func addLeftSideImageView() {
        guard leftSideImageView == nil else { return }
        
        let imageFrame = CGRect(x: 0, y: 0, width: 0.162 * screenWidth, height: frame.height)
        leftSideImageView = UIImageView(frame: imageFrame)
        leftSideImageView?.roundCorners([.topLeft, .bottomLeft], radius: FeedGenericCardLayoutConstants.cornerRadius)
        leftSideImageView?.contentMode = .scaleAspectFit
        leftSideImageView?.image = UIImage(named: LocalizedImageNameKey.FeedCalendarInviteHelper.LeftSideImage)
        
        if leftSideImageView != nil {
            addSubview(leftSideImageView!)
        }
    }
    
    // MARK: - Initiator image view
    
    private func addInitiatorImageView() {
        guard initiatorImageView == nil else { return }
        guard let leftImageFrame = leftSideImageView?.frame else { return }
        let leftInset = 0.026 * screenWidth
        
        let imageFrame = CGRect(x: leftImageFrame.width + leftInset, y: 0.048 * screenWidth, width: 0.104 * screenWidth, height: 0.104 * screenWidth)
        
        initiatorImageView = UIImageView(frame: imageFrame)
        initiatorImageView?.contentMode = .scaleAspectFit
        initiatorImageView?.layer.cornerRadius = imageFrame.height / 2
        initiatorImageView?.clipsToBounds = true
        
        if initiatorImageView != nil {
            addSubview(initiatorImageView!)
        }
    }
    
    // MARK: - Event title label setup
    
    private func addEventTitleLabel() {
        guard eventTitleLabel == nil else { return }
        guard let imageFrame = initiatorImageView?.frame else { return }
        let leftInset = 0.024 * screenWidth
        
        let eventTitleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        
        let titleFrame = CGRect(x: imageFrame.origin.x + imageFrame.width + leftInset, y: imageFrame.origin.y, width: 0.6 * screenWidth, height: 0.052 * screenWidth)
        eventTitleLabel = UILabel(frame: titleFrame)
        eventTitleLabel?.textColor = .black
        eventTitleLabel?.textAlignment = .left
        eventTitleLabel?.font = eventTitleLabelFont
        
        if eventTitleLabel != nil {
            addSubview(eventTitleLabel!)
        }
    }
    
    // MARK: - Event organizer label setup
    
    private func addEventOrganizerLabel() {
        guard eventOrganizerLabel == nil else { return }
        guard let eventTitleFrame = eventTitleLabel?.frame else { return }
        
        let nameFrame = CGRect(x: eventTitleFrame.origin.x, y: eventTitleFrame.origin.y + eventTitleFrame.height, width: 0.6 * screenWidth, height: 0.045 * screenWidth)
        let eventOrganizerLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
        
        eventOrganizerLabel = UILabel(frame: nameFrame)
        eventOrganizerLabel?.textAlignment = .left
        eventOrganizerLabel?.textColor = UIColor.black.withAlphaComponent(0.56)
        eventOrganizerLabel?.font = eventOrganizerLabelFont
        
        if eventOrganizerLabel != nil {
            addSubview(eventOrganizerLabel!)
        }
    }
    
    // MARK: - Event time label setup
    
    private func addEventTimeLabel() {
        guard eventTimeLabel == nil else { return }
        guard let organizerFrame = eventOrganizerLabel?.frame else { return }
        
        let timeFrame = CGRect(x: organizerFrame.origin.x, y: organizerFrame.origin.y + organizerFrame.height , width: 0.65 * screenWidth, height: 0.058 * screenWidth)
        let eventTimeLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
        
        eventTimeLabel = UILabel(frame: timeFrame)
        eventTimeLabel?.textAlignment = .left
        eventTimeLabel?.textColor = UIColor.eventTimeLabelColor
        eventTimeLabel?.font = eventTimeLabelFont
        
        if eventTimeLabel != nil {
            addSubview(eventTimeLabel!)
        }
    }
    
    // MARK: - Actions panel setup
    
    private func addActionsPanel() {
        guard actionsContainerView == nil else { return }
        guard let eventTimeFrame = eventTimeLabel?.frame else { return }
        
        let width = 0.514 * screenWidth
        let height = 0.048 * screenWidth
        let bottomInset = 0.034 * screenWidth
        
        let actionsFrame = CGRect(x: eventTimeFrame.origin.x, y: frame.height - bottomInset - height, width: width, height: height)
        
        actionsContainerView = UIView(frame: actionsFrame)
        actionsContainerView?.backgroundColor = .clear
        
        if actionsContainerView != nil {
            addSubview(actionsContainerView!)
        }
        addButtons()
    }
    
    private func addButtons() {
        guard let actionViewFrame = actionsContainerView?.frame else { return }
        let buttonWidth = actionViewFrame.width / CGFloat(3)
        
        for i in 0...2 {
            addButton(at: i, with: buttonWidth, and: actionViewFrame.height)
        }
    }
    
    private func addButton(at index: Int, with width: CGFloat, and height: CGFloat) {
        let buttonFrame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
        let buttonFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        
        let button = UIButton(frame: buttonFrame)
        button.setTitleColor(UIColor.actionButtonTitleColor, for: .normal)
        button.titleLabel?.font = buttonFont
        if let buttonTitle = title(for: index) {
            button.setTitle(buttonTitle, for: .normal)
        }
        button.tag = index
        
        actionButtons.append(button)
        actionsContainerView?.addSubview(button)
    }
    
    private func title(for index: Int) -> String? {
        switch index {
        case 0:
            return LocalizedStringKey.FeedCalendarInvite.YesActionTitle
        case 1:
            return LocalizedStringKey.FeedCalendarInvite.MaybeActionTitle
        case 2:
            return LocalizedStringKey.FeedCalendarInvite.NoActionTitle
        default:
            return nil
        }
    }
}
