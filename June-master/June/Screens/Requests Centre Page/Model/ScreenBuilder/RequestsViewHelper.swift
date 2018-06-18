//
//  RequestsViewHelper.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsViewHelper {

    // MARK: - Variables & Constants
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private weak var dataRepository: RequestsDataRepository?
    private var cellHeights: [String: CGFloat]
    
    // MARK: - Initialization
    
    init(storage: RequestsDataRepository?) {
        cellHeights = [:]
        dataRepository = storage
    }
    
    // MARK: - height logic
    func put(_ height: CGFloat, at index: Int) {
        guard let itemId = dataRepository?.contact(by: index)?.contactId else { return }
        cellHeights[itemId] = height
    }
    
    func clearHeights() {
        cellHeights = [:]
    }
    
    func height(for rowType: RequestsScreenType, indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0.296 * screenWidth
        switch rowType {
        case .people:
            rowHeight = 0.376 * screenWidth
        case .blockedPeople:
            rowHeight = 0.376 * screenWidth
        default:
            rowHeight = 0.296 * screenWidth
        }
        
        if let itemId = dataRepository?.contact(by: indexPath.row)?.contactId {
            if let height = cellHeights[itemId] {
                rowHeight = height
            }
        }
       
        return rowHeight
    }
}
