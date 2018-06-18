//
//  UITableView+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func willScrollToBottom(offset: CGFloat) -> Bool {
        let tableHeight = bounds.size.height
        let contentHeight = contentSize.height
        let insetHeight = contentInset.bottom
        let yOffset = contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight + offset - insetHeight
        return yOffsetAtBottom > contentHeight
    }
    
    /// Check if cell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }
    
    // Perform a series of method calls that insert, delete, or select rows and sections of the table view.
    /// This is equivalent to a beginUpdates() / endUpdates() sequence,
    /// with a completion closure when the animation is finished.
    /// Parameter update: the update operation to perform on the tableView.
    /// Parameter completion: the completion closure to be executed when the animation is completed.
    
    func performUpdate(_ update: ()->Void, completion: (()->Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        // Table View update on row / section
        beginUpdates()
        update()
        endUpdates()
        
        CATransaction.commit()
    }
}
