//
//  ThreadsDetailViewController.swift
//  June
//
//  Created by Joshua Cleetus on 9/5/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import QuartzCore
import NVActivityIndicatorView
import AlertBar
import Feathers
import FeathersSwiftSocketIO
import SocketIO
import SwiftyJSON
import CoreData
import MarqueeLabel
import AudioToolbox
import Down
import Instabug

struct CustomThreadsDetailViewSwipeAction: ThreadsDetailViewTableViewCellSwipeAction {
    var title: String
    var color: UIColor
}

protocol ThreadsDetailViewControllerDelegate: class {
    func controller(_ controller: ThreadsDetailViewController, starred isStarred: Bool)
    func actionInDetailViewController(_ controller: ThreadsDetailViewController, unread: Bool, seen: Bool, inbox: Bool, starredValueChanged: Bool, thread: Threads)
    func recategorizeValue(_controller: ThreadsDetailViewController, category: String)
}

class ThreadsDetailViewController: UIViewController, ThreadsDetailViewTableViewCellDelegate, UIWebViewDelegate, UIScrollViewDelegate, NVActivityIndicatorViewable {

    private let screenWidth: CGFloat = UIScreen.main.bounds.width

    var window: UIWindow?
    private var avatarImageView: UIImageView!
    var avatar: UIImage?
    var avatarURL: URL?
    private var nameLabel: UILabel!
    var nameString: String?
    let htmlTemplate = "<div dir=\"ltr\">#placeholder#</div><br>"
    let placeholderString = "#placeholder#"
    var tableView: UITableView?
    var threadId: String?
    var threadAccountId: String?
    weak var threadToRead: Threads?
    var fromTableViewTag: Int?
    weak var threadsService: ThreadsDetailService?
    var subjectTitle: String?
    var titleLabel: UILabel!
    var unread: Bool?
    var seen: Bool?
    var inbox: Bool?
    var starred: Bool?
    var isStarredValueChanged: Bool?
    var pendingRequestWorkItem: DispatchWorkItem?
    var blocker: UIImageView!
    var starButton: UIButton!
    var moreOptionBtn: UIButton!
    var alertButton: UIButton!
    var alertButtonLabel = UILabel()
    let webView = UIWebView()
    let webView2 = UIWebView()
    var webViewCount = 0
    var webViewCount2 = 0
    var webViewCount3 = 0
    var backgroundWebViewCount = 0
    var dataSource: ThreadsDetailViewDataSource?
    var delegate: ThreadsDetailViewDelegate?
    var fetchedResultController: NSFetchedResultsController<Messages>!
    var fetchedResultController2: NSFetchedResultsController<Messages>!
    var fetchedResultController3: NSFetchedResultsController<Messages>!
    var backgroundFetchedResultController: NSFetchedResultsController<Messages>!
    var dataArray:[Messages] = []
    var dataArray2:[Messages] = []
    var backgroundDataArray:[Messages]!
    var mainContentHeights : [CGFloat]!
    var mainWebViewContentHeights : [CGFloat]!
    var backgroundMainContentHeights : [CGFloat]!
    var backgroundMainWebViewContentHeights : [CGFloat]!
    var contentHeights : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var contentHeights2 : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var contentHeights3 : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var backgroundContentHeights : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var webViewContentHeights : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var webViewContentHeights2 : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var webViewContentHeights3 : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var backgroundWebViewContentHeights : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var contentHeightsCollapsibleCells : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var contentHeightsExpandableCells : [CGFloat] = [CGFloat](repeating: 0, count: 10000)
    var forwardMessageIndex: [Int] = [Int](repeating: 0, count: 10000)
    var forwardMessageIndex2: [Int] = [Int](repeating: 0, count: 10000)
    var forwardMessageIndex3: [Int] = [Int](repeating: 0, count: 10000)
    var backgroundForwardMessageIndex: [Int] = [Int](repeating: 0, count: 10000)
    var forwardedMessagesDictionary: [Int:CGFloat] = [:]
    var forwardedMessagesDictionary2: [Int:CGFloat] = [:]
    var backgroundForwardedMessagesDictionary: [Int:CGFloat] = [:]
    var messagesService: ThreadsDetailService?
    var backgroundMessagesService: ThreadsDetailService?
    var sortAscending = false
    var fromReplier: Bool = false
    var verticalScrollView: UIScrollView!
    var totalNewMessagesCount = 0
    var isLoading = false
    var isLoading2 = false
    var oldMessage: Messages?
    var newMessage: Messages?
    var skip: Int = 0
    var movedToBottom: Bool = false
    var shouldLoadMoreMessagesThreads: Bool = true
    var selectedIndices: [IndexPath] = [IndexPath]()
    var unreadMessageIndex:Int?
    var unreadMessageId: String?
    var totalUnreadMessagesCount: Int = 0
    var unreadBox: UIImageView!
    weak var controllerDelegate: ThreadsDetailViewControllerDelegate?
    weak var threadCell: ThreadsTableViewCell?
    private var responderAPIEngine = ResponderAPIEngine()
    weak var config: ResponderConfig?
    var isFromSearch: Bool = false
    var receivers: [EmailReceiver] = []
    var replierSuccess:Bool?
    var tempDict = [String:Any]()
    var unWrappedMessages : Messages?
    var unWrappedText : String = ""
    var attachments : [Attachment] = []
    var errorAppeared : Bool = false
    var linkIndexes: [Int] = [Int]()
    var linkIndexes2: [Int] = [Int]()
    var backgroundLinkIndexes: [Int] = [Int]()
    var inititalTableViewFrame: CGRect = .zero
    var cellVisible:Bool?
    var allCells = [ThreadsDetailViewTableViewCell]()
    var fullyVisibleCells = [ThreadsDetailViewTableViewCell]()
    var lineContainingCell:ThreadsDetailViewTableViewCell?

