//
//  RolodexsViewController.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData

class RolodexsViewController: CustomNavBarViewController {
    
    var tapStyle: String?
    var sortAscending = false
    var fetchedResultController: NSFetchedResultsController<Rolodexs>?
    var unreadsFetchedResultController: NSFetchedResultsController<Rolodexs>?
    var pinnedFetchedResultController: NSFetchedResultsController<Rolodexs>?
    var favsFetchedResultController: NSFetchedResultsController<Favorites>?
    var loadingImageView: UIImageView = UIImageView()
    var filterImageView: UIImageView = UIImageView()

    // Screen Builder
    var screenBuilder: RolodexsScreenBuilder = RolodexsScreenBuilder(model: nil)
    
    // TableView
    var rolodexTableView: UITableView?
    var dataSource: RolodexsDataSource?
    var delegate: RolodexsDelegate?
    
    var sections: [RolodexsSectionType] = []
    let rolodexsRealTime = RolodexsRealTime()

    var rolodexsItemsInfo: [Rolodexs]? = nil {
        didSet {
            self.screenBuilder.updateModel(model: self.rolodexsItemsInfo, type: RolodexsScreenType.recent)
            self.sections = self.screenBuilder.loadSections() as! [RolodexsSectionType]
            DispatchQueue.main.async {
                self.rolodexTableView?.reloadData()
                self.removeLoadingGif()
            }
        }
    }
    
    var unreadsItemsInfo: [Rolodexs]? = nil {
        didSet {
            self.screenBuilder.updateModel(model: self.unreadsItemsInfo, type: RolodexsScreenType.unread)
            self.sections = self.screenBuilder.loadSections() as! [RolodexsSectionType]
            DispatchQueue.main.async {
                self.rolodexTableView?.reloadData()
                self.removeLoadingGif()
            }
        }
    }
    
    var pinnedItemsInfo: [Rolodexs]? = nil {
        didSet {
            self.screenBuilder.updateModel(model: self.pinnedItemsInfo, type: RolodexsScreenType.pinned)
            self.sections = self.screenBuilder.loadSections() as! [RolodexsSectionType]
            DispatchQueue.main.async {
                self.rolodexTableView?.reloadData()
                self.removeLoadingGif()
            }
        }
    }
    
    var favsItemsInfo: [Favorites]? = nil {
        didSet {
            self.screenBuilder.updateModel(model: self.favsItemsInfo, type: RolodexsScreenType.favorites)
            self.sections = self.screenBuilder.loadSections() as! [RolodexsSectionType]
            DispatchQueue.main.async {
                self.rolodexTableView?.reloadData()
                self.removeLoadingGif()
            }
        }
    }
    
