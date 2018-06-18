//
//  StarredDetailDelegate.swift
//  June
//
//  Created by Tatia Chachua on 15/09/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//
import UIKit

class StarredDetailDelegate: NSObject {
    
    unowned var parentVC: StarredDetailViewController
    init(parentVC: StarredDetailViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

extension StarredDetailDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 274
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
