//
//  ThreadsDataSource.swift
//  June
//
//  Created by Joshua Cleetus on 8/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class ThreadsDataSource: NSObject {

    let threadsViewHelper: ThreadsViewHelper = ThreadsViewHelper()

    let cellHandler = SwipyCellHandler()
    
    unowned var parentVC: ThreadsViewController
    
    init(parentVC: ThreadsViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITableViewDataSource

extension ThreadsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.parentVC.tableView {
            if self.parentVC.fetchedResultController != nil {
                if let sections = self.parentVC.fetchedResultController?.sections {
                    return sections.count
                }
            }
        }
        if tableView == self.parentVC.readTableView {
            if self.parentVC.fetchedResultController2 != nil {
                if let sections = self.parentVC.fetchedResultController2?.sections {
                    return sections.count
                }
            }
        }
        if tableView == self.parentVC.trashTableView {
            if self.parentVC.fetchedResultController3 != nil {
                if let sections = self.parentVC.fetchedResultController3?.sections {
                    return sections.count
                }
            }
        }
        if tableView == self.parentVC.spamTableView {
            if self.parentVC.fetchedResultController4 != nil {
                if let sections = self.parentVC.fetchedResultController4?.sections {
                    return sections.count
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.parentVC.tableView {
            if self.parentVC.fetchedResultController != nil {
                if let sections = self.parentVC.fetchedResultController?.sections {
                    let currentSection = sections[section]
                    return currentSection.numberOfObjects
                }
            } 
        }
        if tableView == self.parentVC.readTableView {
            if self.parentVC.fetchedResultController2 != nil {
                if let sections = self.parentVC.fetchedResultController2?.sections {
                    let currentSection = sections[section]
                    return currentSection.numberOfObjects
                }
            }
        }
        if tableView == self.parentVC.trashTableView {
            if self.parentVC.fetchedResultController3 != nil {
                if let sections = self.parentVC.fetchedResultController3?.sections {
                    let currentSection = sections[section]
                    return currentSection.numberOfObjects
                }
            }
        }
        if tableView == self.parentVC.spamTableView {
            if self.parentVC.fetchedResultController4 != nil {
                if let sections = self.parentVC.fetchedResultController4?.sections {
                    let currentSection = sections[section]
                    return currentSection.numberOfObjects
                }
            }
        }
        return 0
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == self.parentVC.tableView {
            
            var cell: ThreadsTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: ThreadsTableViewCell.reuseIdentifier()) as? ThreadsTableViewCell)!
            if (cell == nil) {
                cell = ThreadsTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: ThreadsTableViewCell.reuseIdentifier())
            }
            
            if self.parentVC.fetchedResultController != nil {
                cell?.delegate1 = self.parentVC
                cell?.separatorInset = .zero
                cell?.layoutMargins = .zero
                let rightView = viewWithImageName("starred_icon")
                let rightColor = #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1)
                let leftView = viewWithImageName("read_icon")
                let leftColor = #colorLiteral(red: 0.5529411765, green: 0.8431372549, blue: 1, alpha: 1)
                cell?.setTriggerPoints(points: [0.1, 0.2])
                cellHandler.configure(cell)
                cell?.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: leftView, swipeColor: leftColor, completion: nil)
                cell?.addSwipeTrigger(forState: .state(1, .left), withMode: .exit, swipeView: leftView, swipeColor: leftColor, completion: { cell, trigger, state, mode in
                    if let threadCell = cell as? ThreadsTableViewCell {
                        threadCell.performAction()
                    }
                })
                cell?.addSwipeTrigger(forState: .state(0, .right), withMode: .toggle, swipeView: rightView, swipeColor: rightColor, completion: nil)
                cell?.addSwipeTrigger(forState: .state(1, .right), withMode: .exit, swipeView: rightView, swipeColor: rightColor, completion: { cell, trigger, state, mode in
                    if let threadCell = cell as? ThreadsTableViewCell {
                        threadCell.swipedLeft()
                    }
                })
                let isIndexValid = self.parentVC.fetchedResultController?.fetchedObjects?.indices.contains(indexPath.row)
                if isIndexValid! {
                    if let thread = self.parentVC.fetchedResultController?.object(at: indexPath) {
                        DispatchQueue.main.async {
                            cell?.setThreadCellWith(thread: thread)
                            if let thread_id = thread.id {
                                cell?.getCountOfUnreadMessages(threadId: thread_id)
                                if let myCell = cell {
                                    self.showProfileImage(onCell: myCell, withThread: thread)
                                }
                            }
                        }
                    }
                }
                cell?.selectionStyle = .none
                cell?.rightActions = [
                    CustomSwipeAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.leftActions = [
                    CustomSwipeAction(title: "", color: #colorLiteral(red: 0.5529411765, green: 0.8431372549, blue: 1, alpha: 1))
                ]
                cell?.contentView.setNeedsLayout()

            }

            return cell!
        }
        
        if tableView == self.parentVC.readTableView {
            
            var cell: ThreadsStarUnstarTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier()) as? ThreadsStarUnstarTableViewCell)!
            if (cell == nil) {
                cell = ThreadsStarUnstarTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier())
            }
            
            if self.parentVC.fetchedResultController2 != nil {
                cell?.delegate = self.parentVC
                cell?.indexPath = indexPath
                cell?.tableViewTag = tableView.tag
                
                let isIndexValid = self.parentVC.fetchedResultController2?.fetchedObjects?.indices.contains(indexPath.row)
                if isIndexValid! {
                    let thread = self.parentVC.fetchedResultController2?.object(at: indexPath)
                    DispatchQueue.main.async {
                        cell?.setThreadCellWith(thread: thread!)
                    }
                }
                cell?.selectionStyle = .none
                cell?.rightActions = [
                    CustomStarUnstarAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.leftActions = [
                    CustomStarUnstarAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.contentView.setNeedsLayout()

            }

            return cell!
        }
        
        if tableView == self.parentVC.trashTableView {
            
            var cell: ThreadsStarUnstarTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier()) as? ThreadsStarUnstarTableViewCell)!
            if (cell == nil) {
                cell = ThreadsStarUnstarTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier())
            }
            
            if self.parentVC.fetchedResultController3 != nil {
                let thread = self.parentVC.fetchedResultController3?.object(at: indexPath)
                cell?.delegate = self.parentVC
                cell?.indexPath = indexPath
                cell?.tableViewTag = tableView.tag
                
                let isIndexValid = self.parentVC.fetchedResultController3?.fetchedObjects?.indices.contains(indexPath.row)
                if isIndexValid! {
                    DispatchQueue.main.async {
                        cell?.setThreadCellWith(thread: thread!)
                    }
                }
                cell?.selectionStyle = .none
                cell?.rightActions = [
                    CustomStarUnstarAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.leftActions = [
                    CustomStarUnstarAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.contentView.setNeedsLayout()

            }
            
            return cell!
        }
        
        if tableView == self.parentVC.spamTableView {
            
            var cell: ThreadsStarUnstarTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier()) as? ThreadsStarUnstarTableViewCell)!
            if (cell == nil) {
                cell = ThreadsStarUnstarTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: ThreadsStarUnstarTableViewCell.reuseIdentifier())
            }
            
            if self.parentVC.fetchedResultController4 != nil {
                let thread = self.parentVC.fetchedResultController4?.object(at: indexPath)
                cell?.delegate = self.parentVC
                cell?.indexPath = indexPath
                cell?.tableViewTag = tableView.tag
                
                let isIndexValid = self.parentVC.fetchedResultController4?.fetchedObjects?.indices.contains(indexPath.row)
                if isIndexValid! {
                    DispatchQueue.main.async {
                        cell?.setThreadCellWith(thread: thread!)

                    }
                }
                cell?.selectionStyle = .none
                cell?.rightActions = [
                    CustomStarUnstarAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.leftActions = [
                    CustomStarUnstarAction(title: "", color: #colorLiteral(red: 0.6705882353, green: 0.7333333333, blue: 1, alpha: 1))
                ]
                cell?.contentView.setNeedsLayout()

            }
            
            return cell!
        }
        
        var cell: ThreadsTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: ThreadsTableViewCell.reuseIdentifier()) as? ThreadsTableViewCell)!
        if (cell == nil) {
            cell = ThreadsTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: ThreadsTableViewCell.reuseIdentifier())
        }
        return cell!
        
    }
    
    func showProfileImage(onCell cell: ThreadsTableViewCell, withThread thread:Threads) {
        if let profileImageUrl = thread.last_message_from?.profile_pic {
            let url = URL.init(string: profileImageUrl)
            cell.profileImageview.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "june_profile_pic_bg"))
        } else {
            cell.profileImageview.image = #imageLiteral(resourceName: "june_profile_pic_bg")
        }
    }
}