    var segment: RolodexsScreenType {
        get {
            return screenBuilder.loadSegment() as! RolodexsScreenType
        }
        set {
            screenBuilder.switchSegment(newValue)
            sections = screenBuilder.loadSections() as! [RolodexsSectionType]
            self.rolodexTableView?.reloadData {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05, execute: {
                    if newValue == .favorites {
                        DispatchQueue.main.async {
                            self.segmentView.filter.isHidden = true
                            self.removeFilterImageView()
                        }
                        self.removeLoadingGif()
                        print(self.favsItemsInfo?.count as Any)
                        if self.favsItemsInfo?.count == 0 || self.favsItemsInfo == nil {
                            DispatchQueue.main.async {
                                self.showLoadingGif()
                                self.loadingMoreFavs = true
                            }
                        }
                    } else if newValue == .recent {
                        DispatchQueue.main.async {
                            self.segmentView.filter.isHidden = false
                            self.loadRolodexsData()
                        }
                    } else if newValue == .unread {
                        DispatchQueue.main.async {
                            self.showLoadingGif()
                            self.loadingMoreUnreads = true
                        }
                    }else if newValue == .pinned {
                        DispatchQueue.main.async {
                            self.showLoadingGif()
                            self.loadingMorePins = true
                        }
                    }
                })
            }
        }
    }
    
    var segmentView: RolodexsSegmentedView = RolodexsSegmentedView(frame: CGRect.zero, headline: "")
    var segmentHeight: CGFloat {
        get {
            return RolodexsSegmentedView.heightForView()
        }
    }
    var isSegmentViewShowing: Bool {
        get {
            if segmentView.frame.origin.y <= navBarHeight - segmentHeight {
                return false
            }
            return true
        }
    }

    var maxRolodexsItemsReached: Bool {
        get {
            return screenBuilder.viewHelper.maxRolodexsItemsReached
        }
        set {
            screenBuilder.viewHelper.maxRolodexsItemsReached = newValue
        }
    }
    
    var loadingRolodexsItems: Bool = false {
        didSet {
            if loadingRolodexsItems {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: {
                    if let rolodexsItemsCount = self.rolodexsItemsInfo?.count {
                        self.fetchMoreRolodexsConvos(_withSkip: rolodexsItemsCount)
                        self.loadingRolodexsItems = false
                    }
                })
            }
        }
    }
    
    // Favs
    var loadingMoreFavs: Bool = false {
        didSet {
            if loadingMoreFavs {
                self.getNewFavoritesFromBackend()
            }
        }
    }
    
    // Unread
    var loadingMoreUnreads: Bool = false {
        didSet {
            if loadingMoreUnreads {
                self.getNewUnreadFromBackend()
            }
        }
    }
    
    // Unread
    var loadingMorePins: Bool = false {
        didSet {
            if loadingMorePins {
                self.getNewPinsFromBackend()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setUpView()
        self.showLoadingGif()
        self.checkDataStoreForNewRolodexs()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.listenToRealTimeEvents()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Conversations"
        if self.segment == .recent {
            self.segmentView.filter.isHidden = false
            self.segmentView.filter.image = #imageLiteral(resourceName: "rolodex-filter")
        } else if self.segment == .unread {
            self.segmentView.unread.isHidden = false
        } else if self.segment == .pinned {
            self.segmentView.pinned.isHidden = false
        } else if self.segment == .favorites {
            self.segmentView.filter.isHidden = true
            self.segmentView.unread.isHidden = true
            self.segmentView.pinned.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeFilterImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpView() {
        segmentView.frame = CGRect(x: 0, y: navBarHeight, width: view.frame.width, height: segmentHeight)
        segmentView.segmentControl.addTarget(self, action: #selector(RolodexsViewController.didChangeSegment(_:)), for: .valueChanged)

        let tapFilter = UITapGestureRecognizer(target: self, action: #selector(RolodexsViewController.didTapFilter))
        segmentView.filter.isUserInteractionEnabled = true
        segmentView.filter.addGestureRecognizer(tapFilter)

        let tapUnreadClose = UITapGestureRecognizer(target: self, action: #selector(RolodexsViewController.didTapUnreadClose(sender:)))
        self.segmentView.unread.addGestureRecognizer(tapUnreadClose)

        let tapPinnedClose = UITapGestureRecognizer(target: self, action: #selector(RolodexsViewController.didTapPinnedClose(sender:)))
        self.segmentView.pinned.addGestureRecognizer(tapPinnedClose)
        
        var tableViewFrame: CGRect
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height {
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height - 66 - tabBarHeight - 70))
            } else {
                tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height - 66 - tabBarHeight))
            }
        } else {
            tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height - 66))
        }
        rolodexTableView = UITableView(frame: tableViewFrame, style: .plain)
        rolodexTableView?.tableHeaderView = segmentView

        self.rolodexTableView?.separatorStyle = .none
        self.rolodexTableView?.rowHeight = 0
        self.rolodexTableView?.estimatedRowHeight = 0;
        self.rolodexTableView?.tableHeaderView?.frame.size.height = segmentView.frame.size.height;
        self.rolodexTableView?.estimatedSectionFooterHeight = 0;
        self.rolodexTableView?.backgroundColor = .white
        dataSource = RolodexsDataSource(parentVC: self)
        delegate = RolodexsDelegate(parentVC: self)
        self.rolodexTableView?.delegate = delegate
        self.rolodexTableView?.dataSource = dataSource
        if let tableView = self.rolodexTableView {
            view.addSubview(tableView)
        }
        rolodexTableView?.register(RolodexsTableViewCell.self, forCellReuseIdentifier: RolodexsTableViewCell.reuseIdentifier())
        rolodexTableView?.register(FavsTableViewCell.self, forCellReuseIdentifier: FavsTableViewCell.reuseIdentifier())
        rolodexTableView?.register(ConvosViewAllTableViewCell.self, forCellReuseIdentifier: ConvosViewAllTableViewCell.reuseIdentifier())

        self.setUpFilterView()
        self.filterImageView.isHidden = true
        
    }
    
    override func loadViewIfNeeded() {
        if let tapStyleString = self.tapStyle {
            if tapStyleString.isEqualToString(find: "double") {
                self.scrollToFirstRow()
            } else if tapStyleString.isEqualToString(find: "single") {
                self.checkNewRolodexsInBackground()
            }
        }
    }
    
    func setUpFilterView() {
        filterImageView.frame = CGRect.init(x: 0, y: (self.rolodexTableView?.frame.origin.y)! + self.segmentView.frame.size.height + 1, width: self.view.frame.size.width, height: self.view.frame.size.height)
        filterImageView.backgroundColor = .clear
        filterImageView.isUserInteractionEnabled = true
        self.tabBarController?.view.addSubview(filterImageView)
        
        let unread = UIImageView()
        unread.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 58)
        unread.backgroundColor = .white
        unread.isUserInteractionEnabled = true
        self.filterImageView.addSubview(unread)
        
        let unread_icon = UIImageView()
        unread_icon.frame = CGRect.init(x: 14, y: 19, width: 22, height: 20)
        unread_icon.image = #imageLiteral(resourceName: "rolodex-unread-icon")
        unread.addSubview(unread_icon)
        
        let unreadLabel = UILabel()
        unreadLabel.frame = CGRect.init(x: 48, y: 0, width: 200, height: unread.frame.size.height)
        unreadLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
        unreadLabel.textColor = UIColor.init(hexString: "585F6F")
        unreadLabel.textAlignment = .left
        unreadLabel.text = "Unread"
        unread.addSubview(unreadLabel)
        
        let border = CALayer()
        border.backgroundColor = UIColor.init(hexString: "F3F4F5").cgColor
        border.frame = CGRect(x: 0, y: unread.frame.size.height, width: unread.frame.size.width, height: 1)
        unread.layer.addSublayer(border)
        
        let tapUnreadFilter = UITapGestureRecognizer(target: self, action: #selector(RolodexsViewController.didTapUnreadFilter(sender:)))
        unread.isUserInteractionEnabled = true
        unread.addGestureRecognizer(tapUnreadFilter)

        let pinned = UIImageView()
        pinned.frame = CGRect.init(x: 0, y: unread.frame.origin.y + unread.frame.size.height + 1, width: self.view.frame.size.width, height: 58)
        pinned.backgroundColor = .white
        self.filterImageView.addSubview(pinned)
        
        let pinned_icon = UIImageView()
        pinned_icon.frame = CGRect.init(x: 15, y: 17.5, width: 21, height: 23)
        pinned_icon.image = #imageLiteral(resourceName: "rolodex-pinned-icon")
        pinned.addSubview(pinned_icon)
        
        let pinnedLabel = UILabel()
        pinnedLabel.frame = CGRect.init(x: 48, y: 0, width: 250, height: pinned.frame.size.height)
        pinnedLabel.font = UIFont.latoStyleAndSize(style: .bold, size: .largeMedium)
        pinnedLabel.textColor = UIColor.init(hexString: "585F6F")
        pinnedLabel.textAlignment = .left
        pinnedLabel.text = "Pinned"
        pinned.addSubview(pinnedLabel)
        
        let tapPinnedFilter = UITapGestureRecognizer(target: self, action: #selector(RolodexsViewController.didTapPinnedFilter(sender:)))
        pinned.isUserInteractionEnabled = true
        pinned.addGestureRecognizer(tapPinnedFilter)
        
        let clearBg = UIImageView()
        clearBg.frame = CGRect.init(x: 0, y: pinned.frame.origin.y + pinned.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - (pinned.frame.origin.y + pinned.frame.size.height))
        clearBg.image = #imageLiteral(resourceName: "rolodex-clear-bg")
        self.filterImageView.addSubview(clearBg)
        
        let tapClearFilter = UITapGestureRecognizer(target: self, action: #selector(RolodexsViewController.didTapClearFilterBg(sender:)))
        clearBg.isUserInteractionEnabled = true
        clearBg.addGestureRecognizer(tapClearFilter)
    }
    
}
