//
//  ActionsPopupUIInitializer.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ActionsPopupUIInitializer {
    // MARK: - Variables & Constants
    private unowned var parentVC: ActionsPopup
    private let screenWidth = UIScreen.main.bounds.width
    private let arrowHeight = 0.019 * UIScreen.main.bounds.width
    private let arrowWidth = 0.056 * UIScreen.main.bounds.width
    private let arrowOriginX = 0.44 * UIScreen.main.bounds.width
    private let cornerRadius = 0.008 * UIScreen.main.bounds.width
    private let oneCellHeight = 0.104 * UIScreen.main.bounds.width
    
    // MARK: - Public part
    init(with controller: ActionsPopup) {
        parentVC = controller
    }
    
    func performBasicSetup() {
        parentVC.view.backgroundColor = .clear
        addBasicView()
    }
    
    func layoutSubviews() {
        addTableView()
    }
    
    func addTopArrow() {
        let parentView = parentVC.parentView
        let triangleImageView = UIImageView(image: UIImage(named: LocalizedImageNameKey.RequestsViewHelper.Triangle))
        let triangleFrame = CGRect(x: arrowOriginX, y: -arrowHeight, width: arrowWidth, height: arrowHeight)
        triangleImageView.frame = triangleFrame
        triangleImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        parentVC.view.clipsToBounds = true
        parentView.addSubview(triangleImageView)
    }
    
    func addBottomArrow() {
        let parentView = parentVC.parentView
        let tableViewFrame = parentVC.tableView.frame
        let triangleImageView = UIImageView(image: UIImage(named: LocalizedImageNameKey.RequestsViewHelper.Triangle))
        let triangleFrame = CGRect(x: arrowOriginX, y: tableViewFrame.origin.y + tableViewFrame.height, width: arrowWidth, height: arrowHeight)
        triangleImageView.frame = triangleFrame
        parentView.addSubview(triangleImageView)
    }
    
    func updateHeight(with count: Int, and type: ActionsPopupType) {
        var headerHeight: CGFloat = 0
        if type == .cannedResponse {
            headerHeight = 0.056 * screenWidth
        }
        let totalHeight = oneCellHeight * CGFloat(count) + arrowHeight + headerHeight
        parentVC.parentView.frame.size.height = totalHeight
        parentVC.tableView.frame.size.height = totalHeight
    }
    
    //MARK: Private part
    
    private func addBasicView() {
        let view = UIView()
        view.backgroundColor = .white
        let width = 0.528 * screenWidth
        let xOrigin = 0.432 * screenWidth
        let viewFrame = CGRect(x: xOrigin, y: 150, width: width, height: 0.48 * screenWidth + arrowHeight)
        view.frame = viewFrame
        view.layer.cornerRadius = cornerRadius
        addShadow(to: view)
        parentVC.view.addSubview(view)
        parentVC.parentView = view
    }

    private func addShadow(to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 9)
        view.layer.shadowRadius = 16
    }
    
    private func addTableView() {
        let parentView = parentVC.parentView
        guard let tableView = buildTableView() else { return }
        // table view setup goes here
        tableView.register(CannedResponcseTableViewCell.self, forCellReuseIdentifier: CannedResponcseTableViewCell.reuseIdentifier())
        tableView.register(ReplyTableViewCell.self, forCellReuseIdentifier: ReplyTableViewCell.reuseIdentifier())
        tableView.dataSource = parentVC.listDataSource
        tableView.delegate = parentVC.listDelegate
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = cornerRadius
        
        parentView.addSubview(tableView)
        parentVC.tableView = tableView
    }
    
    private func buildTableView() -> UITableView? {
        let parentViewFrame = parentVC.parentView.frame
        let tableViewFrame = CGRect(x: 0, y: 0, width: parentViewFrame.width, height: parentViewFrame.height)
        return UITableView(frame: tableViewFrame, style: .plain)
    }
}
