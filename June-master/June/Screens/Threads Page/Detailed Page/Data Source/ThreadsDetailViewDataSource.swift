//
//  ThreadsDetailViewDataSource.swift
//  June
//
//  Created by Joshua Cleetus on 9/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Down
import Alamofire
import AlamofireImage

class ThreadsDetailViewDataSource: NSObject {

    unowned var parentVC: ThreadsDetailViewController
    
    init(parentVC: ThreadsDetailViewController) {
        self.parentVC = parentVC
        super.init()
    }
    
}

// MARK:- UITableViewDataSource

extension ThreadsDetailViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.parentVC.tableView {
            return self.parentVC.dataArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: ThreadsDetailViewTableViewCell = (tableView.dequeueReusableCell(withIdentifier: ThreadsDetailViewTableViewCell.reuseIdentifier(), for: indexPath) as? ThreadsDetailViewTableViewCell) else {
            print("The dequeued cell is not an instance of ThreadsDetailViewTableViewCell.")
            return UITableViewCell()
        }
        if self.parentVC.mainContentHeights != nil {
            let isIndexValid = self.parentVC.dataArray.indices.contains(indexPath.row)
            if isIndexValid {
                self.checkIfForwardedMessagesExistsOrNot(cell: cell, indexPath: indexPath)
                let message = self.parentVC.dataArray[indexPath.row]
                cell.message = message
                cell.webView.tag = indexPath.row
                cell.indexPath = indexPath
                cell.tag = indexPath.row
                cell.selectionStyle = .none
                cell.delegate = self.parentVC
                cell.webViewHeight = self.parentVC.mainWebViewContentHeights[indexPath.row]
                cell.webView.delegate = self.parentVC.delegate
                cell.forwardedWebView.delegate = self.parentVC.delegate
                cell.onOpenAttachment = parentVC.onAttachmentClick
                cell.onWebViewClicked = parentVC.onWebViewClicked
                addFromObject(messages: message, onCell: cell)
                self.loadWebViewsWith(messages: message, onCell: cell, indexPath: indexPath)
                self.checkIfThisIsATempCell(message: message, cell: cell)
                self.checkIfReplierIsSuccessOrFail(message: message, cell: cell, indexPath: indexPath)
                self.addSwipeActions(cell: cell)
                self.getVisibleCellHeight(forCell: cell, withIndexPath: indexPath)
                DispatchQueue.main.async {
                    cell.setMessagesCellWith(messages: message)
                    self.addAttachmentsView(using: message, onCell: cell)
                }
            }
        }
        
        if !self.parentVC.allCells.contains(cell) {
            self.parentVC.allCells.append(cell)
        }
        
