//
//  FeedDetailedViewScreenBuilder.swift
//  June
//
//  Created by Ostap Holub on 1/17/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedDetailedScreenBuilder: ScreenTableModelBuilder {
    
    // MARK: - Variables & Constants
    
    private weak var dataRepository: MessagesDataRepository?
    private weak var selectedThread: Threads?
    
    private var viewHelper: FeedDetailedViewHelper = FeedDetailedViewHelper()
    
    // MARK: - Initialization
    
    init(model: Any?, storage: MessagesDataRepository?, thread: Threads?) {
        dataRepository = storage
        selectedThread = thread
    }
    
    // MARK: - Rows loading
    
    override func loadRows(withSection section: Any) -> [Any] {
        guard let count = dataRepository?.count else { return [] }
        return FeedDetailedRowType.rows(for: count)
    }
    
    func rowType(at indexPath: IndexPath) -> FeedDetailedRowType? {
        let rowTypes = loadRows(withSection: 1)
        guard rowTypes.count != 0 else { return nil }
        if indexPath.row >= 0 && indexPath.row < rowTypes.count {
            return rowTypes[indexPath.row] as? FeedDetailedRowType
        }
        return nil
    }
    
    // MARK: - Data models loading
    
    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        
        guard let rowType = loadRows(withSection: sectionType)[indexPath.row] as? FeedDetailedRowType,
            let unwrappedThread = selectedThread,
            let unwrappedMessage = dataRepository?.message(at: indexPath.section)?.entity else { return BaseTableModel() }
        
        switch rowType {
        case .header:
            return MessageHeaderInfo(isExpanded: false, message: unwrappedMessage, thread: unwrappedThread)
        case .subject:
            return MessageSubjectInfo(thread: unwrappedThread)
        case .message:
            return MessageBodyInfo(message: unwrappedMessage)
        }
    }
    
    // MARK: - Screen builder UI logic
    
    func save(cellHeigh height: CGFloat, at index: Int) {
        viewHelper.put(height, at: index)
    }
    
    func height(for rowType: FeedDetailedRowType, at indexPath: IndexPath) -> CGFloat {
        switch rowType {
        case .header:
            return viewHelper.headerHeight(isExpanded: false)
        case .subject:
            guard let threadSubject = selectedThread?.subject else { return 0 }
            return viewHelper.subjectHeight(with: threadSubject)
        case .message:
            return viewHelper.messageHeight(at: indexPath)
        }
    }
    
}
