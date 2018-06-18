//
//  SearchThreadsTableViewCell.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class SearchThreadsTableViewCell: UITableViewCell {

    // MARK: - Variables & constants
    var receiver: ThreadsReceiver?
    private let screenWidth = UIScreen.main.bounds.width
    private let dateConverter = FeedDateConverter()
    
    var markAsClearedAction: ((ThreadsReceiver) -> Void)?
    
    //MARK: - Views
    var receiverNameLabel: UILabel = UILabel()
    var threadSubjectLabel: UILabel = UILabel()
    var snippetLabel: UILabel = UILabel()
    var receiverImageView: UIImageView = UIImageView()
    var timeLabel: UILabel = UILabel()
    var checkMarkImageView: UIImageView = UIImageView()
    var separatorView: UIView = UIView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        receiverNameLabel.removeFromSuperview()
        receiverImageView.removeFromSuperview()
        threadSubjectLabel.removeFromSuperview()
        snippetLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        separatorView.removeFromSuperview()
        checkMarkImageView.removeFromSuperview()
    }
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    //Public part
    func loadData(from thread: ThreadsReceiver) {
        self.receiver = thread
        //Don't change order of methods calling
        setUserInfo(with: thread.profilePicture, userName: thread.name, and: thread.lastMessageTimestamp)
        setMessageInfo(with: thread.subject, andSnippet: thread.body)
        loadItemStatus()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        //Don't change order of methods calling
        addReceiverImageView()
        addReceiverNameLabel()
        addTimeLabel()
        addCheckMarkImageView()
        addThreadSubjectLabel()
        addSnippetLabel()
        addSeparator()
        setupSelectedCell()
    }

    //Private part
    private func addReceiverImageView() {
        let imageViewWidth = 0.096 * screenWidth
        let imageViewHeight = imageViewWidth
        let imageViewFrame = CGRect(x: 0.032 * screenWidth, y: 0.056 * screenWidth, width: imageViewWidth, height: imageViewHeight)
        receiverImageView.frame = imageViewFrame
        receiverImageView.contentMode = .scaleAspectFit
        receiverImageView.clipsToBounds = true
        receiverImageView.layer.cornerRadius = imageViewHeight/2
        addSubviewIfNeeded(receiverImageView)
    }
    
    private func addReceiverNameLabel() {
        let originX = receiverImageView.frame.origin.x + receiverImageView.frame.width + UIView.narrowMargin
        let labelHeight = 0.056 * screenWidth
        let originY = receiverImageView.frame.origin.y
        let labelFrame = CGRect(x: originX, y: originY, width: 0, height: labelHeight)
        receiverNameLabel.textColor = UIColor.searchResultReceiverColor
        receiverNameLabel.frame = labelFrame
        addSubviewIfNeeded(receiverNameLabel)
    }
    
    private func addThreadSubjectLabel() {
        let originX = receiverImageView.frame.origin.x + receiverImageView.frame.width + UIView.narrowMargin
        let labelHeight = 0.044 * screenWidth
        let originY = receiverNameLabel.frame.origin.y + receiverNameLabel.frame.height
        let labelFrame = CGRect(x: originX, y: originY, width: 0.8 * screenWidth, height: labelHeight)
        threadSubjectLabel.font = UIFont(name: LocalizedFontNameKey.SearchViewHelper.ThreadSubject, size: 15)
        threadSubjectLabel.textColor = .black
        threadSubjectLabel.frame = labelFrame
        addSubviewIfNeeded(threadSubjectLabel)
    }
    
    private func addSnippetLabel() {
        let originX = receiverImageView.frame.origin.x + receiverImageView.frame.width + UIView.narrowMargin
        let labelHeight = 0.056 * screenWidth
        let originY = threadSubjectLabel.frame.origin.y + threadSubjectLabel.frame.height + UIView.slimMargin
        let labelFrame = CGRect(x: originX, y: originY, width: 0.84 * screenWidth, height: labelHeight)
        snippetLabel.textColor = UIColor.searchResultBodyColor
        snippetLabel.numberOfLines = 1
        snippetLabel.frame = labelFrame
        addSubviewIfNeeded(snippetLabel)
    }
    
    private func addTimeLabel() {
        let rightOffset = screenWidth * 0.094
        let width = screenWidth * 0.096
        timeLabel.frame = CGRect(x: frame.size.width - rightOffset - width, y: receiverImageView.frame.origin.y, width: width, height: screenWidth * 0.042)
        timeLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .regular)
        timeLabel.textColor = UIColor.searchResultTimestemptColor
        addSubviewIfNeeded(timeLabel)
    }
    
    private func updateTimeLabel(with text: String) {
        let width = text.width(usingFont: timeLabel.font)
        let rightOffset = screenWidth * 0.094
        timeLabel.frame.size.width = width
        timeLabel.frame.origin.x = frame.size.width - rightOffset - width
        timeLabel.text = text
    }
    
    private func addCheckMarkImageView() {
        let originX = screenWidth * 0.933
        let width = screenWidth * 0.048
        let height = width
        checkMarkImageView.frame = CGRect(x: originX, y: receiverImageView.frame.origin.y, width: width, height: height)
        checkMarkImageView.image = UIImage(named: LocalizedImageNameKey.SearchViewHelper.UncheckedIcon)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(checkMarkTapped))
        checkMarkImageView.isUserInteractionEnabled = false
        checkMarkImageView.addGestureRecognizer(gesture)
        addSubviewIfNeeded(checkMarkImageView)
    }
    
    private func addSeparator() {
        separatorView.frame = CGRect(x: UIView.narrowMidMargin, y: frame.height - 1, width: screenWidth - 2 * UIView.narrowMidMargin, height: 1)
        separatorView.backgroundColor = UIColor.searchResultBorderColor
        addSubviewIfNeeded(separatorView)
    }
    
    //MARK: - data settings
    private func setUserInfo(with imageUrl: URL?, userName name: String?, and timestamp: Int32?) {
        setImage(imageUrl)
        setTime(timestamp)
        setName(name)
    }
    
    private func setImage(_ imageUrl: URL?) {
        if let unwrappedUrl = imageUrl {
            receiverImageView.hnk_setImageFromURL(unwrappedUrl)
        } else {
            receiverImageView.image = UIImage(named: LocalizedImageNameKey.SearchViewHelper.DefaultImage)
        }
    }
    
    private func setName(_ name: String?) {
        receiverNameLabel.text = name
        guard let unwrappedName = name else { return }
        var width = unwrappedName.width(usingFont: receiverNameLabel.font)
        let offset = screenWidth * 0.013
        let maxWidth = timeLabel.frame.origin.x - receiverNameLabel.frame.origin.x - offset
        if width > maxWidth {
            width = maxWidth
        }
        receiverNameLabel.frame.size.width = width
    }
    
    private func setTime(_ time: Int32? ) {
        if let unwrappedTime = time {
            let date = dateConverter.timeAgoInWords(from: unwrappedTime)
            updateTimeLabel(with: date)
        }
    }

    //MARK: - set message info
    private func setMessageInfo(with subject: String?, andSnippet snippet: String?) {
        threadSubjectLabel.text = subject
        snippetLabel.text = snippet
        if threadSubjectLabel.text == "" {
            threadSubjectLabel.frame.size.height = 0
        } else {
            threadSubjectLabel.frame.size.height = 0.059 * screenWidth
        }
    }
    
    //MARK: - change fonts if unread and change image if starred
    func loadItemStatus() {
        if receiver?.sectionType == .convos {
            //TODO: - uncomment if needed
            //setCleared()
            disableCheckmark()
        } else {
            checkMarkImageView.isHidden = false
            checkMarkImageView.image = UIImage(named: "search_feed_icon")
        }
        setUnread()
    }
    
    func disableCheckmark() {
        timeLabel.frame.origin.x += checkMarkImageView.frame.width + 0.023 * screenWidth
        checkMarkImageView.isHidden = true
    }
    
    func setCleared() {
        guard let isCleared = receiver?.isCleared else {
            checkMarkImageView.image = UIImage(named: LocalizedImageNameKey.SearchViewHelper.UncheckedIcon)
            return
        }
        if isCleared {
            checkMarkImageView.image = UIImage(named: LocalizedImageNameKey.SearchViewHelper.CheckedIcon)
        } else {
            checkMarkImageView.image = UIImage(named: LocalizedImageNameKey.SearchViewHelper.UncheckedIcon)
        }
    }

    func setUnread() {
        guard let isNew = receiver?.isNew, let isSeen = receiver?.isSeen else {
            makeAllFontsRegular()
            return
        }
        if isNew {
            makeInititalFonts()
        } else if isSeen {
            makeAllFontsRegular()
        } else {
           makeAllFontsRegular()
        }
    }
    
    //MARK: - change fonts
    func makeAllFontsRegular() {
        receiverNameLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .largeMedium)
        threadSubjectLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
        snippetLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
    }
    
    func makeInititalFonts() {
        receiverNameLabel.font = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        threadSubjectLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        snippetLabel.font = UIFont.latoStyleAndSize(style: .regular, size: .medium)
    }
    
    //MARK: - actions
    @objc func checkMarkTapped() {
        guard let threadReceiver = receiver else { return }
        if threadReceiver.sectionType == .convos {
            checkMarkImageView.isUserInteractionEnabled = false
            markAsClearedAction?(threadReceiver)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
                self?.checkMarkImageView.isUserInteractionEnabled = true
            })
        }
    }
}