        return cell
    }
    
    private func getVisibleCellHeight(forCell cell: ThreadsDetailViewTableViewCell, withIndexPath indexPath: IndexPath) {
        if let tableView = self.parentVC.tableView, let superview = self.parentVC.tableView?.superview {
            let cellRect = tableView.rectForRow(at: indexPath)
            let convertedRect = tableView.convert(cellRect, to:superview)
            let intersect = tableView.frame.intersection(convertedRect)
            let visibleHeight = intersect.height
            cell.cellVisibleHeight = visibleHeight
        }
    }
            
    private func checkIfIndexContainsUrl(forCell cell: ThreadsDetailViewTableViewCell, withIndexPath indexPath: IndexPath) {
        let isLinkIndexValid = self.parentVC.linkIndexes.contains(indexPath.row)
        if isLinkIndexValid {
            cell.containsUrl = true
        } else {
            cell.containsUrl = false
        }
    }
    
    private func configureReceivers(for message: Messages, with cell: ThreadsDetailViewTableViewCell) {
        let toString = getToString(from: message)
        let ccString = getCcString(from: message)
        var configuredToString = ""
        if toString.count > 0 {
            configuredToString = LocalizedStringKey.DetailedViewHelper.ToTitle
            configuredToString.append(contentsOf: toString)
        }
        
        if ccString.count > 0 {
            configuredToString.append(contentsOf: LocalizedStringKey.DetailedViewHelper.SeparatorTitle)
            configuredToString.append(contentsOf: ccString)
        }
    }
    
    private func getRecipients(from message: Messages) -> String {
        guard let toArray = message.messages_recipients?.allObjects as? [Messages_Recipients] else { return "" }
        var nameArray: [String] = []
        for toData in toArray {
            let toObject: Messages_Recipients = toData
            if toObject.first_name?.count == 0 {
                guard let name = toObject.name else { return "" }
                nameArray.append(name)
            } else {
                guard let first_name = toObject.first_name else { return "" }
                nameArray.append(first_name)
            }
        }
        let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: LocalizedStringKey.DetailedViewHelper.SeparatorTitle)
        return nameConcatenatedString
    }
    
    private func getToString(from message: Messages) -> String {
        guard let toArray = message.messages_to?.allObjects as? [Messages_To] else { return "" }
        var nameArray: [String] = []
        for toData in toArray {
            let toObject: Messages_To = toData
            if toObject.name?.count == 0 {
                guard let email = toObject.email else { return "" }
                nameArray.append(email)
            } else {
                guard let name = toObject.name else { return "" }
                nameArray.append(name)
            }
        }
        let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: LocalizedStringKey.DetailedViewHelper.SeparatorTitle)
        return nameConcatenatedString
    }
    
    private func getCcString(from message: Messages) -> String {
        guard let ccArray = message.messages_cc?.allObjects as? [Messages_Cc] else { return "" }
        var nameArray: [String] = []
        for ccData in ccArray {
            let ccObject: Messages_Cc = ccData
            if ccObject.name?.count == 0 {
                guard let email = ccObject.email else { return "" }
                nameArray.append(email)
            } else {
                guard let name = ccObject.name else { return "" }
                nameArray.append(name)
            }
        }
        let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: LocalizedStringKey.DetailedViewHelper.SeparatorTitle)
        return nameConcatenatedString
    }

    func addSwipeActions(cell: ThreadsDetailViewTableViewCell) {
        cell.rightActions = [
            CustomThreadsDetailViewSwipeAction(title: "", color: #colorLiteral(red: 0.9490196078, green: 0.9411764706, blue: 0.9803921569, alpha: 1))
        ]
    }
    
    func  checkIfForwardedMessagesExistsOrNot(cell: ThreadsDetailViewTableViewCell, indexPath: IndexPath) {
        if let val = self.parentVC.forwardedMessagesDictionary[indexPath.row] {
            cell.forwardedWebViewHeight = val
            cell.containsForwardedMessage = true
            if self.parentVC.selectedIndices.contains(indexPath) {
                cell.viewOrHideMessageTitle.text = "HIDE MESSAGE"
                cell.viewAll = true
            } else {
                cell.viewOrHideMessageTitle.text = "VIEW MESSAGE"
                cell.viewAll = false
            }
        } else {
            cell.containsForwardedMessage = false
        }
    }
    
    func checkIfThisIsUnreadCell(message: Messages, cell: ThreadsDetailViewTableViewCell, indexPath: IndexPath) {
        if let unreadMessageId = self.parentVC.unreadMessageId, let message_id = message.id {
            if (message_id.isEqualToString(find: unreadMessageId)) {
                cell.unreadBeginning = true
                cell.newMessageLineImageView.isHidden = false
                self.parentVC.lineContainingCell = cell
                if self.parentVC.tableView != nil {
                    if (self.parentVC.tableView?.isCellVisible(section: indexPath.section, row: indexPath.row))! {
                        cell.cellVisible = true
                    } else {
                        cell.cellVisible = false
                    }
                }
            } else {
                cell.unreadBeginning = false
                cell.newMessageLineImageView.isHidden = true
            }
        } else {
            cell.unreadBeginning = false
            cell.newMessageLineImageView.isHidden = true
        }
        
    }
    
    func checkIfThisIsATempCell(message: Messages, cell: ThreadsDetailViewTableViewCell) {
        if let bool = message.messages_id?.isEqualToString(find: "tempId"), bool == true {
            cell.statusImageView.isHidden = false
            cell.dateLabel.isHidden = true
            cell.receivers = self.parentVC.receivers
        } else {
            cell.statusImageView.isHidden = true
            cell.dateLabel.isHidden = false
        }
    }
    
    func checkIfReplierIsSuccessOrFail(message: Messages, cell: ThreadsDetailViewTableViewCell, indexPath: IndexPath) {
        if self.parentVC.fromReplier, let replierSuccess = self.parentVC.replierSuccess, replierSuccess, indexPath.row == self.parentVC.dataArray.count - 1 {
            print("replier success")
            cell.fromReplier = true
            cell.replierSuccess = true
            cell.dateLabel.isHidden = true
        } else if self.parentVC.fromReplier, let replierSuccess = self.parentVC.replierSuccess, !replierSuccess, indexPath.row == self.parentVC.dataArray.count - 1 {
            print("replier false")
            cell.fromReplier = true
            cell.replierSuccess = false
            cell.dateLabel.isHidden = true
        } else {
            cell.fromReplier = false
            cell.replierSuccess = nil
        }
    }
    
    func addSpinner(to tableView: UITableView) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableHeaderView = spinner
        tableView.tableHeaderView?.isHidden = false
    }
    
    func relativePast(for dateInt : Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        if (components.day! > 1) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            return localDate
        } else if components.day! == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = localDate
            return labelDate
        }
    }
    
    func addFromObject(messages: Messages, onCell: ThreadsDetailViewTableViewCell) {
        let fromArray = messages.messages_from?.allObjects as? [Messages_From]
        var fromName = ""
        if fromArray?.count != nil {
            if let from:Messages_From = fromArray?.first {
                if let name = from.name {
                    if !name.isEmpty {
                        fromName = name
                    } else if let email = from.email {
                        fromName = email
                    }
                }
                if let email = from.email {
                    onCell.emailLabel.text = email
                }
            }
        }
        let toTitle = LocalizedStringKey.DetailedViewHelper.ToTitle
        var toString = getRecipients(from: messages)
        if toString.count == 0 {
            toString = getToString(from: messages)
        }
        var configuredToString = ""
        if toString.count > 0 {
            configuredToString.append(contentsOf: toString)
        }
        
        let fromNameFont = UIFont.latoStyleAndSize(style: .black, size: .largeMedium)
        let toTitleFont = UIFont.latoStyleAndSize(style: .regular, size: .regular)
        let toStringFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)

        let fromNameDict = [NSAttributedStringKey.font : fromNameFont, NSAttributedStringKey.foregroundColor : UIColor.init(hexString: "404040")]
        let toTitleDict = [NSAttributedStringKey.font : toTitleFont, NSAttributedStringKey.foregroundColor : UIColor.init(hexString: "939393")]
        let toStringDict = [NSAttributedStringKey.font : toStringFont, NSAttributedStringKey.foregroundColor : UIColor.init(hexString: "939393")]
        
        let fromNameAttributedString = NSMutableAttributedString(string: fromName + " ",
                                                                 attributes: fromNameDict )
        let toTitleAttributedString = NSMutableAttributedString(string: toTitle,
                                                                attributes: toTitleDict )
        let toStringAttributedString = NSMutableAttributedString(string: toString,
                                                                attributes: toStringDict )
        
        fromNameAttributedString.append(toTitleAttributedString)
        fromNameAttributedString.append(toStringAttributedString)
        onCell.nameLabel.attributedText = fromNameAttributedString
    }
    
    func loadWebViewsWith(messages: Messages, onCell : ThreadsDetailViewTableViewCell, indexPath: IndexPath) {
        self.loadProfilePicture(messages: messages, onCell: onCell)
        if onCell.unreadBeginning {
            onCell.newMessageLineImageView.isHidden = false
            self.parentVC.lineContainingCell = onCell
        } else {
            onCell.newMessageLineImageView.isHidden = true
        }
        
        //MARK: - if message have sharing message id should load body
        if messages.sharing_message_id != nil {
            loadMessagesBody(messages: messages, onCell: onCell)
            return
        }
        
        let segmentedHtmlArray = messages.messages_segmented_html?.allObjects as? [Messages_Segmented_Html]
        if ((segmentedHtmlArray?.count) != nil && (segmentedHtmlArray?.count)! > 0) {
            for segmentedHtml in segmentedHtmlArray! {
                self.loadTopMessageCell(segmentedHtml: segmentedHtml, onCell: onCell)
            }
        } else {
            self.loadMessagesBody(messages: messages, onCell: onCell)
        }
        
    }
    
    func loadTopMessageCell(segmentedHtml: Messages_Segmented_Html, onCell: ThreadsDetailViewTableViewCell) {
        if let segmentedType = segmentedHtml.type {
            if segmentedHtml.order == 1 && (segmentedType.isEqualToString(find: "top_message")) {
                if segmentedHtml.html_markdown != nil {
                    let down = Down(markdownString: segmentedHtml.html_markdown!)
                    // Convert to HTML
                    let html = try? down.toHTML(.HardBreaks)
                    print(html as Any)
                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html! + "</span>"
                    DispatchQueue.main.async {
                        onCell.webView.loadHTMLString(htmlString , baseURL: nil)
                    }
                } else
                    if segmentedHtml.html != nil {
                        let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px; color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + segmentedHtml.html! + "</span>"
                        DispatchQueue.main.async {
                            onCell.webView.loadHTMLString(htmlString, baseURL: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            onCell.webView.loadHTMLString("<p> <p>", baseURL: nil)
                        }
                }
            }

        }
    }
    
    func loadMessagesBody(messages: Messages, onCell: ThreadsDetailViewTableViewCell) {
        guard var html = messages.body else {
            DispatchQueue.main.async {
                onCell.webView.loadHTMLString("<p> <p>", baseURL: nil)
            }
            return
        }
        let string = html
        if let range = string.range(of: "<blockquote") {
            let firstPart = string[string.startIndex..<range.lowerBound]
            html = firstPart + "</html>"
        }
        if !html.isEmpty {
            let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px; color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
            DispatchQueue.main.async {
                onCell.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        } else {
            DispatchQueue.main.async {
                onCell.webView.loadHTMLString("<p> <p>", baseURL: nil)
            }
        }
    }
    
    func setLinkUrlPreview(htmlString: String, onCell: ThreadsDetailViewTableViewCell) {
        let input = htmlString
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
            for match in matches {
                guard let range = Range(match.range, in: input) else { return }
                let url = input[range]
                let body: [String : Any] = [ "url": "\(url)" ]
                
                Alamofire.request("https://metamorphic-dev.hellolucy.io/dispatcher", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        if (response.result.error == nil) {
                            if let JSON = response.result.value as? [String: Any] {
                                if let dict : [String: Any] = JSON["metamorphic"] as? [String : Any] {
                                    if let domain = dict["site_name"] {
                                        onCell.siteNamelabel.text = domain as? String
                                    }
                                    if let link = dict["url"] as? String {
                                        let str = link.replacingOccurrences(of: "</p>", with: "")
                                        onCell.urlLabel.text = str
                                    }
                                    if let iconUrl = dict["favicon"] {
                                        if let url = URL.init(string: (iconUrl as? String)!) {
                                            DispatchQueue.main.async {
                                                onCell.iconImage.downloadedFrom(url: url, completion: { (finished, error) in
                                                })
                                            }
                                        }
                                    }
                                    if let title = dict["title"] {
                                        onCell.titleLabel.text = title as? String
                                    }
                                    
                                    if let type = dict["type"] as? String {
                                        
                                        let website = "website"
                                        let video = "video"
                                        if type == website {
                                            if let description = dict["description"] {
                                                onCell.descriptionLabel.text = description as? String
                                            }
                                            
                                            if let image = dict["image"] {
                                                if let url = URL.init(string: image as! String) {
                                                    DispatchQueue.main.async {
                                                        onCell.websiteImage.downloadedFrom(url: url, completion: { (finished, error) in
                                                        })
                                                    }
                                                }
                                                onCell.addLinkBoxWithImage()
                                            } else {
                                                onCell.addLinkBoxWithoutImage()
                                            }
                                            
                                            if let webURL = dict["url"] {
                                                onCell.websiteURL = webURL as! String
                                            }
                                        }
                                        
                                        if type == video {
                                            if let videoLink = dict["video_web_embed_url"] {
                                                onCell.youtubeURL = videoLink as? String
                                            }
                                            onCell.addVideoLink()
                                        }
                                    }
                                }
                            }
                        } else {
                            debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                        }
                }
            }
        }
    }
    
    func loadProfilePicture(messages: Messages, onCell: ThreadsDetailViewTableViewCell) {
        let fromArray = messages.messages_from?.allObjects as? Array<Messages_From>
        if fromArray?.count != nil {
            if let from:Messages_From = fromArray?.first {
                if let imagePath = from.profile_pic {
                    onCell.profileImageView.isHidden = false
                    onCell.profileImageView.configureImage(with: imagePath)
                }
            }
        }
    }
    
    func addAttachmentsView(using message: Messages, onCell: ThreadsDetailViewTableViewCell) {
        if onCell.attachmentsView != nil {
            onCell.attachmentsView?.removeFromSuperview()
        }
        guard let files = message.messages_files else { return }
        if files.count == 0 {
            return
        }
        
        onCell.attachmentsView = AttachmentsView()
        onCell.containerView.addSubview(onCell.attachmentsView!)
        onCell.attachmentsView?.autoresizingMask = .flexibleHeight
        if let forwardedMessageIsThere = onCell.containsForwardedMessage, forwardedMessageIsThere == true {
            onCell.attachmentsView?.snp.remakeConstraints({ (make) in
                make.height.equalTo(onCell.attachmentsViewHeight)
                make.top.equalTo(onCell.webView.snp.bottom).offset(onCell.forwardedWebViewHeight)
                make.leading.equalTo(onCell.webView.snp.leading).offset(-8)
                make.width.equalTo(onCell.webView.snp.width)
            })
        } else {
            onCell.attachmentsView?.snp.remakeConstraints({ (make) in
                make.height.equalTo(onCell.attachmentsViewHeight)
                make.top.equalTo(onCell.webView.snp.bottom)
                make.leading.equalTo(onCell.webView.snp.leading).offset(-8)
                make.width.equalTo(onCell.webView.snp.width)
            })
        }
        onCell.attachmentsView?.clipsToBounds = true
        onCell.attachmentsView?.backgroundColor = .white
        onCell.attachmentsView?.layoutIfNeeded()
        
        onCell.attachmentsView?.onOpenAttachment = onCell.onOpenAttachment
        onCell.attachmentsView?.setupSubviews(for: message)
        
//        onCell.attachmentsView = AttachmentsView()
//        onCell.attachmentsView?.translatesAutoresizingMaskIntoConstraints = false
//        onCell.addSubview(onCell.attachmentsView!)
//        onCell.attachmentsView?.heightAnchor.constraint(equalToConstant: onCell.attachmentsViewHeight).isActive = true
//        onCell.attachmentsView?.topAnchor.constraint(equalTo: (onCell.webView.bottomAnchor)).isActive = true
//        onCell.attachmentsView?.leadingAnchor.constraint(equalTo: onCell.containerView.leadingAnchor).isActive = true
//        onCell.attachmentsView?.trailingAnchor.constraint(equalTo: onCell.containerView.trailingAnchor).isActive = true
//        onCell.attachmentsView?.backgroundColor = .white
//        onCell.attachmentsView?.onOpenAttachment = onCell.onOpenAttachment
//        onCell.attachmentsView?.setupSubviews(for: message)
    }
    
}
