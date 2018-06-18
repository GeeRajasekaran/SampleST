//
//  NewThreadsDetailViewController.swift
//  June
//
//  Created by Joshua Cleetus on 10/16/17.
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

class NewThreadsDetailViewController: UIViewController, UIWebViewDelegate {
    
    var scrollView: UIScrollView!
    var threadId: String?
    var threadAccountId: String?
    var threadToRead: Threads?
    var fromTableViewTag: Int?
    var threadsService: ThreadsDetailService?
    var subjectTitle: String?
    var titleLabel: UILabel!
    var starred: Bool?
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var headerLine: UIImageView!
    private var headerLineShadow: UIImageView!
    private var headerLine2: UIImageView!
    private var blocker: UIImageView!
    private var headerLineShadow2: UIImageView!
    private var starButton: UIButton!
    private var moreOptionBtn: UIButton!
    private var alertButton: UIButton!
    private var alertButtonLabel = UILabel()
    let webView = UIWebView()
    var webViewCount = 0
    var fetchedResultController: NSFetchedResultsController<Messages>!
    var dataArray: NSFetchedResultsController<Messages>!
    var contentHeights : [CGFloat] = [CGFloat]()
    var messagesService: ThreadsDetailService?
    var sortAscending = true
    var responder: ResponderOld?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.checkDataStore()
    }

    func setupView() {
        
        self.webView.frame = CGRect(x: 48, y: 5, width: 0.83 * self.view.frame.size.width, height: 250)
        self.webView.backgroundColor = .clear
        self.webView.isOpaque = false
        self.webView.delegate = self
        self.view.addSubview(self.webView)

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = .white
        scrollView.contentSize = view.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        view.addSubview(scrollView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_indicator")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_indicator")
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(18, 0), for: .default)
        self.navigationController?.navigationBar.topItem?.title = ""
        
        starButton = UIButton(type: .custom)
        if !starred! {
            starButton.setImage(#imageLiteral(resourceName: "icon_starred_gray"), for: .normal)
        } else {
            starButton.setImage(#imageLiteral(resourceName: "star_icon"), for: .normal)
        }
        starButton.frame = CGRect(x: 334, y: 5, width: 23.1, height: 40)
        starButton.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
        
        moreOptionBtn = UIButton(type: .custom)
        moreOptionBtn.setImage(UIImage(named: "three_dots"), for: .normal)
        moreOptionBtn.frame = CGRect(x: 304, y: 5, width: 15, height: 40)
        moreOptionBtn.addTarget(self, action: #selector(moreOptionButtonPressed), for: .touchUpInside)
        
        self.navigationController?.navigationBar.addSubview(self.moreOptionBtn)
        self.navigationController?.navigationBar.addSubview(self.starButton)
        
        headerLine = UIImageView(frame: CGRect(x: 0, y: 44, width: self.view.bounds.width, height: 3.57))
        headerLine.image = #imageLiteral(resourceName: "june_gradient_line")
        self.navigationController?.navigationBar.addSubview(headerLine)
        
        headerLineShadow = UIImageView(frame: CGRect(x: 0, y: headerLine.frame.origin.y + headerLine.frame.size.height, width: self.view.bounds.width, height: 10))
        headerLineShadow.image = #imageLiteral(resourceName: "shadow_bottom")
        self.navigationController?.navigationBar.addSubview(headerLineShadow)
        UIView.animate(withDuration: 0.0, animations: {
            self.headerLineShadow.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        })
        
        titleLabel = UILabel.init(frame: CGRect(x: 50, y: 15, width: 250, height: 19))
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "ProximaNova-Semibold", size: 16)
        titleLabel.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        titleLabel.backgroundColor = .white
        self.navigationController?.navigationBar.addSubview(titleLabel)
        if subjectTitle != nil {
            titleLabel.text = subjectTitle
        }
        
        if self.responder != nil {
            self.responder?.start()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            self.headerLineShadow.isHidden = true
            self.headerLine.isHidden = true
            self.titleLabel.isHidden = true
            self.moreOptionBtn.isHidden = true
            self.starButton.isHidden = true
            self.navigationController?.hidesBarsOnSwipe = false
        }
        
        self.responder?.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.headerLineShadow.removeFromSuperview()
        self.headerLine.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        self.moreOptionBtn.removeFromSuperview()
        self.starButton.removeFromSuperview()
        self.responder?.hide()
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
            self.markThreadAsStarredOrUnstarred()
            self.alertButton.addTarget(self, action: #selector(ThreadsDetailViewController.undoStarredUnstarredAction), for: .touchUpInside)
            self.alertButton.isHidden = false
            self.alertButtonLabel.isHidden = false
            
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (timer) in
                self.alertButton.isHidden = true
                self.alertButtonLabel.isHidden = true
            })
        })];
    }
    
    @objc func moreOptionButtonPressed() {
        print("more option button pressed")
    }
    
    @objc func markThreadAsStarredOrUnstarred() {
        print("thread id = ", threadId!)
//        let threadDetailService = ThreadsDetailService.init(parentVC: self)
//        threadDetailService.updateStarredValue(threadId: self.threadId!, starredValue: self.starred!)
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            let service = ThreadsDetailAPIBridge()
            print((self?.threadId)!)
            print((self?.threadToRead)!)
            print((self?.threadAccountId)!)
            print((self?.starred)!)
            service.markThreadAsStarredOnUnstarred(threadId: (self?.threadId)!, accountId: (self?.threadAccountId)!, starred: (self?.starred!)!, completion: { (result) in
                switch result {
                case .Success(let data):
                    print(data)
                case .Error(let message):
                    print(message)
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
            self.markThreadAsStarredOrUnstarred()
            self.alertButton.isHidden = true
            self.alertButtonLabel.isHidden = true
        })];
    }
    
    func checkDataStore() {
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        request.predicate = NSPredicate(format: "thread_id == %@", self.threadId!)
        
        do {
            let threadsCount = try CoreDataManager.sharedInstance.persistentContainer.viewContext.count(for: request)
            print(threadsCount as Any)
            if threadsCount == 0 {
                self.getMessagesFromBackend()
            } else {
                self.loadData()
            }
        }
        catch {
            print("Error in counting")
        }
    }
    
    func getMessagesFromBackend() {
        let service = ThreadsDetailAPIBridge()
        service.getMessagesDataWith(_withThreadId: self.threadId!) { (result) in
//                        switch result {
//                        case .Success(let data):
//                            self.messagesService = ThreadsDetailService(parentVC: self)
//                            self.messagesService?.saveInCoreDataWith(array: data)
//                        case .Error(let message):
//                            print(message)
//                        }
        }
    }
    
    func loadData() {
        for items in self.fetchedResultController.fetchedObjects! {
            print("item = ", items)
            print(items.date)
            print(items.body!)
        }
        self.loadTheWebViewsToFindHeights()
        if self.responder != nil { return }
        if let unwrappedThread = threadToRead, let unwrappedMessage = fetchedResultController.fetchedObjects?.first {
            let config = ResponderConfig(with: unwrappedThread, message: unwrappedMessage, minimized: true)
            self.responder = ResponderOld(with: self, and: config)
            self.responder?.start()
        }
    }
    
    func loadTheWebViewsToFindHeights() {
        
        if webViewCount < (self.fetchedResultController.fetchedObjects?.count)! {
            webView.tag = webViewCount

            let segmentedHtmlArray = self.fetchedResultController.fetchedObjects![webViewCount].messages_segmented_html?.allObjects as? Array<Messages_Segmented_Html>
            if ((segmentedHtmlArray?.count) != nil && (segmentedHtmlArray?.count)! > 0) {
                for segmentedHtml in segmentedHtmlArray! {
                    if segmentedHtml.order == 1 && segmentedHtml.type == "top_message" {
                            if segmentedHtml.html != nil {
                            self.webView.loadHTMLString(segmentedHtml.html!, baseURL: nil)
                        } else {
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString("<p>No content found<p>", baseURL: nil)
                            }
                        }
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    self.webView.loadHTMLString("<p>No content found<p>", baseURL: nil)
                }
            }
        }
        
        if webViewCount == self.fetchedResultController.fetchedObjects?.count {
            
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.webViewCount < (self.fetchedResultController.fetchedObjects?.count)! {
            print("webview tag = ", webView.tag)
            print("webview count = ", webViewCount)
            var frame:CGRect = webView.frame
            frame.size.height = 1.0
            webView.frame = frame
            
            var height:CGFloat = webView.scrollView.contentSize.height + 100
            print("UIWebView.height: \(height)")
            if height < 250 {
                height = 250
            }
            self.contentHeights.append(height)
            self.webViewCount = webViewCount + 1
            self.loadTheWebViewsToFindHeights()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("error = ", error)
    }
    
    func setupTheWebViews() -> Void {
        
    }
    
}
