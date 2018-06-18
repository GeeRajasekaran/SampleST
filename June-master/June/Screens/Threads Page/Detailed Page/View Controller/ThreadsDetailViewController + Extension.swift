//
//  File.swift
//  June
//
//  Created by Joshua Cleetus on 1/22/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import CoreData
import Down
import AudioToolbox

extension ThreadsDetailViewController {

    func checkDataStore() {
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        request.predicate = NSPredicate(format: "thread_id == %@", self.threadId!)
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            self.startLoader()
            if threadsCount == 0 {
                if Reachability.isConnectedToNetwork(){
                    print("Internet Connection Available!")
                    self.getMessagesFromBackend()
                }else{
                    print("Internet Connection not Available!")
                    self.stopLoader()
                }
            } else {
                self.loadData()
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when){[weak self] in
                    self?.getMessagesFromBackendIntheBackground()
                }
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getMessagesFromBackend() {
        self.isLoading = true
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: self.threadId!) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    strongSelf.messagesService = ThreadsDetailService(parentVC: strongSelf)
                    strongSelf.messagesService?.saveInCoreDataWith(array: data)
                    strongSelf.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                    strongSelf.isLoading = false
                case .Error(let message):
                    print(message)
                    strongSelf.stopLoader()
                    strongSelf.isLoading = false
                }
            }
        }
    }
    
    func getIndexOfUnreadMessagesBeginning() -> Void {
        if let thread_id = self.threadId {
            let service = ThreadsDetailAPIBridge()
            service.getUnreadMessagesForTheThread(threadId: thread_id) { [weak self] (result) in
                if let strongSelf = self {
                    switch result {
                    case .Success(let data):
                        if data.count > 0 {
                            let offset: CGFloat = 10
                            strongSelf.tableView?.frame.origin.y += offset
                            strongSelf.inititalTableViewFrame.origin.y += offset
                            let dict = data[0]
                            let message_id = dict["id"]
                            strongSelf.unreadMessageId = (message_id as? String)
                            strongSelf.totalUnreadMessagesCount = service.totalUnreadMessagesCount
                        }
                    case .Error(let message):
                        print(message)
                    }
                }
            }
        }
    }
    
    func showUnreadMessagesBox(indexPath: IndexPath) -> Void {
        self.unreadBox = UIImageView()
        self.unreadBox.frame = CGRect(x: 0, y: 66, width: self.view.frame.size.width, height: 44)
        self.unreadBox.image = #imageLiteral(resourceName: "unread_box")
        self.unreadBox.isUserInteractionEnabled = true
        self.unreadBox.accessibilityHint = "unreadBox"
        self.navigationController?.view.addSubview(self.unreadBox)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        label.textColor = .white
        label.text = "\(self.totalUnreadMessagesCount)" + " new messages"
        label.font = UIFont.fontWith(style: "Lato-Regular", size: FontSize(rawValue: 14)!)
        label.textAlignment = .center
        self.unreadBox.addSubview(label)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        button.addTarget(self, action: #selector(ThreadsDetailViewController.hideUnreadMessagesBox), for: .touchUpInside )
        button.backgroundColor = .clear
        self.unreadBox.addSubview(button)
    }
    
    @objc func hideUnreadMessagesBox() -> Void {
        self.removeUnreadBox()
    }
    
    func loadData() {
        self.messagesService = ThreadsDetailService(parentVC: self)
        self.fetchedResultController = self.messagesService?.getMessagesFromThread(_withThreadId: self.threadId!, withAscendingOrder: self.sortAscending)
        self.fetchedResultController.delegate = nil
        guard let array = self.fetchedResultController.fetchedObjects?.reversed() else {
            return
        }
        self.dataArray = Array(array)
        self.linkIndexes = []
        self.loadTheWebViewsToFindHeights()
        self.oldMessage = self.dataArray.last
    }
    
    func removeAttachments() {

    }
    
    func getMessagesFromBackend2() {
        self.isLoading = true
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: self.threadId!) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    strongSelf.messagesService = ThreadsDetailService(parentVC: strongSelf)
                    strongSelf.messagesService?.saveInCoreDataWith2(array: data)
                    strongSelf.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                    strongSelf.isLoading = false
                case .Error(let message):
                    print(message)
                    strongSelf.isLoading = false
                }
            }
        }
    }
    
    func buildHTMLBody(from bodyString: String) -> String {
        let template = htmlTemplate.replacingOccurrences(of: placeholderString, with: bodyString)
        return template.replacingOccurrences(of: "\n", with: "<br>")
    }
    
    @objc func markThreadAsStarredOrUnstarred() {
        
        let threadDetailService = ThreadsDetailService.init(parentVC: self)
        threadDetailService.updateStarredValue(threadId: self.threadId!, starredValue: self.starred!)
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            let service = ThreadsDetailAPIBridge()
            guard let threadId = self?.threadId, let accountId = self?.threadAccountId, let starred = self?.starred else { return }
            service.markThreadAsStarredOnUnstarred(threadId: threadId, accountId: accountId, starred: starred, completion: { [weak self] (result) in
                if self != nil {
                    switch result {
                    case .Success(let data):
                        print(data)
                    case .Error(let message):
                        print(message)
                    }
                }
            })
        }
        
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3,
                                      execute: requestWorkItem)
    }
    
    @objc func undoStarredUnstarredAction() {
        print("clicked undo")
        self.starButton.transform = CGAffineTransform(scaleX: 1.75, y: 1.75);
        _ = [UIView .animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.starButton.transform = CGAffineTransform.identity;
        }, completion: { [weak self] (finished) in
            
            if let strongSelf = self {
                if !strongSelf.starred! {
                    strongSelf.starred = true
                    strongSelf.starButton.setImage(#imageLiteral(resourceName: "star_icon"), for: .normal)
                    strongSelf.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
                    strongSelf.alertButtonLabel.text = ""
                } else {
                    strongSelf.starred = false
                    strongSelf.starButton.setImage(#imageLiteral(resourceName: "icon_starred_gray"), for: .normal)
                    strongSelf.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_unstarred"), for: .normal)
                    strongSelf.alertButtonLabel.text = ""
                }
                strongSelf.controllerDelegate?.controller(strongSelf, starred: strongSelf.starred!)
                strongSelf.markThreadAsStarredOrUnstarred()
                strongSelf.alertButton.isHidden = true
                strongSelf.alertButtonLabel.isHidden = true
            }
        })];
    }
    
    func loadTheWebViewsToFindHeights() {
        
        guard self.isScreenVisible == true else { return }
        self.shouldLoadMoreMessagesThreads = false
        self.webView.tag = 1
        
        if webViewCount < (self.dataArray.count) {
            
            //MARK: - if message have sharing message id should load body
            if dataArray[webViewCount].sharing_message_id != nil {
                guard let body = self.dataArray[webViewCount].body else {
                    return
                }
                webView.loadHTMLString(body, baseURL: nil)
                return
            }
            
            if let segmentedHtmlArray = self.dataArray[webViewCount].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html> {
                
                if ((segmentedHtmlArray.count) > 0) {
                    
                    let attributeValue = "forward";
                    let namePredicate = NSPredicate(format: "type like %@",attributeValue)
                    let filteredArray = segmentedHtmlArray.filter { namePredicate.evaluate(with: $0) };
                    
                    if filteredArray.count != 0 {
                        self.forwardMessageIndex.append(webViewCount)
                        self.loadTheForwardedMessage(withTag: 100+webViewCount, localWebViewCount: webViewCount)
                        return
                    }
                    
                    let attributeValueTopMessage = "top_message";
                    let namePredicateTopMessage = NSPredicate(format: "type like %@",attributeValueTopMessage)
                    let filteredArrayTopMessage = segmentedHtmlArray.filter { namePredicateTopMessage.evaluate(with: $0) };
                    
                    if filteredArrayTopMessage.count != 0 {
                        let segmentedHtml = filteredArrayTopMessage.first
                        if let segmentedType = segmentedHtml?.type {
                            if segmentedHtml?.order == 1 && (segmentedType.isEqualToString(find: "top_message")) {
                                
                                if segmentedHtml?.html_markdown != nil {
                                    let down = Down(markdownString: (segmentedHtml?.html_markdown!)!)
                                    // Convert to HTML
                                    if let html = try? down.toHTML(.HardBreaks) {
                                        let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"

                                        DispatchQueue.main.async {
                                            self.webView.loadHTMLString(htmlString , baseURL: nil)
                                        }
                                        let input = htmlString
                                        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                                        if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                                            for match in matches {
                                                guard let range = Range(match.range, in: input) else { continue }
                                                let url = input[range]
                                                if url.count > 0 {
                                                    self.linkIndexes.append(webViewCount)
                                                }
                                            }
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                                        }
                                    }
                                } else if segmentedHtml?.html != nil {
                                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + (segmentedHtml?.html!)! + "</span>"

                                    DispatchQueue.main.async {
                                        self.webView.loadHTMLString(htmlString, baseURL: nil)
                                    }
                                    
                                    let input = htmlString
                                    let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                                    if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                                        for match in matches {
                                            guard let range = Range(match.range, in: input) else { continue }
                                            let url = input[range]
                                            if url.count > 0 {
                                                self.linkIndexes.append(webViewCount)
                                            }
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                                    }
                                }
                            }
                        }
                    } else {
                        guard let body = self.dataArray[webViewCount].body else {
                            return
                        }
                        var html = body
                        let string = html
                        if let range = string.range(of: "<blockquote") {
                            let firstPart = string[string.startIndex..<range.lowerBound]
                            html = firstPart + "</html>"
                        }
                        if !html.isEmpty {
                            let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString(htmlString, baseURL: nil)
                            }
                            
                            let input = htmlString
                            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                            if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                                for match in matches {
                                    guard let range = Range(match.range, in: input) else { continue }
                                    let url = input[range]
                                    if url.count > 0 {
                                        self.linkIndexes.append(webViewCount)
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                            }
                        }
                    }
                } else {
                    var html = self.dataArray[webViewCount].body!
                    let string = html
                    if let range = string.range(of: "<blockquote") {
                        let firstPart = string[string.startIndex..<range.lowerBound]
                        html = firstPart + "</html>"
                    }
                    if !html.isEmpty {
                        let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString(htmlString, baseURL: nil)
                        }
                        
                        let input = htmlString
                        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                        if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                            for match in matches {
                                guard let range = Range(match.range, in: input) else { continue }
                                let url = input[range]
                                if url.count > 0 {
                                    self.linkIndexes.append(webViewCount)
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                        }
                    }
                }
            }
        }
        
        if webViewCount == self.dataArray.count {
            let array = self.contentHeights.prefix(self.dataArray.count)
            self.mainContentHeights = Array(array)
            let array2 = self.webViewContentHeights.prefix(self.dataArray.count)
            self.mainWebViewContentHeights = Array(array2)
            webViewCount = 0
            self.isLoading = true
            self.loader.hide()
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            self.isLoading = false
            self.shouldLoadMoreMessagesThreads = true
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.tableView?.isHidden = false
                self.showResponder()
                self.scrollToLastMessage()
                self.stopLoader()
            }
        }
    }
    
    func loadTheForwardedMessage(withTag tagValue:Int, localWebViewCount:Int) {
        
        let segmentedHtmlArray = self.dataArray[webViewCount].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
        
        let attributeValue = "forward";
        let namePredicate = NSPredicate(format: "type like %@",attributeValue)
        let filteredArray = segmentedHtmlArray?.filter { namePredicate.evaluate(with: $0) };
        
        if filteredArray?.count != 0 {
            let segmentedHtml = filteredArray?.first
            if segmentedHtml?.order == 2 && (segmentedHtml?.type?.isEqualToString(find: "forward"))! {
                self.forwardedMessagesDictionary.updateValue( 75, forKey: localWebViewCount)
                
            }
        }
        
        let attributeValue2 = "top_message";
        let namePredicate2 = NSPredicate(format: "type like %@",attributeValue2)
        let filteredArray2 = segmentedHtmlArray?.filter { namePredicate2.evaluate(with: $0) };
        
        if filteredArray2?.count != 0 {
            let segmentedHtml = filteredArray2?.first
            if segmentedHtml?.order == 1 && (segmentedHtml?.type?.isEqualToString(find: "top_message"))! {
                if segmentedHtml?.html_markdown != nil {
                    let down = Down(markdownString: (segmentedHtml?.html_markdown!)!)
                    // Convert to HTML
                    if let html = try? down.toHTML(.HardBreaks) {
                        let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString(htmlString , baseURL: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                        }
                    }
                } else if segmentedHtml?.html != nil {
                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + (segmentedHtml?.html!)! + "</span>"
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString( htmlString, baseURL: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                    }
                }
            }
        }
    }
    
    func showResponder() {
        if newResponder != nil { return }
        guard isScreenVisible else { return }
        if let unwrappedThread = self.threadToRead, let unwrappedMessage = self.dataArray.last {
            let config = ResponderConfig(with: unwrappedThread, message: unwrappedMessage, minimized: true)
            config.goal = .replyAll
            newResponder = Responder(rootVC: self, config: config)
            newResponder?.actionsListener = self
            newResponder?.show()
            self.config = config
        }
    }
    
    func scrollToLastMessage() {
        guard let numberOfSections = self.tableView?.numberOfSections else { return }
        if numberOfSections > 0 {
            let lastSectionIndex = numberOfSections - 1
            guard let numberOfRows = self.tableView?.numberOfRows(inSection: lastSectionIndex) else { return }
            if numberOfRows > 0 {
                let lastSectionLastRow = numberOfRows - 1
                let indexPath = IndexPath(row: lastSectionLastRow, section: lastSectionIndex)
                self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
            }
        }
    }
    
    func scrollToTopOfFirstMessage() {
        guard let numberOfSections = self.tableView?.numberOfSections else { return }
        if numberOfSections > 0 {
            let lastSectionIndex = numberOfSections - 1
            guard let numberOfRows = self.tableView?.numberOfRows(inSection: lastSectionIndex) else { return }
            if numberOfRows > 0 {
                let lastSectionLastRow = 0
                let indexPath = IndexPath(row: lastSectionLastRow, section: lastSectionIndex)
                self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.tag == 1 {
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            var height:CGFloat = webView.scrollView.contentSize.height
            if height <= 8 {
                height = 43
            }
            self.contentHeights[webViewCount] = height + 22 + 15
            self.webViewContentHeights[webViewCount] = height
            self.webViewCount = webViewCount + 1
            self.loadTheWebViewsToFindHeights()
            print(self.contentHeights as Any)
        } else if webView.tag == 2 {
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            var height:CGFloat = webView.scrollView.contentSize.height
            if height <= 8 {
                height = 43
            }
            self.contentHeights[webViewCount2 + self.dataArray.count] = height + 22 + 15
            self.webViewContentHeights[webViewCount2 + self.dataArray.count] = height
            self.webViewCount2 = webViewCount2 + 1
            self.loadTheWebViewsToFindHeights2()
        } else if webView.tag == 3 {
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            var height:CGFloat = webView.scrollView.contentSize.height + 150
            if height < 150 {
                height = 150
            }
            self.contentHeights[webViewCount3] = height
            self.webViewContentHeights[webViewCount3] = (webView.scrollView.contentSize.height)
            self.webViewCount3 = webViewCount3 + 1
            self.loadTheWebViewsToFindHeights3()
        } else if webView.tag == 4 {
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            var height:CGFloat = webView.scrollView.contentSize.height
            if height <= 8 {
                height = 43
            }
            if self.backgroundDataArray.isEmpty == false {
                self.backgroundContentHeights[backgroundWebViewCount] = height + 22 + 15
                self.backgroundWebViewContentHeights[backgroundWebViewCount] = height
                self.backgroundWebViewCount = backgroundWebViewCount + 1
                self.loadTheWebViewsToFindHeightsInTheBackground()
            }
        } else if webView.tag >= 100 {
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            let height:CGFloat = webView.scrollView.contentSize.height + 75
            self.forwardedMessagesDictionary[webView.tag - 100] = height
            self.tableView?.reloadData()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("error = ", error)
        if webView.tag == 1 {
            let height:CGFloat = 150
            self.contentHeights[webViewCount] = height
            self.webViewContentHeights[webViewCount] = height
            self.webViewCount = webViewCount + 1
            self.loadTheWebViewsToFindHeights()
        } else if webView.tag == 2 {
            let height:CGFloat = 150
            self.contentHeights[webViewCount2] = height
            self.webViewContentHeights[webViewCount2 + self.dataArray.count] = height
            self.webViewCount2 = webViewCount2 + 1
            self.loadTheWebViewsToFindHeights2()
        } else if webView.tag == 3 {
            let height:CGFloat = 150
            self.contentHeights[webViewCount3] = height
            self.webViewContentHeights[webViewCount3] = height
            self.webViewCount3 = webViewCount3 + 1
            self.loadTheWebViewsToFindHeights3()
        }else if webView.tag == 4 {
            let height:CGFloat = 150
            self.backgroundContentHeights[backgroundWebViewCount] = height
            self.backgroundWebViewContentHeights[backgroundWebViewCount] = height
            self.backgroundWebViewCount = backgroundWebViewCount + 1
            self.loadTheWebViewsToFindHeightsInTheBackground()
        }else if webView.tag >= 100 {
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            let height:CGFloat = webView.scrollView.contentSize.height + 75
            self.forwardedMessagesDictionary[webView.tag - 100] = height
            self.tableView?.reloadData()
        }
    }
    
    func getFromHeight(fromMessage message:Messages) -> CGFloat {
        let fromArray = message.messages_from?.allObjects as? Array<Messages_From>
        var fromString = String()
        if fromArray?.count != nil {
            if let from:Messages_From = fromArray?.first {
                if from.name?.count == 0 {
                    fromString = from.email!
                } else {
                    fromString = from.name!
                }
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
        
        return fromHeight
    }
    
    func getToHeight(fromMessage message:Messages) -> CGFloat {
        
        let toArray = message.messages_to?.allObjects as? Array<Messages_To>
        var toString = String()
        if toArray?.count != nil {
            var nameArray: [String] = []
            for toData in toArray! {
                let toObject:Messages_To = toData
                if let toObjectName = toObject.name {
                    if toObjectName.count > 0 {
                        nameArray.append(toObject.name!)
                    } else {
                        nameArray.append("")
                    }
                } else if let toObjectEmail = toObject.email {
                    if toObjectEmail.count > 0 {
                        nameArray.append(toObjectEmail)
                    } else {
                        nameArray.append("")
                    }
                } else {
                    nameArray.append("")
                }
            }
            print(nameArray as Any)
            let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: ", ")
            toString = "to " + nameConcatenatedString
        } else {
            toString = ""
        }
        let toFont = UIFont(name: LocalizedFontNameKey.ThreadsDetailViewHelper.FromParticipantLabelFontRegular, size: 12)
        let toWidth = self.view.frame.size.width - 48 - 15
        var toHeight = ThreadsDetailViewHelper.init().heightForLabel(toString, font: toFont!, width: CGFloat(toWidth), lineSpacing: 0.0)
        if toHeight < 15 {
            toHeight = 15
        }
        return toHeight
    }
    
    func getCcHeight(fromMessage message:Messages) -> CGFloat {
        let ccArray = message.messages_cc?.allObjects as? Array<Messages_Cc>
        var ccString = String()
        if ccArray?.count != nil {
            var nameArray: [String] = []
            for ccData in ccArray! {
                let ccObject:Messages_Cc = ccData
                if ccObject.name?.count == 0 {
                    nameArray.append(ccObject.email!)
                } else {
                    nameArray.append(ccObject.name!)
                }
            }
            let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: ", ")
            if nameConcatenatedString.count > 0 {
                ccString = "cc: " + nameConcatenatedString
            } else {
                ccString = ""
            }
        } else {
            ccString = ""
        }
        
        let ccFont = UIFont(name: LocalizedFontNameKey.ThreadsDetailViewHelper.FromParticipantLabelFontRegular, size: 12)
        let ccWidth = self.view.frame.size.width - 48 - 15
        var ccHeight = ThreadsDetailViewHelper.init().heightForLabel(ccString, font: ccFont!, width: CGFloat(ccWidth), lineSpacing: 0.0)
        if ccHeight < 15 {
            ccHeight = 15
        }
        if !(ccString.count > 0) {
            ccHeight = 0
        }
        return ccHeight
    }
    
    func loadMoreMessages(withSkip skip:Int) -> Void {
        self.isLoading = true
        self.shouldLoadMoreMessagesThreads = false
        let service = ThreadsDetailAPIBridge()
        service.getMoreMessagesDataWith(_withSkip: skip, threadId: self.threadId!) { [weak self] (result) in
            
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    if data.count != 0 {
                        strongSelf.skip = skip
                        strongSelf.webViewCount3 = strongSelf.skip + data.count
                        strongSelf.messagesService = ThreadsDetailService(parentVC: strongSelf)
                        strongSelf.messagesService?.saveInCoreDataWith3(array: data)
                        strongSelf.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                    }
                    strongSelf.tableView?.tableHeaderView = nil
                    strongSelf.isLoading = false
                case .Error(let message):
                    print(message)
                    if message.isEqualToString(find: "The operation couldn’t be completed. (Feathers.AnyFeathersError error 1.)") {
                        SocketIOManager.sharedInstance.refreshJWTToken()
                    }
                    strongSelf.isLoading = false
                    strongSelf.shouldLoadMoreMessagesThreads = true
                    strongSelf.tableView?.tableHeaderView = nil
                }
            }
        }
    }
    
    func loadData3() {
        self.messagesService = ThreadsDetailService(parentVC: self)
        self.fetchedResultController3 = self.messagesService?.getMessagesFromThread(_withThreadId: self.threadId!, skipValue: self.skip+5, withAscendingOrder: self.sortAscending)
        self.forwardMessageIndex3 = self.forwardMessageIndex
        self.loadTheWebViewsToFindHeights3()
    }
    
    func loadTheWebViewsToFindHeights3() {
        
        guard self.isScreenVisible == true else { return }
        self.isLoading = true
        self.webView.tag = 3
        
        if webViewCount3 < (self.fetchedResultController3.fetchedObjects?.count)! {
            
            //MARK: - if message have sharing message id should load body
            if self.fetchedResultController3.fetchedObjects![webViewCount3].sharing_message_id != nil {
                guard let body = self.fetchedResultController3.fetchedObjects![webViewCount3].body else {
                    return
                }
                webView.loadHTMLString(body, baseURL: nil)
                return
            }
            
            let segmentedHtmlArray = self.fetchedResultController3.fetchedObjects![webViewCount3].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
            if ((segmentedHtmlArray?.count) != nil && (segmentedHtmlArray?.count)! > 0) {
                let attributeValue = "forward";
                let namePredicate = NSPredicate(format: "type like %@",attributeValue)
                let filteredArray = segmentedHtmlArray?.filter { namePredicate.evaluate(with: $0) };
                if filteredArray?.count != 0 {
                    self.forwardMessageIndex3.append(webViewCount3)
                    self.loadTheForwardedMessage(withTag: 100+webViewCount3, localWebViewCount: webViewCount3)
                    return
                }
                
                for segmentedHtml in segmentedHtmlArray! {
                    if segmentedHtml.order == 1 && segmentedHtml.type == "top_message" {
                        if segmentedHtml.html_markdown != nil {
                            let down = Down(markdownString: segmentedHtml.html_markdown!)
                            // Convert to HTML
                            let html = try? down.toHTML(.HardBreaks)
                            let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html! + "</span>"
                            self.webView.loadHTMLString(htmlString , baseURL: nil)
                        } else if segmentedHtml.html != nil {
                            let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + segmentedHtml.html! + "</span>"

                            self.webView.loadHTMLString(htmlString, baseURL: nil)
                        } else {
                            self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                        }
                    }
                }
            } else {
                var html = self.fetchedResultController3.fetchedObjects![webViewCount3].body!
                let string = html
                if let range = string.range(of: "<blockquote") {
                    let firstPart = string[string.startIndex..<range.lowerBound]
                    html = firstPart + "</html>"
                }
                if !html.isEmpty {
                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                    self.webView.loadHTMLString(htmlString, baseURL: nil)
                } else {
                    self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                }
            }
        }
        
        if webViewCount3 == self.fetchedResultController3.fetchedObjects?.count {
            self.fetchedResultController = self.fetchedResultController3
            guard let array = self.fetchedResultController3.fetchedObjects?.reversed() else {
                return
            }
            self.dataArray = Array(array)
            self.forwardMessageIndex = self.forwardMessageIndex3
            self.tableView?.tableHeaderView = nil
            self.tableView?.reloadData()
            self.isLoading = false
            if ((self.fetchedResultController3.fetchedObjects?.count) != nil) {
                if self.totalNewMessagesCount == self.fetchedResultController3.fetchedObjects?.count {
                    self.shouldLoadMoreMessagesThreads = false
                } else {
                    self.shouldLoadMoreMessagesThreads = true
                }
            }
            webViewCount3 = 0
        } else {
            self.isLoading = false
        }
    }
    
    //MARK: Load More Cells
    func loadMoreMessagesFromBackend(with skipValue: Int) -> Void {
        if self.unreadBox != nil {
            self.unreadBox.removeFromSuperview()
        }
        let service = ThreadsDetailAPIBridge()
        self.skip = skipValue
        service.getMoreMessagesDataWith(_withSkip: skipValue, threadId: self.threadId!) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    if data.count != 0 {
                        strongSelf.webViewCount2 = 0
                        strongSelf.messagesService = ThreadsDetailService(parentVC: strongSelf)
                        strongSelf.messagesService?.saveInCoreDataWith2(array: data)
                        strongSelf.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                    }
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    func loadData2() {
        self.messagesService = ThreadsDetailService(parentVC: self)
        self.fetchedResultController2 = self.messagesService?.getMessagesFromThread(_withThreadId: self.threadId!, skipValue: self.skip, withAscendingOrder: self.sortAscending)
        guard let array =  self.fetchedResultController2.fetchedObjects?.reversed() else {
            return
        }
        self.dataArray2 = Array(array)
        webViewCount2 = 0
        self.newMessage = self.fetchedResultController2.fetchedObjects?.last
        let keys = self.forwardedMessagesDictionary.compactMap(){ $0.0 }
        let values = self.forwardedMessagesDictionary.compactMap(){ $0.1 }
        self.forwardedMessagesDictionary2 = [:]
        for key in keys {
            self.forwardedMessagesDictionary2[key + self.dataArray2.count - self.dataArray.count] = values[keys.index(of: key)!]
        }
        self.forwardedMessagesDictionary = self.forwardedMessagesDictionary2
        self.linkIndexes2 = []
        self.loadTheWebViewsToFindHeights2()
    }
    
    func loadTheWebViewsToFindHeights2() {
        
        guard self.isScreenVisible == true else { return }
        self.webView.tag = 2
        if webViewCount2 < (self.dataArray2.count - self.dataArray.count) {
            
            //MARK: - if message have sharing message id should load body
            if dataArray2[webViewCount2].sharing_message_id != nil {
                guard let body = self.dataArray2[webViewCount2].body else {
                    return
                }
                webView.loadHTMLString(body, baseURL: nil)
                return
            }
            
            let segmentedHtmlArray = self.dataArray2[webViewCount2].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
            if ((segmentedHtmlArray?.count) != nil && (segmentedHtmlArray?.count)! > 0) {
                let attributeValue = "forward";
                let namePredicate = NSPredicate(format: "type like %@",attributeValue)
                let filteredArray = segmentedHtmlArray?.filter { namePredicate.evaluate(with: $0) };
                
                if filteredArray?.count != 0 {
                    self.forwardMessageIndex.append(webViewCount2)
                    self.loadTheForwardedMessage2(withTag: 100+webViewCount2, webViewCountLocal: webViewCount2)
                    return
                }
                
                for segmentedHtml in segmentedHtmlArray! {
                    if segmentedHtml.order == 1 && segmentedHtml.type == "top_message" {
                        
                        if segmentedHtml.html_markdown != nil {
                            
                            let down = Down(markdownString: segmentedHtml.html_markdown!)
                            // Convert to HTML
                            if let html = try? down.toHTML(.HardBreaks) {
                                let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                                DispatchQueue.main.async {
                                    self.webView.loadHTMLString(htmlString , baseURL: nil)
                                }
                                
                                let input = htmlString
                                let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                                if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                                    for match in matches {
                                        guard let range = Range(match.range, in: input) else { continue }
                                        let url = input[range]
                                        if url.count > 0 {
                                            self.linkIndexes2.append(webViewCount2)
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                                }
                            }
                        } else if segmentedHtml.html != nil {
                            let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + segmentedHtml.html! + "</span>"
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString(htmlString, baseURL: nil)
                            }
                            
                            let input = htmlString
                            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                            if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                                for match in matches {
                                    guard let range = Range(match.range, in: input) else { continue }
                                    let url = input[range]
                                    if url.count > 0 {
                                        self.linkIndexes2.append(webViewCount2)
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                            }
                        }
                    }
                }
            } else {
                var html = self.dataArray2[webViewCount2].body!
                let string = html
                if let range = string.range(of: "<blockquote") {
                    let firstPart = string[string.startIndex..<range.lowerBound]
                    html = firstPart + "</html>"
                }
                if !html.isEmpty {
                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(htmlString, baseURL: nil)
                    }
                    
                    let input = htmlString
                    let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                        for match in matches {
                            guard let range = Range(match.range, in: input) else { continue }
                            let url = input[range]
                            if url.count > 0 {
                                self.linkIndexes2.append(webViewCount2)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                    }
                }
            }
        }
        
        if webViewCount2 == (self.dataArray2.count - self.dataArray.count) {
                        
            let array = self.contentHeights[self.dataArray.count ..< self.dataArray2.count]
            let array2 = Array(array) + self.mainContentHeights
            self.mainContentHeights = array2
            
            let array3 = self.webViewContentHeights[self.dataArray.count ..< self.dataArray2.count]
            let array4 = Array(array3) + self.mainWebViewContentHeights
            self.mainWebViewContentHeights = array4
            
            self.fetchedResultController = self.fetchedResultController2
            self.dataArray = self.dataArray2
            
            UIView.performWithoutAnimation {
                self.tableView?.reloadData()
                guard let numberOfSections = self.tableView?.numberOfSections else { return }
                if numberOfSections > 0 {
                    let lastSectionIndex = numberOfSections - 1
                    guard let numberOfRows = self.tableView?.numberOfRows(inSection: lastSectionIndex) else { return }
                    if numberOfRows > 0 {
                        let lastSectionLastRow = (self.dataArray.count - self.skip)
                        let indexPath = IndexPath(row: lastSectionLastRow, section: lastSectionIndex)
                        self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                    }
                }
            }
            
            self.tableView?.tableHeaderView = nil
            tableView?.tableHeaderView?.isHidden = true
            self.shouldLoadMoreMessagesThreads = true
            self.checkForUnreadMessagesAfterLoadMore()
        }
    }
    
    func checkForUnreadMessagesAfterLoadMore(){
        let wait = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: wait) { [weak self] in
            
            self?.tableView?.visibleCells.forEach { cell in
                if let cell = cell as? ThreadsDetailViewTableViewCell {
                    if let rect = self?.tableView?.rectForRow(at: cell.indexPath) {
                        if let isVisible = self?.tableView?.bounds.contains(rect) {
                            if isVisible {
                                self?.fullyVisibleCells.append(cell)
                            }
                        }
                    }
                }
            }
            
            if self?.allCells.isEmpty == false {
                for visibleCell in (self?.fullyVisibleCells)! {
                    if let unreadMessageid = self?.unreadMessageId, let visibleCellMessageId = visibleCell.message?.id {
                        if unreadMessageid.isEqualToString(find: visibleCellMessageId) {
                            return
                        }
                    }
                }
            }
            
            if (self?.unreadMessageId) != nil {
                self?.removeUnreadBox()
            }
            
        }
    }
    
    func loadTheForwardedMessage2(withTag tagValue:Int, webViewCountLocal:Int) {
        
        let segmentedHtmlArray = self.fetchedResultController2.fetchedObjects![webViewCountLocal].messages_segmented_html?.allObjects as? [Messages_Segmented_Html]
        
        let attributeValue = "forward";
        let namePredicate = NSPredicate(format: "type like %@",attributeValue)
        let filteredArray = segmentedHtmlArray?.filter { namePredicate.evaluate(with: $0) };
        
        if filteredArray?.count != 0 {
            let segmentedHtml = filteredArray?.first
            if segmentedHtml?.order == 2 && (segmentedHtml?.type?.isEqualToString(find: "forward"))! {
                self.forwardedMessagesDictionary.updateValue( 75, forKey: webViewCountLocal)
                
            }
        }
        
        let attributeValue2 = "top_message";
        let namePredicate2 = NSPredicate(format: "type like %@",attributeValue2)
        let filteredArray2 = segmentedHtmlArray?.filter { namePredicate2.evaluate(with: $0) };
        
        if filteredArray2?.count != 0 {
            let segmentedHtml = filteredArray2?.first
            if segmentedHtml?.order == 1 && (segmentedHtml?.type?.isEqualToString(find: "top_message"))! {
                if segmentedHtml?.html_markdown != nil {
                    let down = Down(markdownString: (segmentedHtml?.html_markdown!)!)
                    // Convert to HTML
                    if let html = try? down.toHTML(.HardBreaks) {
                        let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString(htmlString , baseURL: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                        }
                    }
                } else if segmentedHtml?.html != nil {
                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + (segmentedHtml?.html)! + "</span>"
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString( htmlString, baseURL: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                    }
                }
            }
        }
    }
    
    func getMessagesFromBackendIntheBackground() {
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: self.threadId!) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    print(data as Any)
                    if data.isEmpty == false {
                        if let dataObject = data.first{
                            if let dataId = dataObject["id"] {
                                if let currentDataObject = self?.dataArray.last {
                                    if let currentDataId = currentDataObject.id {
                                        let isEqual = (dataId as! String == currentDataId)
                                        if !isEqual {
                                            strongSelf.backgroundMessagesService = ThreadsDetailService(parentVC: strongSelf)
                                            strongSelf.backgroundMessagesService?.saveInCoreDataWithBackendSaved(array: data)
                                        }
                                        strongSelf.totalNewMessagesCount = Int(service.totalNewMessagesCount)
                                    }
                                }
                            }
                        }
                    }
                    
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    func getMessagesAfterReply() {
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: self.threadId!) { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    print(data as Any)
                    if data.isEmpty == false {
                        strongSelf.backgroundMessagesService = ThreadsDetailService(parentVC: strongSelf)
                        strongSelf.backgroundMessagesService?.saveInCoreDataWithBackendSaved(array: data)
                        strongSelf.totalNewMessagesCount = Int(service.totalNewMessagesCount)

                    }
                    
                case .Error(let message):
                    print(message)
                }
            }
        }
    }
    
    func loadDataInTheBackground() {
        self.backgroundMessagesService = ThreadsDetailService(parentVC: self)
        self.backgroundFetchedResultController = self.messagesService?.getMessagesFromThread(_withThreadId: self.threadId!, withAscendingOrder: self.sortAscending)
        self.backgroundFetchedResultController.delegate = nil
        self.backgroundDataArray = self.backgroundFetchedResultController.fetchedObjects?.reversed()
        
        self.backgroundLinkIndexes = []
        self.loadTheWebViewsToFindHeightsInTheBackground()
        self.oldMessage = self.backgroundDataArray.last
    }
    
    func loadTheWebViewsToFindHeightsInTheBackground() {
        
        guard self.isScreenVisible == true else { return }
        self.shouldLoadMoreMessagesThreads = false
        self.webView.tag = 4
        if backgroundWebViewCount < (self.backgroundDataArray.count) {
            if self.backgroundDataArray.isEmpty == false {
                //MARK: - if message have sharing message id should load body
                if backgroundDataArray[backgroundWebViewCount].sharing_message_id != nil {
                    guard let body = self.backgroundDataArray[backgroundWebViewCount].body else {
                        return
                    }
                    webView.loadHTMLString(body, baseURL: nil)
                    return
                }

                let segmentedHtmlArray = self.backgroundDataArray![backgroundWebViewCount].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
                if ((segmentedHtmlArray?.count) != nil && (segmentedHtmlArray?.count)! > 0) {
                    let attributeValue = "forward";
                    let namePredicate = NSPredicate(format: "type like %@",attributeValue)
                    let filteredArray = segmentedHtmlArray?.filter { namePredicate.evaluate(with: $0) };
                    if filteredArray?.count != 0 {
                        self.backgroundForwardMessageIndex.append(backgroundWebViewCount)
                        self.loadTheForwardedMessage(withTag: 100+backgroundWebViewCount, localWebViewCount: backgroundWebViewCount)
                        return
                    }
                    for segmentedHtml in segmentedHtmlArray! {
                        self.findHeightInBackgroundOf(segmentedHtmlObject: segmentedHtml)
                    }
                } else {
                    self.findHeightOfWebViewInBackgroundOfHtmlObject()
                }
            }
        }
        
        if backgroundWebViewCount == self.backgroundDataArray.count {
            self.dataArray = self.backgroundDataArray
            let array = self.backgroundContentHeights.prefix(self.backgroundDataArray.count)
            self.backgroundMainContentHeights = Array(array)
            let array2 = self.backgroundWebViewContentHeights.prefix(self.backgroundDataArray.count)
            self.backgroundMainWebViewContentHeights = Array(array2)
            self.mainContentHeights = self.backgroundMainContentHeights
            self.mainWebViewContentHeights = self.backgroundMainWebViewContentHeights
            self.backgroundWebViewCount = 0
            self.webViewCount = 0
            self.isLoading = true
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.scrollToLastMessage()
            }
            self.isLoading = false
            self.shouldLoadMoreMessagesThreads = true
            let when = DispatchTime.now() + 0.35
            DispatchQueue.main.asyncAfter(deadline: when){
                self.tableView?.isHidden = false
            }
        }
    }
    
    func loadTheForwardedMessageinBackground(withTag tagValue:Int, localWebViewCount:Int) {
        
        let segmentedHtmlArray = self.backgroundDataArray![localWebViewCount].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
        let attributeValue = "forward";
        let namePredicate = NSPredicate(format: "type like %@",attributeValue)
        let filteredArray = segmentedHtmlArray?.filter { namePredicate.evaluate(with: $0) };
        
        if filteredArray?.count != 0 {
            let segmentedHtml = filteredArray?.first
            if segmentedHtml?.order == 2 && (segmentedHtml?.type?.isEqualToString(find: "forward"))! {
                self.forwardedMessagesDictionary.updateValue( 75, forKey: localWebViewCount)
            }
        }
        let attributeValueTopMessage = "top_message";
        let namePredicateTopMessage = NSPredicate(format: "type like %@",attributeValueTopMessage)
        let filteredArrayTopMessage = segmentedHtmlArray?.filter { namePredicateTopMessage.evaluate(with: $0) }
        if filteredArrayTopMessage?.count != 0 {
            if let segmentedHtml = filteredArrayTopMessage?.first {
                self.findHeightInBackgroundOf(segmentedHtmlObject: segmentedHtml)
            }
        }
    }
    
    func findHeightInBackgroundOf(segmentedHtmlObject segmentedHtml:Messages_Segmented_Html) {
        if segmentedHtml.order == 1 && segmentedHtml.type == "top_message" {
            if segmentedHtml.html_markdown != nil {
                let down = Down(markdownString: segmentedHtml.html_markdown!)
                // Convert to HTML
                if let html = try? down.toHTML(.HardBreaks) {
                    let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(htmlString , baseURL: nil)
                    }
                    let input = htmlString
                    let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                        for match in matches {
                            guard let range = Range(match.range, in: input) else { continue }
                            let url = input[range]
                            if url.count > 0 {
                                self.backgroundLinkIndexes.append(backgroundWebViewCount)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                    }
                }
            } else if segmentedHtml.html != nil {
                let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + segmentedHtml.html! + "</span>"
                DispatchQueue.main.async {
                    self.webView.loadHTMLString(htmlString, baseURL: nil)
                }
                let input = htmlString
                let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                    for match in matches {
                        guard let range = Range(match.range, in: input) else { continue }
                        let url = input[range]
                        if url.count > 0 {
                            self.backgroundLinkIndexes.append(backgroundWebViewCount)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.webView.loadHTMLString("<p> <p>", baseURL: nil)
                }
            }
        }
    }
    
    func findHeightOfWebViewInBackgroundOfHtmlObject() {
        var html = self.backgroundDataArray![backgroundWebViewCount].body!
        let string = html
        if let range = string.range(of: "<blockquote") {
            let firstPart = string[string.startIndex..<range.lowerBound]
            html = firstPart + "</html>"
        }
        if !html.isEmpty {
            let htmlString = "<span style=\"font-family:Lato; font-size: 15; line-height: 20px;  color:#373737\">" + "<style>img{height:auto!important;max-width:100%!important;}</style>" + html + "</span>"
            DispatchQueue.main.async {
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }
            let input = htmlString
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                for match in matches {
                    guard let range = Range(match.range, in: input) else { continue }
                    let url = input[range]
                    if url.count > 0 {
                        self.backgroundLinkIndexes.append(backgroundWebViewCount)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.webView.loadHTMLString("<p> <p>", baseURL: nil)
            }
        }
    }
    
    func showUnreadMessagesBox() -> Void {
        self.unreadBox = UIImageView()
        self.unreadBox.frame = CGRect(x: 0, y: 66, width: self.view.frame.size.width, height: 44)
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    //we are running on iPhone X
                    self.unreadBox.frame.origin.y = self.unreadBox.frame.origin.y + 30
                }
            }
        }
        self.unreadBox.image = #imageLiteral(resourceName: "unread_box")
        self.unreadBox.isUserInteractionEnabled = true
        self.navigationController?.view.addSubview(self.unreadBox)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        label.textColor = .white
        label.text = "\(self.totalUnreadMessagesCount)" + " new messages"
        label.font = UIFont.fontWith(style: "Lato-Regular", size: FontSize(rawValue: 14)!)
        label.textAlignment = .center
        self.unreadBox.addSubview(label)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        button.addTarget(self, action: #selector(ThreadsDetailViewController.hideUnreadMessagesBlueBox), for: .touchUpInside )
        button.backgroundColor = .clear
        self.unreadBox.addSubview(button)
    }
    
    @objc func hideUnreadMessagesBlueBox() -> Void {
        self.unreadBox.removeFromSuperview()
        if self.dataArray.isEmpty == false {
            for message in self.dataArray {
                if let message_id = message.id, let unreadMessageid = self.unreadMessageId {
                    if message_id.isEqualToString(find: unreadMessageid) {
                        if let index = self.dataArray.index(of: message) {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                        return
                    }
                }
            }
            
            if dataArray.count > 0 {
                if ((self.dataArray.count) < self.totalNewMessagesCount) && self.shouldLoadMoreMessagesThreads {
                    let skip = self.dataArray.count
                    self.shouldLoadMoreMessagesThreads = false
                    if self.tableView != nil {
                        self.addSpinner(to: self.tableView!)
                    }
                    self.loadMoreMessagesFromBackend(with: skip)
                }
            }
        }
    }
    
    func addSpinner(to tableView: UITableView) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableHeaderView = spinner
        tableView.tableHeaderView?.isHidden = false
    }
    
    @objc func starButtonPressed() {
        print("star button pressed")
        AudioServicesPlaySystemSound(1519)
        // instantaneously make the image view small (scaled to 1% of its actual size)
        self.starButton.transform = CGAffineTransform(scaleX: 1.75, y: 1.75);
        _ = [UIView .animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.starButton.transform = CGAffineTransform.identity;
        }, completion: { (finished) in
            if !self.starred! {
                self.starred = true
                self.starButton.setImage(#imageLiteral(resourceName: "star_icon"), for: .normal)
                self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_starred"), for: .normal)
                self.alertButtonLabel.text = ""
            } else {
                self.starred = false
                self.starButton.setImage(#imageLiteral(resourceName: "icon_starred_gray"), for: .normal)
                self.alertButton.setBackgroundImage( #imageLiteral(resourceName: "alert_button_unstarred"), for: .normal)
                self.alertButtonLabel.text = ""
            }
            self.controllerDelegate?.controller(self, starred: self.starred!)
            self.alertButton.addTarget(self, action: #selector(ThreadsDetailViewController.undoStarredUnstarredAction), for: .touchUpInside)
            self.alertButton.isHidden = false
            self.alertButtonLabel.isHidden = false
            
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
            })
        })];
    }
    
    @objc func clearButtonPressed() {
        AudioServicesPlaySystemSound(1519)
        if let unread = self.unread, let inbox = self.inbox, inbox {
            if inbox == false || (inbox == true && unread == false) {
                self.starButton.setImage(#imageLiteral(resourceName: "clear-circle"), for: .normal)
            } else {
                self.starButton.setImage(#imageLiteral(resourceName: "clear-circle-checked"), for: .normal)
            }
        }
        // instantaneously make the image view small (scaled to 1% of its actual size)
        self.starButton.transform = CGAffineTransform(scaleX: 1.75, y: 1.75);
        _ = [UIView .animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.starButton.transform = CGAffineTransform.identity;
        }, completion: { (finished) in
            if let unread = self.unread, let inbox = self.inbox {
                if inbox == false || (inbox == true && unread == false) {
                    self.unread = true
                    self.seen = true
                    self.inbox = true
                    self.starButton.setImage(#imageLiteral(resourceName: "clear-circle"), for: .normal)
                    self.markThreadAsSeen()
                } else {
                    self.unread = false
                    self.seen = false
                    self.inbox = true
                    self.starButton.setImage(#imageLiteral(resourceName: "clear-circle-checked"), for: .normal)
                    self.markThreadAsCleared()
                }
            }
            self.isStarredValueChanged = true
            if let controllerDelegate = self.controllerDelegate, let unread = self.unread, let seen = self.seen, let inbox = self.inbox, let isStarredValueChanged = self.isStarredValueChanged, let thread = self.threadToRead {
                controllerDelegate.actionInDetailViewController(self, unread: unread, seen: seen, inbox: inbox, starredValueChanged: isStarredValueChanged, thread: thread)
            }
            if let inbox = self.inbox, let unread = self.unread {
                if !inbox || (inbox && !unread) {
                    self.goBack()
                }
            }
        })];
    }
    
    func markThreadAsSeen() {
        guard let threadObject = self.threadToRead else {
            return
        }
        guard let threadId = self.threadToRead?.id else {
            return
        }
        guard let accountId = self.threadToRead?.account_id else {
            return
        }
        
        let convosService = ThreadsDetailService(parentVC: self)
        convosService.update(currentThread: threadObject, unread: true, seen: true, inbox: true)
        
        let backendService = ConvosAPIBridge()
        backendService.markThreadAsSeen(threadId: threadId, accountId: accountId, thread: threadObject) { (result) in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func markThreadAsCleared() {
        guard let threadObject = self.threadToRead else {
            return
        }
        guard let threadId = self.threadToRead?.id else {
            return
        }
        guard let accountId = self.threadToRead?.account_id else {
            return
        }
        
        let convosService = ThreadsDetailService(parentVC: self)
        convosService.update(currentThread: threadObject, unread: false, seen: false, inbox: true)

        let backendService = ConvosAPIBridge()
        backendService.markThreadAsCleared(threadId: threadId, accountId: accountId, thread: threadObject) { (result) in
            switch result {
            case .Success(let data):
                print(data)
                self.goBack()
            case .Error(let message):
                print(message)
                let convosService = ThreadsDetailService(parentVC: self)
                convosService.update(currentThread: threadObject, withNewStarredValue: true, withNewUnreadValue: false)
            }
        }
    }
    
    func changeCategoryOfMessage(){
     
        guard let threadId = self.threadToRead?.id else {
            return
        }
        guard let category = self.categoryName else {
            return
        }

        let backendService = ConvosAPIBridge()
        backendService.changeCategoryForSpam(threadId: threadId, category: category) { (result) in
            switch result {
            case .Success(let data):
                let convosService = ThreadsDetailService(parentVC: self)
                convosService.saveInCoreDataWithUpdatedCategory(dictionary: data as [String : AnyObject])
                self.goBack()
            case .Error(let message):
                print(message)
            }
        }
    }
    
    func  startLoader() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let frame = CGRect(x: 0, y: 0, width: w, height: h)
        self.customLoader = CustomLoader(frame: frame)
        self.view.addSubview(self.customLoader)
    }
    
    func stopLoader() {
        self.customLoader.removeFromSuperview()
    }

    func closeOpenedCell(indexPath: IndexPath) {
        let action = ThreadDetailViewActions(parentVC: self)
        action.closeOpenedCell(indexPath: indexPath)
    }
        
}
