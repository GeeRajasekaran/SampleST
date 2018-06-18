//
//  StareDetailViewController.swift
//  June
//
//  Created by Tatia Chachua on 26/09/17.
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

class StarredDetailViewController: UIViewController {
    
    var threadId: String?
    var subjectTitle: String?
    var subjectLabel: UILabel!
    
    private var starButton: UIButton!
    private var moreOptionBtn: UIButton!
    private var line: UIImageView!
    private var shadow: UIImageView!
    
    var delegate: StarredDetailDelegate!
    var dataSource: StarredDetailDataSource!
    
    var tableView: UITableView!
    
    static let subjectLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .largeMedium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
  
        self.line = UIImageView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.minY)!, width: self.view.bounds.width, height: 3.57))
        line.image = #imageLiteral(resourceName: "june_gradient_line")
        self.view.addSubview(line)
        
        self.shadow = UIImageView(frame: CGRect(x: 0, y: self.line.bounds.maxY, width: self.view.bounds.width, height: 23.94))
        shadow.image = #imageLiteral(resourceName: "shadow_copy_2")
        self.view.addSubview(shadow)
        
        self.delegate = StarredDetailDelegate(parentVC: self)
        self.dataSource = StarredDetailDataSource(parentVC: self)
        
        subjectLabel = UILabel.init(frame: CGRect(x: 50, y: 15, width: 250, height: 19))
        subjectLabel.textAlignment = .left
        subjectLabel.font = StarredDetailViewController.subjectLabelFont
        subjectLabel.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        subjectLabel.backgroundColor = .white
        self.navigationController?.navigationBar.addSubview(subjectLabel)
        if subjectTitle != nil {
            subjectLabel.text = subjectTitle
        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: 3, width: self.view.frame.width, height: self.view.frame.height - 66))
        tableView?.delegate = delegate
        tableView?.dataSource = dataSource 
        tableView?.separatorInset = .zero
        tableView?.layoutMargins = .zero
//        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
        tableView?.tag = 10
        tableView?.backgroundColor = .clear
        self.view.addSubview(self.tableView!)
        tableView?.register(StarredDetailTableViewCell.self, forCellReuseIdentifier: StarredDetailTableViewCell.reuseIdentifier())
        tableView?.allowsSelection = true
        tableView?.allowsSelectionDuringEditing = true
        tableView?.estimatedRowHeight = 274
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorColor = .clear
      
        
    }
    
//     func moveUp() {
//        UIView.animate(withDuration: 0.5) {
//            self.navigationController?.isNavigationBarHidden = true
//        }
//    }
//    func moveDown() {
//        UIView.animate(withDuration: 0.5) {
//            self.navigationController?.isNavigationBarHidden = false
//        }
//    }
    
    @objc func starButtonPressed() {
        print("star button pressed")
    }
    
    @objc func moreOptionButtonPressed() {
        print("more option button pressed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_indicator")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_indicator")
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(11, 0), for: .default)
        self.navigationController?.navigationBar.topItem?.title = "landing page"
        
        self.starButton = UIButton(type: .custom)

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(18, 0), for: .default)
        self.navigationController?.navigationBar.topItem?.title = ""
        
        starButton = UIButton(type: .custom)

        starButton.setImage(UIImage(named: "icon_starred_gray"), for: .normal)
        starButton.frame = CGRect(x: 334, y: 10, width: 23.1, height: 22.06)
        starButton.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
        
        moreOptionBtn = UIButton(type: .custom)
        moreOptionBtn.setImage(UIImage(named: "three_dots"), for: .normal)
        moreOptionBtn.frame = CGRect(x: 304, y: 21, width: 15, height: 4)
        moreOptionBtn.addTarget(self, action: #selector(moreOptionButtonPressed), for: .touchUpInside)
        
        self.navigationController?.navigationBar.addSubview(self.moreOptionBtn)
        self.navigationController?.navigationBar.addSubview(self.starButton)
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            self.moreOptionBtn.removeFromSuperview()
            self.starButton.removeFromSuperview()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.subjectLabel.removeFromSuperview()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
