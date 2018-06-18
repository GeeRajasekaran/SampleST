//
//  FeedDetailedViewHelper.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedDetailedViewHelper {
    
    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var webViewHeighs: [Int: CGFloat] = [:]
    
    // MARK: - Rows height calculations
    
    func subjectHeight(with subject: String) -> CGFloat {
        let availableWidth: CGFloat = screenWidth - (0.08 * screenWidth)
        let height = subject.height(withConstrainedWidth: availableWidth, font: UIFont.latoStyleAndSize(style: .bold, size: .large))
        return height + (0.077 * screenWidth)
    }
    
    func headerHeight(isExpanded: Bool) -> CGFloat {
        return 0.216 * screenWidth
    }
    
    // MARK: - Message cell height calculation
    
    func put(_ height: CGFloat, at index: Int) {
        webViewHeighs[index] = height
    }
    
    func messageHeight(at indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 100
        if let height = webViewHeighs[indexPath.section] {
            rowHeight = height
        }
        return rowHeight
    }
    
}
