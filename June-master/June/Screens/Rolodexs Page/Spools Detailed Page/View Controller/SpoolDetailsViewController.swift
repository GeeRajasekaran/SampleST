//
//  SpoolDetailsViewController.swift
//  June
//
//  Created by Ostap Holub on 4/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import AlertBar

class SpoolDetailsViewController: UIViewController {
    
    // MARK: - Variables & Constants
    
    weak var selectedSpool: Spools?
    var tableView: UITableView?
    var leftNavBarView: SpoolDetailsLeftNavBarView?
    var responder: Responder?
    private var previousResponderFrame: CGRect?
    var bottomConstraint: NSLayoutConstraint?
    private var resignTap: UITapGestureRecognizer?
    
    private var responderInfoLoader: SpoolResponderInfoLoader = SpoolResponderInfoLoader()
    
    private lazy var screenBuilder: SpoolDetailsScreenBuilder = { [weak self] in
        let builder = SpoolDetailsScreenBuilder(model: self?.selectedSpool)
        return builder
    }()
    
    private lazy var uiInitializer: SpoolDetailsUIInitializer = { [unowned self] in
        let initializer = SpoolDetailsUIInitializer(vc: self)
        return initializer
    }()
    
    private lazy var dataProvider: MessagesDataProvider = { [weak self] in
        let provider = MessagesDataProvider(with: self)
        return provider
    }()
    
    private lazy var dataSource: SpoolDetailsDataSource = { [weak self] in
        let source = SpoolDetailsDataSource(builder: self?.screenBuilder)
        source.onWebViewLoaded = self?.onWebViewLoaded
        source.onPaginateAction = self?.onPaginateAction
        return source
    }()
    
    private lazy var tableDelegate: SpoolDetailsTableDelegate = { [weak self] in
        let delegate = SpoolDetailsTableDelegate(builder: self?.screenBuilder)
        delegate.onCollapse = self?.onCollpaseAction
        return delegate
    }()
    
    private lazy var loader: RequestsLoaderHandler = { [unowned self] in
        let loader = RequestsLoaderHandler(with: self.view)
        return loader
    }()
    
    // MARK: - View lifecycle managament
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.initialize()
        tableView?.dataSource = dataSource
        tableView?.delegate = tableDelegate
        loader.startLoader()
        dataProvider.requestMessages(for: selectedSpool)
        
        if let spoolId = selectedSpool?.spools_id {
            responderInfoLoader.requestInfo(for: spoolId, completion: onResponderInfoLoaded)
        }
        
        if let headerModel = screenBuilder.headerInfo {
            leftNavBarView?.load(headerModel)
        }
    }
    
    private lazy var onPaginateAction: () -> Void = { [weak self] in
        guard let skipCount = self?.screenBuilder.dataRepository.count else { return }
        self?.loader.startLoader()
        self?.dataProvider.requestNextMessagesPage(for: self?.selectedSpool, skipCount: skipCount)
    }
    
    // MARK: - Navigation
    
    private lazy var onCollpaseAction: () -> Void = { [weak self] in
        self?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Web view content loading
    
    private lazy var onWebViewLoaded: (String, CGFloat, WKWebView) -> Void = { [weak self] id, height, wView in
        self?.tableDelegate.save(height: height, for: id)
        self?.dataSource.save(wView, for: id)
        self?.tableView?.beginUpdates()
        self?.tableView?.endUpdates()
    }
    
    // MARK: - Responder initialization
    
    private lazy var onResponderInfoLoaded: (Threads, Messages) -> Void = { [weak self] t, m in
        let config = ResponderConfig(with: .reply, thread: t, message: m, minimized: true)
        if let viewController = self {
            self?.responder = Responder(rootVC: viewController, config: config)
            self?.responder?.actionsListener = self
            self?.responder?.show()
        }
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
    
    private func addResignTap() {
        guard resignTap == nil else { return }
        guard responder?.metadata.state != .minimized else { return }
        
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
    
    @objc private func handleHideResponderOnTap(_ gesture: UIGestureRecognizer) {
        if responder?.metadata.state == .regular {
            responder?.metadata.state = .minimized
            removeResignTap()
        }
    }
    
    lazy var onSendButtonPressed: (Messages, String, [EmailReceiver], [Attachment]) -> Void = { unwrappedMessage, unwrappedText, unwrappedReceivers, attachments in
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
        for receiver in unwrappedReceivers {
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
        guard let threadId = self.responderInfoLoader.pendingThread?.id else {
            return
        }
        dict["id"] = "tempId"
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

        let proxy = MessagesProxy()
        let parser = MessagesParser()
        
        let message = proxy.addNewMessage()
        parser.loadData(from: JSON(dict), into: message)
        proxy.saveContext()
        self.screenBuilder.updateModel(model: proxy.fetchMessagesEntities(forThread: threadId), type: [])
        self.responder?.metadata.state = .minimized
    }
    
    let htmlTemplate = "<div dir=\"ltr\">#placeholder#</div><br>"
    let placeholderString = "#placeholder#"
    
    func buildHTMLBody(from bodyString: String) -> String {
        let template = htmlTemplate.replacingOccurrences(of: placeholderString, with: bodyString)
        return template.replacingOccurrences(of: "\n", with: "<br>")
    }
}

    // MARK: - MessagesProviderDelegate

extension SpoolDetailsViewController: MessagesProviderDelegate {
    
    func provider(_ dataProvider: MessagesDataProvider, didReceiveMessageFor threadId: String, total: Int) {
        let proxy: MessagesProxy = MessagesProxy()
        screenBuilder.updateModel(model: proxy.fetchMessagesEntities(forThread: threadId), type: [])
        screenBuilder.isLoadingMoreAvailable = screenBuilder.dataRepository.count < total
        tableView?.reloadData()
        loader.stopLoader()
    }
}

extension SpoolDetailsViewController: UIGestureRecognizerDelegate {
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

extension SpoolDetailsViewController: IResponderActionsListener {
    
    func onChangeFrame(_ responderFrame: CGRect) {
        guard let unwrappedFrame = previousResponderFrame else {
            bottomConstraint?.constant = -responderFrame.height
            previousResponderFrame = responderFrame
            return
        }
        if unwrappedFrame.origin.y != responderFrame.origin.y {
            let constant = view.frame.height - responderFrame.origin.y
            bottomConstraint?.constant = -constant
            previousResponderFrame = responderFrame
            addResignTap()
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
        responder?.disableSendButton()
        onSendButtonPressed(metadata.config.message, metadata.message, metadata.recipients, metadata.attachments)
        tableView?.reloadData()
    }
    
    func onSuccessAction(_ responseData: [String : AnyObject]) {
        removeResignTap()
        guard let threadId = responderInfoLoader.pendingThread?.id else { return }
        let proxy: MessagesProxy = MessagesProxy()
        if let message = proxy.fetchTempMessage(for: threadId) {
            let json = JSON(responseData)
            MessagesParser().loadData(from: json, into: message)
            proxy.saveContext()
            screenBuilder.updateModel(model: proxy.fetchMessagesEntities(forThread: threadId), type: [])
            tableView?.reloadData()
        }
    }
    
    func onFailAction(_ error: String) {
        guard let threadId = responderInfoLoader.pendingThread?.id else { return }
        let proxy: MessagesProxy = MessagesProxy()
        if proxy.fetchTempMessage(for: threadId) != nil {
            proxy.removeTempMessage(for: threadId)
            proxy.saveContext()
            screenBuilder.updateModel(model: proxy.fetchMessagesEntities(forThread: threadId), type: [])
            tableView?.reloadData()
        }
        AlertBar.show(.error, message: error)
    }
}