    var previousResponderFrame: CGRect?
    var movedToBtn: UIButton!
    var categoryName: String?
    var loaderView: NVActivityIndicatorView?
    var loaderBgView: UIImageView?
    var customLoader: CustomLoader = CustomLoader()
    
    var isScreenVisible: Bool = true
    var fromSwipedRight: Bool = false

    lazy var shareViewPresenter: ShareViewPresenter = { [unowned self] in
        let presenter = ShareViewPresenter(with: self)
        presenter.onHidePopupAction = onHideSharePopup
        return presenter
    }()
    
    lazy var onHideSharePopup: () -> Void = { [weak self] in

    }
    
    lazy var onResponderShown: (CGFloat) -> Void = { [weak self] height in
        if let strongSelf = self {
            let minimumTableViewHeight = 0.128 * UIScreen.main.bounds.width
            strongSelf.tableView?.frame = strongSelf.inititalTableViewFrame
            if let tableViewHeight = strongSelf.tableView?.frame.size.height {
                strongSelf.tableView?.frame.size.height -= height
                if tableViewHeight < minimumTableViewHeight {
                    strongSelf.tableView?.frame.size.height = minimumTableViewHeight
                }
            }
            strongSelf.scrollToLastMessage()
        }
    }
    
    lazy var onRespnderMinimized: (CGFloat) -> Void = { [weak self] height in

    }
    
    lazy private var attachmentsHandler: AttachmentHandler = { [unowned self] in
        let handler = AttachmentHandler(with: self)
        return handler
    }()
    
    lazy var onAttachmentClick: (Attachment) -> Void = { [weak self] attachment in
       self?.attachmentsHandler.present(attachment)
    }
    
    lazy var loader: Loader = { [unowned self] in
        let loader = Loader(with: self)
        return loader
    }()
    
    var newResponder: IResponder?
    
    //MARK: - on webViewClicked
    lazy var onWebViewClicked: () -> Void = {

    }
    
