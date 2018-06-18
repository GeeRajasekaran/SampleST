//
//  SpoolDetailsScreenBuilder.swift
//  June
//
//  Created by Ostap Holub on 4/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolDetailsScreenBuilder: ScreenTableModelBuilder {
    
    // MARK: - Variables & Constants
    
    var dataRepository: SpoolDetailsDataRepository = SpoolDetailsDataRepository()
    var headerTitle: String?
    var headerInfo: SpoolDetailsHeaderInfo?
    
    var isLoadingMoreAvailable: Bool = false
    
    override init(model: Any?) {
        guard let spoolItem = model as? Spools else { return }
        headerTitle = spoolItem.last_message_subject
        headerInfo = SpoolDetailsHeaderInfo(spool: spoolItem)
    }
    
    // MARK: - Updating logic
    
    override func updateModel(model: Any?, type: Any) {
        guard let dbMessages = model as? [Messages] else { return }
        let messagesInfo = dbMessages.map { m -> SpoolMessageInfo in
            return SpoolMessageInfo(message: m)
        }
        dataRepository.update(with: messagesInfo)
    }
    
    // MARK: - Rows data loading
    
    override func loadRows(withSection section: Any) -> [Any] {
        return SpoolDetailsRowType.rowTypes(for: dataRepository.messages, isLoadingMoreAvailable: isLoadingMoreAvailable)
    }
    
    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        guard let currentRow = rowType as? SpoolDetailsRowType else {
            return BaseTableModel()
        }
        
        switch currentRow {
        case .message:
            return message(at: indexPath.row)
        case .showOlderMessages:
            return SpoolShowOlderMessagesInfo()
        }
    }
    
    // MARK: - Data access logic
    
    func message(at index: Int) -> SpoolMessageInfo {
        if isLoadingMoreAvailable {
            return dataRepository.messages[index - 1]
        } else {
            return dataRepository.messages[index]
        }
    }
}
