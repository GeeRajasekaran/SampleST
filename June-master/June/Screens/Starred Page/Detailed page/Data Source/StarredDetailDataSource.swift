//
//  StarredDetailDataSource.swift
//  June
//
//  Created by Tatia Chachua on 15/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit

class StarredDetailDataSource: NSObject {
    
    unowned var parentVC: StarredDetailViewController
    init(parentVC: StarredDetailViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITableViewDataSource
extension StarredDetailDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StarredDetailTableViewCell.reuseIdentifier()) as! StarredDetailTableViewCell
        cell.selectionStyle = .none
   
        
        
        
        
//        cell.transform = CGAffineTransform (scaleX: 1,y: -1)
//        let index = Int(indexPath.row)
//        if index >= 3 {
//            self.parentVC.moveUp()
//        }
//        if index <= 2 {
//            self.parentVC.moveDown()
//        }
        
        return cell
    }
    
    
}