    func replyButtonPressedActionView(indexPath: IndexPath) {
        self.fromSwipedRight = true
        self.closeOpenedCell(indexPath: indexPath)
        guard newResponder != nil else { return }
        let unwrappedMessage = self.dataArray[indexPath.row]
        if let unwrappedThread = threadToRead {
            let config = ResponderConfig(with: unwrappedThread, message: unwrappedMessage, minimized: true)
            config.goal = .reply
            newResponder?.update(with: config)
            newResponder?.metadata.state = .regular
        }
        self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
    func replyAllButtonPressedActionView(indexPath: IndexPath) {
        self.fromSwipedRight = true
        self.closeOpenedCell(indexPath: indexPath)
        guard newResponder != nil else { return }
        let unwrappedMessage = self.dataArray[indexPath.row]
        if let unwrappedThread = threadToRead {
            let config = ResponderConfig(with: unwrappedThread, message: unwrappedMessage, minimized: true)
            config.goal = .replyAll
            newResponder?.update(with: config)
            newResponder?.metadata.state = .regular
        }
        self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
    func forwardButtonPressedActionView(indexPath: IndexPath) {
        self.fromSwipedRight = true
        self.closeOpenedCell(indexPath: indexPath)
        let message = dataArray[indexPath.row]
        shareViewPresenter.show(message: message)
        self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
    func reportButtonPressedActionView(indexPath: IndexPath) {
        let thread : Messages = self.fetchedResultController.object(at: indexPath)
        FeathersManager.Services.suggestions.request(.create(data: [
            "report": "Message not parsed correctly",
            "message_id": thread.id!,
            "account_id": thread.account_id!
            ], query: nil))
            .on(value: { response in
                print(response)
            })
            .startWithFailed { (error) in
                print(error)
        }
        self.alertButton.setBackgroundImage(#imageLiteral(resourceName: "alert_button"), for: .normal)
        self.alertButtonLabel.text = "Thanks for reporting!"
        self.alertButton.removeTarget(nil, action: nil, for: .allEvents)
        self.alertButton.isHidden = false
        self.alertButtonLabel.isHidden = false

        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
            self.alertButton.isHidden = true
            self.alertButtonLabel.isHidden = true
        })
    }
    
    func fullEmailButtonPressedActionView(indexPath: IndexPath) {
        let fullEmailVC = FullEmailViewController()
        let thread : Messages = self.dataArray[indexPath.row]
        fullEmailVC.emailThread = thread
        self.navigationController?.pushViewController(fullEmailVC, animated: true)
    }
    
    func viewAllButtonPressedActionView(indexPath: IndexPath) {
        let cell = self.tableView?.cellForRow(at: indexPath) as? ThreadsDetailViewTableViewCell
        cell?.viewHideButton.isEnabled = true
        if !self.selectedIndices.contains(indexPath) {
            cell?.viewAll = true
            cell?.viewOrHideMessageTitle.text = "HIDE MESSAGE"
            self.selectedIndices.append(indexPath)
        } else {
            cell?.viewAll = false
            cell?.viewOrHideMessageTitle.text = "VIEW MESSAGE"
            self.selectedIndices.remove(at: (self.selectedIndices.index(of: indexPath))!)
        }

        var indexPathArray:Array = [indexPath]
        let beforeIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        indexPathArray.append(beforeIndexPath)
        if indexPath.row != (self.fetchedResultController.fetchedObjects?.count)! - 1 {
            let afterIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            indexPathArray.append(afterIndexPath)
        }
        DispatchQueue.main.async {
            self.tableView?.reloadRows(at: indexPathArray, with: UITableViewRowAnimation.none)
        }
    }
    
    func undoButtonPressedAction(indexPath: IndexPath) {
        print("undo button pressed")
        self.pendingRequestWorkItem?.cancel()
        self.deleteTempIdCell()
    }
    
    func markFromReplierAsFalse(indexPath: IndexPath) {
        self.fromReplier = false
        self.replierSuccess = nil
    }
    
    func showActionSheet(indexPath: IndexPath) {
        
        self.newResponder?.show()
        
        // Create the AlertController
        let actionSheetController = UIAlertController(title: "Unable to send your message", message: "", preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            // Just dismiss the action sheet
            self.newResponder?.show()
        }
        actionSheetController.addAction(cancelAction)
        
        // Create and add first option action
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { action -> Void in
            print("try again")
            self.fromReplier = false
            self.replierSuccess = nil
            self.tryAgainToSendMessage()
        }
        actionSheetController.addAction(tryAgainAction)
        
        // Create and add a second option action
        let deleteMessageAction = UIAlertAction(title: "Delete Message", style: .default) { action -> Void in
            print("delete message")
            self.fromReplier = false
            self.replierSuccess = nil
            self.deleteTempIdCell()
        }
        actionSheetController.addAction(deleteMessageAction)

        // Present the AlertController
        self.view.sendSubview(toBack: (self.newResponder?.rootViewController.view)!)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func markErrorAppearedAsTrue() {
        self.errorAppeared = true
    }
    
    func tryAgainToSendMessage() {
        
        self.errorAppeared = false
        
        self.messagesService = ThreadsDetailService(parentVC: self)
        self.messagesService?.saveInCoreDataWith(array: [self.tempDict as Dictionary<String, AnyObject>])
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { //[weak self] in
            if InternetReachability.isConnectedToNetwork() {
                self.responderAPIEngine.respond(to: self.unWrappedMessages!, with: self.unWrappedText, to: self.receivers, with: self.attachments, completion: self.onSendCompletedAction)
            } else {
                self.replierSuccess = false
                self.fromReplier = true
                self.messagesService = ThreadsDetailService(parentVC: self)
                self.messagesService?.saveInCoreDataWith(array: [self.tempDict as Dictionary<String, AnyObject>])
                AlertBar.show(.error, message: "Network Error. Please try again!")
            }
        }
        // Save the new work item and execute it after 250 ms
        self.pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5,
                                      execute: requestWorkItem)
        
    }
    
    func deleteTempIdCell() {
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        request.predicate = NSPredicate(format: "messages_id = %@", "tempId")
        do {
            let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            
            print(result as Any)
            if result.count > 0 {
                print(result as Any)
                self.deleteThread(threadToDelete: result.first!)
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
    }
    
    func deleteThread(threadToDelete thread: Messages) {
        CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(thread)
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
            self.dataArray.remove(at: self.dataArray.count - 1)
            self.tableView?.reloadData()
        }
        catch let error as NSError {
            print("Delete item failed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupView()
        self.getIndexOfUnreadMessagesBeginning()
        self.checkDataStore()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        addBackButton()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView?.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        self.tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    var isFromSpam = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if newResponder != nil {
            newResponder?.show()
        }
        Instabug.logUserEvent(withName: "Thread Detail View", params: ["thread_id" : self.threadId ?? "threadId"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isScreenVisible = true
        self.deleteTempIdCell2(data: nil, body: nil)
        if self.tableView != nil {
            self.tableView?.isHidden = false
        }
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let dimension: CGFloat = 0.085 * screenWidth
        avatarImageView = UIImageView(frame: CGRect(x: 54, y: (self.navigationController?.navigationBar.frame.size.height)! / 2 - dimension / 2, width: dimension, height: dimension))
        avatarImageView?.contentMode = .scaleAspectFit
        avatarImageView?.layer.cornerRadius = dimension / 2
        avatarImageView?.clipsToBounds = true
        self.navigationController?.navigationBar.addSubview(self.avatarImageView)
        if let avatar_pic_url = avatarURL {
            self.avatarImageView?.hnk_setImageFromURL(avatar_pic_url)
        }
        
        nameLabel = UILabel(frame: CGRect(x: (0.109 * screenWidth) + 54, y: (0.025 * screenWidth) + 2, width: (self.navigationController?.navigationBar.frame.size.width)! - 0.109 * screenWidth, height: 0.057 * screenWidth))
        nameLabel?.font = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
        nameLabel?.textColor = UIColor.spoolNameHeaderColor
        nameLabel?.textAlignment = .left
        if let name = self.nameString {
            nameLabel?.text = name
        }
        self.navigationController?.navigationBar.addSubview(self.nameLabel)

        starButton = UIButton(type: .custom)
        starButton.setImage(#imageLiteral(resourceName: "spool-detail-view-clear-icon-grey"), for: .normal)
        starButton.frame = CGRect(x: 338.21, y: 10, width: 23, height: 23)
        if UIScreen.isPhoneX {
            starButton.frame = CGRect(x: 338.21, y: 10, width: 23, height: 23)
        } else
        if UIScreen.is6PlusOr6SPlus() {
            starButton.frame = CGRect(x: 380, y: 10, width: 23, height: 23)
        }
        
        moreOptionBtn = UIButton(type: .custom)
        moreOptionBtn.setImage(#imageLiteral(resourceName: "rolodex-filter"), for: .normal)
        moreOptionBtn.frame = CGRect(x: 300, y: 15, width: 21, height: 15)
        
        self.navigationController?.navigationBar.addSubview(self.moreOptionBtn)
        self.navigationController?.navigationBar.addSubview(self.starButton)
        
        titleLabel = UILabel.init(frame: CGRect(x: 50, y: 15, width: 260, height: 19))
        if UIScreen.isPhoneX {
            titleLabel.frame = CGRect.init(x: 50, y: 15, width: 260, height: 19)
        } else
        if UIScreen.is6PlusOr6SPlus() {
            titleLabel.frame = CGRect.init(x: 50, y: 15, width: 300, height: 19)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
        titleLabel.textColor = UIColor.init(hexString:"2B3348")
        titleLabel.backgroundColor = .clear
        self.navigationController?.navigationBar.addSubview(titleLabel)
        if subjectTitle != nil {
            titleLabel.text = subjectTitle
        }
        if let unread = self.unread, let seen = self.seen, let inbox = self.inbox, unread == true, seen == false, inbox == true {
            self.unread = true
            self.seen = true
            self.isStarredValueChanged = true
            if let controllerDelegate = self.controllerDelegate, let isStarredValueChanged = self.isStarredValueChanged, let thread = self.threadToRead {
                controllerDelegate.actionInDetailViewController(self, unread: true, seen: true, inbox: true, starredValueChanged: isStarredValueChanged, thread: thread)
            }
        }
        if (self.unreadBox != nil) {
            self.unreadBox.isHidden = false
        }
        movedToBtn = UIButton(type: .custom)
        movedToBtn.setImage(#imageLiteral(resourceName: "move_to"), for: .normal)
        movedToBtn.isHidden = true
        movedToBtn.addTarget(self, action: #selector(moveToButtonPressed), for: .touchUpInside)
        movedToBtn.frame = CGRect(x: 283, y: 13, width: 77, height: 17)
        if UIScreen.isPhoneX {
            movedToBtn.frame = CGRect(x: 283, y: 13, width: 77, height: 17)
        } else if UIScreen.is6PlusOr6SPlus() {
            movedToBtn.frame = CGRect(x: 323, y: 13, width: 77, height: 17)
        }
        self.navigationController?.navigationBar.addSubview(self.movedToBtn)
        
        if isFromSpam == true {
            movedToBtn.isHidden = false
            self.titleLabel.removeFromSuperview()
            self.moreOptionBtn.removeFromSuperview()
            self.starButton.removeFromSuperview()
        }
        
    }
    
    func addTitleAndImage() -> Void {
        
    }
    
    lazy var uiInitializerForActionSheet: MoveToActionSheet = {
        let initializer = MoveToActionSheet(with: self)
        return initializer
    }()
    
    @objc func moveToButtonPressed() {
        uiInitializerForActionSheet.setupSubviews()
    }
    
    func addBackButton() {
        let buttonWidth = UIScreen.main.bounds.width*0.121
        let buttonHeight = buttonWidth
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        let btnLeftMenu = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back_indicator"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(onClickBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = buttonFrame
        btnLeftMenu.contentHorizontalAlignment = .left
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func onClickBack() {
        if self.errorAppeared {
            // create the alert
            let alert = UIAlertController(title: "", message: "Are you sure you want to leave? Your message did not send.", preferredStyle: UIAlertControllerStyle.alert)

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Leave", style: UIAlertActionStyle.default, handler: { action in
                self.goBack()
            } ))
            alert.addAction(UIAlertAction(title: "Stay", style: UIAlertActionStyle.cancel, handler: { action in
                self.stayHere()
            }))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }

        self.titleLabel.isHidden = true
        self.moreOptionBtn.isHidden = true
        self.movedToBtn.isHidden = true
        self.deleteTempIdCell2(data: nil, body: nil)
        self.starButton.isHidden = true
        self.navigationController?.hidesBarsOnSwipe = false
        self.fetchedResultController = nil
        self.fetchedResultController2 = nil
        if self.unreadBox != nil {
            self.removeUnreadBox()
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func stayHere() {
        // do things staying on the view controller
    }
    
    func removeUnreadBox() {
        if let viewsArray = self.navigationController?.view.subviews {
            if self.unreadBox != nil && viewsArray.contains(self.unreadBox) {
                self.unreadBox.removeFromSuperview()
            }
        }
    }
    
    func goBack() {
        self.titleLabel.isHidden = true
        self.moreOptionBtn.isHidden = true
        self.starButton.isHidden = true
        self.movedToBtn.isHidden = true
        self.avatarImageView.isHidden = true
        self.nameLabel.isHidden = true
        self.navigationController?.hidesBarsOnSwipe = false
        self.fetchedResultController = nil
        self.fetchedResultController2 = nil
        if self.unreadBox != nil {
            self.removeUnreadBox()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isScreenVisible = false
        if self.isMovingFromParentViewController {
            self.titleLabel.isHidden = true
            self.moreOptionBtn.isHidden = true
            self.movedToBtn.isHidden = true
            self.starButton.isHidden = true
            self.fetchedResultController = nil
            self.fetchedResultController2 = nil
            self.errorAppeared = false
        }
        self.deleteTempIdCell2(data: nil, body: nil)
        if (self.unreadBox != nil) {
            self.unreadBox.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.titleLabel.removeFromSuperview()
        self.moreOptionBtn.removeFromSuperview()
        self.starButton.removeFromSuperview()
        self.avatarImageView?.removeFromSuperview()
        self.nameLabel?.removeFromSuperview()
        self.tableView?.isHidden = true
        self.movedToBtn.removeFromSuperview()
        if self.isMovingFromParentViewController {
            newResponder?.hide()
        }
    }
    
    func swipeCellIfNeeded() {
        if starred! {
            threadCell?.swipeLeftAnimation(completion: nil)
        } else {
            threadCell?.swipeRightAnimation(completion: nil)
        }
    }
    
    // MARK: - Recategorization logic
    
    var categories: [FeedCategory] = [FeedCategory]()
    
    private lazy var recategorizeHandler: RecategorizeHandler = { [unowned self] in
        let handler = RecategorizeHandler(rootVC: self, categories: self.categories)
        return handler
    }()
        
    private lazy var onRecategorize: () -> Void = { [weak self] in
        if let unwrappedThread = self?.threadToRead {
            self?.recategorizeHandler.recategorize(unwrappedThread)
        }
    }
    
    @objc func moreOptionButtonPressed() {
        self.uiInitializerForActionSheet.setupSubviews()
    }
    
    private var resignTap: UIGestureRecognizer?
    
    private func addResignTap() {
        guard resignTap == nil else { return }
        guard newResponder?.metadata.state != .minimized else { return }
        
        resignTap = UITapGestureRecognizer(target: self, action: #selector(handleHideResponderOnTap(_:)))
        resignTap?.delegate = self
        if resignTap != nil {
            tableView?.addGestureRecognizer(resignTap!)
        }
    }
    
    private func removeResignTap() {
        guard resignTap != nil else { return }
        tableView?.removeGestureRecognizer(resignTap!)
        resignTap = nil
    }
    
    private func initialTableViewHeight() -> CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navigationControllerHeigh: CGFloat = 0
        if let navControllerHeigh = navigationController?.navigationBar.frame.height {
            navigationControllerHeigh = navControllerHeigh
        }
        var heightOffset: CGFloat = navigationControllerHeigh + statusBarHeight
        
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    //we are running on iPhone X
                    heightOffset += (((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!)
                }
            }
        }
        return self.view.frame.height - heightOffset
    }
    
    private func bottomSafeAreaInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            if let insets = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets {
                if insets.top > 0 {
                    //we are running on iPhone X
                    return (((UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom)!)
                }
            }
        }
        return 0.0
    }
    
    func setupView() {
        dataSource = ThreadsDetailViewDataSource(parentVC: self)
        delegate = ThreadsDetailViewDelegate(parentVC: self)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navigationControllerHeigh: CGFloat = 0
        if let navControllerHeigh = navigationController?.navigationBar.frame.height {
            navigationControllerHeigh = navControllerHeigh
        }
        let tableViewHeight = initialTableViewHeight()
        //MARK: - use only if open VC from search
        var originY: CGFloat = 0
        if isFromSearch {
            originY = navigationControllerHeigh + statusBarHeight
        }
        inititalTableViewFrame = CGRect(x: 0, y: originY, width: self.view.frame.width, height: tableViewHeight)
        tableView = UITableView(frame: inititalTableViewFrame)
        tableView?.delegate = delegate
        tableView?.dataSource = dataSource
        tableView?.separatorInset = .zero
        tableView?.layoutMargins = .zero
        tableView?.scrollsToTop = true
        tableView?.tag = 10
        tableView?.backgroundColor = .white
        if let tableView = self.tableView {
            self.view.addSubview(tableView)
            self.view.bringSubview(toFront: tableView)
        }
        tableView?.register(ThreadsDetailViewTableViewCell.self, forCellReuseIdentifier: ThreadsDetailViewTableViewCell.reuseIdentifier())
        tableView?.allowsSelection = true
        tableView?.allowsSelectionDuringEditing = true
        tableView?.separatorStyle = .none
        tableView?.isHidden = true

        alertButton = UIButton(type: .custom)
        alertButton.frame = CGRect(x: 94, y: 500, width: 185, height: 46)
        alertButton.titleLabel?.textColor = .black
        alertButton.titleLabel?.font = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
        self.view.addSubview(alertButton)
        self.alertButton.isHidden = true

        alertButtonLabel = UILabel.init(frame: CGRect(x: 94, y: 497, width: 185, height: 46))
        alertButtonLabel.textAlignment = .left
        alertButtonLabel.font = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid) 
        alertButtonLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertButtonLabel.backgroundColor = .clear
        alertButtonLabel.textAlignment = .center
        self.view.addSubview(alertButtonLabel)
        alertButtonLabel.isHidden = true
        
        self.webView.frame = CGRect(x: 48 - 8, y: 5, width: (0.85 * self.view.frame.size.width) + 8, height: 1)
        self.webView.backgroundColor = .clear
        self.webView.isOpaque = false
        self.webView.isHidden = true
        self.webView.delegate = self
        self.webView.scrollView.isScrollEnabled = false
        self.view.addSubview(self.webView)
        
        self.webView2.frame = CGRect(x: 48 - 8, y: 5, width: (0.85 * self.view.frame.size.width) + 8, height: 1)
        self.webView2.backgroundColor = .clear
        self.webView2.isOpaque = false
        self.webView2.isHidden = true
        self.webView2.delegate = self
        self.webView2.scrollView.isScrollEnabled = false
        self.view.addSubview(self.webView2)
    }
    
    lazy var onSendButtonPressed: (Messages, String, [EmailReceiver], [Attachment]) -> Void = { unwrappedMessage, unwrappedText, unwrappedReceivers, attachments in
        
        self.unWrappedMessages = unwrappedMessage
        self.receivers = unwrappedReceivers
        self.unWrappedText = unwrappedText
        self.attachments = attachments
        self.fromReplier = false
        
        var fromDict = [String: String]()

        if let userObjectdata = KeyChainManager.load(key: JuneConstants.KeychainKey.userObject) {
            let userObject = KeyChainManager.NSDATAtoDictionary(data: userObjectdata)
            if let name = userObject["name"] {
                fromDict["name"] = name as? String
            }
            if let email = userObject["primary_email"] {
                fromDict["email"] = email as? String
            }
            if let profile_pic = userObject["profile_image"] {
                fromDict["profile_pic"] = profile_pic as? String
            }
        }
        var fromArray = [fromDict]
        var toArray = [[String:String]]()
        for receiver in self.receivers {
            var toDict = [String: String]()
            if let name = receiver.name {
                toDict["name"] = name
            }
            if let email = receiver.email {
                toDict["email"] = email
            }
            if let profile_pic = receiver.profileImage {
                toDict["profile_pic"] = profile_pic
            }
            if !toDict.values.joined().isEmpty {
                toArray.append(toDict)
            }
        }
        
        var dict = [String:Any]()
        guard let threadId = self.threadId else {
            return
        }
        dict["_id"] = "tempId"
        dict["thread_id"] = threadId as AnyObject
        let html = self.buildHTMLBody(from: unwrappedText)
        var segmented_html_dict : [String : AnyObject] = ["html" : html as AnyObject,
                                                          "order" : 1 as AnyObject,
                                                          "type" : "top_message" as AnyObject]
        var array = [segmented_html_dict]
        dict["segmented_html"] = array as AnyObject
        dict["from"] = fromArray as NSArray
        dict["to"] = toArray as NSArray
        
        // using current date and time as an example
        let someDate = Date()
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        // convert to Integer
        let myInt = Int32(timeInterval)
        dict["date"] = myInt as AnyObject
        
        self.tempDict = dict
        
        self.messagesService = ThreadsDetailService(parentVC: self)
        self.messagesService?.saveInCoreDataWith(array: [dict as Dictionary<String, AnyObject>])
        
        self.newResponder?.metadata.state = .minimized
        
    }
    
    lazy var onSendCompletedAction: (Result<[String: AnyObject]>) -> Void = { [weak self] result in
        switch result {
        case .Success (let data):
            self?.replierSuccess = true
            if let unwrappedBody = self?.unWrappedText {
                self?.onSuccessResponse(data, unwrappedBody)
            } else {
                self?.onSuccessResponse(data, "")
            }
            self?.removeAttachments()
            
        case .Error(let error):
            self?.replierSuccess = false
            print(error as Any)
            self?.onErrorResponse(error)
            self?.removeAttachments()
            AlertBar.show(.error, message: error)
        }
    }
    
    @objc func onTableViewTapped() {

    }
    
    lazy var onSuccessResponse: ([String: AnyObject], String) -> Void = { data, body in
        let requestWorkItem = DispatchWorkItem { //[weak self] in
            if !InternetReachability.isConnectedToNetwork() {
                self.replierSuccess = false
                self.fromReplier = true
                AlertBar.show(.error, message: "Pls check your internet connection!")
                self.tableView?.reloadData()
                self.isLoading = false
            } else {
                self.deleteTempIdCell2(data: data, body: body)
                self.showMessageSentAlert()
            }
        }
        // Save the new work item and execute it after 250 ms
        self.pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      execute: requestWorkItem)
    }
    
    lazy var onErrorResponse: (String) -> Void = { error in
        self.replierSuccess = false
        self.fromReplier = true
        AlertBar.show(.error, message: error)
        self.tableView?.reloadData()
        self.isLoading = false
    }
    
    func deleteTempIdCell2(data: [String: AnyObject]?, body: String?) {
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        request.predicate = NSPredicate(format: "messages_id = %@", "tempId")
        do {
            let result = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                self.deleteThread2(threadToDelete: result.first!)
                if let data = data, let body = body {
                    self.updateThreadAfterSentSuccess(data: data, body: body)
                }
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
    }
    
    func deleteThread2(threadToDelete thread: Messages) {
        CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(thread)
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch let error as NSError {
            print("Delete item failed: \(error.localizedDescription)")
        }
    }
    
    func updateThreadAfterSentSuccess(data: [String: AnyObject], body: String) {
        self.replierSuccess = true
        self.fromReplier = true
        self.getMessagesAfterReply()
    }
    
}

extension ThreadsDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !String(describing: touch.view).isEqualToString(find: "UITableViewCellContentView")
    }
}

extension ThreadsDetailViewController: IResponderActionsListener {
    
    private func scrollToLastMessageIfNeeded() {
        guard let messageId = newResponder?.metadata.config.message.id,
           let lastMessageId = self.dataArray.last?.id else { return }
        if messageId == lastMessageId {
            scrollToLastMessage()
        }
    }
    
    @objc private func handleHideResponderOnTap(_ gesture: UIGestureRecognizer) {
        if newResponder?.metadata.state == .regular {
            newResponder?.metadata.state = .minimized
            removeResignTap()
        }
    }
    
    func onChangeFrame(_ responderFrame: CGRect) {
        guard let unwrappedFrame = previousResponderFrame else {
            tableView?.frame.size.height -= responderFrame.height
            previousResponderFrame = responderFrame
            return
        }
        if unwrappedFrame.origin.y != responderFrame.origin.y {
            let delta: CGFloat = unwrappedFrame.origin.y - responderFrame.origin.y
            tableView?.frame.size.height -= delta
            previousResponderFrame = responderFrame
            addResignTap()
        }
        if !self.fromSwipedRight {
            scrollToLastMessage()
        } else {
            self.fromSwipedRight = false
        }
    }
    
    func onHideAction(_ metadata: ResponderMetadata, shouldSaveDraft: Bool) {
        tableView?.frame.size.height = view.frame.height - bottomSafeAreaInset()
        previousResponderFrame = nil
        if shouldSaveDraft {
            DraftsProxy().saveDraft(with: metadata)
        }
    }
    
    func onSendAction(_ metadata: ResponderMetadata) {
        self.newResponder?.disableSendButton()
        if !self.isLoading {
            self.isLoading = true
            onSendButtonPressed(metadata.config.message, metadata.message, metadata.recipients, metadata.attachments)
            scrollToLastMessage()
            removeResignTap()
        }
    }
    
    func showMessageSentAlert() {
        let sentView = UIImageView()
        sentView.image = #imageLiteral(resourceName: "no_internet_alert")
        if UIScreen.isPhoneX {
            sentView.frame = CGRect.init(x: 110, y: 667 - 40, width: 140, height: 50)
        } else if UIScreen.is6Or6S() {
            sentView.frame = CGRect.init(x: 110, y: 475 - 40, width: 140, height: 50)
        } else if UIScreen.is6PlusOr6SPlus() {
            sentView.frame = CGRect.init(x: 110, y: 540 - 40, width: 140, height: 50)
        }
        self.view.addSubview(sentView)
        
        let title = UILabel()
        title.frame = CGRect(x: 25, y: 13, width: 90, height: 22)
        title.text = "Message Sent"
        title.textAlignment = .center
        title.font = UIFont.latoStyleAndSize(style: .regular, size: .regMid)
        title.textColor = UIColor(hexString: "#FFFFFF")
        title.backgroundColor = .clear
        sentView.addSubview(title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            sentView.removeFromSuperview()
        }
    }
    
    func onSuccessAction(_ responseData: [String : AnyObject]) {
        onSendCompletedAction(.Success(responseData))
    }
    
    func onFailAction(_ error: String) {
        onErrorResponse(error)
    }
}
