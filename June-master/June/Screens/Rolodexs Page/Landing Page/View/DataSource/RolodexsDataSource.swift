//
//  RolodexsDataSource.swift
//  June
//
//  Created by Joshua Cleetus on 3/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit
import QuartzCore

class RolodexsDataSource: NSObject {
    let cellHandler = SwipyCellHandler()
    unowned var parentVC: RolodexsViewController
    init(parentVC: RolodexsViewController) {
        self.parentVC = parentVC
        super.init()
    }
}

// MARK:- UITableViewDataSource

extension RolodexsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return parentVC.sections.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let validIndex = parentVC.sections.indices.contains(section)
        if validIndex {
            let sectionType = parentVC.sections[section]
            switch sectionType {
            case .rolodexs:
                if let rolodexsItemsCount = parentVC.rolodexsItemsInfo?.count {
                    guard rolodexsItemsCount > 0 else {
                        return 0
                    }
                    return rolodexsItemsCount
                }

            case .rolodexsLoader:
                return parentVC.screenBuilder.loadRows(withSection: sectionType).count
                
            case .favs:
                if let favsItemsCount = parentVC.favsItemsInfo?.count {
                    guard favsItemsCount > 0 else {
                        return 0
                    }
                    return favsItemsCount
                }
                
            case .favsLoader:
                return parentVC.screenBuilder.loadRows(withSection: sectionType).count

            case .unreads:
                if let unreadsItemsCount = parentVC.unreadsItemsInfo?.count {
                    guard unreadsItemsCount > 0 else {
                        return 0
                    }
                    return unreadsItemsCount
                }
                
            case .unreadsLoader:
                return parentVC.screenBuilder.loadRows(withSection: sectionType).count

            case .pins:
                if let pinsItemsCount = parentVC.pinnedItemsInfo?.count {
                    guard pinsItemsCount > 0 else {
                        return 0
                    }
                    return pinsItemsCount
                }
                
            case .pinsLoader:
                return parentVC.screenBuilder.loadRows(withSection: sectionType).count
                
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isIndexValid = parentVC.sections.indices.contains(indexPath.section)
        if isIndexValid {
            let sectionType = parentVC.sections[indexPath.section]
            let isRowIndexValid = parentVC.screenBuilder.loadRows(withSection: sectionType).indices.contains(indexPath.row)
            if isRowIndexValid {
                guard let rowType = parentVC.screenBuilder.loadRows(withSection: sectionType)[indexPath.row] as? RolodexsRowType else {
                    return UITableViewCell()
                }
                let dataModel = parentVC.screenBuilder.loadModel(for: sectionType, rowType: rowType, forPath: indexPath)
                return cellForRowType(rowType, tableView: tableView, withModel: dataModel, item: indexPath)
            } else {
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            tableView.deleteRows(at:[indexPath], with: .top)
            tableView.endUpdates()
        case .insert:
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        case .none:
            tableView.beginUpdates()
            tableView.deleteRows(at:[indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func cellForRowType(_ row: RolodexsRowType, tableView: UITableView, withModel dataModel: BaseTableModel, item: IndexPath) -> UITableViewCell {
        switch row {
        case .rolodexsItem:
            let cell: RolodexsTableViewCell = tableView.dequeueReusableCell(withIdentifier: RolodexsTableViewCell.reuseIdentifier()) as! RolodexsTableViewCell
            if let model = dataModel as? RolodexsTableInfo, let rolodexs = model.rolodexs {
                cell.configure(rolodexs: rolodexs)
            }
            return cell
            
        case .loader:
            let cell: ConvosViewAllTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConvosViewAllTableViewCell.reuseIdentifier()) as! ConvosViewAllTableViewCell
            if let model = dataModel as? TableLabelInfo {
                cell.itemLabel.text = model.value
            }
            cell.backgroundColor = .clear
            cell.itemLabel.textAlignment = .center
            return cell

        case .favsItem:
            let cell: FavsTableViewCell = tableView.dequeueReusableCell(withIdentifier: FavsTableViewCell.reuseIdentifier()) as! FavsTableViewCell
            if let model = dataModel as? FavsTableInfo, let favorites = model.favorites {
                cell.configure(favorites: favorites)
            }
            return cell
            
        case .unreadItem:
            let cell: RolodexsTableViewCell = tableView.dequeueReusableCell(withIdentifier: RolodexsTableViewCell.reuseIdentifier()) as! RolodexsTableViewCell
            if let model = dataModel as? RolodexsTableInfo, let rolodexs = model.rolodexs {
                cell.configure(rolodexs: rolodexs)
            }
            return cell
            
        case .pinnedItem:
            let cell: RolodexsTableViewCell = tableView.dequeueReusableCell(withIdentifier: RolodexsTableViewCell.reuseIdentifier()) as! RolodexsTableViewCell
            if let model = dataModel as? RolodexsTableInfo, let rolodexs = model.rolodexs {
                cell.configure(rolodexs: rolodexs)
            }
            return cell
            
        }
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
    
    func getTotalNewMessagesCount(onCell: ConvosViewAllTableViewCell, dataModel: BaseTableModel) {
       
    }
    
}
